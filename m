Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D571A1E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389893; cv=none; b=tluYVMpRmPkZoPeQ2QB9JLUrI0uThAnZk7HhfailxX5VLa8h9xUPKndkia5s7xWwhkajH0Bh7gKsY5S6oS5Me8mkxPHW8Irn+Hni+NNkI/66y1MiZyI3lTF9+5+0p8D0WC8wVp1tmWP6RwpM9jS/DGZMMW1DYXOAH0M9ze4Vjj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389893; c=relaxed/simple;
	bh=vGdaFroVnJjz/8Vqwu1fIGIphqX2uQ+9v19niNsgfoM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjqfk/rHK+sjJZKJR4SJPstiP7R5ZzK3Dcq0V0vzrBOmnRjXHXL+wXbyF5QedzVMH/eQ49pWjDqeBcnKRLEMeTMWXYXxPLMICThHpod77JupKDpRbDrTh5C720wUanoERT1elU7o/QBMWi/1cMHbv0KP4VvKbb9k7+BkhyLwkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwoJisip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwoJisip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A350C072AA;
	Wed, 17 Apr 2024 21:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389893;
	bh=vGdaFroVnJjz/8Vqwu1fIGIphqX2uQ+9v19niNsgfoM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uwoJisipPiI0eXY+rKIuOJy+2JDYhUecrahTq1BdwVf7HMmdvYnCAdvBZs9jZ9vZH
	 yIfEA1mni6kVqzdGzQoNnyqtcGi3e1wdejpDn25M4ICYfsHY63MA8svWHvsK+5lXMJ
	 mIlNuh2vDbM4Y93Umsbj7AKwOgi/idjqBqEH64VPY/BDJZrIHvrBMZ7RjkgI1fKmOU
	 M4qtEkK/eNOIOFgA9nvNIYcaWhY096Ev9CuJGNCVUeRjKPDNDGust1+bevHSyUpfsf
	 MLCeqAVot0dBnbcLHpIgz17C8YSA6lfHTtj1OWahfnio0Jk+lfAp4/dnqPb935qSI+
	 9hgRv5eQ6QpbQ==
Date: Wed, 17 Apr 2024 14:38:12 -0700
Subject: [PATCH 63/67] xfs: fix a use after free in xfs_defer_finish_recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: kernel test robot <oliver.sang@intel.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843286.1853449.2542062323932218911.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4f6ac47b55e3ce6e982807928d6074ec105ab66e

dfp will be freed by ->recover_work and thus the tracepoint in case
of an error can lead to a use after free.

Store the defer ops in a local variable to avoid that.

Fixes: 7f2f7531e0d4 ("xfs: store an ops pointer in struct xfs_defer_pending")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 077e99298..5bdc8f5a2 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -909,12 +909,14 @@ xfs_defer_finish_recovery(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	int				error;
 
-	error = dfp->dfp_ops->recover_work(dfp, capture_list);
+	/* dfp is freed by recover_work and must not be accessed afterwards */
+	error = ops->recover_work(dfp, capture_list);
 	if (error)
 		trace_xlog_intent_recovery_failed(mp, error,
-				dfp->dfp_ops->recover_work);
+				ops->recover_work);
 	return error;
 }
 

