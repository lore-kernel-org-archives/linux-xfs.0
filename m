Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334552F619D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291293; cv=none; b=YTI8i2pHC+XmFtPBQYfRjSBZKv+nXx8RAQwKYpWNX6l80Qg8XE1BzgUYnBbiXm9GfylUOJzPoFMDhYZqVFhpkJxZnt2YoSRqRFfVSRy1/LgwPJId5wdGtdN4vFN43sg3xcP0lbiwMgWCm7VmQnvhE7NFieNkPH938gCBUk1chVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291293; c=relaxed/simple;
	bh=ncg0NJ/rxRcCw6PH0ueMZT+hv5+VEhQ2Az8cykSbQHA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQsTRjMKtpYvDtISeg5sRjhxH7Aj134KdWbaaS226qE69STuklfgREYKo8kKk4WL6R7iNJWyaiozaZVNR/B4H6pzqSSVlEn9vdf06oRjJ0HxdI+vkAZu+fg4x+a+ZzHnEADJpio0sunc1OAhHPChobKVJ5P/dCN8i0BSIDqtmHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fgUT5ViG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fgUT5ViG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08619C4CEF7;
	Mon, 23 Mar 2026 18:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291293;
	bh=ncg0NJ/rxRcCw6PH0ueMZT+hv5+VEhQ2Az8cykSbQHA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fgUT5ViG+lKx9rH6FYAk3N3eud1K8GmsMrLGMRS5NYxI+a0dW4VEeKgeFZUqQ/dyA
	 l1YvI2Tc6fxP37+1Bt9+LdgQNoFXpTMPbuMtNbmDTg050w7nkWozn6lBnC4TezpjjB
	 deE0QQcbyh5bx67ZXkMWgaeB6OKXcdt7cwcSQaTUIW+3fWI8gRgFHgaj3Wi1TjQ2ks
	 GC8Fq8VF+ewQ74KCbrU9Hj/5Mxb9dl3d28gOmvlkVVMxmC3rg8gBsjXDvZ1CuTblWt
	 EvI9cQwmL9gpva6ukVn/+3DeE6TD4JCdqnZbxCkXn1NXNQkBc9uhnVDw+CbAzOVUuF
	 uJnuxLjmW38IQ==
Date: Mon, 23 Mar 2026 11:41:32 -0700
Subject: [PATCH 01/40] libxfs: fix XFS_STATS_DEC
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177429120757.2266274.10399851330751546106.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This macro only takes two arguments in the kernel, so fix the definition
here too.  All existing callsites #if 0 it into oblivion which is why
we've never noticed, but an upcoming patch in the libxfs sync will not
be so lucky.

Cc: <linux-xfs@vger.kernel.org> # v4.9.0
Fixes: ece930fa14a343 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5474865a673e9a..f72f07fabdf21e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -183,7 +183,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_ILOCK_SHARED		0
 #define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
-#define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
+#define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_TEST_ERROR(a,b)		(false)
 

