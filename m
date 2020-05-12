Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46340C2D0F7
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ADD620753
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CAloOdxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgELVCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 17:02:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELVCi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 17:02:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CKroNb136239
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 21:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=83H2F6iW5od7rDBOBNzHY48QhThNctq46KFZ2pBViY0=;
 b=CAloOdxvSr8DsB5A1YSbWr5JTnBN1quo3r4qU/cBv9znvMtg2P6NagsJZjZKQpXE3Msp
 ZYqTLDbbS1YoMjjxb5xVqbyfcHpRATCX99NjzR5TEZeSNzY4L4lhxNRPwlJhp06zzVe4
 fKFlz+Axz/09TE6dQWA9rIoHBThbvPCHc5rsAd68MtN70MaJ4AHFqfgdj++QNNlGLKs3
 2kO0Rm85T2tidl4l714hqD1w92cohqUSWmE2RjptuQ1aU6h+iwXJvkAm4YyQNBWgBWms
 ztKqOI636fW3BWQhLctCCOwH9sbeG3Pcy2nHBXgShlLds2dEOsdnktMy0CWXSyjEmfxR 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3100xwgrw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 21:02:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CKrlVr163993
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 21:00:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3100y90mqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 21:00:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CL0Ydg015165
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 21:00:34 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 14:00:34 -0700
Date:   Tue, 12 May 2020 14:00:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: use ordered buffers to initialize dquot buffers during
 quotacheck
Message-ID: <20200512210033.GL6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While QAing the new xfs_repair quotacheck code, I uncovered a quota
corruption bug resulting from a bad interaction between dquot buffer
initialization and quotacheck.  The bug can be reproduced with the
following sequence:

# mkfs.xfs -f /dev/sdf
# mount /dev/sdf /opt -o usrquota
# su nobody -s /bin/bash -c 'touch /opt/barf'
# sync
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            3      0      0  00 [------]
nobody          1      0      0  00 [------]

# xfs_io -x -c 'shutdown' /opt
# umount /opt
# mount /dev/sdf /opt -o usrquota
# touch /opt/man2
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            1      0      0  00 [------]
nobody          1      0      0  00 [------]

# umount /opt

Notice how the initial quotacheck set the root dquot icount to 3
(rootino, rbmino, rsumino), but after shutdown -> remount -> recovery,
xfs_quota reports that the root dquot has only 1 icount.  We haven't
deleted anything from the filesystem, which means that quota is now
under-counting.  This behavior is not limited to icount or the root
dquot, but this is the shortest reproducer.

I traced the cause of this discrepancy to the way that we handle ondisk
dquot updates during quotacheck vs. regular fs activity.  Normally, when
we allocate a disk block for a dquot, we log the buffer as a regular
(dquot) buffer.  Subsequent updates to the dquots backed by that block
are done via separate dquot log item updates, which means that they
depend on the logged buffer update being written to disk before the
dquot items.  Because individual dquots have their own LSN fields, that
initial dquot buffer must always be recovered.

However, the story changes for quotacheck, which can cause dquot block
allocations but persists the final dquot counter values via a delwri
list.  Because recovery doesn't gate dquot buffer replay on an LSN, this
means that the initial dquot buffer can be replayed over the (newer)
contents that were delwritten at the end of quotacheck.  In effect, this
re-initializes the dquot counters after they've been updated.  If the
log does not contain any other dquot items to recover, the obsolete
dquot contents will not be corrected by log recovery.

Because quotacheck uses a transaction to log the setting of the CHKD
flags in the superblock, we skip quotacheck during the second mount
call, which allows the incorrect icount to remain.

Fix this by changing the ondisk dquot initialization function to use
ordered buffers to write out fresh dquot blocks if it detects that we're
running quotacheck.  If the system goes down before quotacheck can
complete, the CHKD flags will not be set in the superblock and the next
mount will run quotacheck again, which can fix uninitialized dquot
buffers.  This requires amending the defer code to maintaine ordered
buffer state across defer rolls for the sake of the dquot allocation
code.

For regular operations we preserve the current behavior since the dquot
items require properly initialized ondisk dquot records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |   10 ++++++++-
 fs/xfs/xfs_dquot.c        |   51 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 00bd0e478829..c56d4715f521 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -243,10 +243,13 @@ xfs_defer_trans_roll(
 	struct xfs_log_item		*lip;
 	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
 	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
+	unsigned int			ordered = 0; /* bitmap */
 	int				bpcount = 0, ipcount = 0;
 	int				i;
 	int				error;
 
+	BUILD_BUG_ON(NBBY * sizeof(ordered) < XFS_DEFER_OPS_NR_BUFS);
+
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		switch (lip->li_type) {
 		case XFS_LI_BUF:
@@ -257,7 +260,10 @@ xfs_defer_trans_roll(
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
-				xfs_trans_dirty_buf(tp, bli->bli_buf);
+				if (bli->bli_flags & XFS_BLI_ORDERED)
+					ordered |= (1U << bpcount);
+				else
+					xfs_trans_dirty_buf(tp, bli->bli_buf);
 				bplist[bpcount++] = bli->bli_buf;
 			}
 			break;
@@ -298,6 +304,8 @@ xfs_defer_trans_roll(
 	/* Rejoin the buffers and dirty them so the log moves forward. */
 	for (i = 0; i < bpcount; i++) {
 		xfs_trans_bjoin(tp, bplist[i]);
+		if (ordered & (1U << i))
+			xfs_trans_ordered_buf(tp, bplist[i]);
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7f39dd24d475..cf8b2f4de587 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -243,16 +243,18 @@ xfs_qm_adjust_dqtimers(
  */
 STATIC void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	struct xfs_dqblk	*d;
+	xfs_dqid_t		curid;
+	unsigned int		qflag;
+	unsigned int		blftype;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -277,11 +279,34 @@ xfs_qm_init_dquot_blk(
 		}
 	}
 
-	xfs_trans_dquot_buf(tp, bp,
-			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
-			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
-			     XFS_BLF_GDQUOT_BUF)));
-	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
+	if (type & XFS_DQ_USER) {
+		qflag = XFS_UQUOTA_CHKD;
+		blftype = XFS_BLF_UDQUOT_BUF;
+	} else if (type & XFS_DQ_PROJ) {
+		qflag = XFS_PQUOTA_CHKD;
+		blftype = XFS_BLF_PDQUOT_BUF;
+	} else {
+		qflag = XFS_GQUOTA_CHKD;
+		blftype = XFS_BLF_GDQUOT_BUF;
+	}
+
+	xfs_trans_dquot_buf(tp, bp, blftype);
+
+	/*
+	 * If the CHKD flag isn't set, we're running quotacheck and need to use
+	 * ordered buffers so that the logged initialization buffer does not
+	 * get replayed over the delwritten quotacheck buffer.  If we crash
+	 * before the end of quotacheck, the CHKD flags will not be set in the
+	 * superblock and we'll re-run quotacheck at next mount.
+	 *
+	 * Outside of quotacheck, dquot updates are logged via dquot items and
+	 * we must use the regular buffer logging mechanisms to ensure that the
+	 * initial buffer state is recovered before dquot items.
+	 */
+	if (mp->m_qflags & qflag)
+		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
+	else
+		xfs_trans_ordered_buf(tp, bp);
 }
 
 /*
