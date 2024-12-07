Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD66139E
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530540; cv=none; b=J17xjSDpbGJNzcPibhVb4HUtjRih2CpQHvcgRFueCPhI+LWbIxj+kx1GR+Q0gvblGlMc2wvpA2Ibb7yvfWckqbvLpXxBaMA97oyXrP7WBW8y6POiV8t/g4tnfGYxF0HwwJtbf3dIeC+tO2K/GQnE1BPIXEH3QzfnC/QYs4s/QRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530540; c=relaxed/simple;
	bh=xLZS5RfCx57ncrOTCJQPFMeVwKvfpth46i9B1IOJE50=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M/rMy16OXF2rUxhyhSQmC7qhRcPXNHPXKUw/T5SaBs0a5lrnXG81aXNhYgbv16MLs/5XxRE0e2coyB3juGpSs0fqia/rmyOKAxfF/jXvz6Vvg6hvHAIZ3m/HyobHbT62B7/NrVRD06LAF5MDq2xWCiPoJ27fgTvIaZp2zGpaM3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZZEuux/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZZEuux/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD21C4CED1;
	Sat,  7 Dec 2024 00:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530539;
	bh=xLZS5RfCx57ncrOTCJQPFMeVwKvfpth46i9B1IOJE50=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lZZEuux/Qf+TukFXDS1SAfb4Mw4WPcCkSTuaHQwwzQdXOpyIIR/6fXXuKnJEA1ZEN
	 v/qB89poNYhvoF+GxaBhBvQI2zJnXLS//g/p1z/57Vg1u3hdteyRZayqw4rF2bSt3p
	 OQl65V/aii5SBZVEa87hBPgZOJ6dY5tCTEWMI5ANGPNebnk7/Z2LTGYGY0QJRLGuLN
	 3W3hMFJy+rZLCG5OkCTUvVBRIFrtTXbt29ZnqDkZ8NP4IbZHPcv++yFZSJ4xerqpxE
	 uc8Fqc0PmAw2fzdcbmvw7XXLHVoJPxgJPr6LDgp13fOLkfVqGcyLLt5UN2Xl1Gvypa
	 ZHPNDqzBIT9jg==
Date: Fri, 06 Dec 2024 16:15:39 -0800
Subject: [PATCH 41/50] xfs_io: display rt group in verbose bmap output
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752571.126362.12918164461473948684.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Display the rt group number in the bmap -v output, just like we do for
regular data files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/bmap.c        |   27 ++++++++++++++++++---------
 libfrog/fsgeom.h |   12 ++++++++++++
 2 files changed, 30 insertions(+), 9 deletions(-)


diff --git a/io/bmap.c b/io/bmap.c
index 6182e1c591da18..b2f6b490528513 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -257,16 +257,18 @@ bmap_f(
 #define	FLG_BSW		0000010	/* Not on begin of stripe width */
 #define	FLG_ESW		0000001	/* Not on end   of stripe width */
 		int	agno;
-		off_t agoff, bbperag;
+		off_t	agoff, bbperag;
 		int	foff_w, boff_w, aoff_w, tot_w, agno_w;
 		char	rbuf[32], bbuf[32], abuf[32];
 		int	sunit, swidth;
 
 		foff_w = boff_w = aoff_w = MINRANGE_WIDTH;
 		tot_w = MINTOT_WIDTH;
-		if (is_rt)
-			sunit = swidth = bbperag = 0;
-		else {
+		if (is_rt) {
+			bbperag = bytes_per_rtgroup(&fsgeo) / BBSIZE;
+			sunit = 0;
+			swidth = 0;
+		} else {
 			bbperag = (off_t)fsgeo.agblocks *
 				  (off_t)fsgeo.blocksize / BBSIZE;
 			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
@@ -295,7 +297,7 @@ bmap_f(
 					(long long)(map[i + 1].bmv_block +
 						map[i + 1].bmv_length - 1LL));
 				boff_w = max(boff_w, strlen(bbuf));
-				if (!is_rt) {
+				if (bbperag > 0) {
 					agno = map[i + 1].bmv_block / bbperag;
 					agoff = map[i + 1].bmv_block -
 							(agno * bbperag);
@@ -312,13 +314,20 @@ bmap_f(
 					numlen(map[i+1].bmv_length, 10));
 			}
 		}
-		agno_w = is_rt ? 0 : max(MINAG_WIDTH, numlen(fsgeo.agcount, 10));
+		if (is_rt) {
+			if (fsgeo.rgcount > 0)
+				agno_w = max(MINAG_WIDTH, numlen(fsgeo.rgcount, 10));
+			else
+				agno_w = 0;
+		} else {
+			agno_w = max(MINAG_WIDTH, numlen(fsgeo.agcount, 10));
+		}
 		printf("%4s: %-*s %-*s %*s %-*s %*s%s\n",
 			_("EXT"),
 			foff_w, _("FILE-OFFSET"),
 			boff_w, is_rt ? _("RT-BLOCK-RANGE") : _("BLOCK-RANGE"),
-			agno_w, is_rt ? "" : _("AG"),
-			aoff_w, is_rt ? "" : _("AG-OFFSET"),
+			agno_w, is_rt ? (fsgeo.rgcount ? _("RG") : "") : _("AG"),
+			aoff_w, is_rt ? (fsgeo.rgcount ? _("RG-OFFSET") : "") : _("AG-OFFSET"),
 			tot_w, _("TOTAL"),
 			flg ? _(" FLAGS") : "");
 		for (i = 0; i < egcnt; i++) {
@@ -377,7 +386,7 @@ bmap_f(
 						map[i + 1].bmv_length - 1LL));
 				printf("%4d: %-*s %-*s", i, foff_w, rbuf,
 					boff_w, bbuf);
-				if (!is_rt) {
+				if (bbperag > 0) {
 					agno = map[i + 1].bmv_block / bbperag;
 					agoff = map[i + 1].bmv_block -
 							(agno * bbperag);
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index c571ddbcfb9b70..b851b9bbf36a58 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -205,4 +205,16 @@ cvt_b_to_agbno(
 	return cvt_daddr_to_agbno(xfd, cvt_btobbt(byteno));
 }
 
+/* Return the number of bytes in an rtgroup. */
+static inline uint64_t
+bytes_per_rtgroup(
+	const struct xfs_fsop_geom	*fsgeo)
+{
+	if (!fsgeo->rgcount)
+		return 0;
+
+	return (uint64_t)fsgeo->rgextents * fsgeo->rtextsize *
+		fsgeo->blocksize;
+}
+
 #endif /* __LIBFROG_FSGEOM_H__ */

