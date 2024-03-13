Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55C3BA33
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295752; cv=none; b=SxlqjudnZJoi3/sr/YW2G3HzmvcHSzmaCiWWhCkJFq9uB6WXkoNexipfmXvqnrmRJdSYxQjrQmJtmXZ8vRWDkAf/hIxrQJHNZe+KTJojex3ta0NPVWXLSZ6oSnFJZ41BlHuOXmjlwXrM+2i04BZiZFx1uo7QcOMDfYOdUBTViEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295752; c=relaxed/simple;
	bh=DWuvM+dKw/66ZaNybARal43QlZQJwWlbxX+QWpPT64Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuT76Irf9/AcZY2QRvoupS4BZoeq+uGSZBztD/a/2NaKnXMfxoAjtD9oSqnHnVhtA5i4mLEzbSLpOKRzt8mq6/WAdcLEq4YGD/FOurcNY+1mTs9fxLwQid0ggU3+2SAMqTjep/1FFLQFutMnJPI+8ITrd0JOBRU8O3xqPchss6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bG0LeYKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bG0LeYKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E4EC433F1;
	Wed, 13 Mar 2024 02:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295752;
	bh=DWuvM+dKw/66ZaNybARal43QlZQJwWlbxX+QWpPT64Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bG0LeYKjTS6ISJ/BW5TOSiM9Z4DHt0l2jVj0+ii6V7bnvNVhY80xdt273HMJYvy/w
	 wYxrYDCUINkuCuNoFLV224eN7ZOPrgdp+okj0UpL1ErYcqeh3QALoY4evasNaGnxFC
	 5RiSpugFAAECgGoa6nuJd2CVVv/FeUVGuKtEmzqTclL/lfRBHFycbhsKchb85HGdFz
	 2aTwg77IaHCOeIb1NtBSNagi5Ci19+GxGVNqAoHou+7vSjgNj1XsRSVZY1mK3hnT6R
	 RTQTk87HdP3udaBC5TMLFgU9ZFxbHveLd9YciSB4HxYvpXy/vF/NPCBYYLY01XpMgk
	 BpWs9qrhgXDSQ==
Date: Tue, 12 Mar 2024 19:09:12 -0700
Subject: [PATCH 62/67] xfs: turn the XFS_DA_OP_REPLACE checks in
 xfs_attr_shortform_addname into asserts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029432089.2061787.15016455242739550153.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 378b6aef9de0f7c3d0de309ecc61c11eb29e57da

Since commit deed9512872d ("xfs: Check for -ENOATTR or -EEXIST"), the
high-level attr code does a lookup for any attr we're trying to set,
and does the checks to handle the create vs replace cases, which thus
never hit the low-level attr code.

Turn the checks in xfs_attr_shortform_addname as they must never trip.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 055d204101a5..1419846bdf9d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1070,8 +1070,7 @@ xfs_attr_shortform_addname(
 	if (xfs_attr_sf_findname(args)) {
 		int		error;
 
-		if (!(args->op_flags & XFS_DA_OP_REPLACE))
-			return -EEXIST;
+		ASSERT(args->op_flags & XFS_DA_OP_REPLACE);
 
 		error = xfs_attr_sf_removename(args);
 		if (error)
@@ -1085,8 +1084,7 @@ xfs_attr_shortform_addname(
 		 */
 		args->op_flags &= ~XFS_DA_OP_REPLACE;
 	} else {
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			return -ENOATTR;
+		ASSERT(!(args->op_flags & XFS_DA_OP_REPLACE));
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||

