Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAE95223
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230654; cv=none; b=B6ZMUKZMjcAMOnpJRopW0BCVQGxVT4+cV4w6n3THN5BMI7oJt9xf5az75iARkpkSh3OvLgtVu07OAZ1+l5BngAYXZmz7E77g3yr4MMBZLp9ULTsLB7WpXmJ6IjIipAjk7cUs0s414FgMXj71ckv9PCa5Ee/iNlkHCuyO5SXVljA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230654; c=relaxed/simple;
	bh=EqolgGLZTNItbyakPVtyVNDgo59AfiA83rAzgavNmYY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HKAIijH6OKAVtJqWVDBCOY/WsrdHMMDIZXqweKTYRxlMumhecpasqW0hoOt8J5rXat0R5f5RP4DfMVen2N1m4Gw4aiAGVSVZT97A/oXcgHFuoDO5UzZw4uU2IruOxP0nunmhfIkZWQ/WZPdIVqUgnykcz81nd0clQbIvmpb0DSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MV1QuufI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MV1QuufI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA95C113CC;
	Tue, 16 Apr 2024 01:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230653;
	bh=EqolgGLZTNItbyakPVtyVNDgo59AfiA83rAzgavNmYY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MV1QuufIvZxCAcgM+9Ll5fHL/IkJeTl+xndJGvMXhXYgx52mSxWCeKsUdwLohiA+0
	 sl3yTUqZi8ZDcbj6fjVcaI3aAKOSe9nuck7Tmei3eWFSZTu5PIN23mxMwphXbuT2Pv
	 xgQkUeNN6OIcIBUoII0AfXHa890bF/FbuoWYWU+GQGW/adNtpIlwsJWUXynhQGgpoP
	 MDbRc/MPoh4lGYN+799thckPNbhKl+8c6ICmdTJHrRFBrL8GyiaW1NcTVvIxpZ23FS
	 fy23Olq9l/5C3kVb4WFAdTHlPg3M/jbBNdGYZkQ4VNxoKifRBPwuWYGDcXH4wVytWe
	 khJatS9AqsNMA==
Date: Mon, 15 Apr 2024 18:24:13 -0700
Subject: [PATCH 07/14] xfs: restructure xfs_attr_complete_op a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027185.251201.10317514123596708301.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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

Eliminate the local variable from this function so that we can
streamline things a bit later when we add the PPTR_REPLACE op code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 54edc690ac1e1..ba59dab6c56db 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -432,14 +432,13 @@ xfs_attr_complete_op(
 	enum xfs_delattr_state	replace_state)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
-	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
+
+	if (!(args->op_flags & XFS_DA_OP_REPLACE))
+		replace_state = XFS_DAS_DONE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-	if (do_replace)
-		return replace_state;
-
-	return XFS_DAS_DONE;
+	return replace_state;
 }
 
 static int

