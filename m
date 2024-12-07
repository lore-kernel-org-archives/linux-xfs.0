Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBC728E8
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530446; cv=none; b=EzxFGzkcNHg5vCQNztIUgm/Dc9zl3i1xqKoW6Y91XeRy0Q9pUCCbnauuDpUVC+mI1yFjzkr4KvvTS25mk6iSby0YJKKWfQUaAbhaP5Ok0VmRPDYj/fIWteXWON+CN0IDzpvPQZgbelQJT8h9PsOEZsAbj/HXu3pdtLlErRKGUMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530446; c=relaxed/simple;
	bh=h0Mj3+CMNgmOPhk0kg+OAmzU5sQQThPVoA5OyIJnn0o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ReqlOABYX1fJDFCRySGHFwUsDnSB9ZQQMHU3nKJG0DZam/udksASTaXaGfF9edkr7tWplXrxFApW7RGfhUiBF2Td4wqL5GgGqdEXFIAfgqUpe1oBz2aCY4E+YRAIDQZ048gr7fE6OH6mtDAh/Ag96S0pErC8kiqTRT/4NUOK2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/lM0vr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/lM0vr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD292C4CED1;
	Sat,  7 Dec 2024 00:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530445;
	bh=h0Mj3+CMNgmOPhk0kg+OAmzU5sQQThPVoA5OyIJnn0o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W/lM0vr3m2ZVC7aUPqzMbF49MewgxIIkHfe6SWJlXpu+Ui6hysRdFp2QYBAPJtXt8
	 PiwJzskNGzXahoV1uT75ChZH6vntq3QPvaBnn/joL3q3UvZOWzJtB8Wtka2o88m+64
	 /LPdUPrCkN/cH5o1u7LSP/12o4e/k55icPTu4/biRLNRxiZrpLCEkg/nzOS8J4aOb+
	 +iCietvsE/zIuPv1vwv2GDm5xpHm+eG2FAB+ekJ9nwugJhhIzwLgIJR2aMR77txk1M
	 CqyeVH+9gsb2v+7MI/SrvrBACAX5PrOfxI6tsGIT3ECOMUCm+82BnxAsFeS+JEIQVr
	 K7V6YPamIOYXA==
Date: Fri, 06 Dec 2024 16:14:05 -0800
Subject: [PATCH 35/50] xfs_db: report rt group and block number in the bmap
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752480.126362.14408954135415554700.stgit@frogsfrogsfrogs>
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

The bmap command does not report startblocks for realtime files
correctly.  If rtgroups are enabled, we need to use the appropriate
functions to crack the startblock into rtgroup and block numbers; if
not, then we need to report a linear address and not try to report a
group number.

Fix both of these issues.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

