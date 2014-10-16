Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 862C67F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 06:01:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 126CCAC003
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 04:01:31 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id PQmJ8tqC92SWRi6i (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 04:01:29 -0700 (PDT)
Date: Thu, 16 Oct 2014 13:01:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [vfs] WARNING: CPU: 3 PID: 2339 at mm/truncate.c:758
	pagecache_isize_extended+0xdd/0x120()
Message-ID: <20141016110127.GD6085@quack.suse.cz>
References: <20141016100913.GA8140@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20141016100913.GA8140@wfg-t540p.sh.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, lkp@01.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 16-10-14 18:09:13, Wu Fengguang wrote:
> Hi Jan,
> 
> Your patch gives a warning on the xfs code path. :)
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> commit be330474e2d0533a7a6185e567f3654fec096dbd ("vfs: fix data corruption when blocksize < pagesize for mmaped data")
...

> <5>[   25.956576] XFS (sda1): Mounting V4 Filesystem
> <6>[   26.194468] XFS (sda1): Ending clean mount
> <4>[   27.258450] ------------[ cut here ]------------
> <4>[   27.258789] WARNING: CPU: 3 PID: 2339 at mm/truncate.c:758 pagecache_isize_extended+0xdd/0x120()
  Ah, I believe this is:
WARN_ON(!mutex_is_locked(&inode->i_mutex));
  because XFS doesn't use i_mutex but its private rwlock. I forgot to check
dmesg after running xfstests for XFS and didn't notice this. Anyway, the
solution is to just remove the assertion since it doesn't hold for all
filesystems. Patch for that is attached. Thanks Fengguang for catching
this.

								Honza

> <4>[   27.259443] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod cdrom sd_mod firewire_ohci firewire_core crc_itu_t snd_hda_codec_realtek pcspkr snd_hda_codec_generic ahci libahci libata snd_hda_intel i2c_i801 snd_hda_controller parport_pc parport snd_hda_codec snd_hwdep snd_pcm snd_timer shpchp snd x38_edac edac_core soundcore acpi_cpufreq
> <4>[   27.262734] CPU: 3 PID: 2339 Comm: fallocate Not tainted 3.17.0-gda9a9f1 #1
> <4>[   27.263153] Hardware name:                  /        , BIOS VVRBLI9J.86A.2891.2007.0511.1144 05/11/2007
> <4>[   27.263780]  0000000000000009 ffff88007a43fd88 ffffffff81859ea6 0000000000000000
> <4>[   27.264492]  ffff88007a43fdc0 ffffffff8106ef0d 0000000000001000 ffff88005b6f05a8
> <4>[   27.265199]  0000000000000000 ffff88005b6f05a8 0000000004000000 ffff88007a43fdd0
> <4>[   27.265906] Call Trace:
> <4>[   27.266165]  [<ffffffff81859ea6>] dump_stack+0x4d/0x66
> <4>[   27.266511]  [<ffffffff8106ef0d>] warn_slowpath_common+0x7d/0xa0
> <4>[   27.266900]  [<ffffffff8106efea>] warn_slowpath_null+0x1a/0x20
> <4>[   27.267286]  [<ffffffff8117020d>] pagecache_isize_extended+0xdd/0x120
> <4>[   27.267690]  [<ffffffff811712b7>] truncate_setsize+0x27/0x40
> <4>[   27.268068]  [<ffffffff8133eab7>] xfs_setattr_size+0x157/0x3a0
> <4>[   27.268442]  [<ffffffff8134c827>] ? xfs_trans_commit+0x157/0x250
> <4>[   27.268821]  [<ffffffff813336df>] xfs_file_fallocate+0x2df/0x300
> <4>[   27.269215]  [<ffffffff811dbb09>] ? __sb_start_write+0x49/0xf0
> <4>[   27.269596]  [<ffffffff813923b4>] ? selinux_file_permission+0xc4/0x120
> <4>[   27.270009]  [<ffffffff811d7563>] do_fallocate+0x123/0x1b0
> <4>[   27.270380]  [<ffffffff811d7633>] SyS_fallocate+0x43/0x70
> <4>[   27.270738]  [<ffffffff81862c69>] system_call_fastpath+0x16/0x1b
> <4>[   27.271119] ---[ end trace 6a3b1350ad399610 ]---
> <4>[   27.274498] ------------[ cut here ]------------

--IJpNTDwzlM2Ie8A6
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mm-Remove-false-WARN_ON-from-pagecache_isize_extende.patch"

>From de3426d6495f4b44b14c09b7c7202e9a86d864b9 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Oct 2014 12:58:42 +0200
Subject: [PATCH] mm: Remove false WARN_ON from pagecache_isize_extended()

The WARN_ON checking whether i_mutex is held in
pagecache_isize_extended() was wrong because some filesystems (e.g.
XFS) use different locks for serialization of truncates / writes. So
just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/truncate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 261eaf6e5a19..c646084e5eec 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -755,7 +755,6 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 	struct page *page;
 	pgoff_t index;
 
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
 	WARN_ON(to > inode->i_size);
 
 	if (from >= to || bsize == PAGE_CACHE_SIZE)
-- 
1.8.1.4


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--IJpNTDwzlM2Ie8A6--
