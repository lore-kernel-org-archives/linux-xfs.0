Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC64C127B5C
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817443; cv=none; b=EjUn95paZlweMVUybO/XbocLKLPXLr2KiocEeMUECCMwzlBhk02Qrm06zajloG+YzWVZInT9Wl3mhN1wt1O2rVzNUqS4QdCifGeVIsziq2ZxST2FgwpL2I4ztP7+lB5QKnU90tV/zQ8W2plEgz3qJS6Ks4cM4+dtGoG0LfPaFTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817443; c=relaxed/simple;
	bh=9+cCfHdULPrmi4ChUxEfhfrygfxWSTCRxKIcj14Cldo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UiZkN6C7f9i84R5U5lNvvOfxzKN8R8DxzevhqFvhyQeAWA93S55iqWfQL1GFQsItG1cnVgtSU06vAqRX6kGyfGnVu0rGc4yEOH8gF+zA7uQ2+0ZVU8mqUh//gBLa2PCPLwD25MnjV7ecwjjLd+w2ebVtzOlqnR2ISm6x7zvkraY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msmnk4tq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msmnk4tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0F5C433F1;
	Thu,  1 Feb 2024 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817443;
	bh=9+cCfHdULPrmi4ChUxEfhfrygfxWSTCRxKIcj14Cldo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=msmnk4tqHBEWNnwSXuMJj8hsq7Ac71Ke/nSWEQwfeqRV6Sj//n9QslmqNkj/epKwU
	 zH9slZdjmw2wSsW8/clgU1/O3pe7nqwqpiC/075C4bSPs0w76Pa252zxuAfotnunGk
	 VAUgQ5LFlLNbjwB1Dh8FlbQ21FltYdiqDqkiH8ZuA9wsTbBNEPpKoqbg5/7WYJSONw
	 so9rh2U7Xicw0dTDqFvWkynFibr0/KpALOUTvVaeRFaDj93hN9on3IxGH9KcM573Ru
	 E8QFUT+vLLgPLxSlOdNTF0lp0HVCj2fKFN2VjctJr1y+eVkbPCJO/eFBBVKYGIcJHB
	 cVxweDqqQMm3w==
Date: Thu, 01 Feb 2024 11:57:23 -0800
Subject: [PATCH 4/4] xfs: move setting bt_logical_sectorsize out of
 xfs_setsize_buftarg
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336598.1608248.2944339951949273975.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
References: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
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

bt_logical_sectorsize and the associated mask is set based on the
constant logical block size in the block_device structure and thus
doesn't need to be updated in xfs_setsize_buftarg.  Move it into
xfs_alloc_buftarg so that it is only done once per buftarg.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4c8a2c739eca2..6958729ee7e46 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1988,10 +1988,6 @@ xfs_setsize_buftarg(
 		return -EINVAL;
 	}
 
-	/* Set up device logical sector size mask */
-	btp->bt_logical_sectorsize = bdev_logical_block_size(btp->bt_bdev);
-	btp->bt_logical_sectormask = bdev_logical_block_size(btp->bt_bdev) - 1;
-
 	return 0;
 }
 
@@ -2023,6 +2019,10 @@ xfs_alloc_buftarg(
 	if (xfs_setsize_buftarg(btp, bdev_logical_block_size(btp->bt_bdev)))
 		goto error_free;
 
+	/* Set up device logical sector size mask */
+	btp->bt_logical_sectorsize = bdev_logical_block_size(btp->bt_bdev);
+	btp->bt_logical_sectormask = bdev_logical_block_size(btp->bt_bdev) - 1;
+
 	/*
 	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
 	 * per 30 seconds so as to not spam logs too much on repeated errors.

