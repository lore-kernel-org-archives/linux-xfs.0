Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01F9BA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294970; cv=none; b=d5RXDufp/Jr16K48WELhq6sSjfNIEbutWmBB7PEQzYprFZk6NG7Ab1DGsOnf7UllACflbc2sWJGmq0q04p7xA1NZ7gxpGLjHQx97/WwlJ6cSBcyN4xxzLEtJrF3PIxGCeLGu1vozS3+aabrhEFILUmBS53k55fL4/gxEZSO8r3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294970; c=relaxed/simple;
	bh=0rPbk7OJMq4jDSKbhm3gTtY055lgbARDxEhveyoU9pc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGKLlAdOiYAOTSB1OBUulPl1CsmcUuJnNvqPyMANRZjwCIrlGKGL8vTDp4CyrAF0jJG6Z4I7tLHbUzK/EMXtJ4Bg+gHL1J3LnNhNqVlHNT8n4XGF3U5U/JL9bJUV/O/yhD6wYH6y5ngKplkcUvGyE8Bqn2nwVH+AkHrexsd/iq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmoifYB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmoifYB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D3C433F1;
	Wed, 13 Mar 2024 01:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294970;
	bh=0rPbk7OJMq4jDSKbhm3gTtY055lgbARDxEhveyoU9pc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qmoifYB49xwlT86xa1yBmEGXyX9BygDqMCSEGl2iNBddBbWx/6jMm8vm1mA1ghvkM
	 eSzG1BI7pdgKJB5oEXJ/gJND9SstkYmBo68ZkCgW98fxKydyP9bXXa7BR0MAa5yCnI
	 tCraqsSRBH/J7W+NH1CQ0RuuWfemers3N8Wu9nLKe12lPIAlzXhTPawq9h+1rLQCGs
	 et7X5R5lxS5xiMMk10vV+vHXd5DfE50vE9cegdSkEGSIKr0P0GhLbOVFUVCkC0HMLt
	 7hNmE3UdIipTRO/ohip5UF/W6zsPMt/23fa0B3KvkadczaIgo8Lhpm/X+7RagL5D6N
	 d51nxwg+mGcEQ==
Date: Tue, 12 Mar 2024 18:56:10 -0700
Subject: [PATCH 12/67] xfs: fix 32-bit truncation in xfs_compute_rextslog
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431366.2061787.13530390174806825113.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: cf8f0e6c1429be7652869059ea44696b72d5b726

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 90fe9028887a..726543abb51a 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1130,14 +1130,16 @@ xfs_rtbitmap_blockcount(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 
 /*

