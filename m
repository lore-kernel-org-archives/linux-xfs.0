Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2832A23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442571; cv=none; b=U8Rge+uFd8GorXG01kAc1gF1BrddKWuPs8Ez5J72Ueq0pNufdFuJl6Ajkj9TRZWcj/ONh6dojVXFlQ7ZFJ+VHMHgA0k/Gk7mNXlqqrbsPX6wG7VKJbQfk349AfknN3nTC+saotsdYHCk3/QycOGxIpCVFHXVFCXiGpJO0pZTTWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442571; c=relaxed/simple;
	bh=+qqjVrjE2XhYWZkQYoMrW0JfdLnsfNGz3+1KQ5WbZ+o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AW27NC14Y9ymOm2ZtZDt85aecC1ZeavOD7YadCfaWbPFBYUVJ2GNeLLqL3t9lnj6JR22RkBnASFMSWpJCP82EIy8t/iZbXaucllgYee1OwgpHje6K74amYg68ZefrNAyZQaqgKg7Li5xaDTt22c6eodp8x+TyBqA9FlRAXDidlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBmIQF61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBmIQF61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51BFC2BD10;
	Mon,  3 Jun 2024 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442570;
	bh=+qqjVrjE2XhYWZkQYoMrW0JfdLnsfNGz3+1KQ5WbZ+o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GBmIQF61zhZzPoKlFXWGi3sJE3nKylsi64AhtQvMaxDACbCPUCYRPE705w1cfDq/8
	 cidkwEp24UBt1DHI/81UBcL8Z3pnlrqBTdJ5gCbkn+1Ptyaq4fXUrU6Uxjnk18YYwW
	 Pg3JmcIYhy5XXWUl0dm5wGHlN6hNkvmAk0LqSvnmsSRYxvEkJ9+DVLcrZT01nYSeEN
	 iZNCyjbu6kc2Rq7aH/Lx15VT1cVug9nxN1s8FoPQDLlnuiBQ8tRTduobYs7tXuveGy
	 zlrasQOfAyPP+s5ooOcj/uVLlR3sKOZucVVVEKZTXliC3zkyaGwbEnQi3pdDhFN5xw
	 bOzpbiMItYuyw==
Date: Mon, 03 Jun 2024 12:22:50 -0700
Subject: [PATCH 2/2] xfs_spaceman: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042074.1449674.16242064085557988937.stgit@frogsfrogsfrogs>
In-Reply-To: <171744042043.1449674.18402357291162524859.stgit@frogsfrogsfrogs>
References: <171744042043.1449674.18402357291162524859.stgit@frogsfrogsfrogs>
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

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 spaceman/health.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 3318f9d1a..88b12c0b0 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -76,6 +76,10 @@ static const struct flag_map fs_flags[] = {
 		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
 		.descr = "quota counts",
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_NLINKS,
+		.descr = "inode link counts",
+	},
 	{0},
 };
 

