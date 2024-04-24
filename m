Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050C131E54
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928810; cv=none; b=iZzQo006kj8ECECqoUTzWUyRnpJqZP8+e0Qvod6akw+PLg5A9Uc7jOUOss0FuMO1aehlYH9otOtfKejgcM2N9q+hlQgNb1S7rCp8SuJMgP1mPGvxPUnrmtPnln+S5Jp3V69JJvLPwlG4JBRw7eFKP9KfDeuIicljpoD816PehGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928810; c=relaxed/simple;
	bh=4qCxMkU/hgHExO2KZcRnPwpp8kvRD3TZToHdV5Prw4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrQhjbu9RQiDl4JZY9DW0Xhy17jpyqAld2tAt+hzKHnWjuQMTPXKVx+qMR0uDAUYzT/OI8YVCnLVLLSS5SgXdVJhMBxbMgp+HXJJFMQ48c2xmzhB25HXaQEZJJaxwiYLs3myt+9/TZ1E1V6VXqGCdbCe9nAattU11CWWKb2/pLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/+tcFpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/+tcFpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9730C32783;
	Wed, 24 Apr 2024 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928809;
	bh=4qCxMkU/hgHExO2KZcRnPwpp8kvRD3TZToHdV5Prw4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n/+tcFpUfsQ8oWFh3okcRJHxulWmajiHTONKA6ChkxPhmBzjT3jQHdf8eZu7bA/c0
	 3Wp5hbRrNgY5QzwrYc1mHBtsAgFs4ttPfmnbT8co5/cVE3mlVMpBx7J8+I4IiRj0nV
	 TvrwMLq+1lpfubC2ZXOICLi3s3FUPj8/mofHprgwCMDqiLe/hm2NWduF84YK17/aEC
	 vKbheXj8CkKECtFJAzFTUTnbFR6qzqnMbAzzIKc3aQYsoiTSDRPc1Sh4/zjoSsxyt6
	 STK94cB1/c6cpVTa04S9iNHzlmNyFu61maYDX4XyAuTdIxbzFx/rLz65y153neN2+9
	 w83ZDaTO8YDWw==
Date: Tue, 23 Apr 2024 20:20:09 -0700
Subject: [PATCH 29/30] xfs: drop compatibility minimum log size computations
 for reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783760.1905110.15767634966137162393.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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

Let's also drop the oversized minimum log computations for reflink and
rmap that were the result of bugs introduced many years ago.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 3518d5e21df0..d3bd6a86c8fe 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -24,6 +24,11 @@
  * because that can create the situation where a newer mkfs writes a new
  * filesystem that an older kernel won't mount.
  *
+ * Several years prior, we also discovered that the transaction reservations
+ * for rmap and reflink operations were unnecessarily large.  That was fixed,
+ * but the minimum log size computation was left alone to avoid the
+ * compatibility problems noted above.  Fix that too.
+ *
  * Therefore, we only may correct the computation starting with filesystem
  * features that didn't exist in 2023.  In other words, only turn this on if
  * the filesystem has parent pointers.
@@ -80,6 +85,15 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * If the feature set is new enough, drop the oversized minimum log
+	 * size computation introduced by the original reflink code.
+	 */
+	if (xfs_want_minlogsize_fixes(&mp->m_sb)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

