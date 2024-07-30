Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E828BF0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301705; cv=none; b=g66qtxU1kEGtYc8LsBqaAQqFnTNzdL1IerT8b4qi0xBjZSykdeNFaAAat+PawHJE5eTUvqqHxIe1KXODpZeI3IkdNS6jS06bQwYUbdVc2Cyp6tqQsObtenHQPZaDcuYbmzbFX75QlTZLl9sotLPE7rR8bS9ZtuvzdNmrga5Dxkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301705; c=relaxed/simple;
	bh=ITS7lNaXEw3O6E5pGSkr2qOTyaAOFABUt3QXmb2c5fY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E3B7pZa9ZKn/KNv5R6QpKfyWd+rZa8TDDVvv/DJs9SpAL98cHlXGmm44p0I03/rI6f94p53FzoMNYOCpWXEpgqBjkNPx4uXVXL/jIwouIg5sozNvz8EWLly33yhDpWexYCdAFdzWd3eiapD5qM1+eFGyCgg7baTPH7/Oojkjs0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tzzT2DxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tzzT2DxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E12C32786;
	Tue, 30 Jul 2024 01:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301704;
	bh=ITS7lNaXEw3O6E5pGSkr2qOTyaAOFABUt3QXmb2c5fY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tzzT2DxEoeZRAiASpSvjaIxSVWxbeuZAth+IBegb6Q+V9r9EIcnEqRKf3NErCacSx
	 tmG5j8gD8Uio4NBztq6cpLG8Lcgb2VbcEmxOBrw6+rfuDvViRZjaEV/+YbQxe28E2B
	 2/8kNaKGkiDu2f0FBG6EyAwliigUUr35vcUTNLNxEQEJnnicknU/a+YryjAsVoKsF7
	 E2YN/yyejkuaVqxrljJ714OOKWEKVoLGsLUFlONJEyRsMkAg8/z6GQuhttb899fO7P
	 3Rq44D8WIoQhZ7J4Wx3CfirFlbYh13pOvtmbUFrl2joIlDVi+kgX+OZ4rCj5tNbvD2
	 Ec7WrZcWMvCtQ==
Date: Mon, 29 Jul 2024 18:08:24 -0700
Subject: [PATCH 10/13] xfs_scrub: reduce size of struct name_entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847681.1348850.5157188790717732185.stgit@frogsfrogsfrogs>
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

libicu doesn't support processing strings longer than 2GB in length, and
we never feed the unicrash code a name longer than about 300 bytes.
Rearrange the structure to reduce the head structure size from 56 bytes
to 44 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 63694c39a..74c0fe1f9 100644
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
@@ -345,6 +347,12 @@ name_entry_create(
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

