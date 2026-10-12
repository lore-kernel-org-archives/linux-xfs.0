Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A894848F84D;
	Mon, 12 Oct 2026 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818531; cv=none; b=ZCzo4AY+a3rzW+7+zdt6ExyzInSmwNoTmVcIVMJzMxtwA48/rpNtJnrZs3TyNbrMa4RwcJEs8jNsgCPTg01eQukTlcNNVU4eGZB8XbvwX3muTiZ06jyRO/DVIz9363YerucP6J10/Zy/98uLtDwtrMgLfp7Hmcv3hbfD/Mqe9rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818531; c=relaxed/simple;
	bh=HKneKNq+sr386WH7+ba5KyRqmeDa4/eYacVm7GQJpEI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9JlgXgDMQwlU8eZweUreOIxlt/sd6uK64XFqIJZlsyXR0MsyD/SaZq5LibmAVgmRMzM3n0QHw3S0uG4tyNnFPEBMdVEHzswUGI2i0qVp4sjBWp6gBlS9c+JS4/BGALilVA9P4KDkLupC7PoX1bO8atriwiLzYk/E+CJnWURXHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvUR3fid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvUR3fid"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 43C121F0089B;
	Mon, 12 Oct 2026 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818530;
	bh=OAC6DIXMqE7iQplqSaIwLBZR/jZ5IXPttswxOzIUo2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LvUR3fidEWbd4ix+29y8waH0181E1LYxteyWwvoNMeSG7mB2i8McyjIFmwDfrikQm
	 hCtEb2juMsCl/Wbuoa5Ahn8QHgIdQR3EVQGUF4HtHj385JVdBnukwRq8omTwpPBt1v
	 F3s7g+DuEhlcouW1l7BK4DbLwH/DHvi0yNT6Vd2JzGzJhVRR0vdN6UgpTugvkRI16D
	 ivvY/6BatOxJ6BBnlf8JJMlgEyNMF6zxW1QPDSFHSdsLmc5TQW/AoemvIfcMbb9ECO
	 IGGP+rwAZh8NNGQPHU/4VQZFHNhRv3Zn8EQEZ45VRewd6BtCb7leRFcxkXI/T47msN
	 7yVd19+VGtujw==
Date: Mon, 12 Oct 2026 08:22:09 -0700
Subject: [PATCH 07/13] xfs: always report inode repair setup failures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839398.1417179.3258688271174727277.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xchk_setup_inode silently discards errors being
returned by xrep_setup_inode.  Fix that, and fix the stub macro so that
it actually "returns" a value.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.h |    2 +-
 fs/xfs/scrub/inode.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 2bb125c4f9bf2b..1af568651e20a1 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -239,7 +239,7 @@ xrep_setup_nothing(
 #define xrep_setup_rtrmapbt		xrep_setup_nothing
 #define xrep_setup_rtrefcountbt		xrep_setup_nothing
 
-#define xrep_setup_inode(sc, imap)	((void)0)
+#define xrep_setup_inode(sc, imap)	(0)
 
 static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 {
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 46e9bf4a43179e..ac42867acbc4c9 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -212,7 +212,7 @@ xchk_setup_inode(
 	 * make repairs to the ondisk inode buffer.
 	 */
 	if (xchk_could_repair(sc))
-		xrep_setup_inode(sc, &imap);
+		return xrep_setup_inode(sc, &imap);
 	return 0;
 
 out_cancel:

