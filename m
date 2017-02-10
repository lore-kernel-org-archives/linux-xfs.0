Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42371 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdBJJcc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 04:32:32 -0500
Date: Fri, 10 Feb 2017 10:31:31 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [BUG 4.10-rc7] sb_fdblocks inconsistency in xfs/297 test
Message-ID: <20170210093131.GH10893@dhcp22.suse.cz>
References: <20170210035348.GA7075@eguan.usersys.redhat.com>
 <20170210071418.GC9346@dhcp22.suse.cz>
 <20170210080210.GC10893@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210080210.GC10893@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

[CC Christoph]

On Fri 10-02-17 09:02:10, Michal Hocko wrote:
> On Fri 10-02-17 08:14:18, Michal Hocko wrote:
> > On Fri 10-02-17 11:53:48, Eryu Guan wrote:
> > > Hi,
> > > 
> > > I was testing 4.10-rc7 kernel and noticed that xfs_repair reported XFS
> > > corruption after fstests xfs/297 test. This didn't happen with 4.10-rc6
> > > kernel, and git bisect pointed the first bad commit to
> > > 
> > > commit d1908f52557b3230fbd63c0429f3b4b748bf2b6d
> > > Author: Michal Hocko <mhocko@suse.com>
> > > Date:   Fri Feb 3 13:13:26 2017 -0800
> > > 
> > >     fs: break out of iomap_file_buffered_write on fatal signals
> > > 
> > >     Tetsuo has noticed that an OOM stress test which performs large write
> > >     requests can cause the full memory reserves depletion.  He has tracked
> > >     this down to the following path
> > > ....
> > > 
> > > It's the sb_fdblocks field reports inconsistency:
> > > ...
> > > Phase 2 - using internal log   
> > >         - zero log...
> > >         - scan filesystem freespace and inode maps...
> > > sb_fdblocks 3367765, counted 3367863
> > >         - 11:37:41: scanning filesystem freespace - 16 of 16 allocation groups done
> > >         - found root inode chunk
> > > ...
> > > 
> > > And it can be reproduced almost 100% with all XFS test configurations
> > > (e.g. xfs_4k xfs_2k_reflink), on all test hosts I tried (so I didn't
> > > bother pasting my detailed test and host configs, if more info is needed
> > > please let me know).
> > 
> > The patch can lead to short writes when the task is killed. Was there
> > any OOM killer triggered during the test? If not who is killing the
> > task? I will try to reproduce later today.
> 
> I have checked both tests and they are killing the test but none of them
> seems to be using SIGKILL. The patch should make a difference only for
> fatal signal (aka SIGKILL). Is there any other part that can do SIGKILL
> except for the OOM killer?

I have done
diff --git a/fs/dax.c b/fs/dax.c
index c45598b912e1..4de00ceaf73d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1032,6 +1032,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		ssize_t map_len;
 
 		if (fatal_signal_pending(current)) {
+			WARN(1, "dax_iomap_actor\n");
 			ret = -EINTR;
 			break;
 		}
diff --git a/fs/iomap.c b/fs/iomap.c
index a51cb4c07d4d..00019e2cdad3 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -114,8 +114,10 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 
 	BUG_ON(pos + len > iomap->offset + iomap->length);
 
-	if (fatal_signal_pending(current))
+	if (fatal_signal_pending(current)) {
+		WARN(1, "iomap_write_begin\n");
 		return -EINTR;
+	}
 
 	page = grab_cache_page_write_begin(inode->i_mapping, index, flags);
 	if (!page)

and it triggered
[  135.055682] WARNING: CPU: 2 PID: 4894 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.087297] WARNING: CPU: 1 PID: 4899 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.150542] WARNING: CPU: 2 PID: 4857 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.153653] WARNING: CPU: 3 PID: 4889 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.154413] WARNING: CPU: 0 PID: 4929 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.154734] WARNING: CPU: 3 PID: 4934 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.162743] WARNING: CPU: 0 PID: 4813 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.163282] WARNING: CPU: 1 PID: 4891 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.163820] WARNING: CPU: 0 PID: 4932 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.169112] WARNING: CPU: 0 PID: 4923 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.182816] WARNING: CPU: 0 PID: 4892 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.321991] WARNING: CPU: 3 PID: 4872 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c

always from
[  135.055682] WARNING: CPU: 2 PID: 4894 at fs/iomap.c:118 iomap_write_begin+0x72/0x12c
[  135.057092] iomap_write_begin
[  135.057556] Modules linked in: xfs libcrc32c
[  135.058191] CPU: 2 PID: 4894 Comm: fsstress Tainted: G        W       4.10.0-rc6-test1-00149-gd1908f52557b-dirty #1064
[  135.060349] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.1-1 04/01/2014
[  135.060865] Call Trace:
[  135.060865]  dump_stack+0x68/0x92
[  135.060865]  __warn+0xc2/0xdd
[  135.060865]  warn_slowpath_fmt+0x4b/0x53
[  135.060865]  iomap_write_begin+0x72/0x12c
[  135.060865]  iomap_write_actor+0x99/0x161
[  135.060865]  iomap_apply+0x9e/0xec
[  135.060865]  ? iomap_write_end+0x62/0x62
[  135.060865]  iomap_file_buffered_write+0x5b/0x7f
[  135.060865]  ? iomap_write_end+0x62/0x62
[  135.060865]  xfs_file_buffered_aio_write+0x187/0x2b4 [xfs]
[  135.060865]  xfs_file_write_iter+0x93/0x11c [xfs]
[  135.060865]  __vfs_write+0xcc/0xf5
[  135.060865]  vfs_write+0x100/0x1a9
[  135.060865]  SyS_write+0x51/0x8e

So somebody had to send SIGKILL to fsstress. Anyway, I am wondering
whether this is really a regression. xfs_file_buffered_aio_write used to
call generic_perform_write which does the same thing.
-- 
Michal Hocko
SUSE Labs
