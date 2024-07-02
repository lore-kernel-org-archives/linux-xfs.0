Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A394EDE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881891; cv=none; b=bq34WnVyarK0kAMNUGmWtDkC17eF8ditUANBcbb1K86JqZFOCFKzJrA3bMHESd8yVJWoCB6OKJ+Np5JEOsN+3ql3fZfbI3KIxKMrBHE/0+OWMR5J6hC6bixhHme3gQsSWMsYppvxP3eRQ9m9FOt/+TIVjApaBYlaCJblvvKgaZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881891; c=relaxed/simple;
	bh=4NwdOswh07YgllYHLzuIZrf3PhCGZtVSU1jvFqbMPnQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=anjZOrscQT1iZx7OtsC9R3CN1ffAdhBk8em76o3aA9wBI7ia9TfcdSTTK8nlXN5NPNhWu4M+8pOHWakBbIB5PmUNBpPdd0SU+KudhFtZVnKGqxNzsa3jDzb8/iBiwdJAHMWqrxKi/MsV0FTXgtX6CXjagZQnBfgmF+JvVItp0/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tcbeu4uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tcbeu4uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD98DC116B1;
	Tue,  2 Jul 2024 00:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881890;
	bh=4NwdOswh07YgllYHLzuIZrf3PhCGZtVSU1jvFqbMPnQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tcbeu4uhlPW4ggZL+Pm1b5qBaEk+7XLuDpuVQXS8CXmbX9wfVqYa/GHdz8ZhelAd6
	 a2NXf/TJZ7qGOHlwsHhxOIaR3DQrqlj2rsKMpFihZlz3i8e0P3D4K6sm5QSaUC2opy
	 dXFaHctZrJGT7IA85yzgsyFDnR95hgdW0Htoz0QGN8zwQfGriiccf6vfYWiLEgnSAa
	 26LRuda7Pbjo2HbOyBT4m0tAnWLgn6sf02KLvQJlcFuqEmhDwl1lNULzUxoNzp63ua
	 Ts4AMOJrWr7EfcuvnDDt0Hcfx9+SCVHhNXtOdYIJ1aCfSXkk1/WhhEukzftFXEW2eQ
	 +xIloBtfnOqXA==
Date: Mon, 01 Jul 2024 17:58:10 -0700
Subject: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible code
 points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs>
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

I missed a few non-rendering code points in the "zero width"
classification code.  Add them now, and sort the list.

$ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
$ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 96e20114c484..fc1adb2caab7 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -351,15 +351,17 @@ name_entry_examine(
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 		/* zero width character sequences */
 		switch (uchr) {
+		case 0x034F:	/* combining grapheme joiner */
 		case 0x200B:	/* zero width space */
 		case 0x200C:	/* zero width non-joiner */
 		case 0x200D:	/* zero width joiner */
-		case 0xFEFF:	/* zero width non breaking space */
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

