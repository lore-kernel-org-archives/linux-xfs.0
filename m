Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0893ADB9B;
	Fri,  9 Oct 2026 06:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526600; cv=none; b=bxV8CXQjW6tzs/ZjWkEVJfXNfKtaB90JdH1gUaoSPReFrhJwvm5KY4qYKFnQewjwJ/hP0T418Ish7ShvRfoDq1VTHZ7zYYp20sWVCI+ne/I2GE90gdaG2sBAo176KGSMMTh9vFp2q/0XqbpedjVZE+ijX0wtJo3aPBz6uL3hF+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526600; c=relaxed/simple;
	bh=HKneKNq+sr386WH7+ba5KyRqmeDa4/eYacVm7GQJpEI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ut9nSCS1hFcxMFSirVyByy6J+4KwBJoNBebVYAgsuq+nQ1rDlOuQeDa4kvPcbXKa7o1anUI0qGxKocLWZjtnXkWMY//yZqLSgZ6OrrC1gQz256B7F1e4LD7YyvhIp+NmnCuamgNFUf+CAOD2a0345uCzwvYG9joQDceoN43ltTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODToZbrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODToZbrS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D07E1F000FF;
	Fri,  9 Oct 2026 06:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526599;
	bh=OAC6DIXMqE7iQplqSaIwLBZR/jZ5IXPttswxOzIUo2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ODToZbrSR1qC5z5p6yyTOxPkuGIcjwFBrW3xLQS/7RUr6LN1WZlg8jcXXL1IgZx8O
	 4wR37jSTUGIxkf71y9d3LaOYgHNsea89tW6RT2vAPG66ed0Ba+Ste/0PKrOmibPrA2
	 fbZYZ31nsDh/KX+gG7BTvS6EnLkHM2/RF+2Zz2QdLCKuZ3XBrO0rN6B7bi48O+bNtJ
	 fHQGjHh7ATyD1WNOIZwk5PZBF/p9sE2LDitzWu0oZpTOrisxFW2v9zc0H2pQTWvaSI
	 ssysMJEl/ZFqEecgraiPF0qehrhMr46ctNrAAJwqBgkYuglG4SgyQ5fFnGSwKiQbnw
	 ifVD0HGOgwa2Q==
Date: Thu, 08 Oct 2026 23:16:39 -0700
Subject: [PATCH 07/13] xfs: always report inode repair setup failures
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614771.3163896.11886739421197857328.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
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

