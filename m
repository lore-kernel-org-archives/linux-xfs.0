Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8217E621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710317; cv=none; b=KHxH3JXjBbpupaJvIXHRPiM+wjrmDqjmxZkAym8eH5S4wR/iaCugYeeYfHyJYnby9BsT8+Yu7dYnLCgZ/CdMleXg7b72mAFmUnDdDV62WDawEA1GzIrXb2iAG2QIn+CJZ3tvnh8mFKDQ3KbfMsYOx+1H0IcZanQmhTV0ZbVA9P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710317; c=relaxed/simple;
	bh=1oW6JbfUMrWpedYRrR91RdEog4KMHWYq0V3FqRiPJH8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KlNi8+ljM/zPD5BEPZ/p0AgH/bnNXQDK0LsYG8hT1BSGHQbaO25Igwe7rv2qhxwGY8MJYpH8iHlsXZMdJn4ywP3d6+lS/qXS9pqvnUzLZma+9zS5a45aHt4Ts8uK4B20ZJm05b2IU3s9kt9z5VMdYkCGroj9DPajiHVugee+LqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7BHumP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7BHumP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59563C433C7;
	Wed, 10 Apr 2024 00:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710317;
	bh=1oW6JbfUMrWpedYRrR91RdEog4KMHWYq0V3FqRiPJH8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B7BHumP2+aIUfNhPhmvwa1qoRSPxYxeYXjyHa/Qnsb40sTHOyTG/dyk78BKflrF3b
	 PwnkSBNSfOkOyhh3z3iuXfq75da1TjsuD/vWQI0ZZfuFDxpyP3hVYueO9In9kF8czM
	 FlgsboXuf6c+t+Raz2brc+BZrOkh1OnQHVLqMi55Mc9Adx7GRne8z+Ne9PENij5Rsa
	 mdnZmgWH/+xiW3ocoK48V3RMRLLSymdlX2/IR6BfaXM23AX6Kss4wz13jUeLJTaElu
	 Mdqb/Nx1qrJ1EL0aXcX28COlm744rqL9pEIWlT1U0fTjf2QDeDRNlBaJGfL1d1u3u2
	 7CPZux+vVFtag==
Date: Tue, 09 Apr 2024 17:51:56 -0700
Subject: [PATCH 06/12] xfs: restructure xfs_attr_complete_op a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968950.3631545.4788373736144068333.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_attr.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cbc9a1b1c72d3..fda9acb81585d 100644
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

