Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96604C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 14:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379671AbiDTOyM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354576AbiDTOyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 10:54:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1720D1A385
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650466285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4/2PQ758KsZ309DwXSkz0+XonmM1FjZVh8TSCZMaAzM=;
        b=E/a8bPaec0UFGC05sC0MjK1wm14zu30KPxSJpFqWXZXio5r1sqkKknXCrytKEyy6962Sv9
        PueTxydlZxPwji/DqSpRn4N+teFp1YMZYRrncAgVBrXER8Aw6dpKp7aNdBgLvb+DXj07ou
        UsoXsST7mtvj1GF9tIjP1kD9hoxinWA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-HYy2nnPmMZ2_dwG9i8sJFw-1; Wed, 20 Apr 2022 10:51:23 -0400
X-MC-Unique: HYy2nnPmMZ2_dwG9i8sJFw-1
Received: by mail-ej1-f72.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso1102513ejs.12
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4/2PQ758KsZ309DwXSkz0+XonmM1FjZVh8TSCZMaAzM=;
        b=QrAmWaHhoN22UDCLaMK58ssrFVlts2YRf8pLvqo5s+rQM0W8xPHXAejUNSvVGlFAdW
         T/HmLTkJ4tKdPOl2qFq76wtJH6DM3r94E8wt7GNWqrGMohGDh1LNe6eudphjFIYxUXDW
         rorOHLm1oeczBn0ca44tDkoHX0o4cIr4Pz0z9qmqLhx/FKTVFndXok2hTkeElrU+xBlQ
         sqekzfcZ5sM9a6mszibnBQnI3ajcxARiYj17s03OD48LW0AYWM1usp7xytEZkBVroFCg
         l0lWmNLBsW2wEbYPvr/zYf+5zXsMN17Rhz8vdqN3rvmK/sr6EWVJ5LlZd8ChCaCDuUsw
         AeJA==
X-Gm-Message-State: AOAM5325qb1/bSoGbhXan/l2ZT/BHbNzwhvuh1IDPaehByvyjtj9yTdZ
        gYqGdXi179P+8LvtYQIADSjhxoviSyFqiusvrhwmohmfbAQGuEdFYpaiIptUOSSe0sHvx5fxTJf
        y8xQjYGqpmfED0jWy7TVU+pFA9LriQqRIzGmaUVUN9ZgOm+rk4AbYcq2hrYi2x1Ly3pnOEXY=
X-Received: by 2002:a50:e696:0:b0:413:3846:20a9 with SMTP id z22-20020a50e696000000b00413384620a9mr23776206edm.96.1650466281897;
        Wed, 20 Apr 2022 07:51:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVdFSMehn8x29EqHGST/dA8AVGnvQiVVEpwHRiaNlqruw63bawE+1qKVi7PbK1RSV9BHxAgw==
X-Received: by 2002:a50:e696:0:b0:413:3846:20a9 with SMTP id z22-20020a50e696000000b00413384620a9mr23776174edm.96.1650466281647;
        Wed, 20 Apr 2022 07:51:21 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm9935622edt.92.2022.04.20.07.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:51:21 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 1/5] xfs_quota: separate quota info acquisition into get_dquot()
Date:   Wed, 20 Apr 2022 16:45:04 +0200
Message-Id: <20220420144507.269754-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420144507.269754-1-aalbersh@redhat.com>
References: <20220420144507.269754-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both report_mount() and dump_file() have identical code to get quota
information. This could be used for further separation of the
functions.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 quota/report.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 2eb5b5a9..cccc654e 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -59,16 +59,15 @@ report_help(void)
 "\n"));
 }
 
-static int 
-dump_file(
-	FILE		*fp,
+static int
+get_dquot(
+	struct fs_disk_quota *d,
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
+	if (!get_dquot(&d, id, oid, type, dev, flags))
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
+	if (!get_dquot(&d, id, oid, type, mount->fs_name, flags))
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

