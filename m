Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E0357314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423188; cv=none; b=l4fQ6bIjQnSd7pz+XAHjqrX3iDNkwnHJvnRt1zZGhakY4Jm328GTHWXj0uMqOPNKSvVZ1nn2yAk/kp6D1tyNxGg/L+UHXiBhpnKPvEGSJArLax/MG60N88RYENDCLXKxpgKskX3mydgksqWFNubBv/ezPv6x9xCLhA4jiqlHWxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423188; c=relaxed/simple;
	bh=/cpd/Wno8DiZtEQPfzes66bd0qh3XmtYVKfARwOOHlU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXF3ud3amrioMPGMDgY1YxV20zNvuP2jf+3SCqojISooxDC2BZlx+Kw1SHSCGRPeS9+1hHjIsNTyo5n4Syybdmj4tcMD7xvNAOm1lpFFgNCM5z+QgWVLvDS40u/KAYQHjMhBK99gsZjTUudthUzg/i+rHqd4qHnPqQQV5OQXgec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlR5/oq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlR5/oq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A7EC433F1;
	Tue, 26 Mar 2024 03:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423188;
	bh=/cpd/Wno8DiZtEQPfzes66bd0qh3XmtYVKfARwOOHlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OlR5/oq1jcY2WPpjvNvUKw+UQUdb3zNOYIHCTnz++fn9Sr84Le92MOnm2jMLiLwN0
	 mB2sEhuTA5s8QNRYBL4DQWiaL/qbmLeedrcoptHtZPuz/VgIigCyMQ7lSxXp1sq2ZD
	 eHeZLiA8fPegfOLyTbhsvW5X6/ILwgkTNWYTQvNKGi0GAkXzxhPZuA+00Uz8kqPYD2
	 rWoOq3P2LJ4BwR3+OgSExbINx92KJQPixwJLEOILVK11qIODoKRgOMt857CITLlaGA
	 +QGsF5S82sfIrOCujesbny3oNgOVUeJm8JNgvV4nMRQjUWXY6sI1306lpvDBZMkAB8
	 WzGb0Go07uJsA==
Date: Mon, 25 Mar 2024 20:19:48 -0700
Subject: [PATCH 65/67] xfs: fix backwards logic in xfs_bmap_alloc_account
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127895.2212320.13666458658733112622.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: d61b40bf15ce453f3aa71f6b423938e239e7f8f8

We're only allocating from the realtime device if the inode is marked
for realtime and we're /not/ allocating into the attr fork.

Fixes: 58643460546d ("xfs: also use xfs_bmap_btalloc_accounting for RT allocations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5e6a5e1f355b..494994d360e4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3271,7 +3271,7 @@ xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
 	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
-					(ap->flags & XFS_BMAPI_ATTRFORK);
+					!(ap->flags & XFS_BMAPI_ATTRFORK);
 	uint			fld;
 
 	if (ap->flags & XFS_BMAPI_COWFORK) {

