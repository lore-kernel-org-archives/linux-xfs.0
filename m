Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234837462
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881969; cv=none; b=HzPGQxpAS5CryavLGKlfNOBx5TjUbv6wpni/C9K+sdGk0xz6PyM4m7xwsXp6otOnfHIn+176jWazUAULvSQn4zHDtzYuvgtbZehnREZ1cuthM29kqBtanrDZby6pooEZZs/yMqBUYCxHEAdFA23sBdjgPr49ey+sKLFokyjLN9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881969; c=relaxed/simple;
	bh=hkh3NKr8wsVVv9geAdW9TiwPJmH6dJl+JeUZVCf7ahg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rGnJGcXDJSBmKS21El3wvg18ERLyomtiAX0CZwMhnx6i/CxcC2Ch+wlE6SDUHl0VURMee0Tr0mYa8uGInK7VwxtsyexzAkayVzMVJ4bbfS1m/7e8xcbeMN7dxTCahaxV0U5fnSak3SkITMrv/YDHkge5qK6U7yWSobMAKmaGgjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4mL5Rs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4mL5Rs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DB9C116B1;
	Tue,  2 Jul 2024 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881969;
	bh=hkh3NKr8wsVVv9geAdW9TiwPJmH6dJl+JeUZVCf7ahg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y4mL5Rs60SnRWUoAQ/KaVbtdRxjX55pIXVhGJ/dweOoPGkoFMpWcR0NhqWuwPYJV1
	 czMWIZn0GcoeGaujNkkdgWNkVKEpsQ9Ghhb8l34axkg2UVHQa5WJ4WFj8h++QofheP
	 mk6KfbhUcvfiuFG7I4OqNtrk9WoB+YXMC4a944iUDtmSxyXOAG1gkjmF4c9hAeCqAT
	 dDuY6dgiJI95CvPLUdVCMhFpycN1BvSi+W2VQaF958BaEmopPHiZ5USnRwf9CmnxQI
	 cUbl/iZdj0JrFCrU0JVX1yIZ/pghVLqS33OFAyqVPR+KJ5i7lm0dQVwWf/SMHRomRG
	 S0PGKlZRr2SCA==
Date: Mon, 01 Jul 2024 17:59:28 -0700
Subject: [PATCH 08/13] xfs_scrub: rename UNICRASH_ZERO_WIDTH to
 UNICRASH_INVISIBLE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117732.2007123.5575573821176131888.stgit@frogsfrogsfrogs>
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

"Zero width" doesn't fully describe what the flag represents -- it gets
set for any codepoint that doesn't render.  Rename it accordingly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index a770d0d7aae4..b2baa47ad6ca 100644
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

