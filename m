Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1208BE0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295924; cv=none; b=k2H92CXVCm3k+M3VjombG3rFl9K8CHBUH6AN2iNE2D7shLck1QhGVwj6qiuFfwSoiGB+rN6/BDxI6LTGbVI+jb/8LaUDK0Pb96pB2Cbjg6vwWtQWpeYGWS4Bg072U9BL5kArsYZiQI7fYKFsGuCqSEt4UfcBmPHxHcSnKInMFTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295924; c=relaxed/simple;
	bh=UApLG3N24gNFpBPDZjXm2f8cYwfx5F6+c+6oLdKFT9E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xi0OMdYsFiiJC2feP7GCe+xgUmLnD+e7CMywauj+V4eVSPGQBYjoDJ+BnDp6+Elbru/iCrUSIuwnSZX3vv/IvesgIAblx48CdmkMz/21D2dfSSX9Efvc+n0mtPRHo7EGUVsN+2uBs06uF2NVUcSGywayhCGW6VwidHF710joWPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzxGrehb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzxGrehb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85644C433C7;
	Wed, 13 Mar 2024 02:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295924;
	bh=UApLG3N24gNFpBPDZjXm2f8cYwfx5F6+c+6oLdKFT9E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MzxGrehbFtelE0eXN5cw6k6mErwpUyBFPpI2v1DqzSQ9fwpJM7c1glRX2P/7TZQfc
	 n1tGuio9HGzw5XzQ57+nmeQ2cNeBvAzfNYNp9FnOlmNsT3Tj/1j+0+vM1CHA7IHXpo
	 ywvfimwP1j1nR9kmIGdCxvTEmwO975xOr3sIGIA6OlNNhh+ftvb3u5iggyCMJBY27J
	 jSLNA102UcXw6RW3mJDP3cZPZOYStIFxBjZ6NKXv2xnXdcVTvVEweO2+pDCkvbySXl
	 SfjVpcx/Fmq9Kz4UMxPRSddKq8H9TV+7AYdb4BToaHR1kK6vgP3/LM/fBBVv+u5pN5
	 xPrKGW28PAtQg==
Date: Tue, 12 Mar 2024 19:12:04 -0700
Subject: [PATCH 3/5] libxfs: remove the S_ISREG check from blkid_get_topology
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433258.2063634.3143875873480142461.stgit@frogsfrogsfrogs>
In-Reply-To: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
References: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The only caller already performs the exact same check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c |    9 ---------
 1 file changed, 9 deletions(-)


diff --git a/libxfs/topology.c b/libxfs/topology.c
index 8ae5f7483f96..3a659c2627c7 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -181,15 +181,6 @@ blkid_get_topology(
 {
 	blkid_topology tp;
 	blkid_probe pr;
-	struct stat statbuf;
-
-	/* can't get topology info from a file */
-	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
-		fprintf(stderr,
-	_("%s: Warning: trying to probe topology of a file %s!\n"),
-			progname, device);
-		return;
-	}
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)

