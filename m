Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B434A2D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609781; cv=none; b=CY1mBQOvtiomm5IaFekGLI5vWML3OTuNjO2Vc+lKOviW7r3yDWfQc2SQ80Z4IG3tgDw3TsCOEQLWcr96/GPZf3wkxdN8j19n/Y+GkNYC0f58W4sUD1PODgqC/v7hTU2hTtOf7cIIgZRTfd5Bn+BtG/vtD3V1TZhb8HGtxFYmsTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609781; c=relaxed/simple;
	bh=JWgv1emXoxMv2DFWh8qSUlkQwE6D4ORdDGZ7K+7f3+g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFuQnhqxfm/SocEriN3MrVxCWQkxPjpksSQYn8F+BNg0MJjcv+5CtEnjxQUQ6+Gf8nFo/RC/ZVd0L6fZ0kZKrJNvtINNlpBiT0ziyz2unHkIQ8ZLOB6FWLwfPoIcvjYwgTqFdJFRGDottFjjNeb7zaE61YR21JLEmc5XtSs4VY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPW4X7CJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPW4X7CJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A246C4CEC5;
	Fri, 11 Oct 2024 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609781;
	bh=JWgv1emXoxMv2DFWh8qSUlkQwE6D4ORdDGZ7K+7f3+g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sPW4X7CJptJtbBV1xJ3HlWGCpXg2neh+Ac9Qiux0JY/KUPxHiUJCauWf+mCxxY5z2
	 0bNCZQ3TWhJpb0h8eHfg7gK7YQLTCig8z3yrTCy80QHdRRrhyqyHBCxcdT1xAs0aGD
	 geqi3I1zeFM16A3UNNUAxHBO44P0kya+4ZjVhp5NnPA3321zcSMl4OSmEL7fr4TSq2
	 0AcQBlrt3Ju9hkK1DjQ0pyCEQfUkIoQy7IaS+rEFPuriJ4bWi7lbo091xv8ncWZgu3
	 pbwzbTvl9LHj58KtkQRszW6lzOlS/SpJAefEE29BdilIPm9lNd9cgTFfpAQpc1prSd
	 jHtII4MX1F9VQ==
Date: Thu, 10 Oct 2024 18:23:00 -0700
Subject: [PATCH 34/38] xfs_repair: do not count metadata directory files when
 doing quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654499.4183231.16989786646606876024.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Previously, we stated that files in the metadata directory tree are not
counted in the dquot information.  Fix the offline quotacheck code in
xfs_repair and xfs_check to reflect this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/quotacheck.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index d9e08059927f80..11e2d64eb34791 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -217,6 +217,10 @@ quotacheck_adjust(
 		return;
 	}
 
+	/* Metadata directory files aren't counted in quota. */
+	if (xfs_is_metadir_inode(ip))
+		goto out_rele;
+
 	/* Count the file's blocks. */
 	if (XFS_IS_REALTIME_INODE(ip))
 		rtblks = qc_count_rtblocks(ip);
@@ -229,6 +233,7 @@ quotacheck_adjust(
 	if (proj_dquots)
 		qc_adjust(proj_dquots, ip->i_projid, blocks, rtblks);
 
+out_rele:
 	libxfs_irele(ip);
 }
 

