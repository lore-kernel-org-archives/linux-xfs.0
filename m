Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB1F15381B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804045; cv=none; b=fCzBPLeFQeJ4kab1q1PzmtDypEoUe5ZlsC8OoA5bJ1lkJNV+po0bJPDJa/RBGR0GzS6O/ZEpuh1ZTRLO1M5iaizLYpjyhilzT5RVrkTChj4nPTa2RopVCARvInGGMrV6SxroypXsqRm4rsw88ERBLSRP0ctBq6ux1NiHMgnofjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804045; c=relaxed/simple;
	bh=xRNHjvWn5Og4xBVEKdmGXR6/2SCdprMCyu8SEUdqwB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBRtj+I/T9XQ+2Jdnelei7npcDG8wzlmOOx4lt0QAnw+iOTBSlPGcfscB2BYYpvkTO+CNuneZcpdXaZW6mIqiVzeqGJCco/T+K85WZKK//AC0MfkohNRPxV0DyWXYOMEp6ycYnwMfaV4+v+19tzVF1pWZ//VyP26OUXn0Akt53A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmFUXjVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmFUXjVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28739C116B1;
	Mon, 22 Apr 2024 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804045;
	bh=xRNHjvWn5Og4xBVEKdmGXR6/2SCdprMCyu8SEUdqwB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmFUXjVwTICMdWAUP6nOSJ02Iuebbkb5dDmRYvNKPHmCJdbyEbtwc7te0UY6tksX4
	 yfUnWNiN5ImGm1pLmI7ICi8sCrw4SEbFar/wOen4P48NMlmCUTNL3GkosA8jZLhrcV
	 5jLSb4b/5f/LJjy2xE3LiRvWWY51oWtAboXm0FmLK0+SGE3Li1m0BcdPAQUbPG4llO
	 drnqDnAGHd9H8a8ZV6X4ii5WxEJP9jk36fp5YPVOVJXPsiEJARaiRM0BAgr3NM+bnB
	 KMj5fBf12/Vqr/CtHOr02A/S3bedszi02IrvD7HNn10HRzrLQj551f9pfsYKA8L4uH
	 5dc7TTRWJd+ng==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 64/67] xfs: use the op name in trace_xlog_intent_recovery_failed
Date: Mon, 22 Apr 2024 18:26:26 +0200
Message-ID: <20240422163832.858420-66-cem@kernel.org>
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

Source kernel commit: bcdfae6ee520b665385020fa3e47633a8af84f12

Instead of tracing the address of the recovery handler, use the name
in the defer op, similar to other defer ops related tracepoints.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5bdc8f5a2..bf1d1e06a 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -915,8 +915,7 @@ xfs_defer_finish_recovery(
 	/* dfp is freed by recover_work and must not be accessed afterwards */
 	error = ops->recover_work(dfp, capture_list);
 	if (error)
-		trace_xlog_intent_recovery_failed(mp, error,
-				ops->recover_work);
+		trace_xlog_intent_recovery_failed(mp, ops, error);
 	return error;
 }
 
-- 
2.44.0

