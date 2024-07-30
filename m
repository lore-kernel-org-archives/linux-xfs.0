Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D4B8BF0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301689; cv=none; b=hwTPVMtge9+Nyra+8PrCnA7nwZQrzJoSQYaaX5SdC/+0LlfLmLjViVvW4ncbBgVJ1i4jm39+0OQKVKrYkeBMntFKmyIwg+IP2XAI+nvnXF0WggoqRy5NcdtgMlxngfU52fIz5+9siLCfKLnz2iW3y27EHkSf6jgh1gMWL/MA1TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301689; c=relaxed/simple;
	bh=+T2svynhSRS4pq4cYgWTHmIIHeR5985xnhZugHYBkkc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMV7RZKY5aar2Uq5BqjPFxOaMF5DC7nXH3gsHGY8CgcCWnG069zaDutZQgQuTftBteQP+kuA9P5PsbTaNLFf7vY0jKTE73E+gzBODMGcRaXtEFj3OVvOjfYn8Dl//pod1I2qRmBZQVVOKp8eN8tbmtmaIfhHcgQKS2ld6EI0nIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWfuA8qR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWfuA8qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1951EC32786;
	Tue, 30 Jul 2024 01:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301689;
	bh=+T2svynhSRS4pq4cYgWTHmIIHeR5985xnhZugHYBkkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fWfuA8qR/zQcpQWAuLCY8l4zeQOpvIslTRIk/+HVqo/0uL/15r+ADuiWMezwWFOqp
	 1ko26iyQqjtuqOL1Ud/SaqKHQ4tIgw8+nMaUHdEx3z67PJGDuR/hN1lqDlmPRMeYs8
	 VwTue8GMzu39HmNsV2zobfIT7pcRp4e/er7yW7UYGUgfQZ1aOail+1FpAL8xq2rVAn
	 YA3y7jkDH31GSBftxIvI1EF+qc+3mx+x0L3uPudO03mi+8H07WykgcWSJ5MR8O4PET
	 2sF6GKt9JCHaFKjIThFZGRN2KjaeVhs8dbyWwY+jBVYcrfMlhA6DjuRxXaJYE+wGN9
	 yJCuIJPTC8Ysw==
Date: Mon, 29 Jul 2024 18:08:08 -0700
Subject: [PATCH 09/13] xfs_scrub: type-coerce the UNICRASH_* flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847667.1348850.1406694167703531231.stgit@frogsfrogsfrogs>
In-Reply-To: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
References: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 5447d94f0..63694c39a 100644
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
@@ -542,7 +548,7 @@ unicrash_complain(
 	struct descr		*dsc,
 	const char		*what,
 	struct name_entry	*entry,
-	unsigned int		badflags,
+	badname_t		badflags,
 	struct name_entry	*dup_entry)
 {
 	char			*bad1 = NULL;
@@ -645,7 +651,7 @@ _("Unicode name \"%s\" in %s could be confused with \"%s\"."),
  * must be skeletonized according to Unicode TR39 to detect names that
  * could be visually confused with each other.
  */
-static unsigned int
+static badname_t
 unicrash_add(
 	struct unicrash		*uc,
 	struct name_entry	**new_entryp,
@@ -655,7 +661,7 @@ unicrash_add(
 	struct name_entry	*entry;
 	size_t			bucket;
 	xfs_dahash_t		hash;
-	unsigned int		badflags = new_entry->badflags;
+	badname_t		badflags = new_entry->badflags;
 
 	/* Store name in hashtable. */
 	hash = name_entry_hash(new_entry);
@@ -713,14 +719,14 @@ __unicrash_check_name(
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
 

