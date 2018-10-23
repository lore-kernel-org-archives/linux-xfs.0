Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43976 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbeJWMUs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 08:20:48 -0400
Subject: Re: Segmentation fault in xfs_repair
References: <CA+MkmrPWg=pD5t-bt8ye36bi8prep+FjM_n-L4XnG-PRJc--7w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6af24679-cc41-3a11-7461-174b82fb9ed1@sandeen.net>
Date: Mon, 22 Oct 2018 22:59:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+MkmrPWg=pD5t-bt8ye36bi8prep+FjM_n-L4XnG-PRJc--7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Oleg Davydov <burunduk3@gmail.com>, linux-xfs@vger.kernel.org

On 10/20/18 7:43 AM, Oleg Davydov wrote:
> I try to repair file system from corrupter drive and this leads to
> Segmentaion Fault in xfs_repair. You can see some logs here (incl.
> stack trace from coredump): https://pastebin.com/farKCDRi
> 
> I tried xfsprogs-4.14.0 (currently installed on my system), custom
> build from git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git, from
> master (3caeb69c) and from libxfs-4.19-sync (b5c71bcd), all ended in
> the same result.
> 
> Please suggest me how to fix it, how to get some more information
> about the problem or how can I workaround it. Additional problem is
> that I can't even mount filesystem now (mount fails with Corruption
> warning: Metadata has LSN (1674570203:54480) ahead of current LSN
> (1:8). Please unmount and run xfs_repair (>= v4.3) to resolve.)

This should fix it.  If you'd like to test it with an abundance of
caution, you can do this:

xfs_metadump -o /dev/original - | xfs_mdrestore - xfs-test.img

then run repair on xfs-test.img and see what it would do to your real
fs.  You can even mount the image to see what files remain, what was
moved to lost+found etc  (but note that all files will appear to be
empty in the restored metadump image.)

====== 8< ======

xfs_repair: initialize realloced bplist space in longform_dir2_entry_check

If we need to realloc the bplist[] array holding buffers for a given
directory, we don't initialize the new slots.  This causes a problem
if the directory has holes, because those slots never get filled in.

At the end of the function we call libxfs_putbuf for every non-null
slot, and any uninitialized slots are segfault landmines.

Make sure we initialize all new slots to NULL for this reason.

Reported-by: Oleg Davydov <burunduk3@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index b87c751..9d24a4f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2348,6 +2348,8 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 
 		db = xfs_dir2_da_to_db(mp->m_dir_geo, da_bno);
 		if (db >= num_bps) {
+			int last_size = num_bps;
+
 			/* more data blocks than expected */
 			num_bps = db + 1;
 			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
@@ -2355,6 +2357,9 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 				do_error(_("realloc failed in %s (%zu bytes)\n"),
 					__func__,
 					num_bps * sizeof(struct xfs_buf*));
+			/* Initialize the new elements */
+			for (i = last_size; i < num_bps; i++)
+				bplist[i] = NULL;
 		}
 
 		if (isblock)
