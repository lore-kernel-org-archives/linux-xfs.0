Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A8457314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423141; cv=none; b=T8bPxCrW/X6IZ45q/rbdJdDUpBq+F5/VCwsCdleAZJ/vwhqgEonVe4tCgXe14FaWWkj3q4/XrCFYSsFNv176FUNidfF6gCZf8P6SBuXxNypL+VcPjX0Ul5H6Ljudo1IfJF5wAi0lardizyriBx6hjBD3nYXR5ERF0obTKy17qKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423141; c=relaxed/simple;
	bh=gQelqOJEJHtVJTmadwvEs0PNWnHBgm5ekYZBDuiFOd4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1fOGMnYkbpfG/eRHCWGuDppaRfVbpyRrTmhloo3G8/MyMNiBXJpu5BS7pOXkolZ+STZMPOuvEjZYV1//YDYQCREFNKj6Ufo38rPhGqgn2++gRtAXSh+125INOweN9Xr0znJZSLfB6J4Yg0mY7TIPcWneQYbUffmHQWumsCRvR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rKHucGxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rKHucGxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6306FC433F1;
	Tue, 26 Mar 2024 03:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423141;
	bh=gQelqOJEJHtVJTmadwvEs0PNWnHBgm5ekYZBDuiFOd4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rKHucGxA6TvogUuRvmCx+KBU7SjpVmFOq8pHEpITRdzo5mgF4yswKpeBybQzilIad
	 ay8Q4GL2W2t09TMTWMvVvqIqq5ifsyE489okcNGba+Tp+NRhcqB5e3vsdMW+q6nZIu
	 Dgga1ZeEf28r108tNWL0tMEQilAeUm5CRan2uPCW3zvmSNmtkHA7NbJj/Zzogen0tY
	 t7j0R9680hAjIcwdCqiF/xd/gtyIX41IPsu+W/sSTz0XAaMDC89cHGAKII9VPYWTqZ
	 ytpP+814RNlhpCJgygv5VH5NzlHFCobOgAq2v35AzMlyYpdjmDcCj98mQZMftXqmnK
	 UNpZT7aL/HRsg==
Date: Mon, 25 Mar 2024 20:19:00 -0700
Subject: [PATCH 62/67] xfs: turn the XFS_DA_OP_REPLACE checks in
 xfs_attr_shortform_addname into asserts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127851.2212320.11824551539799681617.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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

