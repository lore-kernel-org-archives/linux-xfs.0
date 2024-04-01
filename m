Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD435481C6;
	Mon,  1 Apr 2024 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990126; cv=none; b=mx79L/JsIYgudk2unw4/rhCg8lWvCeutdvkfVjav4J4wSTm0nTbzglDc95slHzF1KsUiN3+eA8dR0MrIHAzTSVEY5tN83grBN0ltHrRVgJGPK8QYRh/XOb2w37DvY5Xo1wdJyJ7w0mNvEq+ktVjrX6UihJXS7DlpARcjDfJoIT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990126; c=relaxed/simple;
	bh=ieEYIWM104rwG6p7ORblzwF88ePi3/AKa8/D0+linRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFAtOqMo5unZkXMQ0UA6p7imGH+ArdooG6wtwtc/CllGet8E9X0naMuISBLNNhL0qbyw1WE7DtXPHJHH4M53J6tZpWQFWTGHallmOmmPxCYrdjlk5Lc3TjlUXyuBgnROgLrqMg5rpobsayy7QhW4sBXYxKe4XYgaGHdeDDxUoUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtY6SkXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtY6SkXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2724DC433F1;
	Mon,  1 Apr 2024 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990126;
	bh=ieEYIWM104rwG6p7ORblzwF88ePi3/AKa8/D0+linRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtY6SkXfWFo9ZvmtB4NR8Q0KWxC+XIbqh2lB2cI9/3g5GYS1EHYKpID2kPSInvXsf
	 3xHzJXu6CsO0dOilBq0E3SNrF4oUGPrqwg+laEdNVqQXMvOv0vNG6gv2Rafsp4ghwI
	 AU26VVL7e9MlX4lYO7lYV5njhnKjIg61OrU/0Q5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 255/396] xfs: consider minlen sized extents in xfs_rtallocate_extent_block
Date: Mon,  1 Apr 2024 17:45:04 +0200
Message-ID: <20240401152555.510182619@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 944df75958807d56f2db9fdc769eb15dd9f0366a upstream.

[backport: resolve merge conflict due to missing xfs_rtxlen_t type]

minlen is the lower bound on the extent length that the caller can
accept, and maxlen is at this point the maximal available length.
This means a minlen extent is perfectly fine to use, so do it.  This
matches the equivalent logic in xfs_rtallocate_extent_exact that also
accepts a minlen sized extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -318,7 +318,7 @@ xfs_rtallocate_extent_block(
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
-	if (minlen < maxlen && besti != -1) {
+	if (minlen <= maxlen && besti != -1) {
 		xfs_extlen_t	p;	/* amount to trim length by */
 
 		/*


