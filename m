Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B901A2654
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301983; cv=none; b=m3ew1uBXnlyYab+Q8tzmcnVPVug2gztHhv3KLeb4gmCNVytAoekGBCFNSDFMGI6cr2bMtSbp+cLRI5UT9EBH0lWbRkm9eX9SSrNCIzryCGnTLun5CV90lwN9cTfqHos/EDO9BFOdlV+0YMoSSQYq+VE7Wb2C9EzXGgGS114ZMnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301983; c=relaxed/simple;
	bh=vtlfmftwg2p6QvLNVxCWHwUrUbnIs3nkMIz3kOxhX2w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=URkY39OhiE4YlsLIG9bv4SltpKLbezzr0nZN6Cd1IMLShhA3J9bUbt89mHgSLyaLSo51oVFiS2MbC6tlQWAR/qXYWG/9OsR5mKUY4Rg9wSzZKoF25JcAPNaIF1Y/0HeelliCS3W0AVnIjjz7GjS6pl/rsAJaWD0Ngf1DLp/lqeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvXF9rig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvXF9rig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0D2C4CEC2;
	Mon,  2 Sep 2024 18:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301982;
	bh=vtlfmftwg2p6QvLNVxCWHwUrUbnIs3nkMIz3kOxhX2w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cvXF9rigKXyTHc/pLRCKpOjoGzvxoyfL9LKjNEjXd+GBGkyRIa0Van3qa9oGeQGco
	 /ZJKi0o3rQurmZeGAEm806hQh7NvvRvLxqomGOYk6nUPJltiO5wpYfnnmAIjBiMGDP
	 rEO8IL16lNoZJR9q/u7RujhNA+lPiqHvRHpOGNXLUQwNlEomljbld6gMqPMAeAKfT2
	 /U4DousWHKcEC6PZFCBhcvAO5eU7OOiTaU6QWl2oO4UrSJ0ZWio/lheyzaQDXvtrep
	 CfE8BYZgBqdfJvjH93S5AhStmSTZqK8SDcWOHZUtQ9Q/tjyLD1ARewjGVnUQY0RgSG
	 wQ+x2D5raE7NA==
Date: Mon, 02 Sep 2024 11:33:02 -0700
Subject: [PATCH 2/3] xfs: fix FITRIM reporting again
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530107627.3326571.9730729950210869015.stgit@frogsfrogsfrogs>
In-Reply-To: <172530107589.3326571.1610526525006344754.stgit@frogsfrogsfrogs>
References: <172530107589.3326571.1610526525006344754.stgit@frogsfrogsfrogs>
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

Don't report FITRIMming more bytes than possibly exist in the
filesystem.

Fixes: 410e8a18f8e93 ("xfs: don't bother reporting blocks trimmed via FITRIM")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index bf1e3f330018..d8c4a5dcca7a 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -707,7 +707,7 @@ xfs_ioc_trim(
 		return last_error;
 
 	range.len = min_t(unsigned long long, range.len,
-			  XFS_FSB_TO_B(mp, max_blocks));
+			  XFS_FSB_TO_B(mp, max_blocks) - range.start);
 	if (copy_to_user(urange, &range, sizeof(range)))
 		return -EFAULT;
 	return 0;

