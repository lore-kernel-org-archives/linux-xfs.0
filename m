Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B22537E5
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389972; cv=none; b=OaBC2+1eonAYCVJ/RqzNeVCu6iuUbkaQGvKWTLYyn8DulxJLUAON3D46rwA1vR1ZTdHuiAj26eVrRZjSy6DzsKYkOw9VO4eIdnBMzv5W0aiYQ1wFJtp9mr/rvy7gL9bgfB7aabBJipl7QjtHx51QJMEvm0ClvWXnB4ND9wX/reU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389972; c=relaxed/simple;
	bh=YKuxGwf9zhfNdpouGiyLx41JvFKhquiThxRtO/6vXqk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kN0WHhwPVBkymkPCMy5bJj344nlHoDxlajCDvKCQeIOkfWjxGPmn73YHz6Gx2c7rEaxE+cm1AZDfQnew+azt0OsBrcMdGnlJ/CJ4E0hzrCQT0GZQEgv1qwX6JwZrbXqFjS6EtnJVST+dxCMYkFa0EYBgi8y0eIUTY4DtUolEcz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCkrkLxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCkrkLxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A94C072AA;
	Wed, 17 Apr 2024 21:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389971;
	bh=YKuxGwf9zhfNdpouGiyLx41JvFKhquiThxRtO/6vXqk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TCkrkLxFmJ8BkJ5uvIEBuv1AgVbHspcICNkTcMjqUDG+sJwYuGnyYRf4eIUL0rgWm
	 r2KOMWpEuU7TgPenWkbFHtdmqbR1N42eIIDvdgwmGnRQTnQUqMbTQrpEfmpMBetF7M
	 OgRDnlFMVN6RtZxDQlJoBAnEpKuXOIiOp+S6QphsgK5lC4iftU6bFWvLoAgx23J2iP
	 vqSw+hnq/SWuCCcsSmobGkY+JGUUlDiFtK2uUiwmOH36ca68XxU5OsxZKMM+8+Xy1V
	 phOe0bcIo+38f/mxQjBl1lf4diCq7sA4IpxG5yFNK2/NoKx8BvBGqmWFatxV4XCxsE
	 DF0KOBR6AHczQ==
Date: Wed, 17 Apr 2024 14:39:31 -0700
Subject: [PATCH 1/2] xfs_repair: adjust btree bulkloading slack computations
 to match online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338843660.1855656.13473573874838399965.stgit@frogsfrogsfrogs>
In-Reply-To: <171338843644.1855656.3052850818331228701.stgit@frogsfrogsfrogs>
References: <171338843644.1855656.3052850818331228701.stgit@frogsfrogsfrogs>
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

Adjust the lowspace threshold in the new btree block slack computation
code to match online repair, which uses a straight 10% instead of magic
shifting to approximate that without division.  Repairs aren't that
frequent in the kernel; and userspace can always do u64 division.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/bulkload.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/repair/bulkload.c b/repair/bulkload.c
index 8dd0a0c39..0117f6941 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -106,9 +106,10 @@ bulkload_claim_block(
  * exceptions to this rule:
  *
  * (1) If someone turned one of the debug knobs.
- * (2) The AG has less than ~9% space free.
+ * (2) The AG has less than ~10% space free.
  *
- * Note that we actually use 3/32 for the comparison to avoid division.
+ * In the latter case, format the new btree blocks almost completely full to
+ * minimize space usage.
  */
 void
 bulkload_estimate_ag_slack(
@@ -124,8 +125,8 @@ bulkload_estimate_ag_slack(
 	bload->leaf_slack = bload_leaf_slack;
 	bload->node_slack = bload_node_slack;
 
-	/* No further changes if there's more than 3/32ths space left. */
-	if (free >= ((sc->mp->m_sb.sb_agblocks * 3) >> 5))
+	/* No further changes if there's more than 10% space left. */
+	if (free >= sc->mp->m_sb.sb_agblocks / 10)
 		return;
 
 	/*

