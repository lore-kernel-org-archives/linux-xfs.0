Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7DA1E47CD;
	Mon, 21 Oct 2024 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506938; cv=none; b=XarWUfN8BMrIc+O+gmQcJLxTZ6/W35tzN+IYyEeP1ivdI39C7vBKPM0cswuJYDJGYr3qho5yMFPDRvA4gHvcWtvUatMSDUV+n9r7j2oEVKpJgnYWfcYpgBKBK2IdfjxwITE/EICN/0RwaJzAmmjxulvaBkadZQ/lK+rDN2EgyIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506938; c=relaxed/simple;
	bh=TOINEV2gBFCOp1I1qCzFAK40Qz6W25gljchSWPGMFs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHgPa2WjbOakp+8LOVm1TVHF/NaW/opi+VtD2qrhwUQhGb8nH+iI0W9kMbDhEidsq3JQCsM0e9CMB1aao5aAAS1aHcNyjRHjaQ6nq8tf6zYqYROp0xVeZxbUeHQq3BQfgzO6vi3XHlOT4spXoQ6fTJR+ChQBQZZGpse2wgQshLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTN6KGPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTN6KGPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F7CC4CEC3;
	Mon, 21 Oct 2024 10:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506938;
	bh=TOINEV2gBFCOp1I1qCzFAK40Qz6W25gljchSWPGMFs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTN6KGPfLDv5QCDmqyF2Ey8WWErKYwCaawno1yidYet9rrXCx+g6kUq2shYsD5c3t
	 AhFKO1dV2gecdnDfTT2ExwT9w8ihxZmUQoeff3CMlpEecUjgslMmLeeY4Tlevvdb4b
	 SRfk9ItnJSZ1bvKDJN9ASO3KkZ9mCQIcjGk0zsMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 036/124] xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
Date: Mon, 21 Oct 2024 12:24:00 +0200
Message-ID: <20241021102258.124018134@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit fc8d0ba0ff5fe4700fa02008b7751ec6b84b7677 upstream.

Allow callers to pass a NULLL seq argument if they don't care about
the fork sequence number.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4595,7 +4595,8 @@ xfs_bmapi_convert_delalloc(
 	if (!isnullstartblock(bma.got.br_startblock)) {
 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-		*seq = READ_ONCE(ifp->if_seq);
+		if (seq)
+			*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
 
@@ -4641,7 +4642,8 @@ xfs_bmapi_convert_delalloc(
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-	*seq = READ_ONCE(ifp->if_seq);
+	if (seq)
+		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
 		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);


