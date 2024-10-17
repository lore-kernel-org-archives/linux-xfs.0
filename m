Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178C520100C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190998; cv=none; b=Q+UI+j9QVCPxRCQlCZ+izosuNEFeJqedyRAzNHLpKOD+NCp05yJXzSsxQjhSLhrDoSs1yuyRLSpbT4duoLJVR+aBv6kPvmKNqOc/vDguSqucwG6taQwq45X5aRjZad+GMdtpZQHlUjWjdUE4q8WxwcpZAzJ0bMXhLhF7gOGBu7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190998; c=relaxed/simple;
	bh=3o2OzYz4z6NdmYM5pKR+q3PpKSxN0KvhKLO+Jkwf3CE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFaHmKYHGzn/YvbcxKjDtsCDJLYrmXlWiXhhdTShDprea1HbivOGX9pMossAqMPIZ156e85RjTDGz4lze8AMjv1M8C1hd5rTgITGn0DLv2NOKMoFZy8CWw6IoJ/H9jZaeufwyq58rmnWf5LRQFcBtrNGyaqyRAHUFe8su5P1RNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8ccTVRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8ccTVRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862E5C4CECE;
	Thu, 17 Oct 2024 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190997;
	bh=3o2OzYz4z6NdmYM5pKR+q3PpKSxN0KvhKLO+Jkwf3CE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j8ccTVRAZR4adKfckSeDBgjjwJnu1id2oCHBLywfGPVQJjrApJ0PPoxQuGrCkwiiU
	 f8js5azKRr/Mo/8pObuy7qhw5L7xqItgHnY9LIjN5GzZ5SKBZL+eBo0T9ogtDPXlFo
	 Q5dv+tBuhh0279Vv+1s5ZIYgAJRtvt1/JPELvEBvjR/A5eTi3hR4lXBcWk+k+mKvJk
	 M2L8GyZKBrGGilSl9RFjreqstipLoDuU9KDYfz05w65M4hnGdBcRUBVt+R621ca+Xg
	 5BkxLgOCUcnpLzW3cqobzCezen4JlMiJE2uvN/aKeoluzvJeRamHTQfw+iGFoinhWs
	 /JbP6dux8osbw==
Date: Thu, 17 Oct 2024 11:49:56 -0700
Subject: [PATCH 12/22] xfs: remove the unused xrep_bmap_walk_rmap trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068068.3449971.14753486234333518584.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    1 -
 1 file changed, 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c886d5d0eb021a..5eff6186724d4a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2020,7 +2020,6 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
-DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

