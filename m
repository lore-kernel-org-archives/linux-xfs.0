Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BA8C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 588B221655
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gknILPF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfKJGY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 01:24:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23187 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726612AbfKJGY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 01:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573367064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkSRsCZscJsI9dRDZJMwYVZoRrCUNZAH/OSYfFkL5bc=;
        b=gknILPF1UOqVZ+kuqmkSCS8xZCVlKWJW6WAd5WQSFUCNMYUo4/dvlD2IP/VMS15dE/lW0R
        dRubQTjdJemoReAnEe1OR1S54Q+bnzh+jjKtPtmuElBkjN9L271tSYSIKtLmZPbGwLEgD9
        D7GpsouCzqDhSAfa8TDKL1Elv5HbGCo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-htPdWv0xOlyVcux-ILb9jw-1; Sun, 10 Nov 2019 01:24:23 -0500
Received: by mail-wr1-f69.google.com with SMTP id p6so7240659wrs.5
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 22:24:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dAhCpuy8ZWI1UzY1s3xB311ROTF3Xt0Hu1hn5acD0BM=;
        b=EfEHPxSp+1ZT+yw45GCEwCiPjK1/CjvXk/6ilPXW/lCt7h7aq7qAiyLIBs6t9uJQrb
         N4+8GS7VbttJEfzEmaLNQRjIH6CXQdNBYx4i+DTz4h70wZw2GZLT3ps8b43p4e8DIk5k
         dyZWCOrTlZMFW470trJKuoF2PEvEepQ6l31vY0JxOX6dhIl7mZ81q0jtiNzmnPKrORRf
         EglRzbcW9phryYy5GhW/+KBLFt2oe4lcRn02XL8P7XEJUKazeK2OO3tuUKQ7WzQsyiqc
         641MOvxTQEcNiHUOXz62l3+EcnjHUsLsJj8Vr6ZdjLSxV3vilIyYSTgXNYpDKBXvjyOH
         01kg==
X-Gm-Message-State: APjAAAU+CFR+UnYLcskSipqxj+ENEkXLNnCezIN2bFvR0c1tZsAA/zrL
        1CtUosIH+lcjN5l37WiwLtYelLRJqgXhSeGiSiY4vHmgpEvaaDC7BC6Lixq2sz7bMwVUAmKgtMT
        kVAmjVAXGHosBIZX1T+fA
X-Received: by 2002:adf:fec5:: with SMTP id q5mr4238928wrs.293.1573367061599;
        Sat, 09 Nov 2019 22:24:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSE6XU6NUNQ7lgxZcU+7mArOepMpqPpi5BjNgMMxTwhwoQ2QA9klYNe+RP8iJfo5OHY+U4cA==
X-Received: by 2002:adf:fec5:: with SMTP id q5mr4238914wrs.293.1573367061355;
        Sat, 09 Nov 2019 22:24:21 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id b196sm16261618wmd.24.2019.11.09.22.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 22:24:20 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v3 4/4] xfs: remove the xfs_qoff_logitem_t typedef
Date:   Sun, 10 Nov 2019 07:24:04 +0100
Message-Id: <20191110062404.948433-5-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191110062404.948433-1-preichl@redhat.com>
References: <20191110062404.948433-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: htPdWv0xOlyVcux-ILb9jw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
 fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
 fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
 fs/xfs/xfs_trans_dquot.c       | 14 +++++++-------
 4 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.=
c
index 271cca13565b..eb7fe42b1d61 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -741,7 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
=20
 /*
  * Turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    sizeof(struct xfs_qoff_logitem) * 2
  *    the superblock for the quota flags: sector size
  */
 STATIC uint
@@ -754,7 +754,7 @@ xfs_calc_qm_quotaoff_reservation(
=20
 /*
  * End of turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
 xfs_calc_qm_quotaoff_end_reservation(void)
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 3a64a7fd3b8a..e94003271e74 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -12,24 +12,26 @@ struct xfs_mount;
 struct xfs_qoff_logitem;
=20
 struct xfs_dq_logitem {
-=09struct xfs_log_item=09 qli_item;=09/* common portion */
+=09struct xfs_log_item=09qli_item;=09/* common portion */
 =09struct xfs_dquot=09*qli_dquot;=09/* dquot ptr */
-=09xfs_lsn_t=09=09 qli_flush_lsn;=09/* lsn at last flush */
+=09xfs_lsn_t=09=09qli_flush_lsn;=09/* lsn at last flush */
 };
