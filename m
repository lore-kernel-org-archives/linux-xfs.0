Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ED5hus024083 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 07:05:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 044431D32767
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 05:07:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	PSvQqmVawaE5xp9s for <xfs@oss.sgi.com>;
	Fri, 14 Jan 2011 05:07:56 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	7527278-1927428
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 23:37:55 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PdjNh-00065u-FM
	for xfs@oss.sgi.com; Sat, 15 Jan 2011 00:07:53 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PdjN3-0003GC-5C
	for xfs@oss.sgi.com; Sat, 15 Jan 2011 00:07:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix efi item leak on forced shutdown
Date: Sat, 15 Jan 2011 00:07:10 +1100
Message-Id: <1295010430-12495-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1295010430-12495-1-git-send-email-david@fromorbit.com>
References: <1295010430-12495-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

After test 139, kmemleak shows:

unreferenced object 0xffff880078b405d8 (size 400):
  comm "xfs_io", pid 4904, jiffies 4294909383 (age 1186.728s)
  hex dump (first 32 bytes):
    60 c1 17 79 00 88 ff ff 60 c1 17 79 00 88 ff ff  `..y....`..y....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81afb04d>] kmemleak_alloc+0x2d/0x60
    [<ffffffff8115c6cf>] kmem_cache_alloc+0x13f/0x2b0
    [<ffffffff814aaa97>] kmem_zone_alloc+0x77/0xf0
    [<ffffffff814aab2e>] kmem_zone_zalloc+0x1e/0x50
    [<ffffffff8147cd6b>] xfs_efi_init+0x4b/0xb0
    [<ffffffff814a4ee8>] xfs_trans_get_efi+0x58/0x90
    [<ffffffff81455fab>] xfs_bmap_finish+0x8b/0x1d0
    [<ffffffff814851b4>] xfs_itruncate_finish+0x2c4/0x5d0
    [<ffffffff814a970f>] xfs_setattr+0x8df/0xa70
    [<ffffffff814b5c7b>] xfs_vn_setattr+0x1b/0x20
    [<ffffffff8117dc00>] notify_change+0x170/0x2e0
    [<ffffffff81163bf6>] do_truncate+0x66/0xa0
    [<ffffffff81163d0b>] sys_ftruncate+0xdb/0xe0
    [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

The cause of the leak is that the "remove" parameter of IOP_UNPIN()
is never set when a CIL push is aborted. This means that the EFI
item is never freed if it was in the push being cancelled. The
problem is specific to delayed logging.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f80a067..e66ce5e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1472,6 +1472,16 @@ xfs_trans_committed_bulk(
 		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
 			continue;
 
+		/*
+		 * if we are aborting the operation, no point in inserting the
+		 * object into the AIL as we areee in a shutdown situation.
+		 */
+		if (aborted) {
+			ASSERT(XFS_FORCED_SHUTDOWN(ailp->xa_mount));
+			IOP_UNPIN(lip, aborted);
+			continue;
+		}
+
 		if (item_lsn != commit_lsn) {
 
 			/*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
