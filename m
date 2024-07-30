Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3F18BF0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301673; cv=none; b=svM8kWj4KVlrPCRtFsgCAnLPEaanc4cZ171yiAenCPNgnGtc+wKJiWB2a4HAffFDQKs9I1Kba3wxC2b3dlkb0C8FcvqLOmA+8AK1nkJOXbMIrVG9Naj7VKaI6lFhYIbT1KoVfF+S3b7VMnoZ+lOskWrFQ99R0/5xmkSNqTUryIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301673; c=relaxed/simple;
	bh=BYsCQ2kUyIy6LU2tU4ROVz/qsex4Kp3i7vMDKYyzdmk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ioCpXTX7Roy06zOmHsK+JuhRLu7w2z3M/NhTk12+pUIx4xWAe/s2SnyvbKUSJKqyJbWJwuBBOdV3zs81XtH1VaQpOaBPTSqLS3ViWmzNl/JTQJXnaDtcuuxJaTm9+WHSDSAbazROTcw8ROSfXP2lLYHvu758edjj7i4CC7tRpyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjzLn3iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjzLn3iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62923C32786;
	Tue, 30 Jul 2024 01:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301673;
	bh=BYsCQ2kUyIy6LU2tU4ROVz/qsex4Kp3i7vMDKYyzdmk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MjzLn3iw8wNVE+xIYEBfIKuBB+Uv8gcDs8b4uYQWyfgBu22brNPcIzD+ThKlgNDpN
	 NSHwHUQGe0CZqFfIwmihhPD0TbjV94/9RpGiQklKo0UovCEpvCBsEuePHDE2FFXK/z
	 dlkhyqlHtc6uta3areUa5Y6IbM2SIQOjoTrqk9mP4YIrkelPOt9eZdby+8OQtrnH6d
	 wHfb82A1hQjPZSx2ofuFJeBHYuo2OpCM/fk4z3wpghh9f8ovDvJNruqt/YubfOgB8y
	 taegUju47XSNAz9TUNIqeg8SgT0+DlynfWJ2yutt6bvDTrZK9x/KFtub3FXf2jFDWq
	 qkXElpIYfyRmw==
Date: Mon, 29 Jul 2024 18:07:52 -0700
Subject: [PATCH 08/13] xfs_scrub: rename UNICRASH_ZERO_WIDTH to
 UNICRASH_INVISIBLE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847652.1348850.6582462888057187832.stgit@frogsfrogsfrogs>
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

"Zero width" doesn't fully describe what the flag represents -- it gets
set for any codepoint that doesn't render.  Rename it accordingly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index e98f850ab..5447d94f0 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -109,7 +109,7 @@ struct unicrash {
 #define UNICRASH_CONTROL_CHAR	(1 << 3)
 
 /* Invisible characters.  Only a problem if we have collisions. */
-#define UNICRASH_ZERO_WIDTH	(1 << 4)
+#define UNICRASH_INVISIBLE	(1 << 4)
 
 /* Multiple names resolve to the same skeleton string. */
 #define UNICRASH_CONFUSABLE	(1 << 5)
@@ -298,7 +298,7 @@ name_entry_examine(
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 		/* characters are invisible */
 		if (is_nonrendering(uchr))
-			ret |= UNICRASH_ZERO_WIDTH;
+			ret |= UNICRASH_INVISIBLE;
 
 		/* control characters */
 		if (u_iscntrl(uchr))
@@ -582,7 +582,7 @@ _("Unicode name \"%s\" in %s renders identically to \"%s\"."),
 	 * confused with another name as a result, we should complain.
 	 * "moo<zerowidthspace>cow" and "moocow" are misleading.
 	 */
-	if ((badflags & UNICRASH_ZERO_WIDTH) &&
+	if ((badflags & UNICRASH_INVISIBLE) &&
 	    (badflags & UNICRASH_CONFUSABLE)) {
 		str_warn(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s could be confused with '%s' due to invisible characters."),

