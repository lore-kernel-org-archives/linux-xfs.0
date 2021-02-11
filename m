Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CB3C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FEE164E8A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBKRI0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 12:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231322AbhBKRGw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 12:06:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE49C64E15;
        Thu, 11 Feb 2021 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613063171;
        bh=X3RLJtJvSvy7VFqbK368eTjfK+HK5mYRNCD9dHUa7eE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/xPWqAxlxJ22CLVqfS5ZhUAxdQ9GuVrgWjSeb34XkkPgPinuL7XzgI5fBkoFubSf
         p9TY/gNGkGZ+mPiQeTLZjL/+Yyz0fADSXyBkZiNyfPB2A+sVQYHx5xX9Gjwar4HvXz
         /WFKwZnkEMfS3ToygREk6xgV37WynX/qlVmTCFLfx9TLBPcpYjdDgzKuzECSKMc/bX
         bw8UICELtvd2p/6fAjQ27HBCyT8ZGbq4RyFBUSVejo5MFTQl462KcmjQvqeJpV171P
         ZEuNmZDRbKZSxT5ewlxCLqcD2S360IQTsQ07dsQeTKEwqf4MvR/+VRfzFF4DeuxV5f
         CToi4yaxXy4Ug==
Date:   Thu, 11 Feb 2021 09:06:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Subject: [PATCH v4.1 5/6] xfs_repair: check dquot id and type
Message-ID: <20210211170611.GD7193@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284390433.3058224.6853671538193339438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284390433.3058224.6853671538193339438.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we actually check the type and id of an ondisk dquot.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v4.1: fix backwards logic pointed out by Chaitanya
---
 repair/quotacheck.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 55bcc048..0a505c9c 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -234,12 +234,48 @@ quotacheck_adjust(
 	libxfs_irele(ip);
 }
 
+/* Check the ondisk dquot's id and type match what the incore dquot expects. */
+static bool
+qc_dquot_check_type(
+	struct xfs_mount	*mp,
+	xfs_dqtype_t		type,
+	xfs_dqid_t		id,
+	struct xfs_disk_dquot	*ddq)
+{
+	uint8_t			ddq_type;
+
+	ddq_type = ddq->d_type & XFS_DQTYPE_REC_MASK;
+
+	if (be32_to_cpu(ddq->d_id) != id)
+		return false;
+
+	/*
+	 * V5 filesystems always expect an exact type match.  V4 filesystems
+	 * expect an exact match for user dquots and for non-root group and
+	 * project dquots.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb) || type == XFS_DQTYPE_USER || id)
+		return ddq_type == type;
+
+	/*
+	 * V4 filesystems support either group or project quotas, but not both
+	 * at the same time.  The non-user quota file can be switched between
+	 * group and project quota uses depending on the mount options, which
+	 * means that we can encounter the other type when we try to load quota
+	 * defaults.  Quotacheck will soon reset the the entire quota file
+	 * (including the root dquot) anyway, but don't log scary corruption
+	 * reports to dmesg.
+	 */
+	return ddq_type == XFS_DQTYPE_GROUP || ddq_type == XFS_DQTYPE_PROJ;
+}
+
 /* Compare this on-disk dquot against whatever we observed. */
 static void
 qc_check_dquot(
 	struct xfs_mount	*mp,
 	struct xfs_disk_dquot	*ddq,
-	struct qc_dquots	*dquots)
+	struct qc_dquots	*dquots,
+	xfs_dqid_t		dqid)
 {
 	struct qc_rec		*qrec;
 	struct qc_rec		empty = {
@@ -253,6 +289,22 @@ qc_check_dquot(
 	if (!qrec)
 		qrec = &empty;
 
+	if (!qc_dquot_check_type(mp, dquots->type, dqid, ddq)) {
+		const char	*dqtypestr;
+
+		dqtypestr = qflags_typestr(ddq->d_type & XFS_DQTYPE_REC_MASK);
+		if (dqtypestr)
+			do_warn(_("%s id %u saw type %s id %u\n"),
+					qflags_typestr(dquots->type), dqid,
+					dqtypestr, be32_to_cpu(ddq->d_id));
+		else
+			do_warn(_("%s id %u saw type %x id %u\n"),
+					qflags_typestr(dquots->type), dqid,
+					ddq->d_type & XFS_DQTYPE_REC_MASK,
+					be32_to_cpu(ddq->d_id));
+		chkd_flags = 0;
+	}
+
 	if (be64_to_cpu(ddq->d_bcount) != qrec->bcount) {
 		do_warn(_("%s id %u has bcount %llu, expected %"PRIu64"\n"),
 				qflags_typestr(dquots->type), id,
@@ -327,11 +379,11 @@ _("cannot read %s inode %"PRIu64", block %"PRIu64", disk block %"PRIu64", err=%d
 		}
 
 		dqb = bp->b_addr;
-		dqid = map->br_startoff * dqperchunk;
+		dqid = (map->br_startoff + bno) * dqperchunk;
 		for (dqnr = 0;
 		     dqnr < dqperchunk && dqid <= UINT_MAX;
 		     dqnr++, dqb++, dqid++)
-			qc_check_dquot(mp, &dqb->dd_diskdq, dquots);
+			qc_check_dquot(mp, &dqb->dd_diskdq, dquots, dqid);
 		libxfs_buf_relse(bp);
 	}
 
