Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90586C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JV4+1z91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206EFC433C7;
	Sun, 31 Dec 2023 22:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062828;
	bh=5rVIguoPptjbu6cX1sdNLQ/mp2eNJQxZnYLoZQ2TzkI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JV4+1z91gK2d59Eo7BavhWJzxZcCZ/tcvyRvpcW4t+1XOI+Zlanhs71Z/p/Mgrffm
	 I5e+iCyDp8CmPXCCBQKrWCoyiGU7Cr5t7Z+guecAJVyOXQZCOrxk+ZM4xiLeU9WV/c
	 avwV0cIfQ8zzg4PH6Pt0TLAB1VyhfDYr9sPXVYLgS7oMkJUTYUSKNLaHTpFVMO5S5g
	 vZs6WBQTaloOeXnBB1YhZhrbz5+PI1iCSKhaU5oma+toGH2faa0kWv3DTASEJxEPO5
	 WcwM0N69iuLw7G6NjZSTSQi2RSOGZrTsaNXmEBcrh4nnMNpfY3rODIHaYU8pf6s5SB
	 aiBcl+0E/RdLg==
Date: Sun, 31 Dec 2023 14:47:07 -0800
Subject: [PATCH 08/13] xfs_scrub: rename UNICRASH_ZERO_WIDTH to
 UNICRASH_INVISIBLE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000689.1798385.7914718125300719180.stgit@frogsfrogsfrogs>
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

"Zero width" doesn't fully describe what the flag represents -- it gets
set for any codepoint that doesn't render.  Rename it accordingly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index a770d0d7aae..b2baa47ad6c 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -109,7 +109,7 @@ struct unicrash {
 #define UNICRASH_CONTROL_CHAR	(1 << 3)
 
 /* Invisible characters.  Only a problem if we have collisions. */
-#define UNICRASH_ZERO_WIDTH	(1 << 4)
+#define UNICRASH_INVISIBLE	(1 << 4)
 
 /* Multiple names resolve to the same skeleton string. */
 #define UNICRASH_CONFUSABLE	(1 << 5)
@@ -296,7 +296,7 @@ name_entry_examine(
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 	/* characters are invisible */
 		if (is_nonrendering(uchr))
-			ret |= UNICRASH_ZERO_WIDTH;
+			ret |= UNICRASH_INVISIBLE;
 
 		/* control characters */
 		if (u_iscntrl(uchr))
@@ -580,7 +580,7 @@ _("Unicode name \"%s\" in %s renders identically to \"%s\"."),
 	 * confused with another name as a result, we should complain.
 	 * "moo<zerowidthspace>cow" and "moocow" are misleading.
 	 */
-	if ((badflags & UNICRASH_ZERO_WIDTH) &&
+	if ((badflags & UNICRASH_INVISIBLE) &&
 	    (badflags & UNICRASH_CONFUSABLE)) {
 		str_warn(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s could be confused with '%s' due to invisible characters."),

