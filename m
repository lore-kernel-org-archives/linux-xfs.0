Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848321D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423877; cv=none; b=A8lt8E6o5ppfdOOhTBdtZ89e035yuOBSF0ezHq9BB9WIe3HiLAmRMhLeJoljpUl702Ar6gXU3PMuoJdf4D5DY0LUNHZZ5Cpi/Qh0rTod5rsdfsua75gqF5rQnHREc861qAByBG+rxi7llbfXyXQq0D7pAnBbhzBbr4rZXbI7dDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423877; c=relaxed/simple;
	bh=377hiHeyRGuJwiDS6pHzbQN3A6HHuCo2YVxjIFyHB5g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DebTtUkRd6+MiqhOxsJUOcf3ngNR5p9rDJEfuhxZeMAqlzT7+BdY+QUT9LqAuAErMWAlk+GOAMhRQvx+3e9RsCt1DWi45l7QjyvOEUuOa7C5ozHok1gFmCAY2EBz8y+8OGDIjkv4J9owJYN3aBuEEYNt3/Q2SsUnIkC4zRHNvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfeGsoIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfeGsoIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD9EC433F1;
	Tue, 26 Mar 2024 03:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423877;
	bh=377hiHeyRGuJwiDS6pHzbQN3A6HHuCo2YVxjIFyHB5g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gfeGsoIZl/ldxhLEB22TYcOI7YiEHDMU+Ax5chnAPW54rCaXKQgnQ1T8g/ZzYdndu
	 OVFLzHttpGb65ouxXgyik6NEqzDhPShcdrCkxgb2IDAFHLW4NK0tWXqOhrocfvEfgI
	 J2mP9mHFOkB5f1PF1a/H5e5eub/9RLza0uAbqq5iHt9RiCk1ZyGw0mL6nsE1BXSA/x
	 fON5ILSdp8xP6f/mPHUWknWrBcZu0MCIjtsKm9ro3wyAVzxlvj026H77OynwJznQGw
	 IWOiGqwVGUAg5wO6MCeM41KtNFTdnwDpilHQM6+5rYUjbfr0aPdNrkgSL2IeWZC1Vy
	 3hXLQACoVZAqQ==
Date: Mon, 25 Mar 2024 20:31:16 -0700
Subject: [PATCH 011/110] xfs: create a macro for decoding ftypes in
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131544.2215168.10863425628218516015.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3c79e6a87221e063064e3680946a8b4bcd9fe78d

Create the XFS_DIR3_FTYPE_STR macro so that we can report ftype as
strings instead of numbers in tracepoints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_format.h |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 24f9d1461f9a..060e5c96b70f 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */

