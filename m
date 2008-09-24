Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:14:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8DmiS005341
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:13:49 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F271813297CC
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:15:19 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id GF7pFRUGIsxgHcIY for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:15:19 -0700 (PDT)
Subject: Re: [PATCH 4/10] xfs: Fix error handling inwrite_super_lockfs/unlockfs
Message-Id: <20080924171439t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Wed, 24 Sep 2008 17:14:39 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

Dave Chinner wrote:
>> diff -uprN -X linux-2.6.27-rc7-lockfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c lin
ux-
>> 2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c
>> --- linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c 2008-09-22 07:29:55.000000000 +0900
>> +++ linux-2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c 2008-09-22 10:13:39.000000000 +0900
>> @@ -1351,7 +1351,7 @@ xfs_fs_remount(
>>   * need to take care of themetadata. Once that's done write a dummy
>>   * record to dirty the log in case of a crash while frozen.
>>   */
>> -STATIC void
>> +STATIC int
>>  xfs_fs_lockfs(
>>  	struct super_block *sb)
>>  {
>> @@ -1359,6 +1359,7 @@ xfs_fs_lockfs(
>>  
>>  	xfs_attr_quiesce(mp);
>>  	xfs_fs_log_dummy(mp);
>> + 	return 0;
>>  }
> 
> xfs_fs_log_dummy() currently is void because it had nowhere to
> return errors to. It silently throws away errors because of this.
> Hence the correct thing to do here is to fix xfs_fs_log_dummy()
> to return the errors it currently ignores. i.e. catch the errors
> from xfs_trans_reserve() and xfs_trans_commit() calls in
> xfs_fs_log_dummy().

OK.
I've fixed the patch for xfs as following.
Could you review it?
If it's OK, I will include it in new freeze patch-set.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
diff -uprN -X linux-2.6.27-rc7.org/Documentation/dontdiff linux-2.6.27-rc7-ext4_3/fs/xfs/linux-2.6/xfs_super.c linux-2.6
.27-rc7-xfs_4/fs/xfs/linux-2.6/xfs_super.c
--- linux-2.6.27-rc7-ext4_3/fs/xfs/linux-2.6/xfs_super.c	2008-09-24 10:48:02.000000000 +0900
+++ linux-2.6.27-rc7-xfs_4/fs/xfs/linux-2.6/xfs_super.c	2008-09-24 11:24:08.000000000 +0900
@@ -1351,14 +1351,14 @@ xfs_fs_remount(
  * need to take care of themetadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
-STATIC void
+STATIC int
 xfs_fs_lockfs(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_attr_quiesce(mp);
-	xfs_fs_log_dummy(mp);
+	return -xfs_fs_log_dummy(mp);
 }
 
 STATIC int
diff -uprN -X linux-2.6.27-rc7.org/Documentation/dontdiff linux-2.6.27-rc7-ext4_3/fs/xfs/xfs_fsops.c linux-2.6.27-rc7-xf
s_4/fs/xfs/xfs_fsops.c
--- linux-2.6.27-rc7-ext4_3/fs/xfs/xfs_fsops.c	2008-09-24 10:48:02.000000000 +0900
+++ linux-2.6.27-rc7-xfs_4/fs/xfs/xfs_fsops.c	2008-09-24 11:47:08.000000000 +0900
@@ -589,17 +589,19 @@ out:
 	return 0;
 }
 
-void
+int
 xfs_fs_log_dummy(
 	xfs_mount_t	*mp)
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
+	int		error;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
-	if (xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0)) {
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
-		return;
+		return error;
 	}
 
 	ip = mp->m_rootip;
@@ -609,9 +611,10 @@ xfs_fs_log_dummy(
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_set_sync(tp);
-	xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp, 0);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 int
diff -uprN -X linux-2.6.27-rc7.org/Documentation/dontdiff linux-2.6.27-rc7-ext4_3/fs/xfs/xfs_fsops.h linux-2.6.27-rc7-xf
s_4/fs/xfs/xfs_fsops.h
--- linux-2.6.27-rc7-ext4_3/fs/xfs/xfs_fsops.h	2008-09-24 10:48:02.000000000 +0900
+++ linux-2.6.27-rc7-xfs_4/fs/xfs/xfs_fsops.h	2008-09-24 11:36:29.000000000 +0900
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern void xfs_fs_log_dummy(xfs_mount_t *mp);
+extern int xfs_fs_log_dummy(xfs_mount_t *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
