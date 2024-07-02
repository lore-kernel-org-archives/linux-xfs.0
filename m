Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8468830
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882000; cv=none; b=BqCtYq7YtiLSNHhrTwY88/UG78vPOAYi9eTjbIoq7e5qT16vPwYaBQf2gD1SpLMupFimziAYJ1HMXOHyaLXVcZQofkuzYUa6wYQ7PZGDbqSCtSuguVyHXmUsE/msns9yx9HFg7b8P6idX5K6JPYMgWR+G97Bx57XOHmavhxvDLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882000; c=relaxed/simple;
	bh=LF8G5U2AVAVEpiE2egVc1o0Vl5IdwO7RVF51oGPt84Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjyJkJoIpjw9NSYteyQNCd3rdGNBXKjUaLz2RyqU8q1QWytPHnAlatAjdyiw7bad6IFaZvhu0hwVkg2gW63eRz4vlbFuqzDGR04ynzNBJ7XeTn12DEOcV7+XaPn8rPMI9p7yRDtf+MLiEyf7Ttp+dJi1JmAraf8d+6TrjEEbEgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Le19T169; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Le19T169"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35659C116B1;
	Tue,  2 Jul 2024 01:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882000;
	bh=LF8G5U2AVAVEpiE2egVc1o0Vl5IdwO7RVF51oGPt84Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Le19T169KOisJjNaPGzvnWkcZPtcgt8Za9m2aVbiCCso7OrpwIaL8QGCtiefcAacD
	 nrDbJ/x4I68ebGrzVv5F6puVcUiOxCX/AdUMENX++b0/mMUaDy5YD9EyXBAC6SGz6a
	 FUIs/MIVsmfzxkPwhBesLPavTm0u65jMXOSxJJr6Q7oGRE7RHWWR4Ng7r9Gi+5OpcP
	 FKnSRquhAT7puvcmgY8V6YMeqfypZv+bxDzf3egA16fQiULuGFJmxZIxBGDY2Gw7Wn
	 cgKZ25qjfc21g8d6nfuOF7pxzvyoDfsu7oG65Hc5t7wPGDHipiijD8h+72pk6NiaLr
	 0pcAT8NZFXRgg==
Date: Mon, 01 Jul 2024 17:59:59 -0700
Subject: [PATCH 10/13] xfs_scrub: reduce size of struct name_entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117763.2007123.5929393677337209049.stgit@frogsfrogsfrogs>
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

libicu doesn't support processing strings longer than 2GB in length, and
we never feed the unicrash code a name longer than about 300 bytes.
Rearrange the structure to reduce the head structure size from 56 bytes
to 44 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 25f562b0a36f..dfa798b09b0e 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -57,18 +57,20 @@
  * In other words, skel = remove_invisible(nfd(remap_confusables(nfd(name)))).
  */
 
-typedef unsigned int __bitwise	badname_t;
+typedef uint16_t __bitwise	badname_t;
 
 struct name_entry {
 	struct name_entry	*next;
 
 	/* NFKC normalized name */
 	UChar			*normstr;
-	size_t			normstrlen;
 
 	/* Unicode skeletonized name */
 	UChar			*skelstr;
-	size_t			skelstrlen;
+
+	/* Lengths for normstr and skelstr */
+	int32_t			normstrlen;
+	int32_t			skelstrlen;
 
 	xfs_ino_t		ino;
 
@@ -76,7 +78,7 @@ struct name_entry {
 	badname_t		badflags;
 
 	/* Raw dirent name */
-	size_t			namelen;
+	uint16_t		namelen;
 	char			name[0];
 };
 #define NAME_ENTRY_SZ(nl)	(sizeof(struct name_entry) + 1 + \
@@ -343,6 +345,12 @@ name_entry_create(
 	struct name_entry	*new_entry;
 	size_t			namelen = strlen(name);
 
+	/* should never happen */
+	if (namelen > UINT16_MAX) {
+		ASSERT(namelen <= UINT16_MAX);
+		return false;
+	}
+
 	/* Create new entry */
 	new_entry = calloc(NAME_ENTRY_SZ(namelen), 1);
 	if (!new_entry)