=20
-typedef struct xfs_qoff_logitem {
-=09struct xfs_log_item=09 qql_item;=09/* common portion */
-=09struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any *=
/
+struct xfs_qoff_logitem {
+=09struct xfs_log_item=09qql_item;=09/* common portion */
+=09struct xfs_qoff_logitem *qql_start_lip;=09/* qoff-start logitem, if any=
 */
 =09unsigned int=09=09qql_flags;
-} xfs_qoff_logitem_t;
+};
=20
=20
-extern void=09=09   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
-extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
-=09=09=09=09=09struct xfs_qoff_logitem *, uint);
-extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
-=09=09=09=09=09struct xfs_qoff_logitem *, uint);
-extern void=09=09   xfs_trans_log_quotaoff_item(struct xfs_trans *,
-=09=09=09=09=09struct xfs_qoff_logitem *);
+void=09=09=09xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
+struct xfs_qoff_logitem=09*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
+=09=09=09=09=09struct xfs_qoff_logitem *start,
+=09=09=09=09=09uint flags);
+struct xfs_qoff_logitem=09*xfs_trans_get_qoff_item(struct xfs_trans *tp,
+=09=09=09=09=09struct xfs_qoff_logitem *startqoff,
+=09=09=09=09=09uint flags);
+void=09=09=09xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
+=09=09=09=09=09struct xfs_qoff_logitem *qlp);
=20
 #endif=09/* __XFS_DQUOT_ITEM_H__ */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index da7ad0383037..e685b9ae90b9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,9 +19,12 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
=20
-STATIC int=09xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uin=
t);
-STATIC int=09xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-=09=09=09=09=09uint);
+STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
+=09=09=09=09=09struct xfs_qoff_logitem **qoffstartp,
+=09=09=09=09=09uint flags);
+STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
+=09=09=09=09=09struct xfs_qoff_logitem *startqoff,
+=09=09=09=09=09uint flags);
=20
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -40,7 +43,7 @@ xfs_qm_scall_quotaoff(
 =09uint=09=09=09dqtype;
 =09int=09=09=09error;
 =09uint=09=09=09inactivate_flags;
-=09xfs_qoff_logitem_t=09*qoffstart;
+=09struct xfs_qoff_logitem=09*qoffstart;
=20
 =09/*
 =09 * No file system can have quotas enabled on disk but not in core.
@@ -540,13 +543,13 @@ xfs_qm_scall_setqlim(
=20
 STATIC int
 xfs_qm_log_quotaoff_end(
-=09xfs_mount_t=09=09*mp,
-=09xfs_qoff_logitem_t=09*startqoff,
+=09struct xfs_mount=09*mp,
+=09struct xfs_qoff_logitem=09*startqoff,
 =09uint=09=09=09flags)
 {
-=09xfs_trans_t=09=09*tp;
+=09struct xfs_trans=09*tp;
 =09int=09=09=09error;
-=09xfs_qoff_logitem_t=09*qoffi;
+=09struct xfs_qoff_logitem=09*qoffi;
=20
 =09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp=
);
 =09if (error)
@@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
=20
 STATIC int
 xfs_qm_log_quotaoff(
-=09xfs_mount_t=09       *mp,
-=09xfs_qoff_logitem_t     **qoffstartp,
-=09uint=09=09       flags)
+=09struct xfs_mount=09*mp,
+=09struct xfs_qoff_logitem=09**qoffstartp,
+=09uint=09=09=09flags)
 {
-=09xfs_trans_t=09       *tp;
+=09struct xfs_trans=09*tp;
 =09int=09=09=09error;
-=09xfs_qoff_logitem_t     *qoffi;
+=09struct xfs_qoff_logitem=09*qoffi;
=20
 =09*qoffstartp =3D NULL;
=20
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index d319347093d6..0fdc96ed805a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
 /*
  * This routine is called to allocate a quotaoff log item.
  */
-xfs_qoff_logitem_t *
+struct xfs_qoff_logitem *
 xfs_trans_get_qoff_item(
-=09xfs_trans_t=09=09*tp,
-=09xfs_qoff_logitem_t=09*startqoff,
-=09uint=09=09=09flags)
+=09struct xfs_trans=09=09*tp,
+=09struct xfs_qoff_logitem=09*startqoff,
+=09uint=09=09=09 flags)
 {
-=09xfs_qoff_logitem_t=09*q;
+=09struct xfs_qoff_logitem=09*q;
=20
 =09ASSERT(tp !=3D NULL);
=20
@@ -852,8 +852,8 @@ xfs_trans_get_qoff_item(
  */
 void
 xfs_trans_log_quotaoff_item(
-=09xfs_trans_t=09=09*tp,
-=09xfs_qoff_logitem_t=09*qlp)
+=09struct xfs_trans=09*tp,
+=09struct xfs_qoff_logitem=09*qlp)
 {
 =09tp->t_flags |=3D XFS_TRANS_DIRTY;
 =09set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
--=20
2.23.0

