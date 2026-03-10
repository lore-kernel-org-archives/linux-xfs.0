Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83862AD3D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773113113; cv=none; b=JYq67XVTDMNmBbP9GxFc7JEKAt9S3xCtXDjVr3uT5q4JeFP0Se5IX32ScHVu18SALUxieiDYuGOSksL44S1ValoQZPGiIvAIYTj740vPjcQZstN1mwfP8qfj9F0sWryafaBqVtDbvdsTOFTu/3KUgxSAJ9TlZGo2EZNqa59T0Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773113113; c=relaxed/simple;
	bh=Zm1CA0jdUcIvIY4XzFh9XM/KP9BPVyaabuSMTe68yfo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E34+6SKkZ1VlIO0bAotg5CurlKOXjTnUUlDazJlbA/bl2Y/Jc9RqmVpzPWQ9vYk0tB3ec8bzBIbkSZMQTYVuGaCp3rCJ6bOjZoT7Ig+/w1SmRTa1jjF/5YHO0ynIvp/2FVlmu4XUXh19BqhOkAzWym7G6TllvJhJ5NCP2lpX9Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4bv+Cg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4bv+Cg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8164EC4CEF7;
	Tue, 10 Mar 2026 03:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773113113;
	bh=Zm1CA0jdUcIvIY4XzFh9XM/KP9BPVyaabuSMTe68yfo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V4bv+Cg6MzLAcjl7NYlp04ispcfJeIPBiuIvW/aZowoxCzusakQzikXw1c1BpK396
	 g6nbxAMKzpZFBA7fO86XCccTOOzCzLLabHeyydHqoAuivY0WXyHv+XsGqhJHDpht/I
	 cHm+jC7/DjyW8W3alWd3rHqKnYIGaz6sERmzuMbqgJiGQGR45SQd6DJQjRFcws1mMS
	 NBbA8C2BVdl8FH2oB4rlCSYaWtZlfTneSiy2fzIRUUKfxeHf9UF6y6XBCoruIIq/hs
	 9GIHvC7CqM3S5RL61SKA7O5jw71Ji+AGmsqFOw3MQ7sP6fumWIMm8ukp6u92NZfHUc
	 dqhG5pr/DsUtg==
Date: Mon, 09 Mar 2026 20:25:13 -0700
Subject: [PATCH 2/4] libxfs: fix data corruption bug in libxfs_file_write
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311301516.1161719.17918712255370279131.stgit@frogsfrogsfrogs>
In-Reply-To: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
References: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

libxfs_file_write tries to initialize the entire file block buffer,
which includes zeroing the head portion if @pos is not aligned to the
filesystem block size.  However, @buf is the file data to copy in at
position @pos, not the position of the file block.  Therefore, block_off
should be added to b_addr, not buf.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 8dba3ef0c66139..2b1c32efc4709a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -650,7 +650,8 @@ get_random_u32(void)
 
 /*
  * Write a buffer to a file on the data device.  There must not be sparse holes
- * or unwritten extents.
+ * or unwritten extents, and the blocks underneath the file range will be
+ * completely overwritten.
  */
 int
 libxfs_file_write(
@@ -697,7 +698,7 @@ libxfs_file_write(
 		if (block_off > 0)
 			memset((char *)bp->b_addr, 0, block_off);
 		count = min(len, XFS_FSB_TO_B(mp, map.br_blockcount));
-		memmove(bp->b_addr, buf + block_off, count);
+		memmove(bp->b_addr + block_off, buf, count);
 		bcount = BBTOB(bp->b_length);
 		if (count < bcount)
 			memset((char *)bp->b_addr + block_off + count, 0,

