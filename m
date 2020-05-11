Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E54C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 19:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B8B20675
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 19:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BqCtPvDU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgEKTIh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 15:08:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38215 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730999AbgEKTIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 15:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589224114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=+gMgbPUBMERMX9erNix7JE13OTZ2ydQtsZ1zsLPwX80=;
        b=BqCtPvDUlqc3LHlOUI8EoF29Rk6ldxtaOaGn4L1X+NcBZZw2cEH+FcfUHzriVl43xzR2FO
        W1px7k6Huvnfvzy55BeOrTy30/k302yyBRhN6O+UR21KcEGPAnIbnGYPhKUmsXGjJ6AnKJ
        CvQqD1EadS6VAeqKoK0qPoq/+tR/Tgw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-AIsA7Os1NkSs-aHQqnwOQQ-1; Mon, 11 May 2020 15:08:30 -0400
X-MC-Unique: AIsA7Os1NkSs-aHQqnwOQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CB86460;
        Mon, 11 May 2020 19:08:29 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27C97196AE;
        Mon, 11 May 2020 19:08:29 +0000 (UTC)
Subject: [PATCH V2] xfs_quota: refactor code to generate id from name
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <8b4b7edb-94b2-3bb1-9ede-73674db82330@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Cc:     Christoph Hellwig <hch@infradead.org>
Message-ID: <b5668fd4-7070-4afc-f556-8445ef41fab7@redhat.com>
Date:   Mon, 11 May 2020 14:08:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8b4b7edb-94b2-3bb1-9ede-73674db82330@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
that without copying all the boilerplate again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: dedupe printfs per hch's suggestion

 edit.c |  194 +++++++++++--------------------------
 1 file changed, 49 insertions(+), 145 deletions(-)

diff --git a/quota/edit.c b/quota/edit.c
index f9938b8a..c40985e2 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -101,6 +101,40 @@ warn_help(void)
 "\n"));
 }
 
+static uint32_t
+id_from_string(
+	char	*name,
+	int	type)
+{
+	uint32_t	id = -1;
+	const char	*type_name = "unknown type";
+
+	switch (type) {
+	case XFS_USER_QUOTA:
+		type_name = "user";
+		id = uid_from_string(name);
+		break;
+	case XFS_GROUP_QUOTA:
+		type_name = "group";
+		id = gid_from_string(name);
+		break;
+	case XFS_PROJ_QUOTA:
+		type_name = "project";
+		id = prid_from_string(name);
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	if (id == -1) {
+		fprintf(stderr, _("%s: invalid %s name: %s\n"),
+			type_name, progname, name);
+		exitcode = 1;
+	}
+	return id;
+}
+
 static void
 set_limits(
 	uint32_t	id,
@@ -135,75 +169,6 @@ set_limits(
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
@@ -258,6 +223,7 @@ limit_f(
 	char		**argv)
 {
 	char		*name;
+	uint32_t	id;
 	uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
 	int		c, type = 0, mask = 0, flags = 0;
 	uint		bsize, ssize, endoptions;
@@ -339,20 +305,13 @@ limit_f(
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
 
@@ -561,63 +520,13 @@ set_warnings(
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
 
@@ -675,17 +584,12 @@ warn_f(
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
 


