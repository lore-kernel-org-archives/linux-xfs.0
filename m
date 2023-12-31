Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC2C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmS90iH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833D3C433C8;
	Sun, 31 Dec 2023 22:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062765;
	bh=5X2WOBLTj9JXfhWpdRJGQBZ7IHl2s9lvql1LoVAEgm4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KmS90iH8cbVwNwIQNzRyfSH40nDyOX7VtVLE04N+dGKlMhdY4uE+1Ni5lD9gQnCpX
	 XRNdMtZVFQ60pAYp0revEQwKoQKl76sbkPkBtawjOddjJPAMpVeSBqSY2kAMM1xE2r
	 PwzUZvvI7NmYh/sX+cBdWgitXfCYB+bcNWahTK1wEyu7gi3U9P0y6bnzQTKoNUCeBM
	 jc+3l+N2kjQX2c30e71zNhdlO/RdDAzdzUBz+lY4ZbpPwxJotzElslBCNT7x9MVkoN
	 3Glq371Ny3L/M/6PSBzqp0WOXBf+0P2y1LJxbq9bqjEgu8ZvHq5i7FoSR/E1+uvJxl
	 V5wdnV0g0Kj6g==
Date: Sun, 31 Dec 2023 14:46:05 -0800
Subject: [PATCH 04/13] xfs_scrub: avoid potential UAF after freeing a
 duplicate name entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000636.1798385.416400229275412734.stgit@frogsfrogsfrogs>
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

Change the function declaration of unicrash_add to set the caller's
@new_entry to NULL if we detect an updated name entry and do not wish to
continue processing.  This avoids a theoretical UAF if the unicrash_add
caller were to accidentally continue using the pointer.

This isn't an /actual/ UAF because the function formerly set @badflags
to zero, but let's be a little defensive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index fc1adb2caab..5a61d69705b 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -626,10 +626,11 @@ _("Unicode name \"%s\" in %s could be confused with \"%s\"."),
 static void
 unicrash_add(
 	struct unicrash		*uc,
-	struct name_entry	*new_entry,
+	struct name_entry	**new_entryp,
 	unsigned int		*badflags,
 	struct name_entry	**existing_entry)
 {
+	struct name_entry	*new_entry = *new_entryp;
 	struct name_entry	*entry;
 	size_t			bucket;
 	xfs_dahash_t		hash;
@@ -652,7 +653,7 @@ unicrash_add(
 			entry->ino = new_entry->ino;
 			uc->buckets[bucket] = new_entry->next;
 			name_entry_free(new_entry);
-			*badflags = 0;
+			*new_entryp = NULL;
 			return;
 		}
 
@@ -695,8 +696,8 @@ __unicrash_check_name(
 		return 0;
 
 	name_entry_examine(new_entry, &badflags);
-	unicrash_add(uc, new_entry, &badflags, &dup_entry);
-	if (badflags)
+	unicrash_add(uc, &new_entry, &badflags, &dup_entry);
+	if (new_entry && badflags)
 		unicrash_complain(uc, dsc, namedescr, new_entry, badflags,
 				dup_entry);
 

