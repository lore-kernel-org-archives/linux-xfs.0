Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48786C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRR9cK84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B614FC433C7;
	Sun, 31 Dec 2023 22:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062718;
	bh=fb1UYze0fme7Vv9CRHV8+OCAhrXFFaKmAPPzSeyqGSc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eRR9cK84jn5N35iC6Z6NUueHJc8m2SeBfZSSlWEhKl3ck/mLNJNE3ZV3uN1NLoT18
	 bc4zpSeTg8HxXdGJQjEqrW+Js/Hj7EYJ9djoDM6JcCMn4m0Yk9znuPnHjdjtrzqH0v
	 MY1W002S/M0r9yn4+NjwnB4j/h9vgftA/GZNoyZSS0gpuTKhjRoouAoXJzHTDfM4Ie
	 bMRkSbIj3q3N/Az2pU6VVAKn9Ogx5xi2M0xzwAQO2al7Fq0iXNtuaEQAEOvw5sJ9LH
	 tCnLN/qXsE4H5vPfOnRPhopI3ZhEC+DUdQGRJqOBxYnuafsUXAWFWILFV9kMk7uQhM
	 Ykstn38fZmUlw==
Date: Sun, 31 Dec 2023 14:45:18 -0800
Subject: [PATCH 01/13] xfs_scrub: use proper UChar string iterators
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000597.1798385.6742191957151102671.stgit@frogsfrogsfrogs>
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

For code that wants to examine a UChar string, use libicu's string
iterators to walk UChar strings, instead of the open-coded U16_NEXT*
macros that perform no typechecking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index dd30164354e..02a1b94efb4 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -330,13 +330,12 @@ name_entry_examine(
 	struct name_entry	*entry,
 	unsigned int		*badflags)
 {
+	UCharIterator		uiter;
 	UChar32			uchr;
-	int32_t			i;
 	uint8_t			mask = 0;
 
-	for (i = 0; i < entry->normstrlen;) {
-		U16_NEXT_UNSAFE(entry->normstr, i, uchr);
-
+	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
+	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 		/* zero width character sequences */
 		switch (uchr) {
 		case 0x200B:	/* zero width space */

