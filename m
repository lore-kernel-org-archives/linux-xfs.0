Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5078248D
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726637497; cv=none; b=lTIhn92w+y62XplMrYEZ9bLXJMDgLDWvN2dEt3mvGPN1OY5hhd5VUSM9JxLxVehz6ep+7ThF4gx/2oXL3WW+ov8tChSPDZ6mydFNSEenvV7RJ9GqsW32ZFQ7862vMufuZvVHq0j8xowuOmQHjWmb2SHYXI8h2xmFUHO2WdV9bpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726637497; c=relaxed/simple;
	bh=XC2lZuCkM2t9sZZPzDnlmNMVMENLCC1pIoqQf0Dr7Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=melDordyMS/q0Dunt6p8D5bLz29IHo4Bdi3XhG9R0FA74I+79N3dXKyqyN8pkECtdkM5/rzeyVPcXUPIYChejaRH6k3f0JAGXwIhDBcdWjtFWqA+2nZjv4QoBhgV1MDn7i684z/G57hDU2jHgbYnCYGa3rjHz5u3XniVE5AgDgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BSrmKyjr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BSrmKyjr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C+ruOjrw4q9ixIV/80wE9Yy8f8N5bzhkP/0EoDdGKX4=; b=BSrmKyjrvBwD4BiJQGMW/DJuXl
	0nIh7PVZbQ31jCO/SQubqlqSugg6/WLYO6/NBFGVh4/nIAgIhX/fWCB8T6JBi+YlGFaaIBRc1oBjC
	qdLjmWKhj8iOSaYNHcCehwyte2cgJjiaV8qs8dXxpUSS9l8bxZZCn58fhQicSlt3H2Ufd4vKeXCi7
	rqArnblRI45nj3FMSDnPGsZzqmuII5/zGrnXKtQMm2V/QtoNjM544G2oPZ5/Xlwu7WATUeVGW52WK
	w6mNmg73SvPhkyQH9RTjMrkT9V7fZDAiztHMlD44ZVVRegQdTVt2pExP3ReNNrOHGd+GOssa6kZcM
	P0t7Od6w==;
Received: from [62.218.44.93] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqnHr-00000007Tl4-24Wq;
	Wed, 18 Sep 2024 05:31:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
Date: Wed, 18 Sep 2024 07:30:06 +0200
Message-ID: <20240918053117.774001-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918053117.774001-1-hch@lst.de>
References: <20240918053117.774001-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

