Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC17B8479
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881984; cv=none; b=aH24cQmmP3fRh7C3MZ9x3R+f/lpGznqCnO/4rHXtaOPHqOHkULrGd+bqCaxcEL0VwJfNbC7A6urrhe/2LN/XuE+0AL3mmhDbesNyjAC2hrK5+NrGiOjob3dMzkd30QfvBj5tC+BTVamKZcW0hAjZaMBZaioBh4d8XX/C8UoCknI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881984; c=relaxed/simple;
	bh=o6YvHOsCb717yDORuUZxyEPCVhre7S8QNnCYxLRZcL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZzCg2IVhFw0HzZLDermeQ6d60i+OwkhnXSMFI7Gdj8tBPh+ub9DfrRtvb1B3DobRzmjTh/h4zRe6CIGlG8PEXRm6L3uUeqlLWBIVa7sPjstjYHafm5UXj4gAP1eH62n+HOywF699XOjkLPP7/NNUlHibUVr7eLkZi6s6R2YC8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIkL0jL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIkL0jL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90389C116B1;
	Tue,  2 Jul 2024 00:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881984;
	bh=o6YvHOsCb717yDORuUZxyEPCVhre7S8QNnCYxLRZcL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KIkL0jL7gwTtp4JtisXCzaEhwC9KmHwY9Od9KmVIax1Z0hkHqiBH3EOzyKAAh1j3d
	 zPy/jYgEngPUZkD7E9ZRlpAgql7NQDspRMbU9M2McTNDU0w0DdAYa7FtvZz+yY0Dmb
	 AwIOgZ58Kdd+/oJJbtSeUPPVKZttOEWsUPjcjluT36p6+AGq+/mD9L4o8pHKjRofJW
	 MkVfxuL3mze55G4uOB/JyJ9RNtdqPmP4TTx7dwm0jNxPwBdUo7ysgZMJ+0K9hjD/c0
	 1T/QtkWYWEVBX217fe6M2VCKAOczkaw90Q2D35Y7H2fOpzhg98InebzxPMw1DIbnZv
	 82LjzCX9s3rDg==
Date: Mon, 01 Jul 2024 17:59:44 -0700
Subject: [PATCH 09/13] xfs_scrub: type-coerce the UNICRASH_* flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117748.2007123.4070255254924781803.stgit@frogsfrogsfrogs>
In-Reply-To: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Promote this type to something that we can type-check.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index b2baa47ad6ca..25f562b0a36f 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -4,6 +4,7 @@
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
+#include "xfs_arch.h"
 #include <stdint.h>
 #include <stdlib.h>
 #include <dirent.h>
@@ -56,6 +57,8 @@
  * In other words, skel = remove_invisible(nfd(remap_confusables(nfd(name)))).
  */
 
+typedef unsigned int __bitwise	badname_t;
+
 struct name_entry {
 	struct name_entry	*next;
 
@@ -70,7 +73,7 @@ struct name_entry {
 	xfs_ino_t		ino;
 
 	/* Everything that we don't like about this name. */
-	unsigned int		badflags;
+	badname_t		badflags;
 
 	/* Raw dirent name */
 	size_t			namelen;
@@ -93,26 +96,29 @@ struct unicrash {
 
 /* Things to complain about in Unicode naming. */
 
+/* Everything is ok */
+#define UNICRASH_OK		((__force badname_t)0)
+
 /*
  * Multiple names resolve to the same normalized string and therefore render
  * identically.
  */
-#define UNICRASH_NOT_UNIQUE	(1 << 0)
+#define UNICRASH_NOT_UNIQUE	((__force badname_t)(1U << 0))
 
 /* Name contains directional overrides. */
-#define UNICRASH_BIDI_OVERRIDE	(1 << 1)
+#define UNICRASH_BIDI_OVERRIDE	((__force badname_t)(1U << 1))
 
 /* Name mixes left-to-right and right-to-left characters. */
-#define UNICRASH_BIDI_MIXED	(1 << 2)
+#define UNICRASH_BIDI_MIXED	((__force badname_t)(1U << 2))
 
 /* Control characters in name. */
-#define UNICRASH_CONTROL_CHAR	(1 << 3)
+#define UNICRASH_CONTROL_CHAR	((__force badname_t)(1U << 3))
 
 /* Invisible characters.  Only a problem if we have collisions. */
-#define UNICRASH_INVISIBLE	(1 << 4)
+#define UNICRASH_INVISIBLE	((__force badname_t)(1U << 4))
 
 /* Multiple names resolve to the same skeleton string. */
-#define UNICRASH_CONFUSABLE	(1 << 5)
+#define UNICRASH_CONFUSABLE	((__force badname_t)(1U << 5))
 
 /*
  * We only care about validating utf8 collisions if the underlying
@@ -540,7 +546,7 @@ unicrash_complain(
 	struct descr		*dsc,
 	const char		*what,
 	struct name_entry	*entry,
-	unsigned int		badflags,
+	badname_t		badflags,
 	struct name_entry	*dup_entry)
 {
 	char			*bad1 = NULL;
@@ -643,7 +649,7 @@ _("Unicode name \"%s\" in %s could be confused with \"%s\"."),
  * must be skeletonized according to Unicode TR39 to detect names that
  * could be visually confused with each other.
  */
-static unsigned int
+static badname_t
 unicrash_add(
 	struct unicrash		*uc,
 	struct name_entry	**new_entryp,
@@ -653,7 +659,7 @@ unicrash_add(
 	struct name_entry	*entry;
 	size_t			bucket;
 	xfs_dahash_t		hash;
-	unsigned int		badflags = new_entry->badflags;
+	badname_t		badflags = new_entry->badflags;
 
 	/* Store name in hashtable. */
 	hash = name_entry_hash(new_entry);
@@ -711,14 +717,14 @@ __unicrash_check_name(
 {
 	struct name_entry	*dup_entry = NULL;
 	struct name_entry	*new_entry = NULL;
-	unsigned int		badflags;
+	badname_t		badflags;
 
 	/* If we can't create entry data, just skip it. */
 	if (!name_entry_create(uc, name, ino, &new_entry))
 		return 0;
 
 	badflags = unicrash_add(uc, &new_entry, &dup_entry);
-	if (new_entry && badflags)
+	if (new_entry && badflags != UNICRASH_OK)
 		unicrash_complain(uc, dsc, namedescr, new_entry, badflags,
 				dup_entry);
 

