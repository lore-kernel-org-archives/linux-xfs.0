Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F64BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 235DC2065F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FYmcxzeL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgENQ7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 12:59:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53486 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgENQ7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 12:59:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGuUKs071904;
        Thu, 14 May 2020 16:59:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=AFQqPJrXbTiOGA5IgfrQZvX1M8yUmDknkxG/JqrszhE=;
 b=FYmcxzeLSmZiuGRWxOghYPheR9KBWi7EOwt7Fg/xL6GNv+vOoUcMvY5ej24ZL2nbNuyO
 DJu7AdfDhvpuxfXQQQsbZ6A57JjRYU8tXEmrxC6t7ZcJjLG3VLzLaw/rnx+2dC+IlhAl
 /nKl5hvR+bjV+TQdaRWltq86YF18nZWM1P13J3iGirxFEVXbOU2SpCFSHwQgsl7Lzy2s
 6rGJULoCIWW215qniEvJWjAs+fusqvabmQquxwjzNcsuYfF9MX87fMf6pFD2aq0+iTy2
 NvS8mWKX7ACnLO3VHXRMOuVD3q/bZPSvyJJ3TY55inRi0s7rAQ1hB9IShLf2leB6AV6H 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3100yg3tg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:59:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGs5sb154633;
        Thu, 14 May 2020 16:57:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3100yh5eqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 16:57:01 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04EGuxFm023009;
        Thu, 14 May 2020 16:56:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 09:56:59 -0700
Date:   Thu, 14 May 2020 09:56:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, david@fromorbit.com
Subject: [PATCH v2] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200514165658.GC6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140150
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
v2: rework the code comment explaining all this
---
 fs/xfs/libxfs/xfs_defer.c |   10 +++++++
 fs/xfs/xfs_dquot.c        |   62 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 1172fbf072d8..d8f586256add 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -240,10 +240,13 @@ xfs_defer_trans_roll(
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
@@ -254,7 +257,10 @@ xfs_defer_trans_roll(
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
@@ -295,6 +301,8 @@ xfs_defer_trans_roll(
 	/* Rejoin the buffers and dirty them so the log moves forward. */
 	for (i = 0; i < bpcount; i++) {
 		xfs_trans_bjoin(tp, bplist[i]);
+		if (ordered & (1U << i))
+			xfs_trans_ordered_buf(tp, bplist[i]);
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 52e0f7245afc..f60a8967f9d5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -205,16 +205,18 @@ xfs_qm_adjust_dqtimers(
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
@@ -238,11 +240,45 @@ xfs_qm_init_dquot_blk(
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
+	 * When quotacheck runs, we use delayed writes to update all the dquots
+	 * on disk in an efficient manner instead of logging the individual
+	 * dquot changes as they are made.
+	 *
+	 * Hence if we log the buffer that we allocate here, then crash
+	 * post-quotacheck while the logged initialisation is still in the
+	 * active region of the log, we can lose the information quotacheck
+	 * wrote directly to the buffer. That is, log recovery will replay the
+	 * dquot buffer initialisation over the top of whatever information
+	 * quotacheck had written to the buffer.
+	 *
+	 * To avoid this problem, dquot allocation during quotacheck needs to
+	 * avoid logging the initialised buffer, but we still need to have
+	 * writeback of the buffer pin the tail of the log so that it is
+	 * initialised on disk before we remove the allocation transaction from
+	 * the active region of the log. Marking the buffer as ordered instead
+	 * of logging it provides this behaviour.
+	 *
+	 * If we crash before quotacheck completes, a subsequent quotacheck run
+	 * will re-allocate and re-initialize the dquot records as needed.
+	 */
+	if (!(mp->m_qflags & qflag))
+		xfs_trans_ordered_buf(tp, bp);
+	else
+		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
 /*
