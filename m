Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1147983A06
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 05:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725428323; cv=none; b=o6rlWOBH70AlishyD6rf0irQN3hUaVshdu6+3sZJ/KUVo4kJL9DpGQYrUSvOtd8ocZ1hXN6x12QV6Rw6QN/K1nAV9hlDPv+JnfEsyJHuYEUgZ1wDrneyOtaxr5GSB+P83rLynH2bvCLKczvEf/EcL7z9HAsLfI9QOGMSthCXJns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725428323; c=relaxed/simple;
	bh=6KMaVTjJyogOQdP2Bs9Sm1bSt3HrscVJE0noZhnLsqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFDnDIPFVtHjsNrGzh3jvbf3AImarlwY0xB64EPwF5oyqZnlbW+svM3knYghhYnGANnVnT9R67o+57NJ1mCwJ67rVbUUc3v1xjKW1qzzeuRPVHpiUREzrOzQqxNRIpsuZPy1yeUYGu8F7fXaZJ3eY3lxthSqXXtBII9e7ekjF7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gs3IHkMB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gs3IHkMB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X2JxuptafFSuN+SsF4DTRdc66diz6g8+LTcqNlja3iw=; b=gs3IHkMBw31EgTY/2KfYK0NzLr
	N17dBneH9Stj4SUuCAXwei/itAvxO6T/rDietIIyNiOYvq8TYL1CfnTVJefMgbB0fw+1zwI0UU121
	ZuHJoLFWZF7CgtwyOkXGB+xpFSI5L7NX98oZM01adNgh4lX0dBuN9W+jY7qjj0vySFXInLVxg0XDG
	RHRZKQs4MlmCllCBf3TSf2Jha+qlKgtmUGTcfYUSY2i9gSgKKINzo5D/OYOAO6kGAkPZ85VpekYTx
	+eZNrtCQnI2J3pfAN+IgmGa7msGVKHJf2bdzkJFGi/HhWOqKdwJOpHx/2P6R/bvchc2C2ESN2bUNR
	jNczInhA==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slij3-00000002v7c-0DMd;
	Wed, 04 Sep 2024 05:38:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
Date: Wed,  4 Sep 2024 08:37:55 +0300
Message-ID: <20240904053820.2836285-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240904053820.2836285-1-hch@lst.de>
References: <20240904053820.2836285-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just like xfs_attr3_leaf_split, xfs_attr_node_try_addname can return
-ENOSPC both for an actual failure to allocate a disk block, but also
to signal the caller to convert the format of the attr fork.  Use magic
1 to ask for the conversion here as well.

Note that unlike the similar issue in xfs_attr3_leaf_split, this one was
only found by code review.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0bf4f718be462f..c63da14eee0432 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -597,7 +597,7 @@ xfs_attr_node_addname(
 		return error;
 
 	error = xfs_attr_node_try_addname(attr);
-	if (error == -ENOSPC) {
+	if (error == 1) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -1386,9 +1386,12 @@ xfs_attr_node_addname_find_attr(
 /*
  * Add a name to a Btree-format attribute list.
  *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
+ * This will involve walking down the Btree, and may involve splitting leaf
+ * nodes and even splitting intermediate nodes up to and including the root
+ * node (a special case of an intermediate node).
+ *
+ * If the tree was still in single leaf format and needs to converted to
+ * real node format return 1 and let the caller handle that.
  */
 static int
 xfs_attr_node_try_addname(
@@ -1410,7 +1413,7 @@ xfs_attr_node_try_addname(
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
-			error = -ENOSPC;
+			error = 1;
 			goto out;
 		}
 
-- 
2.45.2

