Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D1A433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992438; cv=none; b=gs4p5wpATB1I9hzqEaMKlpcp9lofvL1wPsGFsWgwnaJU4yLtff7KzrYnaRk/Mw31qwwoJaVWUo4Ow8lmp0opItEzWsiyjOuh/hY1mat4R6nQRX4ejZ0tp8nc53UqoFHHchdtoAlPJyQE66ULA9P2P8h/KSNPl+ieyrsTJgzL7sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992438; c=relaxed/simple;
	bh=NHpDpZefwgkYlA5jt1RQ/FzL+4B3VHnORiYMfHqlOPI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ed+NSpBA0LPXAcFHfAbZ6AkTc8atNgHAC19XNC+zoin7NbdoD7/AN64aCOyuGLcRt06rtWqYN9DKeSgtDVlLJL5Cjtl3SQdScscZ56Ykis+FHB9GnuNfLkB+zmh8stGZ7BazcyMzMoJ6v2dMMkj6nM/AtuKe4qpWwS+njJ6gyNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lF6LJ3Cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lF6LJ3Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AB1C4CED7;
	Mon, 23 Dec 2024 22:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992438;
	bh=NHpDpZefwgkYlA5jt1RQ/FzL+4B3VHnORiYMfHqlOPI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lF6LJ3Cd685iP53gUytV0h7t2twyxlFham4r7g8W9cFYBuLnkQBC6jEkYnRWmme3d
	 GRA6aFjF92PicASvj+tEANwwFJsqFqlStkh88tIF2fxwLOFSRKjD+n6hzVL0agkEOa
	 gZuXKDFRqMmgm7ZMZd02jAsp4sQs/ysjJ8tpEC8O/15E+NJDHey4XQ7iLqjyO6YiYW
	 jJJvd2bYyVP2YL/VSbZuRH5bfZ9QnbRDb47JkORPGVcI53MsOKDIwHPhkDcjiQB5nd
	 yqQe7dwuVj1TbjV8awWDxSNbfCEm6P4V0QEOzx89TOv+4X9ssOpAjl5r+72lWlzjjI
	 WIf/tkDscT/lQ==
Date: Mon, 23 Dec 2024 14:20:37 -0800
Subject: [PATCH 34/51] xfs_db: report rt group and block number in the bmap
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944324.2297565.11397286166087986499.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/bmap.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 7 deletions(-)


diff --git a/db/bmap.c b/db/bmap.c
index 7915772aaee4e0..1c5694c3f7d281 100644
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
+		gno = xfs_fsb_to_gno(mp, be->startblock, XG_TYPE_RTG);
+		gbno = xfs_fsb_to_gbno(mp, be->startblock, XG_TYPE_RTG);
+	} else {
+		gno = xfs_fsb_to_gno(mp, be->startblock, XG_TYPE_AG);
+		gbno = xfs_fsb_to_gbno(mp, be->startblock, XG_TYPE_AG);
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

