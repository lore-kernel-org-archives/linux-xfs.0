Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583361862
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063560; cv=none; b=jkjRkoCFrmcoIjspYxjnRaRU3XkDSrfzobG0SDh4L0nUET8HOPmodNytbNBZq5C/xRIdVB6kMZMRYkJC2asvY0PPXHNiIrxa9sWirI5gxF5vpAyfMkHrL+wZB4QzHZH8fK5fvBFdIqhQ4jgRBb8gWSsE9rhpdusKnuSih+OF7j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063560; c=relaxed/simple;
	bh=wogcHI5ryNCdDtXslixyus7GN4/FJsJSkqKpiEHZCfo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZW6an8yfdLpb1DVCqbP2M6NsmrxeEJCY5TJAzr++DZY4rU4N4lxeTgRyx3rFtgu1Wr2LJMfSJfO0loeifyvmMrr798k7Vga4Yny4GDG8/fNIcxfr9iOU/smNpZfvowgs5UNDaz3U/CmWVZ9wPWgI8oygsue1hRENh0SJOfPJDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDmO1tyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDmO1tyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7066C4CED6;
	Thu, 16 Jan 2025 21:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063558;
	bh=wogcHI5ryNCdDtXslixyus7GN4/FJsJSkqKpiEHZCfo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JDmO1tyV/UgeIP66Qumcdk8QzUywQ6tL6+j/ELWUX0yX11qhUUeMlrliXEylfQQTF
	 zmE3R0/GG+lZS7cwnXTtsEuaYwxqLIv//a4QGSXKdP5aByntQ9TGWhpETqu1CM6jrN
	 MxZUFSEtR9gNgIfMBI2f6W8qoWh8W73VveZ+bApFX2AnrIDF9lbcA9++MO8P8O7q6a
	 abuv9YY28t538gf2Xx8hmW1ZSuzFytPsefB+t/r/r0XhUilNSLEIIGhDJNENiZtwid
	 rGgAd1eCZ7g4BZeJQY3ZVT42SPufHXoHw5ct+VBx5X6++pd/mbdu5cboJFbbL2g3AQ
	 0HamWRu2b56Mg==
Date: Thu, 16 Jan 2025 13:39:18 -0800
Subject: [PATCH 3/8] libxfs: fix uninit variable in libxfs_alloc_file_space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173706332252.1823674.14773579267642290396.stgit@frogsfrogsfrogs>
In-Reply-To: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
References: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this uninitialized variable.

Coverity-id: 1637359
Fixes: b48164b8cd7618 ("libxfs: resync libxfs_alloc_file_space interface with the kernel")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 4a9dd254083a63..3597850ddccb9a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -193,7 +193,7 @@ libxfs_alloc_file_space(
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
-	int			error;
+	int			error = 0;
 
 	if (len <= 0)
 		return -EINVAL;

