Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE386139D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301061; cv=none; b=oeZEJjZGl9eigXEhWi3FY8p7yRBjM2OPMyVoB6EjoVm0l6gEqvzs8K5Ab339Qma9P0QFlz1w9L20mmUq/pQyVeJxN2FFQYoH+FVa7Lxur7XSGxqOwXheVPP3SbOJtjoyFJDbYdk/7ykSXVVcu+/9r7PkftNIl3yGBb69eHGAAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301061; c=relaxed/simple;
	bh=uSy/ra++JWxk7/+7Ij/kxcg+jpc59DFq2l47GBdPw/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RVyD1aCWMq/snnYLU2nrMFv0MJxCDZmKi/43PFRthsCEdg+GsIgTsy9TLeDoM5GcJKpYBhJ+IRgSw6+zvk00t7raazW+LUKkqwCk3wDQrLFz+jdcxPY1YsQjKh5RpI+9QRG3ADkYmGwyKe2wGEReOsbp2TbJe1VyXwy0L4Qa6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLN6Dl+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLN6Dl+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B01EC32786;
	Tue, 30 Jul 2024 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301061;
	bh=uSy/ra++JWxk7/+7Ij/kxcg+jpc59DFq2l47GBdPw/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jLN6Dl+41b9KT+74xO9qDphthKOB+MHSD6FLac5PpdhgMAFxkqv3+aIDUv9LEcSE2
	 WSqEYmpzntXkpcXbTAiGzZ+MlWIOVvsTMyC+y62dMwd3F7TfrBV0rDfMietODNR29m
	 wdlzAImwZOrZmiKaL1K1IKB8KSKjNEfColU9gPNB2v9lDa3WJjZdtMFk0e8dbUwORE
	 PCeQ6irHaTFcBO6fJHLrcNHhPWt8dzvTr4wauZ4CtTV8bmWJOqKd/wscI3eWejTjWz
	 QsGMSvBI7xBjoJQmvfR3kxOgP/0E8GluePG6/DILb0gHrADX8Y3TvZ4o1JkfbvqwLx
	 Bwx726ktUzWoA==
Date: Mon, 29 Jul 2024 17:57:41 -0700
Subject: [PATCH 2/2] mkfs/repair: pin inodes that would otherwise overflow
 link count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845236.1345564.14900483983997622040.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845209.1345564.9915639548188043835.stgit@frogsfrogsfrogs>
References: <172229845209.1345564.9915639548188043835.stgit@frogsfrogsfrogs>
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

Update userspace utilities not to allow integer overflows of inode link
counts to result in a file that is referenced by parent directories but
has zero link count.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c       |    3 ++-
 repair/incore_ino.c |   14 +++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index dc54e3ee6..74eea0fcb 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -252,7 +252,8 @@ libxfs_bumplink(
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	inc_nlink(inode);
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(inode);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 0dd7a2f06..6618e534a 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -89,26 +89,30 @@ nlink_grow_16_to_32(ino_tree_node_t *irec)
 
 void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 {
+	union ino_nlink		*c;
+
 	ASSERT(irec->ino_un.ex_data != NULL);
 
 	pthread_mutex_lock(&irec->lock);
+	c = &irec->ino_un.ex_data->counted_nlinks;
 	switch (irec->nlink_size) {
 	case sizeof(uint8_t):
-		if (irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] < 0xff) {
-			irec->ino_un.ex_data->counted_nlinks.un8[ino_offset]++;
+		if (c->un8[ino_offset] < 0xff) {
+			c->un8[ino_offset]++;
 			break;
 		}
 		nlink_grow_8_to_16(irec);
 		/*FALLTHRU*/
 	case sizeof(uint16_t):
-		if (irec->ino_un.ex_data->counted_nlinks.un16[ino_offset] < 0xffff) {
-			irec->ino_un.ex_data->counted_nlinks.un16[ino_offset]++;
+		if (c->un16[ino_offset] < 0xffff) {
+			c->un16[ino_offset]++;
 			break;
 		}
 		nlink_grow_16_to_32(irec);
 		/*FALLTHRU*/
 	case sizeof(uint32_t):
-		irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
+		if (c->un32[ino_offset] != XFS_NLINK_PINNED)
+			c->un32[ino_offset]++;
 		break;
 	default:
 		ASSERT(0);

