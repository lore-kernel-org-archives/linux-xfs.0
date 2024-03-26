Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0190A1C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422217; cv=none; b=nFhjnZTWTQO+V8BLcyYAavgVfVxiPsjQlmQaZ1qXyBfxFBbSu4py2hHvaulNxCL3J/PXOCl7PgAG9GgZ4t7fmU3vFvRlIHkVeIUrGcftk9do6wn6xq+OL9KMsri/E5yaRNzmKLcACVC4J3M532QSmceBYJaAFj0/I5xfRgj7B80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422217; c=relaxed/simple;
	bh=OyTv+htQSKS9vMQEjvrijZaE9fPEaj/ce8h2m+CfSNA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rWAr/JJm6aKdp0JM2gOAnK1Agt0zr8W/HTjWi/kEcu7PkIFI7Rf/iz6CuMaTJlnzPGbPuJ2Ravq/VaqkfKqo2dQ4dD9k5QHUWX2GeMQeR75/arh2EbjwhNRqSHuZrHtb2F43Ka1TfRRtoPRc/FRR3yE3jb6vulfeVQMhQf+afUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FREbCucU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FREbCucU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6F5C433F1;
	Tue, 26 Mar 2024 03:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422216;
	bh=OyTv+htQSKS9vMQEjvrijZaE9fPEaj/ce8h2m+CfSNA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FREbCucUd0E7ovQS0we0My2pxNpl731LtnzisnEvmijJMauz+gPsSxagcwF6pOF54
	 NCJsOWGBaWTYVBjuTSzYsA4gQDkA+5AOnrKK9kOMVV+khoRvL8jd1XqaBCuXityCdf
	 PPAfED7lMGqg8YmzVeKA+IYK+wYVVf5JdJ+N7D6+xmGa/Ha2AbGFSAzVxKFCLS9pyx
	 jVEXvTyBtHj4R1r+B9Nwgh/NYdOHAEmApxNaui7ttfMoXHCeC78rSWMXXy4bCMT7WF
	 B4WCPjRGefg1UTAedHNFbIPLgyQZGwNgtzcM8ov3043FwomoySLKAVSueZdhvQkEg8
	 dhafMVxJqiE2A==
Date: Mon, 25 Mar 2024 20:03:36 -0700
Subject: [PATCH 03/67] xfs: use xfs_defer_finish_one to finish recovered work
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127007.2212320.10714611467885992395.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e5f1a5146ec35f3ed5d7f5ac7807a10c0062b6b8

Get rid of the open-coded calls to xfs_defer_finish_one.  This also
means that the recovery transaction takes care of cleaning up the dfp,
and we have solved (I hope) all the ownership issues in recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    2 +-
 libxfs/xfs_defer.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4900a7d62e5e..4ef9867cca0e 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -479,7 +479,7 @@ xfs_defer_relog(
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
  */
-static int
+int
 xfs_defer_finish_one(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index bef5823f61fb..c1a648e99174 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -41,6 +41,7 @@ void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
+int xfs_defer_finish_one(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
 void xfs_defer_cancel(struct xfs_trans *);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 

