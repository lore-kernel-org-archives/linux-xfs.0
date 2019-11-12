Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A99C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C361120818
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oh3sw3hR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfKLVtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:49:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbfKLVtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 16:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573595374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4RgUc/wUZ0Z86j69TFuriv8FyuurWY+g6FXQnXvpBCU=;
        b=Oh3sw3hR9aig1SUTzmwGK9wl5NSsFAiXuVdL28VmBtCbXwc4EB89Gt2avXz9H6/itm8c2r
        i7reUWO4WKHv0YSy8i/lM1WzE/dpQyUUSExBmJb3GozckFrFQBPgsroc8nQMPb+w30wG+t
        pxphhzdacNbFubCkPUrM6FuqkoIWJFM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-QvBCrweMPiOT9aNJe_BJGA-1; Tue, 12 Nov 2019 16:49:34 -0500
Received: by mail-wm1-f72.google.com with SMTP id f14so9450wmc.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 13:49:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=le4A4w+942pq2hNxXmdj+7Qlh1NZfiCTUvwEzPMJKcM=;
        b=g7O1k4YrXVuM6SaJjdbLHFKOs4KdErmi8048St9zNvOUKp+bmmdj/6VO/JLHiNNXtb
         Culuw3cGbwiWqvIyoH0+skoomVGeHQoR+0j8FhCAZpCf1hmiGhMN2gi9C0C7ecTNPjjP
         wHaHpv91Jz2XRO3MmPbwExJpjZkTZ4wmEvY6y2g1U6+XzhnduNmtmiEcjSdnM15RtEKW
         sITxtLoQdGHJ5oZDRjSk9HXXH4U6SRbfQzCIH/GpInW1iShmzuWXx8ptuvkfb9R9z67J
         4eVhDyW+dZpj2lEqWOMj5Xs02Sw8FfhQN/zjAmd6k4BFsXEQvvIVmIh5FEUpZdNmkgmx
         sxvA==
X-Gm-Message-State: APjAAAXggt8BknvBmbjJXjBiF7d8V0sn42fnXKZjT1MtMxPyF+59ODwB
        fiZCtpAwomT2G/lF++BN65iU52Ydy72YbwQYSIP/ARDTZ0odngP2jL0tn/9+fpTW96cSTp7h6Ou
        JlFPtrJ4n+RRVfudZhQs/
X-Received: by 2002:a5d:570a:: with SMTP id a10mr21710546wrv.107.1573595372529;
        Tue, 12 Nov 2019 13:49:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqzs+E1PNJbAeT3IzsIk++KBwWJMhaE5HQCQGyTlbMNGNdzhHisz96tfHRvfLt+abC+99YaLFw==
X-Received: by 2002:a5d:570a:: with SMTP id a10mr21710542wrv.107.1573595372340;
        Tue, 12 Nov 2019 13:49:32 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id x6sm252681wrw.34.2019.11.12.13.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:49:31 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v4 5/5] Replace function declartion by actual definition
