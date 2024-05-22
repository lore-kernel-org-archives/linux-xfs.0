Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380B35234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347833; cv=none; b=JOv+bWpQEqOq2fJeFhrLf0rKPDYXIPlVlfNqjlIR24W+HOerG/5zizNWA0ONtrNvR++Qtm/CbJ357s9IXJ3rd4x3F1n/3PBqToP+qJbGAbZGODGf4Gd3DEGFP3NpOrW3W9mG3Q66j6j7n2k6Kk5SlFkIA0a73NjxpxZM/vMRgq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347833; c=relaxed/simple;
	bh=uFA6ERi+mjlaRTl5oQoqh1doP3nZ0tcqQ/p3sPFowKo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pxkPZGof24bs6Jf7hFl6eM8YMGm5dQwm/d6PhMxyjfwzhn3AzfRrdCwVOLjmw+4LmwQ8fr4tUiyl8j2GfLpgRzODILoKnjXu4JZolBtsSTsHV/UcYbay2ZwfL+6NnhQlHk7jkS0QVb/Tcy57toN1yXYDV5GgetE8oCeeYKF0w9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAN7l1bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAN7l1bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8EBC2BD11;
	Wed, 22 May 2024 03:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347832;
	bh=uFA6ERi+mjlaRTl5oQoqh1doP3nZ0tcqQ/p3sPFowKo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FAN7l1bbHiJMEvndnDY8XuhxrOsowFHOqp1Tw5Vk/EJPFTCDs/QLuGU1bMG/2c1bE
	 yVLJn4y4IMyCfg2Q4OoVMBicaxkb1IYyHRcPOezF9LnjZPWenJgW/p9PchoAdPiNrK
	 DFqMIGEC9buuN7LWECKOrMU+UclBfPqtaxJQETSuA3HqJM1v9NUl5kibZ9vMFIdKYF
	 UuiS6c1XowQdUac4gh6qy08MgciDC6P/Qz18n/fazpnr9CCTZYUwXNbH+R/Yr/eDxT
	 dpKmbe9h9ENrhqrb6Zi+pfK2I3wqtVQeXk0IC+ZqsoFQpNcmJvoIy6D9s7rLTACPod
	 C9g9Rf1hqBPxA==
Date: Tue, 21 May 2024 20:17:12 -0700
Subject: [PATCH 109/111] xfs: xfs_btree_bload_prep_block() should use
 __GFP_NOFAIL
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
 Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171634533338.2478931.3396589096501088822.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 3aca0676a1141c4d198f8b3c934435941ba84244

This was missed in the conversion from KM* flags.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_btree_staging.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 52410fe4f..2f5b1d0b6 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -303,7 +303,7 @@ xfs_btree_bload_prep_block(
 
 		/* Allocate a new incore btree root block. */
 		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
-		ifp->if_broot = kzalloc(new_size, GFP_KERNEL);
+		ifp->if_broot = kzalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */

