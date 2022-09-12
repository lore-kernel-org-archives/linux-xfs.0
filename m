Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEE0ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 14:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiILOdf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 10:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILOdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 10:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A185022514
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662993211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0xOQ0r9Bdz4I/zPUnX0Avp3akxJlCRk8jxAhIe8i5Q=;
        b=PwDgEoz7B5rrZqBh+aPTdkJbaC8jFdr8wB1u4AGyW6cFRQqiDDAoxsAgOMJFfGfL+xSVhk
        lwmXBARVQGyJqMjZT6igpQvyB/8R9JTHvIDQAC6Du5gbMq45J9Obo5qXVO8VbgxzzSrf7I
        QekcWXAY3jbt6gNgG9+Tp+fF4v6qPfI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-662-z0OaK0f2NcOB1UKRdr0Gxw-1; Mon, 12 Sep 2022 10:33:30 -0400
X-MC-Unique: z0OaK0f2NcOB1UKRdr0Gxw-1
Received: by mail-ej1-f70.google.com with SMTP id ho13-20020a1709070e8d00b00730a655e173so3293576ejc.8
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=H0xOQ0r9Bdz4I/zPUnX0Avp3akxJlCRk8jxAhIe8i5Q=;
        b=OiguhWbUwsyeZF1+bC8oZxgmoqZ1Tblu/F4oMA7Ep9wR9uZNsOn5AANO/XLa0Qb4A/
         tzjfuwOI8YF3n9oXVEC8u8vgEoa6eAUFGyJbsu2FfdrL7XRb8gBt7ricMcKCKmOLhXa8
         ujdt0Zww1JVBvT7uuKq6G8Eyvxds4N1u0/O1lpLyZatFYoKPeIlmDPsyQ8NOz6TfvxJz
         bAN+HKgrlgUegypF6BE+MSW2PbMiIFJ3QM1rRf3MNPNFxzzU9Jw/kvt8pEPpB0pbN7T0
         3ynN3LKpIMfIcty29MhDM7NvTCbgTm7Q7sDeCp3KRS5cga/tV7Ec0qN7wEFwZ//Ua/Fh
         zbkA==
X-Gm-Message-State: ACgBeo1aCOrlgHEcF8joA09gTC5cs50CH0TyBIuj1aOM5nOkTc9Mcw8t
        QwGj8Kf9sh35gUeHt7zxRekeIBnxPHeC9j3YPvgx7bd7xFKRB0fw/r6QwtG96o3uKNxwHgInOLN
        IQ4MJg3RKtXVPufc90kkm4rV04UK5cdJ+begvdQKsTbXGjTiQ6mlUIZ4z4f/vIgiWW8Dw5XM=
X-Received: by 2002:a17:907:961a:b0:77a:5ca3:f467 with SMTP id gb26-20020a170907961a00b0077a5ca3f467mr9822141ejc.281.1662993209150;
        Mon, 12 Sep 2022 07:33:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6oxnxUy6K4//Kl8Y4yLAbMKx038GpRVk76EHQVIP/1ePIkPzPfJ7G+3b4pBn9INwvCvMGLqw==
X-Received: by 2002:a17:907:961a:b0:77a:5ca3:f467 with SMTP id gb26-20020a170907961a00b0077a5ca3f467mr9822126ejc.281.1662993208930;
        Mon, 12 Sep 2022 07:33:28 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906539600b0076fa6d9d891sm4500765ejo.46.2022.09.12.07.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 07:33:28 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cmaiolino@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RESEND PATCH v3 5/5] xfs_quota: apply -L/-U range limits in uid/gid/pid loops
Date:   Mon, 12 Sep 2022 16:32:40 +0200
Message-Id: <20220912143240.31574-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220912143240.31574-1-aalbersh@redhat.com>
References: <20220912142823.30865-1-aalbersh@redhat.com>
 <20220912143240.31574-1-aalbersh@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 quota/report.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 2b9577a5..2acf81b8 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -157,9 +157,11 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL) {
-				get_dquot(&d, g->gr_gid, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, g->gr_gid, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endgrent();
 			break;
@@ -168,9 +170,11 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL) {
-				get_dquot(&d, p->pr_prid, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, p->pr_prid, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endprent();
 			break;
@@ -179,9 +183,11 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL) {
-				get_dquot(&d, u->pw_uid, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, u->pw_uid, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endpwent();
 			break;
@@ -474,7 +480,9 @@ report_user_mount(
 		setpwent();
 		while ((u = getpwent()) != NULL) {
 			if (get_dquot(&d, u->pw_uid, XFS_USER_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, u->pw_name, form,
 						XFS_USER_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -514,7 +522,9 @@ report_group_mount(
 		setgrent();
 		while ((g = getgrent()) != NULL) {
 			if (get_dquot(&d, g->gr_gid, XFS_GROUP_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, g->gr_name, form,
 						XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -556,7 +566,9 @@ report_project_mount(
 			 * isn't defined
 			 */
 			if (get_dquot(&d, 0, XFS_PROJ_QUOTA, mount->fs_name,
-						flags)) {
+						flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
 						mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -566,7 +578,9 @@ report_project_mount(
 		setprent();
 		while ((p = getprent()) != NULL) {
 			if (get_dquot(&d, p->pr_prid, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, p->pr_name, form,
 						XFS_PROJ_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
-- 
2.27.0

