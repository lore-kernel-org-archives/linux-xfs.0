Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B65231C9C;
	Fri, 21 Mar 2025 21:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592492; cv=none; b=EzBwu92E6wQqCiXHgT7949EhC/ASFgfZg9vS5CiHl4XROvP/V1tdoK0k87ugulhqEUP88lVSkiraPUf3KwW66KM6ZBslEFdAL8jkBdgz1FLoZwEdRMhRkz7Z0Y7HeVtMn6+kHGnIkNV+GVGSqVdvufMgc2Xz0xP2KoPd9z8J7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592492; c=relaxed/simple;
	bh=mVOiviCv8uJtTr4gy0MKvCpfPl5bxRFzfKfog1sG0Og=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pRJF67fj+jPMLcGRWNF1STaxcPtH/qGVI6c0fE7MoNHmbODVRtjPxYzbhe9gWSYfhTfXG68Ni63hcv8eVWX5/EBWcLBuPo36VZdfcQnBbBH0nmRN6dHghj/6n69MLxsjuWjJdp6xe+tr/ddHNHug/rM0Z0fPz+X/A6b2OdcOr0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcGMxgLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcGMxgLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617C5C4CEE3;
	Fri, 21 Mar 2025 21:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592491;
	bh=mVOiviCv8uJtTr4gy0MKvCpfPl5bxRFzfKfog1sG0Og=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NcGMxgLcQnCgJTC+hxtTTCHMgQ1R2iEvE1/bkMVlMYBsm+40JLtOzx+Xbs5VAcCXj
	 jSi72kpVfWDWO8o8Fe41809LcVJHue++rv0Kkm5CHHD9O/Sxk0rR9DXTc5QwnTBIay
	 5TOs6S4acdyg9WBPMVgQiTvLEgyOVxC+8kxhopnl58sCNLn1DySimRsCVpN3Y0my6/
	 La5d4XsieF3UTjk/KFeTBXthHBnUf24cigA40cX6zS0TP+CkCs7MDt+SpW5/cSoThQ
	 yALb+XYEwRNZNjEw7Sh5K+RebCMMFzfHtkwUftow5jjl7AUvDQFot4oEtHb3Sh+io5
	 xKvH09HOXv9VQ==
Date: Fri, 21 Mar 2025 14:28:10 -0700
Subject: [PATCH 3/4] common/populate: drop fallocate mode 0 requirement
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174259234017.743619.10601450560372036830.stgit@frogsfrogsfrogs>
In-Reply-To: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
References: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

None of the _scratch_$FSTYP_populate functions use fallocate mode 0 (aka
preallocation) to run, so drop the _require check.  This enables xfs/349
and friends to work on always-cow xfs filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/populate |    1 -
 1 file changed, 1 deletion(-)


diff --git a/common/populate b/common/populate
index a1be26d5b24adf..7352f598a0c700 100644
--- a/common/populate
+++ b/common/populate
@@ -8,7 +8,6 @@
 . ./common/quota
 
 _require_populate_commands() {
-	_require_xfs_io_command "falloc"
 	_require_xfs_io_command "fpunch"
 	_require_test_program "punch-alternating"
 	_require_test_program "popdir.pl"

