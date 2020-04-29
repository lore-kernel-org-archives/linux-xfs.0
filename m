Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADDCC83006
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C35B20737
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OP1iqdin"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgD2Cqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 22:46:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgD2Cqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 22:46:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2hShc072984
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CKgS1tjHLD9NlvCvq7xsFqRR5iH33tIBhkJEEn/+HsU=;
 b=OP1iqdincTX/qY4Au+SSMWhyzNCmj/XMrxJ+faLaBjIH+4ne61figltYZlS8s4AIpA5K
 i8DNzSx5cWmaXM6zAjU8f29F0r7fqDAQ+HQvNxUyu4QX8/wbLtd1X3en9ShAgcchYZQj
 wKgyPCzjNELygtd897ujXTpv27PsftxehNXSGmMSgf7An0etwZcasZKNzLgPwT/e0Z1r
 FHpbEcSaWpNOagmie1Aj2WyPxGDqUo1zIb6axxUZB9LAt16qgCi4UXM442WXhJP6D54d
 8OewFDnMI36Df3I7fhjYbeiWCYpak/1nOQ0IhYN8HMwCDFBcXfgM9xdckh/4JcSmVP+L Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg39ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2gg3m071553
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30mxphp5uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:28 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03T2kRnM023161
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 19:46:27 -0700
Subject: [PATCH 2/5] xfs: create temporary files and directories for online
 repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Apr 2020 19:46:26 -0700
Message-ID: <158812838655.169849.13868470966237126958.stgit@magnolia>
In-Reply-To: <158812837421.169849.625434931406278072.stgit@magnolia>
References: <158812837421.169849.625434931406278072.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=3
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=3 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach the online repair code how to create temporary files or
directories.  These temporary files can be used to stage reconstructed
information until we're ready to perform an atomic extent swap to commit
the new metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    1 
 fs/xfs/scrub/scrub.c  |    6 ++
 fs/xfs/scrub/scrub.h  |    3 +
 4 files changed, 132 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c134804bc5a1..0ec483d511cd 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -31,6 +31,9 @@
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_health.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_dir2.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1502,6 +1505,125 @@ xrep_metadata_inode_forks(
 	return error;
 }
 
+/* Create a temporary file or directory. */
+int
+xrep_create_tempfile(
+	struct xfs_scrub	*sc,
+	uint16_t		mode)
+{
+	struct xfs_ialloc_args	args = {
+		.pip		= sc->mp->m_rootip,
+		.nlink		= 0,
+		.mode		= mode,
+	};
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_trans	*tp = NULL;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_trans_res	*tres;
+	unsigned int		resblks;
+	bool			is_dir = S_ISDIR(mode);
+	int			error;
+
+	ASSERT(sc->tp == NULL);
+	ASSERT(sc->tempip == NULL);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/*
+	 * Make sure that we have allocated dquot(s) on disk.  The temporary
+	 * inode should be completely root owned, but we'll still go through
+	 * the motions to keep the quota accounting accurate.
+	 */
+	error = xfs_qm_vop_dqalloc(sc->mp->m_rootip, args.uid, args.gid,
+			args.prid, XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+			&udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	if (is_dir) {
+		resblks = XFS_MKDIR_SPACE_RES(mp, 0);
+		tres = &M_RES(mp)->tr_mkdir;
+	} else {
+		resblks = XFS_IALLOC_SPACE_RES(mp);
+		tres = &M_RES(mp)->tr_create_tmpfile;
+	}
+
+	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+	if (error)
+		goto out_release_inode;
+
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, pdqp, resblks,
+			1, 0);
+	if (error)
+		goto out_trans_cancel;
+
+	/* Allocate inode, set up directory. */
+	error = xfs_dir_ialloc(&tp, &args, &sc->tempip);
+	if (error)
+		goto out_trans_cancel;
+
+	if (is_dir) {
+		error = xfs_dir_init(tp, sc->tempip, sc->mp->m_rootip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	/*
+	 * Attach the dquot(s) to the inodes and modify them incore.
+	 * These ids of the inode couldn't have changed since the new
+	 * inode has been locked ever since it was created.
+	 */
+	xfs_qm_vop_create_dqattach(tp, sc->tempip, udqp, gdqp, pdqp);
+
+	/*
+	 * Put our temp file on the unlinked list so it's purged automatically.
+	 * Anything being reconstructed using this file must be atomically
+	 * swapped with the original file because the contents here will be
+	 * purged when the inode is dropped or log recovery cleans out the
+	 * unlinked list.
+	 */
+	error = xfs_iunlink(tp, sc->tempip);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_release_inode;
+
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	/* Finish setting up the incore / vfs context. */
+	xfs_setup_iops(sc->tempip);
+	xfs_finish_inode_setup(sc->tempip);
+
+	sc->temp_ilock_flags = 0;
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+out_release_inode:
+	/*
+	 * Wait until after the current transaction is aborted to finish the
+	 * setup of the inode and release the inode.  This prevents recursive
+	 * transactions and deadlocks from xfs_inactive.
+	 */
+	if (sc->tempip) {
+		xfs_finish_inode_setup(sc->tempip);
+		xfs_irele(sc->tempip);
+	}
+
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	return error;
+}
+
 /*
  * Make sure that the given range of the data fork of the metadata file being
  * checked is mapped to written blocks.  The caller must ensure that the inode
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9388b3ce1cb8..299d39360c11 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -32,6 +32,7 @@ int xrep_alloc_ag_block(struct xfs_scrub *sc,
 int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 		struct xfs_buf **bpp, xfs_btnum_t btnum,
 		const struct xfs_buf_ops *ops);
+int xrep_create_tempfile(struct xfs_scrub *sc, uint16_t mode);
 int xrep_fallocate(struct xfs_scrub *sc, xfs_fileoff_t off, xfs_filblks_t len);
 
 typedef int (*xrep_setfile_getbuf_fn)(struct xfs_scrub *sc,
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a2911a01cf68..a6f5b5c21f3f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -194,6 +194,12 @@ xchk_teardown(
 		kmem_free(sc->buf);
 		sc->buf = NULL;
 	}
+	if (sc->tempip) {
+		if (sc->temp_ilock_flags)
+			xfs_iunlock(sc->tempip, sc->temp_ilock_flags);
+		xfs_irele(sc->tempip);
+		sc->tempip = NULL;
+	}
 	return error;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b8d582808cd3..798942bd7eaf 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -72,6 +72,9 @@ struct xfs_scrub {
 	struct file			*xfile;
 	uint				ilock_flags;
 
+	struct xfs_inode		*tempip;
+	uint				temp_ilock_flags;
+
 	/* See the XCHK/XREP state flags below. */
 	unsigned int			flags;
 

