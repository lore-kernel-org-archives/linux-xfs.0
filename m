Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E155312A145
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423643; cv=none; b=tya2NVyTpCMrV5s4gNeNye2Dz5CcWSCazdFRrwrPZVkTxLAC4zAXQPHgHDbBUTxUGRz6IS7a5xfH49Vcq2lOopiq0or/oqZBbuoEWhVexEEjoAcxS4q70mFePUsXmut261jMJFBHxsc4hJnqxUEGgkHVsLAFRZU+Gj6Wz/ieL50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423643; c=relaxed/simple;
	bh=sz6yNOnnw62kRxPdoPthCB8SWdjdDSyvGNBDFKGushc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bhcsb9Q6FlW1+ouBNBIjDj7vag7uLCh+xANic3959AqOh+S1+wC8o4CN8qaLORtjB1TpsGK4hUD2hHUe0sNDVg2R1dZdAfaSZ4tMPrc4FxFB30JQBkst2JMAGEEWuVOVO8KEOXOoV4HTpAkGJNPQHGf81eXioIJQGjaR8ugDbRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G69jIRrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G69jIRrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BC0C43399;
	Tue, 26 Mar 2024 03:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423642;
	bh=sz6yNOnnw62kRxPdoPthCB8SWdjdDSyvGNBDFKGushc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G69jIRrrQ8y0i2yz/0L2lg2pV5YcBogewtAE/f277XPu7KVYXE6uoPhW0cSxC9ZR1
	 o+ZhYzKdAG06t49AeP7YYh1hgVKLRGDL1TpWSfFVdmqcYYFCbJpPmiAmvajLZPg5qI
	 7k4SK7FY2qFIw3aC/2rFH2Ir6iBJEjsKICao9VTi3N5z7lLM659vJvMd3L9dx21ZWq
	 xL7sxmlagaakAP8dNjNI04lVJOIxYevYqqhqqVTxLMMdKHob+E8pV/9U1sl1uP8K1n
	 gz2fbWJg9tLJUdYf4p6olfnJ/nj0XlgOolua1jn0LkRGmHwpfEt741CXBjCRdu769E
	 MXe0JFF6Zm1Jw==
Date: Mon, 25 Mar 2024 20:27:21 -0700
Subject: [PATCH 7/8] xfs_repair: don't create block maps for data files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130456.2214793.13545681190697709010.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
References: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
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

Repair only queries inode block maps for inode forks that map filesystem
metadata.  IOWs, it only uses it for directories, quota files, symlinks,
and realtime space metadata.  It doesn't use it for regular files or
realtime files, so exclude its use for these files to reduce processing
times for heavily fragmented regular files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index bf93a5790877..94f5fdcb4a37 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1930,8 +1930,14 @@ process_inode_data_fork(
 	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
-
-	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
+	/*
+	 * Repair doesn't care about the block maps for regular file data
+	 * because it never tries to read data blocks.  Only spend time on
+	 * constructing a block map for directories, quota files, symlinks,
+	 * and realtime space metadata.
+	 */
+	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
+	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
 

