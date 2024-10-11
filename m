Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6FB8BE8
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610406; cv=none; b=B7Qc3ccPgaVQe/LGNdUkP/66gr9yNeE18VOxma83GKchM5Bz/kCLvXJtOJl1CyJjDrHxI8fBjMvNa0Xerkz6T3R28TZo4D/27MebPhdatC/lu9eycRfYGBAYuJNw8/1LZHHzsKMjXyOada4LHqmun/dP+z8n41I/gG1mz0qwK6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610406; c=relaxed/simple;
	bh=AwsB+9bbgwkc2OLhxcri3q0mECFeFvK9DhcXiZb0uKk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKgWfF4YWvxGrodRBPHT1+npsHWiTTykiOTM2q83GNvhZCBjQ+/co2Xu36q9xgGtKNXJzvyIMAnwt3EJZ9HvTDvMTRdy7rIlAizZxiVQFNd3VVYXFgqIiRn8QtS9FaWY0GwXtwH/08+A5lA2SuhVQSoNs//Do3n8+6nTIPzoJ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r54PJrA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r54PJrA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35DCC4CEC5;
	Fri, 11 Oct 2024 01:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610405;
	bh=AwsB+9bbgwkc2OLhxcri3q0mECFeFvK9DhcXiZb0uKk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r54PJrA6Pm1Tdn7NivSrEfy4A7ogb64XCX4dybi2sXOn/Fni29M1/5ah9hrPZnylr
	 E7lQbGv2rvUQ9U2hyk56AfpJ4SW8+8NIGgifVvSUK/x/hB8HVTg7tF6AKjgslU1EWT
	 gmYY+LZnhQ2KeH2ux91HPJLCMv+/ijo6F2OuIf9NrXYXOAGHhtCqEZSMmg5MIEWBBs
	 Y3J5cLJuumIZhzrEiPjpyQZZowv3bQbYWYb2BSFoHde9lZ51j95rc31LDz6WrKSoNn
	 kKxldRmXunAGdeya/W1A9FtiEzY88ZgYdGFBNrNuuvJNbzKUmMMlLMgYNzy1P9PAwp
	 LPF853p/klmOg==
Date: Thu, 10 Oct 2024 18:33:25 -0700
Subject: [PATCH 34/43] xfs_io: display rt group in verbose bmap output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655887.4184637.8211766445762954492.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Display the rt group number in the bmap -v output, just like we do for
regular data files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

