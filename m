Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2010C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 14:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379699AbiDTOyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379712AbiDTOyP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 10:54:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CFC71ADB9
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650466288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MTztX0iN/9etmjP8brsZmmwHwmEq0cedF/izZWI/JDk=;
        b=eJirdt/d2z86BsPoHySrbtmSlFuwA3UPAyo3mQ4FIUQEmIulBYlYhpQFEmFCaAkR87btH8
        jPBr7LWYbW7FlYmqTYI1RluotdB2CcKLdZtzSPQsquDyCWg38JKbspF4a4YnjGbSF+iqYh
        tV/jSw+Hql2cfVW9ObUpaOBIMi3Xeow=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-fLHS3FiZOtWXOe3gX6GwQQ-1; Wed, 20 Apr 2022 10:51:27 -0400
X-MC-Unique: fLHS3FiZOtWXOe3gX6GwQQ-1
Received: by mail-ed1-f70.google.com with SMTP id b24-20020a50e798000000b0041631767675so1324992edn.23
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MTztX0iN/9etmjP8brsZmmwHwmEq0cedF/izZWI/JDk=;
        b=B+ew5pR5i7fuVGisl0gy7ru6e/JyZege8AduNkAZvdAeD37Kgq1GW7ffCjEAcY57Uh
         5TEE5irb9S01Rs0cyLU9aMi0jdGZEh5tkFou4jOZ4U6zvWVqP5pmHQkIb9n4EWKAwbdE
         /VKZa+6Uy6L7j0yDs8K6gg8fnbicbSKJmiJl7KXVBkYUFDYdZq5gjJsaS6uDW/7mBCYH
         cO7y5SL+XJKL0y5ykt1zTCEDnFevr+gOcU3o9C0EBvVfZ2AHb/SC8NyYh1+Ts4+BW+kp
         Bm/5dyqWLaQx83YNLgsWyWiRqUM/I6tPiu3EZ8UZHA0Qa+5rrRaBGfU92M11MNyyFAm6
         iN6A==
X-Gm-Message-State: AOAM531kUpAXMRMfEqZ2pNnonHMVnOeVREOoPsPrpfLyedCPj3yu1Kal
        l21GJgKLcz18JE7CaYL0faFHTWfvuPAyNg0QhTSzhtPab0fwHwYYRyfadartlSIcWj9Krl29mo4
        XJ0ZeDOKcku9pwk9AseO/cpLx2g7fnlus+YLYicO9B4jwbsxvn9/WOFncuJfBoIMkQs7CkVA=
X-Received: by 2002:a05:6402:34c7:b0:423:d44a:4c6c with SMTP id w7-20020a05640234c700b00423d44a4c6cmr21650448edc.356.1650466285805;
        Wed, 20 Apr 2022 07:51:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4/QlB6P7ZFZakc0W2Iu3o6/jfdOpJWEaeq10Es+NsadksiEM4/HT/AE0UkU6IG6Ye9Rc8Rg==
X-Received: by 2002:a05:6402:34c7:b0:423:d44a:4c6c with SMTP id w7-20020a05640234c700b00423d44a4c6cmr21650423edc.356.1650466285557;
        Wed, 20 Apr 2022 07:51:25 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm9935622edt.92.2022.04.20.07.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:51:25 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 5/5] xfs_quota: apply -L/-U range limits in uid/gid/pid loops
Date:   Wed, 20 Apr 2022 16:45:08 +0200
Message-Id: <20220420144507.269754-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420144507.269754-1-aalbersh@redhat.com>
References: <20220420144507.269754-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In case kernel doesn't support XFS_GETNEXTQUOTA the report/dump
command will fallback to iterating over all known uid/gid/pid.
However, currently it won't take -L/-U range limits into account
(all entities with non-zero qoutas will be outputted). This applies
those limits for fallback case.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/report.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 65d931f3..8af763e4 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -161,9 +161,11 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL) {
-				get_dquot(&d, g->gr_gid, NULL, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, g->gr_gid, NULL, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endgrent();
 			break;
@@ -172,9 +174,11 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL) {
-				get_dquot(&d, p->pr_prid, NULL, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, p->pr_prid, NULL, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endprent();
 			break;
@@ -183,9 +187,11 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL) {
-				get_dquot(&d, u->pw_uid, NULL, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, u->pw_uid, NULL, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endpwent();
 			break;
@@ -478,7 +484,9 @@ report_user_mount(
 		setpwent();
 		while ((u = getpwent()) != NULL) {
 			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, u->pw_name, form,
 						XFS_USER_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -518,7 +526,9 @@ report_group_mount(
 		setgrent();
 		while ((g = getgrent()) != NULL) {
 			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, g->gr_name, form,
 						XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -560,7 +570,9 @@ report_project_mount(
 			 * isn't defined
 			 */
 			if (get_dquot(&d, 0, NULL, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
 						mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -570,7 +582,9 @@ report_project_mount(
 		setprent();
 		while ((p = getprent()) != NULL) {
 			if (get_dquot(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, p->pr_name, form,
 						XFS_PROJ_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
-- 
2.27.0

