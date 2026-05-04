Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5583E3159
	for <linux-xfs@vger.kernel.org>; Mon,  4 May 2026 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777914533; cv=none; b=GAiAlNh7VIxZ2rVJBWHJccKtEN7yoZDqVNspbAa7jvuwuga/WN3eVfXCH6i/3umEX0RWlHQmw2pEQ7/7wN6Z7twjeiFuxYsq6wCbgBq1HHFRPfzyLm6a42une4tCxQ24BXW9m808l08YmSWr2d0dJJ83QdwJfH1vlGRB15YAZD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777914533; c=relaxed/simple;
	bh=Y8zQ10XbPuh/McS1aVtyAWIjVKdJYJz/9gMtKhj440E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZCrJBovQMLFX34+4RHYkkEfnf6DXK10cpmkEQWRS2pJxs0cXzm+WYJ0l+okMVzb8t23Vab37Fy0h7eoylpaQLZ0dxSw0GwfizfWmop1CnbvHe8zEpZeQkoXsBYCtX9dlC3lXuhbYWkEFXOC0FWckQthCmKBChPdRgrIixak30+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYgS22IE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYgS22IE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6239BC2BCB8;
	Mon,  4 May 2026 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777914533;
	bh=Y8zQ10XbPuh/McS1aVtyAWIjVKdJYJz/9gMtKhj440E=;
	h=Date:From:To:Cc:Subject:From;
	b=mYgS22IEuTJX/vKJYRh20UP73m6lmP+4IvG8oPSgdOUjSvGdPKKHlgj8QBg6LnBHN
	 IG6YA4Bmjq444I1dj9DHJKBCVza2ShWUCQv9tJ6dxOBX6iBqDPejdxBAerBNn2uKu6
	 GFdcVFqzB2/Hh83i4mdw/OR2By0dig0tH8s/91YPx1rMk+/gbcqD4lyiyYnMyAOekm
	 PJNwIs6CS5FasLw+PgWSx5/nqYihhnnJkTK8gJ0DMmmM8t0Eg2ZMtghUDB3byRO376
	 2n0RrluzmOK6XnGx3+PR6Wj1OfkJ3X8UlhGvY9Y2yAOO9tETbsTPR2ZkEeWa5Nkvn/
	 kf/0Dui9NRXhg==
Date: Mon, 4 May 2026 10:08:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Gedalya <gedalya@gedalya.net>, Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_scrub: drop the warning about mixed bidirectional
 codepoints in names
Message-ID: <20260504170852.GH7751@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Gedalya complained about receiving warnings about mixed bidirectional
codepoints in a filename:

"First, well-known file name extensions are not internationalized. While
the file name can be in non-latin letters, the extension will be in
latin. Hence you would expect to see file names such as עברית.pdf ."

Gedalya goes on to point out that file names can be created from (say)
the title of an article, which might itself mix RTL and LTR characters.
Both uses are totally fair, but regrettably unfamiliar to 2018-era me.

Unicode TR 36 even weasel-words its own recommendation: "As much as
possible, avoid mixing right-to-left and left-to-right characters in a
single name."  Maybe I should have paid more attention to weasel
wording in specifications. :P

Let's fix this by removing the warning altogether.

Reported-by: gedalya@gedalya.net
Link: https://lore.kernel.org/linux-xfs/8961ee4a-3830-498b-a432-5545695db599@gedalya.net/
Link: https://www.unicode.org/reports/tr36/tr36-15.html#Bidirectional_Text_Spoofing
Cc: <linux-xfs@vger.kernel.org> # v4.16.0
Fixes: baa9ed8dca213f ("xfs_scrub: check name for suspicious characters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/unicrash.c |   29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 75493c5ee795da..87c0a8f0542fbb 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -112,23 +112,20 @@ struct unicrash {
 /* Name contains directional overrides. */
 #define UNICRASH_BIDI_OVERRIDE	((__force badname_t)(1U << 1))
 
-/* Name mixes left-to-right and right-to-left characters. */
-#define UNICRASH_BIDI_MIXED	((__force badname_t)(1U << 2))
-
 /* Control characters in name. */
-#define UNICRASH_CONTROL_CHAR	((__force badname_t)(1U << 3))
+#define UNICRASH_CONTROL_CHAR	((__force badname_t)(1U << 2))
 
 /* Invisible characters.  Only a problem if we have collisions. */
-#define UNICRASH_INVISIBLE	((__force badname_t)(1U << 4))
+#define UNICRASH_INVISIBLE	((__force badname_t)(1U << 3))
 
 /* Multiple names resolve to the same skeleton string. */
-#define UNICRASH_CONFUSABLE	((__force badname_t)(1U << 5))
+#define UNICRASH_CONFUSABLE	((__force badname_t)(1U << 4))
 
 /* Possible phony file extension. */
-#define UNICRASH_PHONY_EXTENSION ((__force badname_t)(1U << 6))
+#define UNICRASH_PHONY_EXTENSION ((__force badname_t)(1U << 5))
 
 /* More than one variation selector in a row. */
-#define UNICRASH_VARIATION_RUN	((__force badname_t)(1U << 7))
+#define UNICRASH_VARIATION_RUN	((__force badname_t)(1U << 6))
 
 /* FULL STOP (aka period), 0x2E */
 #define UCHAR_PERIOD		((UChar32)'.')
@@ -549,9 +546,6 @@ name_entry_examine(
 		was_variation = is_variation;
 	}
 
-	/* mixing left-to-right and right-to-left chars */
-	if (mask == 0x3)
-		ret |= UNICRASH_BIDI_MIXED;
 	return ret;
 }
 
@@ -869,19 +863,6 @@ _("Unicode name \"%s\" in %s contains a weird sequence of variation selectors.")
 	if (!verbose && (uc->is_only_root_writeable || entry->namelen < 4))
 		goto out;
 
-	/*
-	 * It's not considered good practice (says Unicode) to mix LTR
-	 * characters with RTL characters.  The mere presence of different
-	 * bidirectional characters isn't enough to trip up software, so don't
-	 * warn about this too loudly.
-	 */
-	if (badflags & UNICRASH_BIDI_MIXED) {
-		str_info(uc->ctx, descr_render(dsc),
-_("Unicode name \"%s\" in %s mixes bidirectional characters."),
-				bad1, what);
-		goto out;
-	}
-
 	/*
 	 * We'll note if two names could be confusable with each other, but
 	 * whether or not the user will actually confuse them is dependent
