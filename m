Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A94C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 14:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354576AbiDTOyN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379676AbiDTOyN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 10:54:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF67E1ADA9
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650466286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5z/nqt/ArG+s/W33oitdt8N9tENyD4I70njHXWSkXTs=;
        b=jT3Az5+SryjAsm3jQvFO7q7op0/7CDRGSq1X8JWHd65lP8kgyu14NdeKD3EyAGPEylWYtN
        Edrzoy0ItQle7GYZIrcFig+LS4cNqQ0n5VXNQVvAw1j5Jjopn0Wjo4bZ2UhsWwDT4NKWSO
        yE0SlTMJ1j2PWTHEDHpE0dpkEpOlnC0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-qJW32uoMNL2hZufrQvgBFA-1; Wed, 20 Apr 2022 10:51:24 -0400
X-MC-Unique: qJW32uoMNL2hZufrQvgBFA-1
Received: by mail-ej1-f72.google.com with SMTP id mp18-20020a1709071b1200b006e7f314ecb3so1091270ejc.23
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5z/nqt/ArG+s/W33oitdt8N9tENyD4I70njHXWSkXTs=;
        b=K+9NvyjfRKq/1Oo33S5WHOaloA9qDNMji4V0LqtsV8RxibUEnksfUOQDKcpYXrFOgk
         X0w3r6JJLuQEL37oq/eXHRmeAJm8y6G0Csm+AwYAFi2rQwMpJifiOBqLUsH8wNlTXcFq
         8QNirq1WKp4FRDyrkQIBB62/adkaALPUhxYowpaTptsTIELynbnjWSAs+TD1SvkU1e7D
         orXuPgLUxSSftZUOFlLcfxLMuRpZqjUslydejgg8ScRIGbO4pW0PycO8IDS+O/otI7fL
         5+t4k6kJ4f3xJgfhLdJ986MArbdMQ75BVcFWYTmjUKTQez0GhQEcCaD5Az2K7fE4j9kX
         eMpQ==
X-Gm-Message-State: AOAM531qbYVwb9bnMxVQ9OybSocdfJjOc/4HEMk17Tx/2lhsDg3ritfR
        jnVf8VITPXzfNPLzMuVnSbaUvcNQUT38yCWUPTwKbNasAP4YZJ7GlrL0ABABZwdoLR/+4B70YE9
        0+AxCrG6zceia6wIkDYl9K1DPeZPyNLxcraZ2QgaWxKWcpWnI/v0gI/SXL44N7iZe40gZ6mA=
X-Received: by 2002:aa7:d318:0:b0:41d:8733:1c4d with SMTP id p24-20020aa7d318000000b0041d87331c4dmr23139283edq.46.1650466282997;
        Wed, 20 Apr 2022 07:51:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlq73LeHJldTm3kYX6L+8Zb+vugd4dG4HgCbYUUXrSfLpGq3K2BJUuBGYlb/5xemtBqquawA==
X-Received: by 2002:aa7:d318:0:b0:41d:8733:1c4d with SMTP id p24-20020aa7d318000000b0041d87331c4dmr23139261edq.46.1650466282778;
        Wed, 20 Apr 2022 07:51:22 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm9935622edt.92.2022.04.20.07.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:51:22 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 2/5] xfs_quota: separate get_dquot() and dump_file()
