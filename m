Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB512539C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230794; cv=none; b=eRPC7ojpaWFq5/kciKHW6J2Y9ZkvpoOQhi7/OO1a5VPWPVKq0mm855+XzlVkD6IN5bFOjZkUGQTq7F1Ux0hhlEsGq9pl4HZK2bwk3CpB4ESEPyBxkeWvPBi+mYxcmpSdsmz2usGhU+9tfimdIh4D7+7iPKtPrkt7Dh2LmI0UCZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230794; c=relaxed/simple;
	bh=DU/yNHJGHUDsUNSrGcO4d1NTtLanpgEaVVMr6H3T/DM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKktii4CyqyLc0/RZc0/OS3Up5Med83wp4iYEdAv4CnRB5SbqL3EkYDe+WIyoXt/XI2Yq9egnz3df/iCEw1htoPBK/5rX2EmZrKSAAkq1uMNNGHxXZ4oEi1MoTbPyLEpfxemGlJlM5j6UxIOwhkvF/LbF2TuslPiTwCmX7qDMX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCzHuvcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCzHuvcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C386C113CC;
	Tue, 16 Apr 2024 01:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230794;
	bh=DU/yNHJGHUDsUNSrGcO4d1NTtLanpgEaVVMr6H3T/DM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LCzHuvcIQ9vA5mhI9nRMEBzksbQBJObS9tMAOFYnfRlniCXfD+Zv2OcdXk3loFTUG
	 XpcFE51obKAJa0rAPSV6OyfXLeZMY1iyeB1Yn5+wLLNtJgMaWBN8nO8pOCeIMj5M2p
	 V0xR/UMbVEf1fI7KvrKLPXnxmB66Mh8VBQqGy7CLgCxQxE9zsoYzJsPBxhHjv1Ngmq
	 3L1PNyYGrd3AGaXITAisiCPzcUgGbwF5vwT3bs/bftv81ObgevQ4DvyNNzxLLK7oFl
	 WEAHk+CUMoLseS2+lI4oc5iudwxjwZ4sv9ca+y1HRcdS82wfdqWTAdaaZf3ORS1DJl
	 rl/nJ98ojHxCg==
Date: Mon, 15 Apr 2024 18:26:33 -0700
Subject: [PATCH 02/31] xfs: check the flags earlier in xfs_attr_match
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027818.251715.653930288520430859.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Checking the flags match is much cheaper than a memcmp, so do it early
on in xfs_attr_match, and also add a little helper to calculate the
match mask right under the comment explaining the logic for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bb00183d13492..c47fad39744ee 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -507,6 +507,13 @@ xfs_attr3_leaf_read(
  * INCOMPLETE flag will not be set in attr->attr_filter, but rather
  * XFS_DA_OP_RECOVERY will be set in args->op_flags.
  */
+static inline unsigned int xfs_attr_match_mask(const struct xfs_da_args *args)
+{
+	if (args->op_flags & XFS_DA_OP_RECOVERY)
+		return XFS_ATTR_NSP_ONDISK_MASK;
+	return XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE;
+}
+
 static bool
 xfs_attr_match(
 	struct xfs_da_args	*args,
@@ -514,21 +521,15 @@ xfs_attr_match(
 	const unsigned char	*name,
 	unsigned int		namelen)
 {
+	unsigned int		mask = xfs_attr_match_mask(args);
 
 	if (args->namelen != namelen)
 		return false;
+	if ((args->attr_filter & mask) != (attr_flags & mask))
+		return false;
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
 
-	/* Recovery ignores the INCOMPLETE flag. */
-	if ((args->op_flags & XFS_DA_OP_RECOVERY) &&
-	    args->attr_filter == (attr_flags & XFS_ATTR_NSP_ONDISK_MASK))
-		return true;
-
-	/* All remaining matches need to be filtered by INCOMPLETE state. */
-	if (args->attr_filter !=
-	    (attr_flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
-		return false;
 	return true;
 }
 

