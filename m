Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E85BC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E93F321925
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KfAqG2XP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKLVte (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:49:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbfKLVte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 16:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573595373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mh68MY1nUFgP+py9XWeehenTADylaE2ZZJHQ0QfbApw=;
        b=KfAqG2XPrx16FQBh975tydRNyv3Ib6IVE4lPWpU2zHSd+e7VihsR0Z2GKGFWQa+JUs+xVt
        /lqYEAdQ3OD+GFpJHlNDSkWZFms4Hek+FU7S6/TT9B/bR72vTRLVusmVQx+kT1DZfQSc3Z
        27btIu/+/lw4OYG19JgUpilutI88hmU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-rHqGOpK5Moq1D1NwvSTc3Q-1; Tue, 12 Nov 2019 16:49:31 -0500
Received: by mail-wm1-f69.google.com with SMTP id g13so2017263wme.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 13:49:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sqg0sUO1eLArDmR9AFt/bxIUgwogncxntmaiZuBd5XI=;
        b=q+lGBqZVMnt/xgg4b9RPE4eCJIlDo/KUO8tsY3IrDTW6nOu++nBgkSz8FO44uk/beD
         JSR1Jv4wK3Kl7DYp5ve5b72cujVAp+ePe5kfjbkM0H8OuQTOHc7rBt5MQ8KWw5XIk3oF
         94QuUaelx/orFp/sJqtvYHsm9Kk7zMCI3JjL5Q4LjL61/xS+mBQQc8WVc7kVN+3W0QQC
         /HjLJTyyFRbE4fAhoT2RaOcVo2CRz2GlrvefY5/X0Ln93aPjKkad/UOpFACOl6JmtB6k
         d2f/fazkBymFU6bHHO9XXjDaTw/vH4CAYpelDhHxWx+VISJTBQr6pjEQzCmM5MHXCeYK
         bDAg==
X-Gm-Message-State: APjAAAVa8CUnxIoDVPbv/pTwG64cxJtosk+vIBEN+HDLQ5Rzo18vCwb8
        pY4XlHBx7o4Poz/ZujWUKUorSsGCGpvvnr2mLIG3Oi1gv6UkxBFbJjzMFZOpSflrAvnNclhLTP7
        OhaFeKmhlkiY88Nza5pbG
X-Received: by 2002:adf:ba4b:: with SMTP id t11mr24463232wrg.331.1573595368148;
        Tue, 12 Nov 2019 13:49:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYbTy2C76dIsSkuYK0H2ONW7gSqFsMy+IMeBVdvrt989XAqv6vnZpVZKZQlhfl0z0LWcKMyQ==
X-Received: by 2002:adf:ba4b:: with SMTP id t11mr24463223wrg.331.1573595367970;
        Tue, 12 Nov 2019 13:49:27 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id x6sm252681wrw.34.2019.11.12.13.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:49:27 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v4 2/5] xfs: remove the xfs_quotainfo_t typedef
Date:   Tue, 12 Nov 2019 22:33:07 +0100
Message-Id: <20191112213310.212925-3-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191112213310.212925-1-preichl@redhat.com>
References: <20191112213310.212925-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: rHqGOpK5Moq1D1NwvSTc3Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c          | 20 ++++++++++----------
 fs/xfs/xfs_qm.h          |  6 +++---
 fs/xfs/xfs_trans_dquot.c |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 035930a4f0dd..64a944296fda 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -30,10 +30,10 @@
  * quota functionality, including maintaining the freelist and hash
  * tables of dquots.
  */
-STATIC int=09xfs_qm_init_quotainos(xfs_mount_t *);
-STATIC int=09xfs_qm_init_quotainfo(xfs_mount_t *);
+STATIC int=09xfs_qm_init_quotainos(struct xfs_mount *mp);
+STATIC int=09xfs_qm_init_quotainfo(struct xfs_mount *mp);
=20
-STATIC void=09xfs_qm_destroy_quotainos(xfs_quotainfo_t *qi);
+STATIC void=09xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
 STATIC void=09xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 /*
  * We use the batch lookup interface to iterate over the dquots as it
@@ -540,9 +540,9 @@ xfs_qm_shrink_count(
=20
 STATIC void
 xfs_qm_set_defquota(
-=09xfs_mount_t=09*mp,
-=09uint=09=09type,
-=09xfs_quotainfo_t=09*qinf)
+=09struct xfs_mount=09*mp,
+=09uint=09=09=09type,
+=09struct xfs_quotainfo=09*qinf)
 {
 =09struct xfs_dquot=09*dqp;
 =09struct xfs_def_quota=09*defq;
@@ -643,7 +643,7 @@ xfs_qm_init_quotainfo(
=20
 =09ASSERT(XFS_IS_QUOTA_RUNNING(mp));
=20
-=09qinf =3D mp->m_quotainfo =3D kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
+=09qinf =3D mp->m_quotainfo =3D kmem_zalloc(sizeof(struct xfs_quotainfo), =
0);
=20
 =09error =3D list_lru_init(&qinf->qi_lru);
 =09if (error)
@@ -710,9 +710,9 @@ xfs_qm_init_quotainfo(
  */
 void
 xfs_qm_destroy_quotainfo(
-=09xfs_mount_t=09*mp)
+=09struct xfs_mount=09*mp)
 {
-=09xfs_quotainfo_t *qi;
+=09struct xfs_quotainfo=09*qi;
=20
 =09qi =3D mp->m_quotainfo;
 =09ASSERT(qi !=3D NULL);
@@ -1568,7 +1568,7 @@ xfs_qm_init_quotainos(
=20
 STATIC void
 xfs_qm_destroy_quotainos(
-=09xfs_quotainfo_t=09*qi)
+=09struct xfs_quotainfo=09*qi)
 {
 =09if (qi->qi_uquotaip) {
 =09=09xfs_irele(qi->qi_uquotaip);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index b41b75089548..7823af39008b 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -54,7 +54,7 @@ struct xfs_def_quota {
  * Various quota information for individual filesystems.
  * The mount structure keeps a pointer to this.
  */
-typedef struct xfs_quotainfo {
+struct xfs_quotainfo {
 =09struct radix_tree_root qi_uquota_tree;
 =09struct radix_tree_root qi_gquota_tree;
 =09struct radix_tree_root qi_pquota_tree;
@@ -76,8 +76,8 @@ typedef struct xfs_quotainfo {
 =09struct xfs_def_quota=09qi_usr_default;
 =09struct xfs_def_quota=09qi_grp_default;
 =09struct xfs_def_quota=09qi_prj_default;
-=09struct shrinker  qi_shrinker;
-} xfs_quotainfo_t;
+=09struct shrinker=09qi_shrinker;
+};
=20
 static inline struct radix_tree_root *
 xfs_dquot_tree(
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 0b7f6f228662..d319347093d6 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -585,7 +585,7 @@ xfs_trans_dqresv(
 =09xfs_qwarncnt_t=09=09warnlimit;
 =09xfs_qcnt_t=09=09total_count;
 =09xfs_qcnt_t=09=09*resbcountp;
-=09xfs_quotainfo_t=09=09*q =3D mp->m_quotainfo;
+=09struct xfs_quotainfo=09*q =3D mp->m_quotainfo;
 =09struct xfs_def_quota=09*defq;
=20
=20
--=20
2.23.0

