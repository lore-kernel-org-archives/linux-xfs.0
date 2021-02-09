Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3513C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C0364EB1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBIETL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhBIEQS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:16:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A5D64ED0;
        Tue,  9 Feb 2021 04:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843904;
        bh=GnlZY/3mOVfmPQ9biLLARdwZSTWcxVryyl9AoJoG+lk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kGXuajRv2/XTA9vXPos9o+43cIOJ/FBBtJ5hSVQAjwcngt50XpK7MdQ9XUOhgapve
         2YJIzuKSkT3aaUPvyQftH9bvMgdNOG7rB42KvIDQ0ZjAURxpzbA8QqlDdwGThWRu3L
         Be9Tqd2igJmS2eVruRWgmIedXdojvUszp3Ee4wlwcTre71jcz9pzcyb6Q1sAC9rFw9
         MBcsa6REXbnQou4MHoVqYjun6EyZ8jocMqu8/nfj6pgleJ1076DU/o8ZIefSWjmAZJ
         sQVJ2B4gnx3xnQXa8CputpPwnGh9d8TKNvSMwD/gXJbs8DmZGh+EqNNqEBpaznlfNA
         UTY5FTZUs16fA==
Subject: [PATCH 5/6] xfs_repair: check dquot id and type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Date:   Mon, 08 Feb 2021 20:11:44 -0800
Message-ID: <161284390433.3058224.6853671538193339438.stgit@magnolia>
In-Reply-To: <161284387610.3058224.6236053293202575597.stgit@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we actually check the type and id of an ondisk dquot.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/quotacheck.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 55bcc048..0ea2deb5 100644
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
+	if (xfs_sb_version_hascrc(&mp->m_sb) || type == XFS_DQTYPE_USER || !id)
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
 

