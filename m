Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977F5C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 22:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiC1W2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiC1W2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:28:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D96BC1728A8
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648506424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqP0qoAPAW+XR9MNalFFLNb+d2lbrYOJww0irumLfec=;
        b=CRtt99VgCJDDxrRxFRnx8gB1srZYSi/0mqxZJ4e1Al3VaCIx8rdv2V+Ko88fzbEHU/5Cdb
        wDfEQPRuK0l/V7q/XIkb+7ifboMXBA3Fy5CKHJkXT1Xlhb6eyOqmpmiKqhZ/AXtWSTHGJi
        zlNd3WCAh9PeAgJAyz9wlERinJBXyWY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-wJwcrZ03MymzShKG5lX6Zw-1; Mon, 28 Mar 2022 18:27:03 -0400
X-MC-Unique: wJwcrZ03MymzShKG5lX6Zw-1
Received: by mail-ed1-f72.google.com with SMTP id l24-20020a056402231800b00410f19a3103so9776149eda.5
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vqP0qoAPAW+XR9MNalFFLNb+d2lbrYOJww0irumLfec=;
        b=m4qWImjF3TRdg9llCGsABvhORnaZNMZ4w4dWb0YZ3gwuRJay7QCWLVLFnWaBwrbS5b
         Dm1T3EC/iXDUVBDHW4S93eBZE+lsMJIIYmDOQ5ibJiixqb58BUMH5TNA/UFDBhVobOI3
         5OKa8NT9WSByKQ60tiGctkIHrTqq8HOg928DcbvpbPdomEgDsS8T/e4WT9Ny/7ilLlRJ
         QexmCmdYycK4dCepnfzF78upyC9MR769gYyyB5p22a1au+pGvKZcoP/n06dseel0YhnF
         4iXqk+joliXUNtrj4oA5jGN/B2c8a9gfraSFKcfseU+D/7EYVWs+yEDbYpq/6B/yrIiV
         m76A==
X-Gm-Message-State: AOAM533Doz+C6DBoBxWpKLKOT+LxxF8vsdUIXCiNe+EAzsa+cZ/tdhDw
        uL7mMq9bzE1fVgTUo03mfPIV0nGWo6VJL9wnE5yFe0IjDdnPBaqU4uK4Zp6rI9Ruf3iF1vcqh98
        QPD8w43DaVmpmvsVNzL7xPZAFGZTbVCFi16Z1k15gXUX6rAuC+ASxxbEmafGazeu5oU7dWTY=
X-Received: by 2002:aa7:d543:0:b0:416:13eb:6fec with SMTP id u3-20020aa7d543000000b0041613eb6fecmr132767edr.348.1648506421403;
        Mon, 28 Mar 2022 15:27:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycltK5WvUm0kQA1iquW0mHC0j8ltqLM9Yf19z+OHpp1RjLFaJBGZ9KpI2gW0SuspHaHItzBA==
X-Received: by 2002:aa7:d543:0:b0:416:13eb:6fec with SMTP id u3-20020aa7d543000000b0041613eb6fecmr132749edr.348.1648506421171;
        Mon, 28 Mar 2022 15:27:01 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t19-20020a056402525300b0041952a1a764sm7722360edd.33.2022.03.28.15.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 15:27:00 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 5/5] xfs_quota: apply -L/-U range limits in uid/gid/pid loops
Date:   Tue, 29 Mar 2022 00:25:03 +0200
Message-Id: <20220328222503.146496-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220328222503.146496-1-aalbersh@redhat.com>
References: <20220328222503.146496-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/report.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 074abbc1..c79e95ab 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -161,8 +161,10 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL) {
-				get_quota(&d, g->gr_gid, NULL, type, mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_quota(&d, g->gr_gid, NULL, type, mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endgrent();
 			break;
@@ -171,8 +173,10 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL) {
-				get_quota(&d, p->pr_prid, NULL, type, mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_quota(&d, p->pr_prid, NULL, type, mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endprent();
 			break;
@@ -181,8 +185,10 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL) {
-				get_quota(&d, u->pw_uid, NULL, type, mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_quota(&d, u->pw_uid, NULL, type, mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endpwent();
 			break;
@@ -474,8 +480,10 @@ report_user_mount(
 	if (!(flags & GETNEXTQUOTA_FLAG)) {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
-			if (get_quota(&d, u->pw_uid, NULL, XFS_USER_QUOTA, mount->fs_name,
-					flags)) {
+			if (get_quota(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, u->pw_name, form, XFS_USER_QUOTA, mount,
 						flags);
 				flags |= NO_HEADER_FLAG;
@@ -515,7 +523,9 @@ report_group_mount(
 		setgrent();
 		while ((g = getgrent()) != NULL) {
 			if (get_quota(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, g->gr_name, form,
 						XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -557,7 +567,9 @@ report_project_mount(
 			 * isn't defined
 			 */
 			if (get_quota(&d, 0, NULL, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
 			}
@@ -566,7 +578,9 @@ report_project_mount(
 		setprent();
 		while ((p = getprent()) != NULL) {
 			if (get_quota(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, p->pr_name, form, XFS_PROJ_QUOTA, mount,
 						flags);
 				flags |= NO_HEADER_FLAG;
-- 
2.27.0

