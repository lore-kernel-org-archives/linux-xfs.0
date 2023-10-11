Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B64CDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 20:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbjJKUx5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 16:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376384AbjJKUxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 16:53:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8BB90
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 13:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697057585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lOppXXoOOt9V3G+yuBJ4lEufGMzhjqgbwBj73RGJmf0=;
        b=OQbECEwkcaoebcHDvZdXayVgUS4RZpfIcqJqBag6p21SzCJkFVCcc53OV1JDO1nxLiYjO+
        U7i9g7/pQ/Ps1hv8lE7Zc6lkYYE9TeKxdBTqhTH57Laczmje9/oJ3SBnvNYAbrKqFImwPx
        TQelBwIcO6OADrzDoEPziIzfku/V5bU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-CXDpGQLkMGyBPrETzlpC7A-1; Wed, 11 Oct 2023 16:52:57 -0400
X-MC-Unique: CXDpGQLkMGyBPrETzlpC7A-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9b2e030e4caso148171966b.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 13:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697057576; x=1697662376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lOppXXoOOt9V3G+yuBJ4lEufGMzhjqgbwBj73RGJmf0=;
        b=AGc9Yc/iMZH2i4gFqFHLcGsMaZxUGYWCphb4Gcq9xMJYwM75kwIAuEccKrLHEhT/25
         eSxHBOVarYReMDxED54LnYWn66pJ4rsXDyd5tApcdIhVhCfFHNQfsF551+4xvXLoZ60w
         WZe+CaqkYINJWMfqDlN9LUrQPTFroSoIr6TPCPvlggtupL9b9k+Q+ft0G3FRGWDXviAv
         nvNWhZt2JWERfXAl9tmgSlWdZS9IxKWTNCfUg+E6Fbiua4kMuLuFb0iVmkKHVMJWkwEK
         zIGTdZc+/FLfmbHRwOCdR7f8S6+M1tENR/m4DUfLQLOo8BhEFP9hCqUsaSy+d1O7gPW/
         ynOA==
X-Gm-Message-State: AOJu0YyUPr4O6eh16kqIOMnvJ2Pa0O5fZwK/0X3vI/Br/I9jZSiC4Lqa
        Af5AQz4zwJVRM3JU40dH0cel3EDImW386/yKNJQXq82WKjBCdvxNcdDOmA9A7oIz3ux5nZ6q/SK
        hjZn7yOI2gSafnXH1xJXkEpS5Ija4s0/Agt17ajashgeORGwKMEvGteVsZcLHwLktSSC1vtVZIv
        4Svk0=
X-Received: by 2002:a17:907:9491:b0:9a5:962c:cb6c with SMTP id dm17-20020a170907949100b009a5962ccb6cmr18436671ejc.31.1697057576338;
        Wed, 11 Oct 2023 13:52:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrwJ9PENZPzOKAzY65D36OC5EfmZdzcYmx4aaeaehICf4kszJ0DNZZWI8vl5ZbCLsfQAAtEg==
X-Received: by 2002:a17:907:9491:b0:9a5:962c:cb6c with SMTP id dm17-20020a170907949100b009a5962ccb6cmr18436656ejc.31.1697057575985;
        Wed, 11 Oct 2023 13:52:55 -0700 (PDT)
Received: from fedora.redhat.com (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906a28b00b009737b8d47b6sm10146087ejz.203.2023.10.11.13.52.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 13:52:55 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_quota: fix missing mount point warning
Date:   Wed, 11 Oct 2023 22:50:54 +0200
Message-ID: <20231011205054.115937-1-preichl@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When user have mounted an XFS volume, and defined project in
/etc/projects file that points to a directory on a different volume,
then:
	`xfs_quota -xc "report -a" $path_to_mounted_volume'

complains with:
	"xfs_quota: cannot find mount point for path \
`directory_from_projects': Invalid argument"

unlike `xfs_quota -xc "report -a"' which works as expected and no
warning is printed.

This is happening because in the 1st call we pass to xfs_quota command
the $path_to_mounted_volume argument which says to xfs_quota not to
look for all mounted volumes on the system, but use only those passed
to the command and ignore all others (This behavior is intended as an
optimization for systems with huge number of mounted volumes). After
that, while projects are initialized, the project's directories on
other volumes are obviously not in searched subset of volumes and
warning is printed.

I propose to fix this behavior by conditioning the printing of warning
only if all mounted volumes are searched.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 libfrog/paths.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/libfrog/paths.c b/libfrog/paths.c
index abb29a237..d8c42163a 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -457,7 +457,8 @@ fs_table_insert_mount(
 
 static int
 fs_table_initialise_projects(
-	char		*project)
+	char		*project,
+	bool		all_mps_initialised)
 {
 	fs_project_path_t *path;
 	fs_path_t	*fs;
@@ -473,8 +474,10 @@ fs_table_initialise_projects(
 			continue;
 		fs = fs_mount_point_from_path(path->pp_pathname);
 		if (!fs) {
-			fprintf(stderr, _("%s: cannot find mount point for path `%s': %s\n"),
-					progname, path->pp_pathname, strerror(errno));
+			if (all_mps_initialised)
+				fprintf(stderr,
+	_("%s: cannot find mount point for path `%s': %s\n"), progname,
+					path->pp_pathname, strerror(errno));
 			continue;
 		}
 		(void) fs_table_insert(path->pp_pathname, path->pp_prid,
@@ -495,11 +498,12 @@ fs_table_initialise_projects(
 
 static void
 fs_table_insert_project(
-	char		*project)
+	char		*project,
+	bool		all_mps_initialised)
 {
 	int		error;
 
-	error = fs_table_initialise_projects(project);
+	error = fs_table_initialise_projects(project, all_mps_initialised);
 	if (error)
 		fprintf(stderr, _("%s: cannot setup path for project %s: %s\n"),
 			progname, project, strerror(error));
@@ -532,9 +536,9 @@ fs_table_initialise(
 	}
 	if (project_count) {
 		for (i = 0; i < project_count; i++)
-			fs_table_insert_project(projects[i]);
+			fs_table_insert_project(projects[i], mount_count == 0);
 	} else {
-		error = fs_table_initialise_projects(NULL);
+		error = fs_table_initialise_projects(NULL, mount_count == 0);
 		if (error)
 			goto out_error;
 	}
-- 
2.41.0