Date:   Wed, 20 Apr 2022 16:45:05 +0200
Message-Id: <20220420144507.269754-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420144507.269754-1-aalbersh@redhat.com>
References: <20220420144507.269754-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Separate quota info acquisition from outputting it to file. This
allows upper functions to filter obtained info (e.g. within specific
ID range).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/report.c | 86 ++++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index cccc654e..d5c6f84f 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -96,39 +96,31 @@ get_dquot(
 static int
 dump_file(
 	FILE		*fp,
-	uint		id,
-	uint		*oid,
-	uint		type,
-	char		*dev,
-	int		flags)
+	struct fs_disk_quota *d,
+	char		*dev)
 {
-	fs_disk_quota_t	d;
-
-	if (!get_dquot(&d, id, oid, type, dev, flags))
-		return 0;
-
-	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
-	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
-	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
+	if (!d->d_blk_softlimit && !d->d_blk_hardlimit &&
+	    !d->d_ino_softlimit && !d->d_ino_hardlimit &&
+	    !d->d_rtb_softlimit && !d->d_rtb_hardlimit)
 		return 1;
 	fprintf(fp, "fs = %s\n", dev);
 	/* this branch is for backward compatibility reasons */
-	if (d.d_rtb_softlimit || d.d_rtb_hardlimit)
+	if (d->d_rtb_softlimit || d->d_rtb_hardlimit)
 		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu %7llu %7llu\n",
-			d.d_id,
-			(unsigned long long)d.d_blk_softlimit,
-			(unsigned long long)d.d_blk_hardlimit,
-			(unsigned long long)d.d_ino_softlimit,
-			(unsigned long long)d.d_ino_hardlimit,
-			(unsigned long long)d.d_rtb_softlimit,
-			(unsigned long long)d.d_rtb_hardlimit);
+			d->d_id,
+			(unsigned long long)d->d_blk_softlimit,
+			(unsigned long long)d->d_blk_hardlimit,
+			(unsigned long long)d->d_ino_softlimit,
+			(unsigned long long)d->d_ino_hardlimit,
+			(unsigned long long)d->d_rtb_softlimit,
+			(unsigned long long)d->d_rtb_hardlimit);
 	else
 		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu\n",
-			d.d_id,
-			(unsigned long long)d.d_blk_softlimit,
-			(unsigned long long)d.d_blk_hardlimit,
-			(unsigned long long)d.d_ino_softlimit,
-			(unsigned long long)d.d_ino_hardlimit);
+			d->d_id,
+			(unsigned long long)d->d_blk_softlimit,
+			(unsigned long long)d->d_blk_hardlimit,
+			(unsigned long long)d->d_ino_softlimit,
+			(unsigned long long)d->d_ino_hardlimit);
 
 	return 1;
 }
@@ -142,6 +134,7 @@ dump_limits_any_type(
 	uint		upper)
 {
 	fs_path_t	*mount;
+	struct fs_disk_quota d;
 	uint		id = 0, oid;
 
 	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
@@ -153,46 +146,57 @@ dump_limits_any_type(
 
 	/* Range was specified; query everything in it */
 	if (upper) {
-		for (id = lower; id <= upper; id++)
-			dump_file(fp, id, NULL, type, mount->fs_name, 0);
+		for (id = lower; id <= upper; id++) {
+			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
+			dump_file(fp, &d, mount->fs_name);
+		}
 		return;
 	}
 
 	/* Use GETNEXTQUOTA if it's available */
-	if (dump_file(fp, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+		dump_file(fp, &d, mount->fs_name);
 		id = oid + 1;
-		while (dump_file(fp, id, &oid, type, mount->fs_name,
-				 GETNEXTQUOTA_FLAG))
+		while (get_dquot(&d, id, &oid, type, mount->fs_name,
+					GETNEXTQUOTA_FLAG)) {
+			dump_file(fp, &d, mount->fs_name);
 			id = oid + 1;
+		}
 		return;
-        }
+	}
 
 	/* Otherwise fall back to iterating over each uid/gid/prjid */
 	switch (type) {
 	case XFS_GROUP_QUOTA: {
 			struct group *g;
 			setgrent();
-			while ((g = getgrent()) != NULL)
-				dump_file(fp, g->gr_gid, NULL, type,
-					  mount->fs_name, 0);
+			while ((g = getgrent()) != NULL) {
+				get_dquot(&d, g->gr_gid, NULL, type,
+						mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endgrent();
 			break;
 		}
 	case XFS_PROJ_QUOTA: {
 			struct fs_project *p;
 			setprent();
-			while ((p = getprent()) != NULL)
-				dump_file(fp, p->pr_prid, NULL, type,
-					  mount->fs_name, 0);
+			while ((p = getprent()) != NULL) {
+				get_dquot(&d, p->pr_prid, NULL, type,
+						mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endprent();
 			break;
 		}
 	case XFS_USER_QUOTA: {
 			struct passwd *u;
 			setpwent();
-			while ((u = getpwent()) != NULL)
-				dump_file(fp, u->pw_uid, NULL, type,
-					  mount->fs_name, 0);
+			while ((u = getpwent()) != NULL) {
+				get_dquot(&d, u->pw_uid, NULL, type,
+						mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endpwent();
 			break;
 		}
-- 
2.27.0

