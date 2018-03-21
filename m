Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeCUDkC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:40:02 -0400
Subject: [PATCH 03/14] xfs_scrub: don't complain about different
 normalization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:39:58 -0700
Message-ID: <152160359862.8288.13397778165305364775.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since there are different ways to normalize utf8 names, don't complain
when we find a name that is normalized in a different way than the NFKC
that we use to find duplicate names.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/unicrash.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 0b5d1fa..10d7c14 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -256,7 +256,6 @@ unicrash_complain(
 	struct unicrash		*uc,
 	const char		*descr,
 	const char		*what,
-	bool			normal,
 	bool			unique,
 	const char		*name,
 	uint8_t			*uniname)
@@ -267,10 +266,6 @@ unicrash_complain(
 	bad1 = string_escape(name);
 	bad2 = string_escape((char *)uniname);
 
-	if (!normal && should_warn_about_name(uc->ctx))
-		str_info(uc->ctx, descr,
-_("Unicode name \"%s\" in %s should be normalized as \"%s\"."),
-				bad1, what, bad2);
 	if (!unique)
 		str_warn(uc->ctx, descr,
 _("Duplicate normalized Unicode name \"%s\" found in %s."),
@@ -342,20 +337,18 @@ __unicrash_check_name(
 {
 	uint8_t			uniname[(NAME_MAX * 2) + 1];
 	bool			moveon;
-	bool			normal;
 	bool			unique;
 
 	memset(uniname, 0, (NAME_MAX * 2) + 1);
-	normal = unicrash_normalize(name, uniname, NAME_MAX * 2);
+	unicrash_normalize(name, uniname, NAME_MAX * 2);
 	moveon = unicrash_add(uc, uniname, ino, &unique);
 	if (!moveon)
 		return false;
 
-	if (normal && unique)
+	if (unique)
 		return true;
 
-	unicrash_complain(uc, descr, namedescr, normal, unique, name,
-			uniname);
+	unicrash_complain(uc, descr, namedescr, unique, name, uniname);
 	return true;
 }
 

