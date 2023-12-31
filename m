Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0897C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVwEU8ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB82C433C7;
	Sun, 31 Dec 2023 22:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062843;
	bh=bul95YVYBXiH3qj2jWh3YFfdO3WAAzq3wilwHdduTrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lVwEU8tsXLkW+aVMHoNybg9Q6xneD4UTFyhdDxg0Gi0pQ26uPEsMurBQOD4OOebEh
	 dVbqWbfnHr7pbNxzL19195lyIT8HNiD0H7aZpZNBss+bHteIMiYOmYoixbx3weMPxH
	 46JakObN35x6qYdHbM4F0nIkJwf7KEzZ2/IMtKgO6MUdFZ85ry7ebbu1muRAvD0XMJ
	 RuETpyM0naqOIZj7qMdZNTdBxnrkiaf7QNrI0PfrfZToUxgVIzSlomjqA7fgelnz8L
	 NfVoqLCb7938Y+GTeDWeeSPC77GagGsbykk9o5u3bxKdEkOmdbWPHcCykSuhc9ARib
	 ECTwNxGYhDmLg==
Date: Sun, 31 Dec 2023 14:47:23 -0800
Subject: [PATCH 09/13] xfs_scrub: type-coerce the UNICRASH_* flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000702.1798385.12347191299170418722.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
References: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
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
index b2baa47ad6c..25f562b0a36 100644
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
 

