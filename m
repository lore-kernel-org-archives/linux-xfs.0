Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802DC1D7982
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990437; cv=none; b=QeVlrQZkgePT/a1THdf/ifPMMZkCZrdmsdcTVZGvPRqreJO2MR5W1x01fQ719om5BQVJ+mkHQ4HoJzXmTzlaI32MSRNQ0lMpp4UKHOp361fph6Qks4FHR5pg6/UhpPUcxkTlH7aDD4I6xDtnbdIMx2yG1+uMTe5B40sW+6o5NIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990437; c=relaxed/simple;
	bh=kWE442pT3RSOyEdCIrLuZKELUQVa+ZtuM6POBwDpYms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MGLNGvPaFikIUM9hj8cGdfVVdJdZv6Xt0Yan8VYZ/B49ahSZTG/fxxFBENh8uAs/6WTD+tPcTsFS6wJd5YQjDD3BmpTqMbzF9tKzVBYS8qV0a46Plu9CPRrYwS212eQMGwNnIoF0mVhet9/T9pHbaTGZG6Z4iMgkK+T3efHyVJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1eSpHWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1eSpHWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58718C4CED6;
	Mon, 23 Dec 2024 21:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990437;
	bh=kWE442pT3RSOyEdCIrLuZKELUQVa+ZtuM6POBwDpYms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F1eSpHWSB2UsqvH0tHpZRG9EAa0YBpResCQaKMW6U/2ST61urUpBErJMxdBVQPvn5
	 kuIC/V11EvBdjSFbuHLXm7gtNixoGVkEInpsF6fwFJ69JWgu7Sm04x27fFdTUr9e7s
	 HWGxWPhXi0sM43A9abR6o/ZzZFOeG2ODBCrlyPkELe8c72SAZP1399EJvdVMPL5Aqm
	 Nv5qAH90XomeIQwIYHL78u20YaxdsIgKqFyNS0BVIjmseDSAYXh+kWk6WXvqJ9SD7g
	 z1pCsxTuScYwOIRTmQS/ahS/OqkIhas7WYFKlFzTrk2yNBkQphomsAWNwzApwkqkqF
	 +XFqzkE9ltSPw==
Date: Mon, 23 Dec 2024 13:47:16 -0800
Subject: [PATCH 03/41] libxfs: enforce metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941012.2294268.4220474805447112535.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 1eb0bccae48906..0598a70ff504a4 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -208,7 +208,8 @@ libxfs_iget(
 /*
  * Get a metadata inode.
  *
- * The metafile type must match the file mode exactly.
+ * The metafile type must match the file mode exactly, and for files in the
+ * metadata directory tree, it must match the inode's metatype exactly.
  */
 int
 libxfs_trans_metafile_iget(
@@ -232,6 +233,12 @@ libxfs_trans_metafile_iget(
 		mode = S_IFREG;
 	if (inode_wrong_type(VFS_I(ip), mode))
 		goto bad_rele;
+	if (xfs_has_metadir(mp)) {
+		if (!xfs_is_metadir_inode(ip))
+			goto bad_rele;
+		if (metafile_type != ip->i_metatype)
+			goto bad_rele;
+	}
 
 	*ipp = ip;
 	return 0;

