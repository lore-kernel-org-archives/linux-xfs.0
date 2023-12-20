Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02694776B
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4sBn6mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61636C433C8;
	Wed, 20 Dec 2023 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092364;
	bh=eN91+4MAgFuMmqb76P1Fwg3iVtpbmfK+GS7guuHN/Yo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u4sBn6mJ/B8oMUocBmIQQDEZZ+BYHbsuS+FNyVafIAPSg7EC7h1Xqy88q2zQX91b1
	 wLexndA8YMaIsI+cmV6OPHmMHuHPWG5ToYu/lJ4FRDG4zirRayrg3INmzsE6fnmPVl
	 7VYa0+1Zz5KbkAtHi+Nj1RLlMAZaI6xEuLbAJD0Eud6as+mobm5RRmhB4/gEcJcxrM
	 YmgHggVwA1VOoGHg2k+w4CothXMMSAk516hHx0+5N9v1oPSH9nlRJ8TNfDttiXxPYs
	 oQ9tv4rB7CMniD2MHbZq0lUbOdUM1kXxs3928RgDDyW95k7V0ytcfPYTpWoEWFXigI
	 KRV5mmLg9LFow==
Date: Wed, 20 Dec 2023 09:12:43 -0800
Subject: [PATCH 5/5] xfs_db: report the device associated with each io cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170309218429.1607770.15957197387853311608.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
References: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
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

When db is reporting on an io cursor, have it print out the device
that the cursor is pointing to.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |   14 +++++++++++++-
 db/io.c    |   35 ++++++++++++++++++++++++++++++++---
 db/io.h    |    3 +++
 3 files changed, 48 insertions(+), 4 deletions(-)


diff --git a/db/block.c b/db/block.c
index 788337d3..d730c779 100644
--- a/db/block.c
+++ b/db/block.c
@@ -126,7 +126,15 @@ daddr_f(
 	char		*p;
 
 	if (argc == 1) {
-		dbprintf(_("current daddr is %lld\n"), iocur_top->off >> BBSHIFT);
+		xfs_daddr_t	daddr = iocur_top->off >> BBSHIFT;
+
+		if (iocur_is_ddev(iocur_top))
+			dbprintf(_("datadev daddr is %lld\n"), daddr);
+		else if (iocur_is_extlogdev(iocur_top))
+			dbprintf(_("logdev daddr is %lld\n"), daddr);
+		else
+			dbprintf(_("current daddr is %lld\n"), daddr);
+
 		return 0;
 	}
 	d = (int64_t)strtoull(argv[1], &p, 0);
@@ -220,6 +228,10 @@ fsblock_f(
 	char		*p;
 
 	if (argc == 1) {
+		if (!iocur_is_ddev(iocur_top)) {
+			dbprintf(_("cursor does not point to data device\n"));
+			return 0;
+		}
 		dbprintf(_("current fsblock is %lld\n"),
 			XFS_DADDR_TO_FSB(mp, iocur_top->off >> BBSHIFT));
 		return 0;
diff --git a/db/io.c b/db/io.c
index 5ccfe3b5..590dd1f8 100644
--- a/db/io.c
+++ b/db/io.c
@@ -137,18 +137,47 @@ pop_help(void)
 		));
 }
 
+bool
+iocur_is_ddev(const struct iocur *ioc)
+{
+	if (!ioc->bp)
+		return false;
+
+	return ioc->bp->b_target == ioc->bp->b_mount->m_ddev_targp;
+}
+
+bool
+iocur_is_extlogdev(const struct iocur *ioc)
+{
+	struct xfs_buf	*bp = ioc->bp;
+
+	if (!bp)
+		return false;
+	if (bp->b_mount->m_logdev_targp == bp->b_mount->m_ddev_targp)
+		return false;
+
+	return bp->b_target == bp->b_mount->m_logdev_targp;
+}
+
 void
 print_iocur(
 	char	*tag,
 	iocur_t	*ioc)
 {
+	const char	*block_unit = "fsbno?";
 	int	i;
 
+	if (iocur_is_ddev(ioc))
+		block_unit = "fsbno";
+	else if (iocur_is_extlogdev(ioc))
+		block_unit = "logbno";
+
 	dbprintf("%s\n", tag);
 	dbprintf(_("\tbyte offset %lld, length %d\n"), ioc->off, ioc->len);
-	dbprintf(_("\tbuffer block %lld (fsbno %lld), %d bb%s\n"), ioc->bb,
-		(xfs_fsblock_t)XFS_DADDR_TO_FSB(mp, ioc->bb), ioc->blen,
-		ioc->blen == 1 ? "" : "s");
+	dbprintf(_("\tbuffer block %lld (%s %lld), %d bb%s\n"), ioc->bb,
+			block_unit,
+			(xfs_fsblock_t)XFS_DADDR_TO_FSB(mp, ioc->bb),
+			ioc->blen, ioc->blen == 1 ? "" : "s");
 	if (ioc->bbmap) {
 		dbprintf(_("\tblock map"));
 		for (i = 0; i < ioc->bbmap->nmaps; i++)
diff --git a/db/io.h b/db/io.h
index bd86c31f..f48b67b4 100644
--- a/db/io.h
+++ b/db/io.h
@@ -56,6 +56,9 @@ extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
 extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
 
+bool iocur_is_ddev(const struct iocur *ioc);
+bool iocur_is_extlogdev(const struct iocur *ioc);
+
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good
  */

