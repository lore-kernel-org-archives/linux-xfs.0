Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F55C17441
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 983BE20818
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kv5k/LPv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKLVtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:49:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbfKLVtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 16:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573595372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QfH9wMj0CMgU6iexWUdQTqQsJdIKFyhLwLeMlBGPhMA=;
        b=Kv5k/LPvKRxcBwiDBmRwBPLlei2pRysyVrsjc+q+cwQ66zVKXcPnCFirPxzPZfQL69IGGN
        PrxI2QjoF0Rp7JVrNcgVmXd8dXJtVzUVkZreBj4ej9UOBOSA7wYejI2cd5E3l2uEYURrTh
        QN2Sqf3vUgbZA25wxS/qd+ki07VyM0w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-BZXna-vXOTOnE796NXZ7bA-1; Tue, 12 Nov 2019 16:49:31 -0500
Received: by mail-wm1-f71.google.com with SMTP id f191so8413wme.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 13:49:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0yKOv1FQbrdcPfvvG2WoHyT8ngN7Nxa6Bu3T4w6aZkA=;
        b=XlvDEcrPwAojBu6hgruN/v+Z6Jj0oMz7Da3ODmJeJ090f8zyEeCgIwx7e3GFEF+/EJ
         T43Llsq1GZq66fMBc5kMYHV9yM40XMCqtu9DXXbAYvfAYX5jH4gLEM3phbVKvO2VSZ5K
         QRrlvX+d/p2UKRn6kwrIQyX27PXduTuzS/CArLvlUmx/NSDEnjKmbrRq7bXzO91jpS5x
         YRPQDr2lgzbZjUz8Z/CdIq8mw+ZKDKUTJ4YDs9ul3kaO9xads6EqFgkn00AoRJWxpSpV
         uj2R1+1tFaYPPhecZxKpKi7oSqBgII0pwHmoA6UB/v4I4g+ROz5eyDADz7AaOLlGA92P
         7iqw==
X-Gm-Message-State: APjAAAVrYOR48Lkdx6UyBxe40utwJMKf81B8S9ahwDAY8rKET5J8mrsj
        nLMCRP1pHe70wBfvG5TTRBkXxTXXa86rP03kRmGvKzuF55lb50lY0spxb+6rvu3t7v6+xjjUTQQ
        b9dAsWR9GwkpDq67dPaPJ
X-Received: by 2002:a5d:694d:: with SMTP id r13mr26169972wrw.395.1573595369557;
        Tue, 12 Nov 2019 13:49:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqy387oGl/VhsISAd6p+v2sdrFiDf0ljyRqGVjEBhbh9wqYav9ehpUI1hIXyp3wyEmsNhaNy2A==
X-Received: by 2002:a5d:694d:: with SMTP id r13mr26169964wrw.395.1573595369419;
        Tue, 12 Nov 2019 13:49:29 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id x6sm252681wrw.34.2019.11.12.13.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:49:28 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v4 3/5] xfs: remove the xfs_dq_logitem_t typedef
Date:   Tue, 12 Nov 2019 22:33:08 +0100
Message-Id: <20191112213310.212925-4-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191112213310.212925-1-preichl@redhat.com>
References: <20191112213310.212925-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: BZXna-vXOTOnE796NXZ7bA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/xfs_dquot.c      |  2 +-
 fs/xfs/xfs_dquot.h      |  2 +-
 fs/xfs/xfs_dquot_item.h | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5b089afd7087..4df8ffb9906f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1018,7 +1018,7 @@ xfs_qm_dqflush_done(
 =09struct xfs_buf=09=09*bp,
 =09struct xfs_log_item=09*lip)
 {
-=09xfs_dq_logitem_t=09*qip =3D (struct xfs_dq_logitem *)lip;
+=09struct xfs_dq_logitem=09*qip =3D (struct xfs_dq_logitem *)lip;
 =09struct xfs_dquot=09*dqp =3D qip->qli_dquot;
 =09struct xfs_ail=09=09*ailp =3D lip->li_ailp;
=20
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 831e4270cf65..fe3e46df604b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -40,7 +40,7 @@ struct xfs_dquot {
 =09xfs_fileoff_t=09=09q_fileoffset;
=20
 =09struct xfs_disk_dquot=09q_core;
-=09xfs_dq_logitem_t=09q_logitem;
+=09struct xfs_dq_logitem=09q_logitem;
 =09/* total regular nblks used+reserved */
 =09xfs_qcnt_t=09=09q_res_bcount;
 =09/* total inos allocd+reserved */
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 1aed34ccdabc..3a64a7fd3b8a 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -11,11 +11,11 @@ struct xfs_trans;
 struct xfs_mount;
 struct xfs_qoff_logitem;
=20
-typedef struct xfs_dq_logitem {
-=09struct xfs_log_item=09 qli_item;=09   /* common portion */
-=09struct xfs_dquot=09*qli_dquot;=09   /* dquot ptr */
-=09xfs_lsn_t=09=09 qli_flush_lsn;=09   /* lsn at last flush */
-} xfs_dq_logitem_t;
+struct xfs_dq_logitem {
+=09struct xfs_log_item=09 qli_item;=09/* common portion */
+=09struct xfs_dquot=09*qli_dquot;=09/* dquot ptr */
+=09xfs_lsn_t=09=09 qli_flush_lsn;=09/* lsn at last flush */
+};
=20
 typedef struct xfs_qoff_logitem {
 =09struct xfs_log_item=09 qql_item;=09/* common portion */
--=20
2.23.0

