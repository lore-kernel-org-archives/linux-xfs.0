Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC4219E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371815; cv=none; b=K4szb+xLILK6RwAOuxcHcbyrnPSmT/qQGX1SzvTIXQP2Rt54c14Yy60ZQU6X7bL/o78PPnNsERxPZOLvjXOvY90gKpMqrnjhVlOs51wa/nREW44agTUSYSgqs4d9oGX2k2S2iEoVRuh2Ig7Fw7RuqEe4Eh59OHDOdmyWn+qB0aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371815; c=relaxed/simple;
	bh=3UwhoiQBhu4B3wCFOUoBCiBRZd8gvVXzqqfvqWcpLzQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yoo6WEHlKK1/u6e+po3CbQVqDM7Md+mu7ON/5IKfD54XHTaig/uUusDK2AjOt3Wy2jAX1nb1Tn2JC0w/cxjUgSftr2OjhflNfUB23sXxfZ4p53X8+aBPrTDeCIwpyvOPgH3uINAvV5asqXcxqjDXAkO7YoGzDPJB0NzePxysXxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpXp+bBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpXp+bBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C617C32782;
	Fri, 23 Aug 2024 00:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371814;
	bh=3UwhoiQBhu4B3wCFOUoBCiBRZd8gvVXzqqfvqWcpLzQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SpXp+bBZMaYDJ0X9mms2HV6bgcBRt0ZqEbmMMmeIgy/W9EKdIAXf5uM/HXeekNpV0
	 4K+sbmCBKZl1ozTgqN+BKk8h2jk55uyf9zDY4KvX1SuVKpAB7+PCrNh76kDMGGq7ap
	 fv9QxziFrrJvPr7YHlD/jo8w9xTV077Ilc0ZfYcT3QLInqyVNGTkSNSDiMWKsyRIDy
	 NRm2kyOgjFC1As9RYwCAbeSRt63LFxJRvoy7QHbJORBBBw75P+JELtDWzQVvia/HHg
	 wNlZ1xcROleUjV4ZxZcTbJR3YUF78dsHHAMY9BKGhD+E81ibNtDNndp4ne4nGAk96Z
	 waJEF+pnSvagw==
Date: Thu, 22 Aug 2024 17:10:14 -0700
Subject: [PATCH 05/12] xfs: assert a valid limit in xfs_rtfind_forw
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086105.58604.1010536391875756505.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

Protect against developers passing stupid limits when refactoring the
RT code once again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9feeefe539488..4de97c4e8ebdd 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -315,6 +315,8 @@ xfs_rtfind_forw(
 	xfs_rtword_t		incore;
 	unsigned int		word;	/* word number in the buffer */
 
+	ASSERT(start <= limit);
+
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */

