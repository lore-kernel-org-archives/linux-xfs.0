Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DF35256
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610312; cv=none; b=c4YY9GIbsILrFXNCwZlersmxg9lz/CZgski87xmv0ds4Om9TpS254R9vhSHWpi5cv2rQ4/0kgslx11fXTVzbca4ALgTb30hdaP2eTpyEWng9yXRw0Fb5oYux6pBQdDmA7d9E397ftLbTINR/JajVnS8ElQNu5ytaWBh3bNGUxuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610312; c=relaxed/simple;
	bh=8ixkrp/6F5ZJDjj68+J6gmAOKI5Ruah2E6dOKk6n1qc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpJSqqI/jK3f7O55lhI1Tf16xIRBBikdki4pStYTRPzZJkBYr3LcHf07VClrVInk5CZRakAG4CVkqgdp5th0kN9uGEswIiRnH8folS+u5BWWnkIO8yVtKgjoN07BM93Hs29ktnliJ+pGUUN0+1VZunnltBMj8WjAyc8DO/jrLg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDshzWh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDshzWh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD78C4CEC5;
	Fri, 11 Oct 2024 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610312;
	bh=8ixkrp/6F5ZJDjj68+J6gmAOKI5Ruah2E6dOKk6n1qc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oDshzWh1dBXcPAIYRJtnPcZNiIJS7iuarXPEzyY1V0R/t5NbM/HQMY4gCJXwD/MFC
	 9IORmb9xkmnjZ2Tlr5BNMM73ToTs+b1zxwkfo/zdFIkZnK+SYl+p0H5TeoMiike4DV
	 +g4xZm+oGg4UdjPqQatZLdVlDRrGXCtCy8WC6bhQm/5VG1cigPsHX7U5TWFS3dzVIJ
	 tg/x70GEo0xva2PJCuW0s/xHkWGGRh+j0f1cHVedWL36fWGsywnYRlLhyJ+B6x1qLY
	 +QchYgCZawDWuckmZVQS2PdbPPX0jn6LB0wYK/uN1VIXrPPuxEN2o+sfyuYYZCpETD
	 himv1UZW8Ueww==
Date: Thu, 10 Oct 2024 18:31:51 -0700
Subject: [PATCH 28/43] xfs_db: report rt group and block number in the bmap
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655795.4184637.15998479425263296927.stgit@frogsfrogsfrogs>
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

The bmap command does not report startblocks for realtime files
correctly.  If rtgroups are enabled, we need to use the appropriate
functions to crack the startblock into rtgroup and block numbers; if
not, then we need to report a linear address and not try to report a
group number.

Fix both of these issues.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bmap.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 7 deletions(-)


diff --git a/db/bmap.c b/db/bmap.c
index 7915772aaee4e0..d63aa9ef9c015b 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -119,6 +119,41 @@ bmap(
 	*nexp = n;
 }
 
+static void
+print_group_bmbt(
+	bool			isrt,
+	int			whichfork,
+	const struct bmap_ext	*be)
+{
+	unsigned int		gno;
+	unsigned long long	gbno;
+
+	if (whichfork == XFS_DATA_FORK && isrt) {
+		gno = xfs_rtb_to_rgno(mp, be->startblock);
+		gbno = xfs_rtb_to_rgbno(mp, be->startblock);
+	} else {
+		gno = XFS_FSB_TO_AGNO(mp, be->startblock);
+		gbno = XFS_FSB_TO_AGBNO(mp, be->startblock);
+	}
+
+	dbprintf(
+ _("%s offset %lld startblock %llu (%u/%llu) count %llu flag %u\n"),
+			whichfork == XFS_DATA_FORK ? _("data") : _("attr"),
+			be->startoff, be->startblock,
+			gno, gbno,
+			be->blockcount, be->flag);
+}
+
+static void
+print_linear_bmbt(
+	const struct bmap_ext	*be)
+{
+	dbprintf(_("%s offset %lld startblock %llu count %llu flag %u\n"),
+			_("data"),
+			be->startoff, be->startblock,
+			be->blockcount, be->flag);
+}
+
 static int
 bmap_f(
 	int			argc,
@@ -135,6 +170,7 @@ bmap_f(
 	xfs_extnum_t		nex;
 	char			*p;
 	int			whichfork;
+	bool			isrt;
 
 	if (iocur_top->ino == NULLFSINO) {
 		dbprintf(_("no current inode\n"));
@@ -154,6 +190,10 @@ bmap_f(
 			return 0;
 		}
 	}
+
+	dip = iocur_top->data;
+	isrt = (dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME));
+
 	if (afork + dfork == 0) {
 		push_cur();
 		set_cur_inode(iocur_top->ino);
@@ -198,13 +238,15 @@ bmap_f(
 			bmap(co, eo - co + 1, whichfork, &nex, &be);
 			if (nex == 0)
 				break;
-			dbprintf(_("%s offset %lld startblock %llu (%u/%u) count "
-				 "%llu flag %u\n"),
-				whichfork == XFS_DATA_FORK ? _("data") : _("attr"),
-				be.startoff, be.startblock,
-				XFS_FSB_TO_AGNO(mp, be.startblock),
-				XFS_FSB_TO_AGBNO(mp, be.startblock),
-				be.blockcount, be.flag);
+
+			if (whichfork == XFS_DATA_FORK && isrt) {
+				if (xfs_has_rtgroups(mp))
+					print_group_bmbt(isrt, whichfork, &be);
+				else
+					print_linear_bmbt(&be);
+			} else {
+				print_group_bmbt(isrt, whichfork, &be);
+			}
 			co = be.startoff + be.blockcount;
 		}
 		co = cosave;

