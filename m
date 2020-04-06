Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EF1C2BA1E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE4F421D82
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dkRlXfzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgDFMgj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27692 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727952AbgDFMgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xh8JNhOR7YwcG0UOCYS8BiaHJWd/yQxs0ZRI8IX11Kw=;
        b=dkRlXfzmLBPwPdWRBvUPBzOjJVPa761EdiqeM7IxyvZb4rD5km0lgp5Ilv2FW5/KqYphrB
        gpACQHWb9bQlthxiapFqTVKwL5vLLiwyQBkq8aKPw4zG0KcbY0lLpnlZxFvw9GMA3Z1s0q
        mhLREc53sUlszfS2I5z3bYRCohdzOPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-jkdAlEHNPfKLY9Re1Tcqcg-1; Mon, 06 Apr 2020 08:36:35 -0400
X-MC-Unique: jkdAlEHNPfKLY9Re1Tcqcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F17F78017F3
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC0F960BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:34 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 03/10] xfs: extra runtime reservation overhead for relog transactions
Date:   Mon,  6 Apr 2020 08:36:25 -0400
Message-Id: <20200406123632.20873-4-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Every transaction reservation includes runtime overhead on top of
the reservation calculated in the struct xfs_trans_res. This
overhead is required for things like the CIL context ticket, log
headers, etc., that are stolen from individual transactions. Since
reservation for the relog transaction is entirely contributed by
regular transactions, this runtime reservation overhead must be
contributed as well. This means that a transaction that relogs one
or more items must include overhead for the current transaction as
well as for the relog transaction.

Define a new transaction flag to indicate that a transaction is
relog enabled. Plumb this state down to the log ticket allocation
and use it to bump the worst case overhead included in the
transaction. The overhead will eventually be transferred to the
relog system as needed for individual log items.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 +
 fs/xfs/xfs_log.c           | 12 +++++++++---
 fs/xfs/xfs_log.h           |  3 ++-
 fs/xfs/xfs_log_cil.c       |  2 +-
 fs/xfs/xfs_log_priv.h      |  1 +
 fs/xfs/xfs_trans.c         |  3 ++-
 6 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add9..1ede1e720a5c 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_RELOG		0x80	/* requires extra relog overhead */
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm -=
 when
  * free space is running low the extent allocator may choose to allocate=
 an
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d6b63490a78b..b55abde6c142 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -418,7 +418,8 @@ xfs_log_reserve(
 	int		 	cnt,
 	struct xlog_ticket	**ticp,
 	uint8_t		 	client,
-	bool			permanent)
+	bool			permanent,
+	bool			relog)
 {
 	struct xlog		*log =3D mp->m_log;
 	struct xlog_ticket	*tic;
@@ -433,7 +434,8 @@ xfs_log_reserve(
 	XFS_STATS_INC(mp, xs_try_logspace);
=20
 	ASSERT(*ticp =3D=3D NULL);
-	tic =3D xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
+	tic =3D xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, relo=
g,
+				0);
 	*ticp =3D tic;
=20
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -831,7 +833,7 @@ xlog_unmount_write(
 	uint			flags =3D XLOG_UNMOUNT_TRANS;
 	int			error;
=20
-	error =3D xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
+	error =3D xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, false, false);
 	if (error)
 		goto out_err;
=20
@@ -3421,6 +3423,7 @@ xlog_ticket_alloc(
 	int			cnt,
 	char			client,
 	bool			permanent,
+	bool			relog,
 	xfs_km_flags_t		alloc_flags)
 {
 	struct xlog_ticket	*tic;
@@ -3431,6 +3434,9 @@ xlog_ticket_alloc(
 		return NULL;
=20
 	unit_res =3D xfs_log_calc_unit_res(log->l_mp, unit_bytes);
+	/* double the overhead for the relog transaction */
+	if (relog)
+		unit_res +=3D (unit_res - unit_bytes);
=20
 	atomic_set(&tic->t_ref, 1);
 	tic->t_task		=3D current;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 6d2f30f42245..f1089a4b299c 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -123,7 +123,8 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 			  int		   count,
 			  struct xlog_ticket **ticket,
 			  uint8_t		   clientid,
-			  bool		   permanent);
+			  bool		   permanent,
+			  bool		   relog);
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void	  xfs_log_ungrant_bytes(struct xfs_mount *mp, int bytes);
 void      xfs_log_unmount(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b43f0e8f43f2..1c48e95402aa 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
 {
 	struct xlog_ticket *tic;
=20
-	tic =3D xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
+	tic =3D xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, false, false,
 				KM_NOFS);
=20
 	/*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ec22c7a3867f..08d8ff9bce1a 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -465,6 +465,7 @@ xlog_ticket_alloc(
 	int		count,
 	char		client,
 	bool		permanent,
+	bool		relog,
 	xfs_km_flags_t	alloc_flags);
=20
=20
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4fbe11485bbb..1b25980315bd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -177,6 +177,7 @@ xfs_trans_reserve(
 	 */
 	if (resp->tr_logres > 0) {
 		bool	permanent =3D false;
+		bool	relog	  =3D (tp->t_flags & XFS_TRANS_RELOG);
=20
 		ASSERT(tp->t_log_res =3D=3D 0 ||
 		       tp->t_log_res =3D=3D resp->tr_logres);
@@ -199,7 +200,7 @@ xfs_trans_reserve(
 						resp->tr_logres,
 						resp->tr_logcount,
 						&tp->t_ticket, XFS_TRANSACTION,
-						permanent);
+						permanent, relog);
 		}
=20
 		if (error)
--=20
2.21.1