Date:   Tue, 12 Nov 2019 22:33:10 +0100
Message-Id: <20191112213310.212925-6-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191112213310.212925-1-preichl@redhat.com>
References: <20191112213310.212925-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: QvBCrweMPiOT9aNJe_BJGA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 140 ++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e685b9ae90b9..1ea82764bf89 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,12 +19,72 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
=20
-STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
-=09=09=09=09=09struct xfs_qoff_logitem **qoffstartp,
-=09=09=09=09=09uint flags);
-STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
-=09=09=09=09=09struct xfs_qoff_logitem *startqoff,
-=09=09=09=09=09uint flags);
+STATIC int
+xfs_qm_log_quotaoff(
+=09struct xfs_mount=09*mp,
+=09struct xfs_qoff_logitem=09**qoffstartp,
+=09uint=09=09=09flags)
+{
+=09struct xfs_trans=09*tp;
+=09int=09=09=09error;
+=09struct xfs_qoff_logitem=09*qoffi;
+
+=09*qoffstartp =3D NULL;
+
+=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp)=
;
+=09if (error)
+=09=09goto out;
+
+=09qoffi =3D xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT)=
;
+=09xfs_trans_log_quotaoff_item(tp, qoffi);
+
+=09spin_lock(&mp->m_sb_lock);
+=09mp->m_sb.sb_qflags =3D (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
+=09spin_unlock(&mp->m_sb_lock);
+
+=09xfs_log_sb(tp);
+
+=09/*
+=09 * We have to make sure that the transaction is secure on disk before w=
e
+=09 * return and actually stop quota accounting. So, make it synchronous.
+=09 * We don't care about quotoff's performance.
+=09 */
+=09xfs_trans_set_sync(tp);
+=09error =3D xfs_trans_commit(tp);
+=09if (error)
+=09=09goto out;
+
+=09*qoffstartp =3D qoffi;
+out:
+=09return error;
+}
+
+STATIC int
+xfs_qm_log_quotaoff_end(
+=09struct xfs_mount=09*mp,
+=09struct xfs_qoff_logitem=09*startqoff,
+=09uint=09=09=09flags)
+{
+=09struct xfs_trans=09*tp;
+=09int=09=09=09error;
+=09struct xfs_qoff_logitem=09*qoffi;
+
+=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp=
);
+=09if (error)
+=09=09return error;
+
+=09qoffi =3D xfs_trans_get_qoff_item(tp, startqoff,
+=09=09=09=09=09flags & XFS_ALL_QUOTA_ACCT);
+=09xfs_trans_log_quotaoff_item(tp, qoffi);
+
+=09/*
+=09 * We have to make sure that the transaction is secure on disk before w=
e
+=09 * return and actually stop quota accounting. So, make it synchronous.
+=09 * We don't care about quotoff's performance.
+=09 */
+=09xfs_trans_set_sync(tp);
+=09return xfs_trans_commit(tp);
+}
=20
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -541,74 +601,6 @@ xfs_qm_scall_setqlim(
 =09return error;
 }
=20
-STATIC int
-xfs_qm_log_quotaoff_end(
-=09struct xfs_mount=09*mp,
-=09struct xfs_qoff_logitem=09*startqoff,
-=09uint=09=09=09flags)
-{
-=09struct xfs_trans=09*tp;
-=09int=09=09=09error;
-=09struct xfs_qoff_logitem=09*qoffi;
-
-=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp=
);
-=09if (error)
-=09=09return error;
-
-=09qoffi =3D xfs_trans_get_qoff_item(tp, startqoff,
-=09=09=09=09=09flags & XFS_ALL_QUOTA_ACCT);
-=09xfs_trans_log_quotaoff_item(tp, qoffi);
-
-=09/*
-=09 * We have to make sure that the transaction is secure on disk before w=
e
-=09 * return and actually stop quota accounting. So, make it synchronous.
-=09 * We don't care about quotoff's performance.
-=09 */
-=09xfs_trans_set_sync(tp);
-=09return xfs_trans_commit(tp);
-}
-
-
-STATIC int
-xfs_qm_log_quotaoff(
-=09struct xfs_mount=09*mp,
-=09struct xfs_qoff_logitem=09**qoffstartp,
-=09uint=09=09=09flags)
-{
-=09struct xfs_trans=09*tp;
-=09int=09=09=09error;
-=09struct xfs_qoff_logitem=09*qoffi;
-
-=09*qoffstartp =3D NULL;
-
-=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp)=
;
-=09if (error)
-=09=09goto out;
-
-=09qoffi =3D xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT)=
;
-=09xfs_trans_log_quotaoff_item(tp, qoffi);
-
-=09spin_lock(&mp->m_sb_lock);
-=09mp->m_sb.sb_qflags =3D (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
-=09spin_unlock(&mp->m_sb_lock);
-
-=09xfs_log_sb(tp);
-
-=09/*
-=09 * We have to make sure that the transaction is secure on disk before w=
e
-=09 * return and actually stop quota accounting. So, make it synchronous.
-=09 * We don't care about quotoff's performance.
-=09 */
-=09xfs_trans_set_sync(tp);
-=09error =3D xfs_trans_commit(tp);
-=09if (error)
-=09=09goto out;
-
-=09*qoffstartp =3D qoffi;
-out:
-=09return error;
-}
-
 /* Fill out the quota context. */
 static void
 xfs_qm_scall_getquota_fill_qc(
--=20
2.23.0

