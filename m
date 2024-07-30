Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201B24C97
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301595; cv=none; b=VynRd14IQn4GehOlajXiBSN08rGWLR6rp1+ivcVizLwqQCILx/ccbVE+OTg6EybbbQyqYQpauXs4Fn02P4DgRwM+3cOl0wmDIwuapg9kxcz/zLCI+O4C5LN2qQK4mDFHpe/HFBh3cefwKU/3ZosTHc5MFqKPE8v0QmS82BSFOaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301595; c=relaxed/simple;
	bh=clb0cWF+E7Yy91hZ2f4Ob0arAKmdCLfWGVgIDpqRJtI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5ufy4RvxITaljvId8STYQ9mRm6Ct82QqjQsJxEyIos2GtA5m1N+WXbm42Dd3Zi9XfPHjfmRZbx3jerzJVa+X8/3BIjDW4SS3WxwwrlSGBXpTZZgCEJJBiH3A+YNqcCXm68GB6Uh3BNJeIf3Dg5x52ggn70D+oUUXGO2pT+TDT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M71CI13C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M71CI13C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19ABC32786;
	Tue, 30 Jul 2024 01:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301595;
	bh=clb0cWF+E7Yy91hZ2f4Ob0arAKmdCLfWGVgIDpqRJtI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M71CI13CGZjSj49SCGnBs1FLmOu4JP/lyODgkXj5v00PAW8TD7BFRq5rYG6mi3Ywm
	 Fd0NqWHiQJdDuB5ZZ30iAbt0h0Zme3kmj4A39Jlefgj7+ri9GreTb5USWRaZ9c7Gdf
	 0tDOXUAVdUwNJL5+AMElEp1t03EFvsW8nZrOMcdtTh+yYb0fHzO7xip0Band8dmFjM
	 K5uhDZtS6bGWi2/6U7AI342UMlhSeITGXkXB14wF/9PBLuJDd0n9+m15dKHQmU9sKA
	 hk9pm2AE68aIXrpW+x9QfElCZfzXlX0ZfbP5XpauQFkX2VSUVLeoRTjRoqg6IlGwsn
	 /CsuZtOEFoKmw==
Date: Mon, 29 Jul 2024 18:06:34 -0700
Subject: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible code
 points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847576.1348850.17804705325546372553.stgit@frogsfrogsfrogs>
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

I missed a few non-rendering code points in the "zero width"
classification code.  Add them now, and sort the list.  Finding them is
an annoyingly manual process because there are various code points that
are not supposed to affect the rendering of a string of text but are not
explicitly named as such.  There are other code points that, when
surrounded by code points from the same chart, actually /do/ affect the
rendering.

IOWs, the only way to figure this out is to grep the likely code points
and then go figure out how each of them render by reading the Unicode
spec or trying it.

$ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
$ grep -E '(separator|zero width|invisible|joiner|application)' -i UnicodeData.txt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 96e20114c..edc32d55c 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -351,15 +351,19 @@ name_entry_examine(
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 		/* zero width character sequences */
 		switch (uchr) {
+		case 0x034F:	/* combining grapheme joiner */
 		case 0x200B:	/* zero width space */
 		case 0x200C:	/* zero width non-joiner */
 		case 0x200D:	/* zero width joiner */
-		case 0xFEFF:	/* zero width non breaking space */
+		case 0x2028:	/* line separator */
+		case 0x2029:	/* paragraph separator */
 		case 0x2060:	/* word joiner */
 		case 0x2061:	/* function application */
 		case 0x2062:	/* invisible times (multiply) */
 		case 0x2063:	/* invisible separator (comma) */
 		case 0x2064:	/* invisible plus (addition) */
+		case 0x2D7F:	/* tifinagh consonant joiner */
+		case 0xFEFF:	/* zero width non breaking space */
 			*badflags |= UNICRASH_ZERO_WIDTH;
 			break;
 		}

