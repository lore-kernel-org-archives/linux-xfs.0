Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E6EC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E49421775
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="geV+OL+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEIRSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:18:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46613 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726013AbgEIRSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589044726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lk2GsBi3Ly08L5hGHtU7GZ3OSQxlxwGZnEZo2nYjZfw=;
        b=geV+OL+9u4wufjq4S1puo7C9GMGcWt35T+wfpM4Dbmt7KL0pEnZTELoZSU5BiC5wi8IKLZ
        IGOltMWteRzgVarHWwe2RczuSFwLmgHUY+qzay7oolwMQb3G/uiHpcCBBi8SRjgaGgDn8l
        aUh4CwZPLon+0X5s4fYcFdVHOPRC6VY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-t7oQkQCrPyiAj7OUWMaSEA-1; Sat, 09 May 2020 13:18:44 -0400
X-MC-Unique: t7oQkQCrPyiAj7OUWMaSEA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A855E18CA26B
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 17:18:43 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74DF15C1C8
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 17:18:43 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_quota: refactor code to generate id from name
Message-ID: <8b4b7edb-94b2-3bb1-9ede-73674db82330@redhat.com>
Date:   Sat, 9 May 2020 12:18:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There's boilerplate for setting limits and warnings, where we have
a case statement for each of the 3 quota types, and from there call
3 different functions to configure each of the 3 types, each of which
calls its own version of id to string function... 

Refactor this so that the main function can call a generic id to string
conversion routine, and then call a common action.  This save a lot of
LOC.

I was looking at allowing xfs to bump out individual grace periods like
setquota can do, and this refactoring allows us to add new actions like
that without copyingall the boilerplate again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 edit.c |  196 ++++++++++++++++-----------------------------------------
 1 file changed, 51 insertions(+), 145 deletions(-)

diff --git a/quota/edit.c b/quota/edit.c
index f9938b8a..70c0969f 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -101,6 +101,42 @@ warn_help(void)
 "\n"));
 }
 
