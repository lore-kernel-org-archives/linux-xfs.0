Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B83153BF7
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804042; cv=none; b=MtyOEnkBl52shoVusPJTaZ8u1wPKmyAdCOopnOQ8UQCHyTgbr5mhl26LH76Ahrf8kSuB2rtBOvS+iVw3l4JDmik/xRwYGv6eepRZQHAcN/PxRT/MfPwdjrdheTsK3b+q9v7T92msRNbSRUVcmbj9YVCxk8/XuVr+HcsAadWVzT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804042; c=relaxed/simple;
	bh=jEoFC4aM18HUrTM8+QOIFOXGfB4V2prlJjGz46dLOfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbXfH1BWRVDhFEae6qTY5sMEFUkfuhUIlV4O4wqd2I++qv9L4PIsx4aLeW9vUq0seZvyHi3mNzlACnGnffVW7EVK76BxKfC1zNyPouC76vS3n2MQFbWT+JcmmhgEo4kyeei0PwhT2bZlfENubTcMhsGlq5PbiR3VCZVhMT7/M1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYY0fXyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYY0fXyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D6FC113CC;
	Mon, 22 Apr 2024 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804042;
	bh=jEoFC4aM18HUrTM8+QOIFOXGfB4V2prlJjGz46dLOfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYY0fXyExOo3UWlOFjbrrSo+u3mQJ4KIC1Turwk+BHZ4hzzc3C0M8Fbt02eIGy6lX
	 CJLXeuIsiUnWmf1WIlGofSGg5rI3rk5ISuB/PMcCbHy7Pcv5ZOGPeYSUa9qrO83H31
	 OiJm9d6LVMfiQXWaBEpEhr8tDMpX1cbiEgb6gtzVcWIunZhkYeYEGYCpKiBdrhE54f
	 AclAUSvJYNJhv2ZhxeJ/6BEzuqlM6HCAs3IIwOgxf7ZbqCbdSqFVLq7suTNqgCFJov
	 ZIASbC7oMVJkrCJfEOPyJEaSc78e5kAgxBBjej6ThTTTTa6I69bIz3fg7iC3bEZyDm
	 WgePpWwAU5SSg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 62/67] xfs: turn the XFS_DA_OP_REPLACE checks in xfs_attr_shortform_addname into asserts
Date: Mon, 22 Apr 2024 18:26:24 +0200
Message-ID: <20240422163832.858420-64-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 055d20410..1419846bd 100644
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
-- 
2.44.0

