Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3CB7464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301611; cv=none; b=svFh1aikdFHQvAOCdZBZQcBJUdKSgzAeLow/o2yNSl0cr4yo6h9GfMVhtVnmOEBR28ZfAkqkOpjO/ZpE6ElgvA70nTtoLk0xOb/92b0NQaeZxfMfRx+sgWBxydOLAUA6jpOOmsbYOsg0MMw3IuCbCKu6UDXlJEwskwmLwEXXCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301611; c=relaxed/simple;
	bh=rGE3BySm7eCOCtJgnWsCCfcISzTN6G7a/AXDRMNmv7g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLu1XdCJBRYkux/9BTqpmE74CTBsTtyipqi2vYX7bePEPSGHmPq7MT3Xg9/jjvTE1A+gsdLAHtfc9ObnpLjonCUZc3UfNAJ5Deph0niQnguIgqivh+8QEedkGh/7qtc/gSjY8q4GmzDeXc6LouOmLv8KQ88V+K03T4OebPEPom0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCC8Vfpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCC8Vfpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E757C32786;
	Tue, 30 Jul 2024 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301610;
	bh=rGE3BySm7eCOCtJgnWsCCfcISzTN6G7a/AXDRMNmv7g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JCC8Vfpea31Wm/P/DOzHcyHGieDBaV1Qo1cmjhvaHMLqanPw3FAkBe0gfxEcXJwrr
	 bKUHbYS1wV+URJE8N5HI6LADKMkQUODqU5VY54B6reIwnjF18LErNImRMiectXWMUT
	 DdtQgntQQj8/Ieyi8PpzdiITrzuQJzmLs9KtNu97yiSiheUSuHqcgT1ZKJZ9nX8RF2
	 GKnKB4VLl6XOYNS6CMlAeXduH+EccrF1+SY0dDWQnPTXu7F9+5+acBwOid6i47cPAK
	 Kve/gdsHArRH5dudome9TUZThqjUD93bJ9ukPaYJP0iGhGTWzPuyCf4SMKw9kQryoM
	 Q256ZxX0OOnDQ==
Date: Mon, 29 Jul 2024 18:06:50 -0700
Subject: [PATCH 04/13] xfs_scrub: avoid potential UAF after freeing a
 duplicate name entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847591.1348850.7263037580833766617.stgit@frogsfrogsfrogs>
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

Change the function declaration of unicrash_add to set the caller's
@new_entry to NULL if we detect an updated name entry and do not wish to
continue processing.  This avoids a theoretical UAF if the unicrash_add
caller were to accidentally continue using the pointer.

This isn't an /actual/ UAF because the function formerly set @badflags
to zero, but let's be a little defensive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index edc32d55c..4517e2bce 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -628,10 +628,11 @@ _("Unicode name \"%s\" in %s could be confused with \"%s\"."),
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
@@ -654,7 +655,7 @@ unicrash_add(
 			entry->ino = new_entry->ino;
 			uc->buckets[bucket] = new_entry->next;
 			name_entry_free(new_entry);
-			*badflags = 0;
+			*new_entryp = NULL;
 			return;
 		}
 
@@ -697,8 +698,8 @@ __unicrash_check_name(
 		return 0;
 
 	name_entry_examine(new_entry, &badflags);
-	unicrash_add(uc, new_entry, &badflags, &dup_entry);
-	if (badflags)
+	unicrash_add(uc, &new_entry, &badflags, &dup_entry);
+	if (new_entry && badflags)
 		unicrash_complain(uc, dsc, namedescr, new_entry, badflags,
 				dup_entry);
 

