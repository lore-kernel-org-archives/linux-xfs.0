Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDA8C35242
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 21:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD4D02082E
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 21:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hiOO48up"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgBHVLL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 16:11:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30588 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727484AbgBHVLL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Feb 2020 16:11:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581196270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=RvYyOHTWdQ8lar0sLKSLs5XAq/Rj6jfo2R9TCaOBRm4=;
        b=hiOO48upWWBOICPiLy5dLS4Nov5NRMawBe6O6fVbV97MYM9UEjGlySFa7ISnuKUVEqCBp+
        z+cszyZqCnR++ghBCO1GYBkZpjh+P2QsQ6vDaJonIZE5h3pDjHde58uK/7gL38zJKSt9Eh
        XLhiVCyJeL4uz4gxzft1KPUDmzRsDjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-ibG7y4EJO8GvOOFq7HBoIA-1; Sat, 08 Feb 2020 16:11:08 -0500
X-MC-Unique: ibG7y4EJO8GvOOFq7HBoIA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72E7B107BA97
        for <linux-xfs@vger.kernel.org>; Sat,  8 Feb 2020 21:11:07 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4970C5C1D6
        for <linux-xfs@vger.kernel.org>; Sat,  8 Feb 2020 21:11:07 +0000 (UTC)
Subject: [PATCH 2/4] xfs: simplify args to xfs_get_defquota
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <26218bfd-b003-c1fc-3ea3-e53d9c35187d@redhat.com>
Date:   Sat, 8 Feb 2020 15:11:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There's no real reason to pass both xfs_dquot and xfs_quotainfo to
xfs_get_defquota, because the latter can be obtained from the former.
This simplifies a bit more of the argument passing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_dquot.c       |  3 +--
 fs/xfs/xfs_qm.c          | 17 ++++++++---------
 fs/xfs/xfs_qm.h          |  3 ++-
 fs/xfs/xfs_qm_syscalls.c |  2 +-
 fs/xfs/xfs_trans_dquot.c |  3 +--
 5 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 02f433d1f13a..ddf41c24efcd 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -69,13 +69,12 @@ xfs_qm_adjust_dqlimits(
 	struct xfs_mount	*mp,
 	struct xfs_dquot	*dq)
 {
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_def_quota	*defq;
 	int			prealloc = 0;
 
 	ASSERT(d->d_id);
-	defq = xfs_get_defquota(dq, q);
+	defq = xfs_get_defquota(dq);
 
 	if (defq->bsoftlimit && !d->d_blk_softlimit) {
 		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0b0909657bad..b3cd87d0bccb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -541,8 +541,7 @@ xfs_qm_shrink_count(
 STATIC void
 xfs_qm_set_defquota(
 	struct xfs_mount	*mp,
-	uint			type,
-	struct xfs_quotainfo	*qinf)
+	uint			type)
 {
 	struct xfs_dquot	*dqp;
 	struct xfs_def_quota	*defq;
@@ -554,7 +553,7 @@ xfs_qm_set_defquota(
 		return;
 
 	ddqp = &dqp->q_core;
-	defq = xfs_get_defquota(dqp, qinf);
+	defq = xfs_get_defquota(dqp);
 
 	/*
 	 * Timers and warnings have been already set, let's just set the
@@ -572,9 +571,9 @@ xfs_qm_set_defquota(
 /* Initialize quota time limits from the root dquot. */
 static void
 xfs_qm_init_timelimits(
-	struct xfs_mount	*mp,
-	struct xfs_quotainfo	*qinf)
+	struct xfs_mount	*mp)
 {
+	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
 	struct xfs_disk_dquot	*ddqp;
 	struct xfs_dquot	*dqp;
 	uint			type;
@@ -671,14 +670,14 @@ xfs_qm_init_quotainfo(
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
-	xfs_qm_init_timelimits(mp, qinf);
+	xfs_qm_init_timelimits(mp);
 
 	if (XFS_IS_UQUOTA_RUNNING(mp))
-		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
+		xfs_qm_set_defquota(mp, XFS_DQ_USER);
 	if (XFS_IS_GQUOTA_RUNNING(mp))
-		xfs_qm_set_defquota(mp, XFS_DQ_GROUP, qinf);
+		xfs_qm_set_defquota(mp, XFS_DQ_GROUP);
 	if (XFS_IS_PQUOTA_RUNNING(mp))
-		xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
+		xfs_qm_set_defquota(mp, XFS_DQ_PROJ);
 
 	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
 	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 3a850401b102..4cefe1abb1d4 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -164,9 +164,10 @@ extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
 static inline struct xfs_def_quota *
-xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
+xfs_get_defquota(struct xfs_dquot *dqp)
 {
 	struct xfs_def_quota *defq;
+	struct xfs_quotainfo *qi = dqp->q_mount->m_quotainfo;
 
 	if (XFS_QM_ISUDQ(dqp))
 		defq = &qi->qi_usr_default;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..e08c2f04f3ab 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -478,7 +478,7 @@ xfs_qm_scall_setqlim(
 		goto out_unlock;
 	}
 
-	defq = xfs_get_defquota(dqp, q);
+	defq = xfs_get_defquota(dqp);
 	xfs_dqunlock(dqp);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index d1b9869bc5fa..7470b02c5198 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -585,13 +585,12 @@ xfs_trans_dqresv(
 	xfs_qwarncnt_t		warnlimit;
 	xfs_qcnt_t		total_count;
 	xfs_qcnt_t		*resbcountp;
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 
 
 	xfs_dqlock(dqp);
 
-	defq = xfs_get_defquota(dqp, q);
+	defq = xfs_get_defquota(dqp);
 
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
 		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
-- 
2.17.0