+static uint32_t
+id_from_string(
+	char	*name,
+	int	type)
+{
+	uint32_t	id = -1;
+
+	switch (type) {
+	case XFS_USER_QUOTA:
+		id = uid_from_string(name);
+		if (id == -1)
+			fprintf(stderr, _("%s: invalid user name: %s\n"),
+				progname, name);
+		break;
+	case XFS_GROUP_QUOTA:
+		id = gid_from_string(name);
+		if (id == -1)
+			fprintf(stderr, _("%s: invalid group name: %s\n"),
+				progname, name);
+		break;
+	case XFS_PROJ_QUOTA:
+		id = prid_from_string(name);
+		if (id == -1)
+			fprintf(stderr, _("%s: invalid project name: %s\n"),
+				progname, name);
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	if (id == -1)
+		exitcode = 1;
+	return id;
+}
+
 static void
 set_limits(
 	uint32_t	id,
@@ -135,75 +171,6 @@ set_limits(
 	}
 }
 
-static void
-set_user_limits(
-	char		*name,
-	uint		type,
-	uint		mask,
-	uint64_t	*bsoft,
-	uint64_t	*bhard,
-	uint64_t	*isoft,
-	uint64_t	*ihard,
-	uint64_t	*rtbsoft,
-	uint64_t	*rtbhard)
-{
-	uid_t		uid = uid_from_string(name);
-
-	if (uid == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: invalid user name: %s\n"),
-				progname, name);
-	} else
-		set_limits(uid, type, mask, fs_path->fs_name,
-				bsoft, bhard, isoft, ihard, rtbsoft, rtbhard);
-}
-
-static void
-set_group_limits(
-	char		*name,
-	uint		type,
-	uint		mask,
-	uint64_t	*bsoft,
-	uint64_t	*bhard,
-	uint64_t	*isoft,
-	uint64_t	*ihard,
-	uint64_t	*rtbsoft,
-	uint64_t	*rtbhard)
-{
-	gid_t		gid = gid_from_string(name);
-
-	if (gid == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: invalid group name: %s\n"),
-				progname, name);
-	} else
-		set_limits(gid, type, mask, fs_path->fs_name,
-				bsoft, bhard, isoft, ihard, rtbsoft, rtbhard);
-}
-
-static void
-set_project_limits(
-	char		*name,
-	uint		type,
-	uint		mask,
-	uint64_t	*bsoft,
-	uint64_t	*bhard,
-	uint64_t	*isoft,
-	uint64_t	*ihard,
-	uint64_t	*rtbsoft,
-	uint64_t	*rtbhard)
-{
-	prid_t		prid = prid_from_string(name);
-
-	if (prid == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: invalid project name: %s\n"),
-				progname, name);
-	} else
-		set_limits(prid, type, mask, fs_path->fs_name,
-				bsoft, bhard, isoft, ihard, rtbsoft, rtbhard);
-}
-
 /* extract number of blocks from an ascii string */
 static int
 extractb(
@@ -258,6 +225,7 @@ limit_f(
 	char		**argv)
 {
 	char		*name;
+	uint32_t	id;
 	uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
 	int		c, type = 0, mask = 0, flags = 0;
 	uint		bsize, ssize, endoptions;
@@ -339,20 +307,13 @@ limit_f(
 		return command_usage(&limit_cmd);
 	}
 
-	switch (type) {
-	case XFS_USER_QUOTA:
-		set_user_limits(name, type, mask,
-			&bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
-		break;
-	case XFS_GROUP_QUOTA:
-		set_group_limits(name, type, mask,
-			&bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
-		break;
-	case XFS_PROJ_QUOTA:
-		set_project_limits(name, type, mask,
-			&bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
-		break;
-	}
+
+	id = id_from_string(name, type);
+	if (id >= 0)
+		set_limits(id, type, mask, fs_path->fs_name,
+			   &bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
+	else
+		exitcode = -1;
 	return 0;
 }
 
@@ -561,63 +522,13 @@ set_warnings(
 	}
 }
 
-static void
-set_user_warnings(
-	char		*name,
-	uint		type,
-	uint		mask,
-	uint		value)
-{
-	uid_t		uid = uid_from_string(name);
-
-	if (uid == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: invalid user name: %s\n"),
-				progname, name);
-	} else
-		set_warnings(uid, type, mask, fs_path->fs_name, value);
-}
-
-static void
-set_group_warnings(
-	char		*name,
-	uint		type,
-	uint		mask,
-	uint		value)
-{
-	gid_t		gid = gid_from_string(name);
-
-	if (gid == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: invalid group name: %s\n"),
-				progname, name);
-	} else
-		set_warnings(gid, type, mask, fs_path->fs_name, value);
-}
-
-static void
-set_project_warnings(
-	char		*name,
-	uint		type,
-	uint		mask,
-	uint		value)
-{
-	prid_t		prid = prid_from_string(name);
-
-	if (prid == -1) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: invalid project name: %s\n"),
-				progname, name);
-	} else
-		set_warnings(prid, type, mask, fs_path->fs_name, value);
-}
-
 static int
 warn_f(
 	int		argc,
 	char		**argv)
 {
 	char		*name;
+	uint32_t	id;
 	uint		value;
 	int		c, flags = 0, type = 0, mask = 0;
 
@@ -675,17 +586,12 @@ warn_f(
 		return command_usage(&warn_cmd);
 	}
 
-	switch (type) {
-	case XFS_USER_QUOTA:
-		set_user_warnings(name, type, mask, value);
-		break;
-	case XFS_GROUP_QUOTA:
-		set_group_warnings(name, type, mask, value);
-		break;
-	case XFS_PROJ_QUOTA:
-		set_project_warnings(name, type, mask, value);
-		break;
-	}
+	id = id_from_string(name, type);
+	if (id >= 0)
+		set_warnings(id, type, mask, fs_path->fs_name, value);
+	else
+		exitcode = -1;
+
 	return 0;
 }
 

