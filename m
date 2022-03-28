Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75678C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 22:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiC1W2m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiC1W2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:28:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25E12985BC
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648506419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aAP/mR9+1e0i9VIqKYhIwqKJcO8z1uA1zHUKn7fioR8=;
        b=a0jr5i/kwi/veUmNYYEsNpE6coa8SQcEjjiOChmDQxaUBAXlKK4tElqMjxABwuCTqGkD8N
        +iJCzJnDOAvlPbwGC4b1FGE399GdV091YqyAeWPVBupLipIrlPU2x7EauD8sUOB2IQkZmK
        WLE5hztde8AKG70iCdqf9DE+HzK7AEc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-WKxFsyMlMu-syZc9w8Z6_g-1; Mon, 28 Mar 2022 18:26:58 -0400
X-MC-Unique: WKxFsyMlMu-syZc9w8Z6_g-1
Received: by mail-ed1-f71.google.com with SMTP id i4-20020aa7c9c4000000b00419c542270dso4034496edt.8
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aAP/mR9+1e0i9VIqKYhIwqKJcO8z1uA1zHUKn7fioR8=;
        b=mvJ2hSEL5dIQ3HQs9jipverT0C+JT2ThQhx5vrUMOVB2gm5tjTwIOA3El7QJYXTI5F
         Z3jbTsCW463pqKoX/3LcCB3gBBR0kmp1RdH7x/i8znT6XVISUlew866rmYs2XqCWJUor
         jLgSvToz96QYFeBiE7Mur7anskKYy7TXQiJybZBSaihtAjieY/YdD7YOR0tgA4P2+fJ/
         btbzyLZQ4PILzZ1ORpn6wiAdHxbCo8mkHKACgq+M5ATVw++zleQpLgsVQYMplJ50MUO3
         sTN0XwuY0496uKJgktGMkw0uFJmUE9zExvQd1HsKpirargu9xKft9u92iljFuhyonrIa
         tuuw==
X-Gm-Message-State: AOAM533S/N2iIe1Sp3naqOFmyOEedv0C6pRECiRREH1qXN66FORdPdqh
        fquNPL++VuOnk22y9wzcwVBrL8QUqJ5sK6We6mywH0OlscNYdg9ZZcrbsH+5ro/WhZUPHkNT++B
        D9SSeLGsdStgAC5ZXpGmbsiUQAsQ40rnEktUOC9+S5qD8zDqHq1UULLdwkPnvu/GRyV7HTxE=
X-Received: by 2002:a05:6402:2711:b0:419:5a50:75ef with SMTP id y17-20020a056402271100b004195a5075efmr140684edd.280.1648506416332;
        Mon, 28 Mar 2022 15:26:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmEX6xCqijTgGkXEOSRZom3LOZIjk8/1eX7JP85cBIadPWB3GR3+v296I6r1pP6bOxF1zgAQ==
X-Received: by 2002:a05:6402:2711:b0:419:5a50:75ef with SMTP id y17-20020a056402271100b004195a5075efmr140668edd.280.1648506416156;
        Mon, 28 Mar 2022 15:26:56 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t19-20020a056402525300b0041952a1a764sm7722360edd.33.2022.03.28.15.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 15:26:55 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 1/5] xfs_quota: separate quota info acquisition into get_quota()
Date:   Tue, 29 Mar 2022 00:24:59 +0200
Message-Id: <20220328222503.146496-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220328222503.146496-1-aalbersh@redhat.com>
References: <20220328222503.146496-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both report_mount() and dump_file() have identical code to get quota
information. This could be used for further separation of the
functions.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/report.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 2eb5b5a9..97a89a92 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -59,16 +59,15 @@ report_help(void)
 "\n"));
 }
 
-static int 
-dump_file(
-	FILE		*fp,
+static int
+get_quota(
+	fs_disk_quota_t *d,
 	uint		id,
 	uint		*oid,
 	uint		type,
 	char		*dev,
 	int		flags)
 {
-	fs_disk_quota_t	d;
 	int		cmd;
 
 	if (flags & GETNEXTQUOTA_FLAG)
@@ -77,7 +76,7 @@ dump_file(
 		cmd = XFS_GETQUOTA;
 
 	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA */
-	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
+	if (xfsquotactl(cmd, dev, type, id, (void *)d) < 0) {
 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
 		    cmd == XFS_GETQUOTA)
 			perror("XFS_GETQUOTA");
@@ -85,12 +84,29 @@ dump_file(
 	}
 
 	if (oid) {
-		*oid = d.d_id;
+		*oid = d->d_id;
 		/* Did kernelspace wrap? */
 		if (*oid < id)
 			return 0;
 	}
 
+	return 1;
+}
+
+static int
+dump_file(
+	FILE		*fp,
+	uint		id,
+	uint		*oid,
+	uint		type,
+	char		*dev,
+	int		flags)
+{
+	fs_disk_quota_t	d;
+
+	if	(!get_quota(&d, id, oid, type, dev, flags))
+		return 0;
+
 	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
 	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
 	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
@@ -329,31 +345,12 @@ report_mount(
 {
 	fs_disk_quota_t	d;
 	time64_t	timer;
-	char		*dev = mount->fs_name;
 	char		c[8], h[8], s[8];
 	uint		qflags;
 	int		count;
-	int		cmd;
 
-	if (flags & GETNEXTQUOTA_FLAG)
-		cmd = XFS_GETNEXTQUOTA;
-	else
-		cmd = XFS_GETQUOTA;
-
-	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA*/
-	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
-		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
-		    cmd == XFS_GETQUOTA)
-			perror("XFS_GETQUOTA");
+	if	(!get_quota(&d, id, oid, type, mount->fs_name, flags))
 		return 0;
-	}
-
-	if (oid) {
-		*oid = d.d_id;
-		/* Did kernelspace wrap? */
-		if (* oid < id)
-			return 0;
-	}
 
 	if (flags & TERSE_FLAG) {
 		count = 0;
-- 
2.27.0

