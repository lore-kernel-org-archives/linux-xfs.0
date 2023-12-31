Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E87AC140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ineOteTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0ADC433C7;
	Sun, 31 Dec 2023 22:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062859;
	bh=QnHlVtq5wlUqiD2c5YHvDWi98duNgBFPW0n+Ra8kIBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ineOteTBdd5ZupoP6BwEDfgZkyUzqeH6NLHxzWYWDqOdJE4IPksJ/Yhk4ZYtBVAiS
	 c+wicScx/wcwrZ6UhS74X/ZBZ6D8dYiummfK8B/xhzHXGP8hAPP/6ZKiRacsjdHaWK
	 67wNhKZ36BGZzrKSaj0NVZAWqkR/znRszpXxkCfSSPMGwdP2EzjE670ipUFe47QBja
	 swuwyxnwXFIxOTCjhmm1C6WTf4/cggiToHSMNOwTBxE9ROVFhWtQLCrC2qiSWVWpmg
	 a01Dodf6thfOfTN2rRi6/MMjRp7/j8sMWLQ2x32a1tSf+exXx6ulQdSVI4a6s5HJvu
	 GNhMgOXWEKQNw==
Date: Sun, 31 Dec 2023 14:47:38 -0800
Subject: [PATCH 10/13] xfs_scrub: reduce size of struct name_entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000716.1798385.11560636208183094127.stgit@frogsfrogsfrogs>
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

libicu doesn't support processing strings longer than 2GB in length, and
we never feed the unicrash code a name longer than about 300 bytes.
Rearrange the structure to reduce the head structure size from 56 bytes
to 44 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 25f562b0a36..dfa798b09b0 100644
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

