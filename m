Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0YPd5124096 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C25DFD4384
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	sEfGJZjegqHpEgem for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:37 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	7203807-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:35 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohC-0000Uh-FI
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogv-0002GO-0N
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/12] xfs: rename xfs_cmn_err_fsblock_zero()
Date: Wed, 12 Jan 2011 11:35:50 +1100
Message-Id: <1294792553-8378-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

The "cmn_err" part ofteh function name is no longer relevant. Rename
the function to xfs_alert_fsblock_zero() to match the new logging
API.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4a19da0..9bfcd58 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -101,7 +101,7 @@ xfs_iomap_eof_align_last_fsb(
 }
 
 STATIC int
-xfs_cmn_err_fsblock_zero(
+xfs_alert_fsblock_zero(
 	xfs_inode_t	*ip,
 	xfs_bmbt_irec_t	*imap)
 {
@@ -246,7 +246,7 @@ xfs_iomap_write_direct(
 	}
 
 	if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip))) {
-		error = xfs_cmn_err_fsblock_zero(ip, imap);
+		error = xfs_alert_fsblock_zero(ip, imap);
 		goto error_out;
 	}
 
@@ -459,7 +459,7 @@ retry:
 	}
 
 	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
-		return xfs_cmn_err_fsblock_zero(ip, &imap[0]);
+		return xfs_alert_fsblock_zero(ip, &imap[0]);
 
 	*ret_imap = imap[0];
 	return 0;
@@ -609,7 +609,7 @@ xfs_iomap_write_allocate(
 		 * covers at least part of the callers request
 		 */
 		if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
-			return xfs_cmn_err_fsblock_zero(ip, imap);
+			return xfs_alert_fsblock_zero(ip, imap);
 
 		if ((offset_fsb >= imap->br_startoff) &&
 		    (offset_fsb < (imap->br_startoff +
@@ -719,7 +719,7 @@ xfs_iomap_write_unwritten(
 			return XFS_ERROR(error);
 
 		if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip)))
-			return xfs_cmn_err_fsblock_zero(ip, &imap);
+			return xfs_alert_fsblock_zero(ip, &imap);
 
 		if ((numblks_fsb = imap.br_blockcount) == 0) {
 			/*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
