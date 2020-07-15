Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA669C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA3D2071B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EVIgt5eP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGOBx5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:53:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40312 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgGOBx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:53:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1kwd5101631;
        Wed, 15 Jul 2020 01:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=I5MCXRJowmJikaBfYqC4Xs4UkJRtdagzyZCORyHEkWo=;
 b=EVIgt5ePxPpV53yOvOauSnSxk3og1H4R58q+aw7XPsfJJngPpm1V9Z6osFdIrxf4Vts9
 4wQt38Rm2SeWU4Y/jK2TIEdTPeucWs2zlDphsUCVkre9Zvx7uy/qi7yibxKlzBowd7yK
 GkUSIBKUfNuSWPZvJkeebSZnS7uYaulquP9VMCcK3BeLoQlx/QjXMlXNVqsxVckMKa6Z
 z1bMh3RatCwKXPqi9LC6kt6EgMu3cFLQhFzKasI7f7ztHPp6L5Sed8YfKeMSQIQLPk25
 TClCCyYQux9DFJWLeZhWiLv7SsPZuGO/DefdW543Wh12Mrd3oHSiICvSE+QaPULs176Q 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32762ngggt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:51:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lchg125419;
        Wed, 15 Jul 2020 01:51:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 327q6teg02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:51:49 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1pm7l018749;
        Wed, 15 Jul 2020 01:51:48 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:51:48 -0700
Subject: [PATCH 11/26] xfs: stop using q_core.d_id in the quota code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:51:47 -0700
Message-ID: <159477790720.3263162.10464561542639267745.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a dquot id field to the incore dquot, and use that instead of the
one in qcore.  This eliminates a bunch of endian conversions and will
eventually allow us to remove qcore entirely.

