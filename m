Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7B4C17441
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D89D420818
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PSicgtTI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKLVtf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:49:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41673 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726981AbfKLVtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 16:49:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573595374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hw6Q/URE6ll7x40Fdw5bLRVoIeKI8PJPwog88218IfQ=;
        b=PSicgtTInGRe4aWELML39NH+VpI4Pl1WlijdKDJwln4fmHz7aU2dRBIfcg4zySMd+hoc7+
        16JH7ENldkkW7AJolVhtZ3LQlW3tbqLMLNKu26O1vNYRn76itsNaX7YsV6LBmC1e9iOKZs
        f3rwVl4neVso9bBcXsCVNptLBXLmUjE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-YpqTag4oNyidLpdK7VnFvQ-1; Tue, 12 Nov 2019 16:49:33 -0500
Received: by mail-wm1-f70.google.com with SMTP id v8so2010645wml.4
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 13:49:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vU84d5cVt5Q1QsY70sBF07dceYYY8mk3bm3rNOzSe9E=;
        b=lXmT5LnvH86HmiFj9QTvheeK5yB+akAyWE1amRILwNUKajEdF6u+xWOVsnk4YahbCE
         upP4B5CBcLt85GMfCKFIMGLEYBSvJq4iwSD4nUkpJhlT2rPLTuLQqawFEmGc/rmtSFZK
         jrzXGFpNx8s8aWgMmCg3i2rj03Z5uF1HeOtEC2Ic/Ty0qHJJAkj0negTXfvXxcZNU2hA
         Q8bJQFZF8hj6060MLEg/4GUGCRa341v8+FdUcbUDILKMn6/6QXHMRvJSCyt9WJC/SNX2
         vdYy3dpAYodtfxkrwJeJYDzuiOAtC38Cgw2vQ1XTfX4TZafLUfBcq3bYlQRn2k/PLdT4
         NqFA==
X-Gm-Message-State: APjAAAV5Rl8FyfXprsiqUznwz1A849x0PYQHTR4FdsvqtDxT6BtURtU6
        F9iWn1UygHkmUsCSmDYpcZI5BrKQvqm4lLayqrUdCxvFXOY5AHWJjcqAPurH8HlGDdNvZJbOTBG
        wjLP6durNn2Fc91t9UDgA
X-Received: by 2002:adf:f088:: with SMTP id n8mr25910275wro.115.1573595371469;
        Tue, 12 Nov 2019 13:49:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqy0yWgQIgl5CuKnzegghcl82bGcx+7pwLBHEjVQpaLkKvRJ3UYkmQL5/419Qc5ODzpNhhkX6A==
X-Received: by 2002:adf:f088:: with SMTP id n8mr25910261wro.115.1573595371234;
        Tue, 12 Nov 2019 13:49:31 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id x6sm252681wrw.34.2019.11.12.13.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:49:30 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v4 4/5] xfs: remove the xfs_qoff_logitem_t typedef
Date:   Tue, 12 Nov 2019 22:33:09 +0100
Message-Id: <20191112213310.212925-5-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191112213310.212925-1-preichl@redhat.com>
References: <20191112213310.212925-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: YpqTag4oNyidLpdK7VnFvQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  5 ++---
 fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
 fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
 fs/xfs/xfs_trans_dquot.c       | 12 ++++++------
 4 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.=
c
index 271cca13565b..da6642488177 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -741,8 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
=20
 /*
  * Turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
- *    the superblock for the quota flags: sector size
+ * the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
 xfs_calc_qm_quotaoff_reservation(
@@ -754,7 +753,7 @@ xfs_calc_qm_quotaoff_reservation(
=20
 /*
  * End of turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ * the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
 xfs_calc_qm_quotaoff_end_reservation(void)
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 3a64a7fd3b8a..3bb19e556ade 100644
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
+void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
+struct xfs_qoff_logitem=09*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
+=09=09struct xfs_qoff_logitem *start,
+=09=09uint flags);
+struct xfs_qoff_logitem=09*xfs_trans_get_qoff_item(struct xfs_trans *tp,
+=09=09struct xfs_qoff_logitem *startqoff,
+=09=09uint flags);
+void xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
+=09=09struct xfs_qoff_logitem *qlp);
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
index d319347093d6..454fc83c588a 100644
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
+=09struct xfs_trans=09*tp,
+=09struct xfs_qoff_logitem=09*startqoff,
 =09uint=09=09=09flags)
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

