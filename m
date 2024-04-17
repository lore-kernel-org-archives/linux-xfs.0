Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA2E48CCD
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388844; cv=none; b=u8pxAhXTv7rYP4SO2NyZvsEJGJBREUrxozRt6/WgtGXubSMyc8PiqlBY5uDEXsXQmftxVZ3dEZJkw0fvIqaGXsrozyA0g0XmOacWocyvXUJaWdsmpjO6j6Vs/ALlp0ua0Q8Vfdzt44nJhLPhKAwhSZ5zUdKW8JgqyzYhBr4XAuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388844; c=relaxed/simple;
	bh=oNHiOe7I6poNCU4s7Em6U65u0rdnVjIPr7UDwdTxk/E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/9CbKLLLHqoObv3Y6/SgyW0SehpMvJfqs48w75z6sR/Lzj0FRFtInCufndj7KWXS6tYXGgnZiZ3Ovgdfih36Rb0hOntmonwQpp8MUvvFiD2eZfJq3XeAS5EtXteWFFis8+skzpfSPMvbhXQ+oFMGuwaUblNiRPHjv2wvSOQZxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvRC1J/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvRC1J/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD63C072AA;
	Wed, 17 Apr 2024 21:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388844;
	bh=oNHiOe7I6poNCU4s7Em6U65u0rdnVjIPr7UDwdTxk/E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UvRC1J/7TV5iVpSuUWTtizO4mxO+sLM79oYi9UGXMrF8sxbpBRMFe6CXECUXLWA3L
	 oFAAd8RnYJcOaKtSpbndPCCGPchpP/l9KDuKC3mL1G0QPfm3r/82X8Cms6RJWdKGUQ
	 0w+oi4Ajf9684dCPeOOSdgkfazk8vNXmwM7EcUX3lYKZmS9aRM8jUH6gxK2fEd3w9y
	 ECqD7GnNeffwPGTNiKKJst08DEFikUd1zzEIVUxXOxpyh6qlfqqsG4ExjVySzijX5W
	 FYsR2eVMar3sWqzvL5IklHpHRdFuZWa/HYG2/4PISjKjhf+DWLQjHyMCTW5FWbX+PP
	 kclFgOrixOJPw==
Date: Wed, 17 Apr 2024 14:20:43 -0700
Subject: [PATCH 07/11] xfs_repair: convert helpers for rtbitmap
 block/wordcount computations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841842.1853034.5565080639391311539.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
References: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
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

Port xfs_repair to use the new helper functions that compute the number
of blocks or words necessary to store the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/libxfs_api_defs.h |    2 ++
 repair/rt.c              |   10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a16efa007..5180da2fc 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -175,6 +175,8 @@
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
+#define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
+
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_sb_from_disk		libxfs_sb_from_disk
diff --git a/repair/rt.c b/repair/rt.c
index 8f3b9082a..244b59f04 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -19,6 +19,8 @@
 void
 rtinit(xfs_mount_t *mp)
 {
+	unsigned long long	wordcnt;
+
 	if (mp->m_sb.sb_rblocks == 0)
 		return;
 
@@ -26,11 +28,9 @@ rtinit(xfs_mount_t *mp)
 	 * realtime init -- blockmap initialization is
 	 * handled by incore_init()
 	 */
-	/*
-	sumfile = calloc(mp->m_rsumsize, 1);
-	*/
-	if ((btmcompute = calloc(mp->m_sb.sb_rbmblocks *
-			mp->m_sb.sb_blocksize, 1)) == NULL)
+	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
+	btmcompute = calloc(wordcnt, sizeof(xfs_rtword_t));
+	if (!btmcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 

