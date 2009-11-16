Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAGBuced127204 for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 05:56:39 -0600
Received: from sith.mimuw.edu.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D7B88CA5D
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 03:56:59 -0800 (PST)
Received: from sith.mimuw.edu.pl (sith.mimuw.edu.pl [193.0.96.4]) by
	cuda.sgi.com with ESMTP id ewUf4PLwKhwCtjHF for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2009 03:56:59 -0800 (PST)
Date: Mon, 16 Nov 2009 12:57:02 +0100
From: Jan Rekorajski <baggins@sith.mimuw.edu.pl>
Subject: XFS bug in log recover with quota (bugzilla id 855)
Message-ID: <20091116115702.GN23522@sith.mimuw.edu.pl>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi,
I was hit by a bug in linux 2.6.31 when XFS is not able to recover the
log after a crash if fs was mounted with quotas. Gory details in XFS
bugzilla: http://oss.sgi.com/bugzilla/show_bug.cgi?id=855.

It looks like wrong struct is used in buffer length check, and the following
patch should fix the problem.

xfs_dqblk_t has a size of 104+32 bytes, while xfs_disk_dquot_t is 104 bytes
long, and this is exactly what I see in system logs - "XFS: dquot too small
(104) in xlog_recover_do_dquot_trans."

--- linux-2.6.31.5/fs/xfs/xfs_log_recover.c.orig	2009-11-01 23:59:52.194846209 +0100
+++ linux-2.6.31.5/fs/xfs/xfs_log_recover.c	2009-11-16 12:47:11.601490963 +0100
@@ -1980,7 +1980,7 @@
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
-			if (item->ri_buf[i].i_len < sizeof(xfs_dqblk_t)) {
+			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
 				cmn_err(CE_ALERT,
 					"XFS: dquot too small (%d) in %s.",
 					item->ri_buf[i].i_len, __func__);
@@ -2636,7 +2636,7 @@
 			"XFS: NULL dquot in %s.", __func__);
 		return XFS_ERROR(EIO);
 	}
-	if (item->ri_buf[1].i_len < sizeof(xfs_dqblk_t)) {
+	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		cmn_err(CE_ALERT,
 			"XFS: dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);

-- 
Jan Rekorajski            |  ALL SUSPECTS ARE GUILTY. PERIOD!
baggins<at>mimuw.edu.pl   |  OTHERWISE THEY WOULDN'T BE SUSPECTS, WOULD THEY?
BOFH, MANIAC              |                   -- TROOPS by Kevin Rubio

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
