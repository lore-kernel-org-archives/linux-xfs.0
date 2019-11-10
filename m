Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014AEC17443
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5F4421848
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1TR1Qot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfKJGYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 01:24:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726617AbfKJGYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 01:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573367062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RWbmGbS9+L9MjJOsSSpsRIfy/5WQewkESQU5Z4L2qxc=;
        b=T1TR1Qotk+5LQHUBliuNBA+NK6tBirqxHnHaTTyyAx2WkeQAo+Z1WKqcAlgO6R/hLgW0hx
        e1FYO5/aHtNhasOmn28JPE+rNh/woURNYMrRL0zqpP45Q//FJ+EmLuhsxx9QqxznSBo7yh
        ChPurtjoiAD5uVjU64mNyL7FtUmJr/0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-RoecO8JIND6vkdwIUPhIHg-1; Sun, 10 Nov 2019 01:24:20 -0500
Received: by mail-wr1-f69.google.com with SMTP id e10so4785630wrt.16
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 22:24:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qbomU26J/l3Zq8vd0tq9t+kpOvSH4i4HPdC7YqZtjn8=;
        b=OSSz7ztGK3ZZazRBQSyw37rtqOq+d4+TjgL/oXpmAgjy1wvueTGfwQhHVyzqwMcAkw
         GTZlmtcQSCYKUul7nKAbdX1/KCXRK5ZXrHViMCY3Xa/MCKXSTfnP8ccCpTQAO3GyWLoF
         vuaminXDOxbZ2Yyw0yMrLWfWBjZhmDUerMGS3Zss1INZsqYJha1nahVlS/NTk96gbxle
         dWj0pRo4GFkBTnIbY9iPv+PEZ6N6gG6yvhdOGdB8F9oxTxuL5w2SU+64TkEzTDWBhkhu
         DqdVBEClBXQlZ0CbFe1REkngw2EOVt3frGcaqIP/EKTg8p5hTTVPPVN6xIqbYejUudTM
         UtNw==
X-Gm-Message-State: APjAAAUwX5x+kw55+QIb6hgzipMEnrW+ZdUaa4fL4clXyOqmBzF6Q8t0
        4iPIhvg60D7wYnNLc2rpthOIfTg8C/koI+jXD1eQ8fjIRX+JSQ5SEGbjlAhnjJn5wrDTSAsdvWn
        DzTK275QU4p4DXBOcLUZB
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr15104128wme.115.1573367059470;
        Sat, 09 Nov 2019 22:24:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqwWFAz35U5bmfxr871Qsr3fS7rJ5bLQ3p1VbZUwOClZLk1NmYfXr6g5C0cF1Tgxx4WA2d14Sg==
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr15104119wme.115.1573367059306;
        Sat, 09 Nov 2019 22:24:19 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id b196sm16261618wmd.24.2019.11.09.22.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 22:24:18 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v3 3/4] xfs: remove the xfs_dq_logitem_t typedef
Date:   Sun, 10 Nov 2019 07:24:03 +0100
Message-Id: <20191110062404.948433-4-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191110062404.948433-1-preichl@redhat.com>
References: <20191110062404.948433-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: RoecO8JIND6vkdwIUPhIHg-1
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
index f1614d7c72f8..5743987f6c92 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -49,7 +49,7 @@ struct xfs_dquot {
 =09/* actual usage & quotas */
 =09struct xfs_disk_dquot=09q_core;
 =09/* dquot log item */
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