We also rearrange the start of xfs_dquot to remove padding holes, saving
8 bytes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/scrub/quota.c     |   19 ++++++++++++-------
 fs/xfs/xfs_dquot.c       |   26 +++++++++++---------------
 fs/xfs/xfs_dquot.h       |    3 ++-
 fs/xfs/xfs_dquot_item.c  |    2 +-
 fs/xfs/xfs_qm.c          |   22 ++++++++++------------
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 fs/xfs/xfs_trace.h       |    2 +-
 fs/xfs/xfs_trans_dquot.c |    8 +++-----
 8 files changed, 42 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 023820d45a50..0d43a9adf5ae 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -93,7 +93,6 @@ xchk_quota_item(
 	unsigned long long	icount;
 	unsigned long long	rcount;
 	xfs_ino_t		fs_icount;
-	xfs_dqid_t		id = be32_to_cpu(d->d_id);
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -103,11 +102,11 @@ xchk_quota_item(
 	 * Except for the root dquot, the actual dquot we got must either have
 	 * the same or higher id as we saw before.
 	 */
-	offset = id / qi->qi_dqperchunk;
-	if (id && id <= sqi->last_id)
+	offset = dq->q_id / qi->qi_dqperchunk;
+	if (dq->q_id && dq->q_id <= sqi->last_id)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
-	sqi->last_id = id;
+	sqi->last_id = dq->q_id;
 
 	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
@@ -172,13 +171,19 @@ xchk_quota_item(
 	 * lower limit than the actual usage.  However, we flag it for
 	 * admin review.
 	 */
-	if (id != 0 && bhard != 0 && bcount > bhard)
+	if (dq->q_id == 0)
+		goto out;
+
+	if (bhard != 0 && bcount > bhard)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (id != 0 && ihard != 0 && icount > ihard)
+
+	if (ihard != 0 && icount > ihard)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (id != 0 && rhard != 0 && rcount > rhard)
+
+	if (rhard != 0 && rcount > rhard)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
+out:
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return -EFSCORRUPTED;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 93b5b7277cb8..5a7f8e49ec2b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -75,7 +75,7 @@ xfs_qm_adjust_dqlimits(
 	struct xfs_def_quota	*defq;
 	int			prealloc = 0;
 
-	ASSERT(d->d_id);
+	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(q, dq->q_type);
 
 	if (defq->bsoftlimit && !d->d_blk_softlimit) {
@@ -121,7 +121,7 @@ xfs_qm_adjust_dqtimers(
 	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_def_quota	*defq;
 
-	ASSERT(d->d_id);
+	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(qi, dq->q_type);
 
 #ifdef DEBUG
@@ -373,8 +373,7 @@ xfs_dquot_disk_alloc(
 	 * Make a chunk of dquots out of this buffer and log
 	 * the entire thing.
 	 */
-	xfs_qm_init_dquot_blk(tp, mp, be32_to_cpu(dqp->q_core.d_id),
-			dqp->q_type, bp);
+	xfs_qm_init_dquot_blk(tp, mp, dqp->q_id, dqp->q_type, bp);
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
 	/*
@@ -486,7 +485,7 @@ xfs_dquot_alloc(
 	dqp = kmem_zone_zalloc(xfs_qm_dqzone, 0);
 
 	dqp->q_type = type;
-	dqp->q_core.d_id = cpu_to_be32(id);
+	dqp->q_id = id;
 	dqp->q_mount = mp;
 	INIT_LIST_HEAD(&dqp->q_lru);
 	mutex_init(&dqp->q_qlock);
@@ -544,10 +543,10 @@ xfs_dquot_from_disk(
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
 	if ((ddqp->d_type & XFS_DDQTYPE_REC_MASK) != dqp->q_type ||
-	    ddqp->d_id != dqp->q_core.d_id) {
+	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
-			  __this_address, be32_to_cpu(dqp->q_core.d_id));
+			  __this_address, dqp->q_id);
 		xfs_alert(bp->b_mount, "Unmount and run xfs_repair");
 		return -EFSCORRUPTED;
 	}
@@ -1192,11 +1191,10 @@ xfs_qm_dqflush(
 	ddqp = &dqb->dd_diskdq;
 
 	/* sanity check the in-core structure before we flush */
-	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(dqp->q_core.d_id),
-			      0);
+	fa = xfs_dquot_verify(mp, &dqp->q_core, dqp->q_id, 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				be32_to_cpu(dqp->q_core.d_id), fa);
+				dqp->q_id, fa);
 		xfs_buf_relse(bp);
 		error = -EFSCORRUPTED;
 		goto out_abort;
@@ -1205,7 +1203,7 @@ xfs_qm_dqflush(
 	fa = xfs_qm_dqflush_check(dqp);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				be32_to_cpu(dqp->q_core.d_id), fa);
+				dqp->q_id, fa);
 		xfs_buf_relse(bp);
 		error = -EFSCORRUPTED;
 		goto out_abort;
@@ -1278,8 +1276,7 @@ xfs_dqlock2(
 {
 	if (d1 && d2) {
 		ASSERT(d1 != d2);
-		if (be32_to_cpu(d1->q_core.d_id) >
-		    be32_to_cpu(d2->q_core.d_id)) {
+		if (d1->q_id > d2->q_id) {
 			mutex_lock(&d2->q_qlock);
 			mutex_lock_nested(&d1->q_qlock, XFS_QLOCK_NESTED);
 		} else {
@@ -1347,9 +1344,8 @@ xfs_qm_dqiterate(
 			return error;
 
 		error = iter_fn(dq, type, priv);
-		id = be32_to_cpu(dq->q_core.d_id);
+		id = dq->q_id;
 		xfs_qm_dqput(dq);
-		id++;
 	} while (error == 0 && id != 0);
 
 	return error;
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 84399d1d8188..9da4cb3d752b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -35,9 +35,10 @@ struct xfs_dquot {
 	struct xfs_mount	*q_mount;
 	xfs_dqtype_t		q_type;
 	uint16_t		q_flags;
+	xfs_dqid_t		q_id;
 	uint			q_nrefs;
-	xfs_daddr_t		q_blkno;
 	int			q_bufoffset;
+	xfs_daddr_t		q_blkno;
 	xfs_fileoff_t		q_fileoffset;
 
 	struct xfs_disk_dquot	q_core;
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index fc21e48c889c..8c1fdf37ee8f 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -53,7 +53,7 @@ xfs_qm_dquot_logitem_format(
 	qlf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_QFORMAT);
 	qlf->qlf_type = XFS_LI_DQUOT;
 	qlf->qlf_size = 2;
-	qlf->qlf_id = be32_to_cpu(qlip->qli_dquot->q_core.d_id);
+	qlf->qlf_id = qlip->qli_dquot->q_id;
 	qlf->qlf_blkno = qlip->qli_dquot->q_blkno;
 	qlf->qlf_len = 1;
 	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f6c18cc0c970..f63922277120 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -79,7 +79,7 @@ xfs_qm_dquot_walk(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_dquot *dqp = batch[i];
 
-			next_index = be32_to_cpu(dqp->q_core.d_id) + 1;
+			next_index = dqp->q_id + 1;
 
 			error = execute(batch[i], data);
 			if (error == -EAGAIN) {
@@ -161,8 +161,7 @@ xfs_qm_dqpurge(
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
 
-	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_type),
-			  be32_to_cpu(dqp->q_core.d_id));
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_type), dqp->q_id);
 	qi->qi_dquots--;
 
 	/*
@@ -1108,7 +1107,7 @@ xfs_qm_quotacheck_dqadjust(
 	 *
 	 * There are no timers for the default values set in the root dquot.
 	 */
-	if (dqp->q_core.d_id) {
+	if (dqp->q_id) {
 		xfs_qm_adjust_dqlimits(mp, dqp);
 		xfs_qm_adjust_dqtimers(mp, dqp);
 	}
@@ -1594,8 +1593,7 @@ xfs_qm_dqfree_one(
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	mutex_lock(&qi->qi_tree_lock);
-	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_type),
-			  be32_to_cpu(dqp->q_core.d_id));
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_type), dqp->q_id);
 
 	qi->qi_dquots--;
 	mutex_unlock(&qi->qi_tree_lock);
@@ -1819,7 +1817,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    i_uid_read(VFS_I(ip)) != be32_to_cpu(udqp->q_core.d_id)) {
+	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1832,7 +1830,7 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    i_gid_read(VFS_I(ip)) != be32_to_cpu(gdqp->q_core.d_id)) {
+	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1841,7 +1839,7 @@ xfs_qm_vop_chown_reserve(
 	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
+	    ip->i_d.di_projid != pdqp->q_id) {
 		pdq_delblks = pdqp;
 		if (delblks) {
 			ASSERT(ip->i_pdquot);
@@ -1925,21 +1923,21 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(i_uid_read(VFS_I(ip)) == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(i_uid_read(VFS_I(ip)) == udqp->q_id);
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(i_gid_read(VFS_I(ip)) == be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(i_gid_read(VFS_I(ip)) == gdqp->q_id);
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
+		ASSERT(ip->i_d.di_projid == pdqp->q_id);
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
 		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7f157275e370..15158e5e07e6 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -656,7 +656,7 @@ xfs_qm_scall_getquota_fill_qc(
 	if (((XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_USER) ||
 	     (XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_GROUP) ||
 	     (XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_PROJ)) &&
-	    dqp->q_core.d_id != 0) {
+	    dqp->q_id != 0) {
 		if ((dst->d_space > dst->d_spc_softlimit) &&
 		    (dst->d_spc_softlimit > 0)) {
 			ASSERT(dst->d_spc_timer != 0);
@@ -723,7 +723,7 @@ xfs_qm_scall_getquota_next(
 		return error;
 
 	/* Fill in the ID we actually read from disk */
-	*id = be32_to_cpu(dqp->q_core.d_id);
+	*id = dqp->q_id;
 
 	xfs_qm_scall_getquota_fill_qc(mp, type, dqp, dst);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0b6738070619..8a73d30c4a87 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -877,7 +877,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 	), \
 	TP_fast_assign(
 		__entry->dev = dqp->q_mount->m_super->s_dev;
-		__entry->id = be32_to_cpu(dqp->q_core.d_id);
+		__entry->id = dqp->q_id;
 		__entry->type = dqp->q_type;
 		__entry->flags = dqp->q_flags;
 		__entry->nrefs = dqp->q_nrefs;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index bdbd8e88c772..302aee9ccf80 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -386,7 +386,7 @@ xfs_trans_apply_dquot_deltas(
 			 * Get any default limits in use.
 			 * Start/reset the timer(s) if needed.
 			 */
-			if (d->d_id) {
+			if (dqp->q_id) {
 				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
 				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
 			}
@@ -565,8 +565,7 @@ xfs_quota_warn(
 		return;
 	}
 
-	quota_send_warning(make_kqid(&init_user_ns, qtype,
-				     be32_to_cpu(dqp->q_core.d_id)),
+	quota_send_warning(make_kqid(&init_user_ns, qtype, dqp->q_id),
 			   mp->m_super->s_dev, type);
 }
 
@@ -625,8 +624,7 @@ xfs_trans_dqresv(
 		resbcountp = &dqp->q_res_rtbcount;
 	}
 
-	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
-	    dqp->q_core.d_id &&
+	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
 	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
 	     (XFS_IS_GQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISGDQ(dqp)) ||
 	     (XFS_IS_PQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISPDQ(dqp)))) {

