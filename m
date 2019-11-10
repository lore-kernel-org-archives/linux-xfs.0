Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B28C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9147C21655
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mm34aqJ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfKJGYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 01:24:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbfKJGYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 01:24:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573367061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VZSvOOMeACPPyjdru8X5drSpAuZ1Mb2eJoydr9RjoM=;
        b=Mm34aqJ1+v/VHGDr32hJuP9Jb+DYtUVzU9avOrwBfa08WZDE1vR690DZwRT0sVMZhCwVe+
        6C9b5KbsoxpF3AIrcuVX/aekcUrIc6VUAktXIqTXrqPkvYlUsrQSm2vyjzDyvUPrIalMqa
        S6CtT+r/UmaDRZbAQafYVaAsHj9QHj0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-5ubTX9NkPXu_LaYawjMn8A-1; Sun, 10 Nov 2019 01:24:19 -0500
Received: by mail-wr1-f72.google.com with SMTP id u2so7266068wrm.7
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 22:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NVm+ENmku/F7kCvOdjvNMQb+oNsvB2wPkCvIHURHY/0=;
        b=nQw7bIUs3zEVlL6EvkBWnYbSrNjiPJ7k0k3481rdgH/Esjf6XCcRgneQkMlGavtSQZ
         jxhL3B2gNvfy+YI+3Hwmjket5aRRYLk7/w/Zl2N5hK91w/IbMPfNkzQbxTOxDiUTqaEd
         sEbcEp3Apiu1vD1AcuBp1yyfXNXOs4C/mdT5gYv0/iPIwTM0byvYOWW4azO5+Ub09A+T
         gC7U9I9SKyHxiWCAUDBHUzUUQcispiZ4xm8CeNi2qOIJrdhls6ovfB4YQ5kLh+25U4wj
         7fdh+XDhrNDm6VhreBKIjg0gu0H8J4rn11J+pxbLG6FtSbj98OHzt6h/1p5F/51gpgsJ
         qRxw==
X-Gm-Message-State: APjAAAUYzf4+fisAvIWOjVx0WDQNhJlnwqbLyNMFetsr4vS2ZWXwM/AG
        PE/Z7Q3Hczlj3vvBORGHg4+rJ/QFvOdd7V88p0dmE/eomBg/+FOVzDX4X6lHJCsjqlG4h2lNsOi
        sKt+Jnf2NRLSGM4u01mkz
X-Received: by 2002:a1c:2b82:: with SMTP id r124mr15383454wmr.112.1573367058606;
        Sat, 09 Nov 2019 22:24:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNvhGJ9BWe9ayPAoob773NTB0kv9/SKRyTF1U2VSt921UeeV5ZqVrgabUw2djuABBnRd6b/w==
X-Received: by 2002:a1c:2b82:: with SMTP id r124mr15383442wmr.112.1573367058410;
        Sat, 09 Nov 2019 22:24:18 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id b196sm16261618wmd.24.2019.11.09.22.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 22:24:17 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v3 2/4] xfs: remove the xfs_quotainfo_t typedef
Date:   Sun, 10 Nov 2019 07:24:02 +0100
Message-Id: <20191110062404.948433-3-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191110062404.948433-1-preichl@redhat.com>
References: <20191110062404.948433-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: 5ubTX9NkPXu_LaYawjMn8A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
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

