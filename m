Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A69E6FC3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881906; cv=none; b=QYACl1CSj0EmUYj0eitHzFUhP6G3nYtmdc4f5gGpkMNvSDuQluC47OCuZBRxHPQHuF+zPsu/QA+56BDE7JPCu831PnOvo9acJ2WJYlx0cidpOnVteqKmEhUl9NZNXE5SuuN5etNe7VD9HB8LkIlVqJY6Qn+kP2IjlpoN+f5wzg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881906; c=relaxed/simple;
	bh=YGF71p9bHkNTZoBkDGTz041KCYInXLTRWSBsCuocVbI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4ufPH4aAhXWS/yHsw6+BqYdaVIY7taZZE1doA77ka2JBIOXQZ+iuLL/T9ySIcvGD/cTPFgv1IVkPlc4fLUFISzCC+tMtNIAI6G2pbs4zRqHOTiS75NoOVvClnj5OaBMTZcD6WSwq5NIeXoaRtvJQG9GDCEY/tCrdGS6zYWkYO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otOWjFGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otOWjFGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766ABC116B1;
	Tue,  2 Jul 2024 00:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881906;
	bh=YGF71p9bHkNTZoBkDGTz041KCYInXLTRWSBsCuocVbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=otOWjFGnmgl7nL4g4QrKoVW8Uxc1FWNLaczOiullhV5O2WVXBcoRcN27w71TRaUU3
	 c3fMHYZ+aSMOpqa8RlQT4sGhiD3yqLzIdFfXiKHbxfLycT4rBf644VeuTF8qUZLD/c
	 i7isXW0mBZMyIqZRlQ3u7n9+ECPzUbFxZL0l1pdaOSOEtIZzzVOc9nblQutul77ew4
	 QX1S+sHeTBUL/RxNeMnLzwuuz4sP4e6qz1by9JoQOXVonHOwX4AvpcwJSeTzu4OykI
	 BylSHe39r1oyzG5eUQnxeHdwa+jkkmh5y35DZKa1pCjdd2ctV5vDq9JYiw/OJzb3R3
	 MLqqR5vvS9h7A==
Date: Mon, 01 Jul 2024 17:58:26 -0700
Subject: [PATCH 04/13] xfs_scrub: avoid potential UAF after freeing a
 duplicate name entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117673.2007123.15647994096603486811.stgit@frogsfrogsfrogs>
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
index fc1adb2caab7..5a61d69705bd 100644
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
 

