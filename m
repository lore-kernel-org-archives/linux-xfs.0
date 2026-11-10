Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271118;
	b=JmPIHs7eGBJVsOknr8XW6CeqWGG7fF4xqb9jukm9exoSywkRvnKYZ8Dhj8Ig+lMqz2YR
	 020aH0hXi2hSYcsfIxEBkpd7rRiaprIz0BPXKLfueNUS4LvTJvSQYfe4Nm7Di3QUYJuQ/
	 uRN5PDPjxN+VGPYjZTVABP+Ok7RkoikTMfbQBLgLK6UfKuYZE4Fz0D46C7+CFiI9ef2ef
	 DbyNtMy8NFz9pkk5qgmJ7HLxZLGfBkr68riVf7+SQYhgHdOq378u0nHayPQMIgCfQcfid
	 rI9dCgyd3Iwdw82Tn46zYZPeLeXf4Aw+TEr9xOIP/iBIuqcjiVcRUhzx9CIn/+cVWMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=vvuOBRMLz8cIFRJnJXQEzKV1/U60XiImXz+RLkLXgD0=;
	b=BSZHCipy8rKO/h5dadreSDS4N1X6tntxpKgXcCdTog57n3uOx/tbU2gBuRrFYmKST9vn
	 zBUNgzRVRbOEwmVQnhcgkXvIGhpPat5pyPnPr2udZvssB2jyNceo+Tufo2sNRrNO6ts7K
	 3Xnp0Uiq8fC/581LmeStOeR781ZjCzb0/oZSrrrGDAod/J5eclqeuEKJnAtsFS9ALS7yb
	 LEndWL52NGruvhMDI0qIujZYAO1jWkSR11jacvc/9BHu4fO8v3uQFzTq9D6Hbk4cMYbDM
	 PIOJaqKMGC6gEDUAmWOefAUquMp9oNOpKxnd1y+YP+F66cwdu9OpwkSQyF6HbZo1AjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A87x+oiP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C76606A31C;
	Tue, 10 Nov 2026 00:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A87x+oiP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5261C1F008A2;
	Tue, 10 Nov 2026 00:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271117;
	bh=vvuOBRMLz8cIFRJnJXQEzKV1/U60XiImXz+RLkLXgD0=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=A87x+oiPa3LLyY/2YrrsNu3k9XHbj/YuqTmHVKe0h71nIqQSlW/nJvJPMa7nrakh3
	 4UxPszJLABjNL3McEbjfmMcscG4JuolUdXQiNRAcZMZbQb35cCLmIEmcvGk+EADdJW
	 NrARkh3Fbj5w8YMZZFz8D9h9hCtTvkQi23nzSXDjcMojIxrBSPMVmSuxYraZ3CgY/2
	 OFDhQFmI2ZsBdrD4JSEocO6xX9HOQSbCAgMlAKwtzhBrvrESsPOzybXYYOCZ9AjjUF
	 A6FwAhiJ8Fpf5eDmV0QVF0uNE56vELx9RcEQyuJiiuUxj7X0aQtLr6OdK3fxdq6buv
	 /pWCBKV5rPDzQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: cap the block count of xfs_iomap_write_direct() at one extent" has been added to the 6.6-stable tree
Date: Mon,  9 Nov 2026 19:38:36 -0500
Message-ID: <20261110003836.3527861-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: cap the block count of xfs_iomap_write_direct() at one extent

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-cap-the-block-count-of-xfs_iomap_write_direct-at.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 0a6e140321844b9c1b7d5e593395755fbe248056
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:02 2026 +0900

    xfs: cap the block count of xfs_iomap_write_direct() at one extent
    
    [ Upstream commit 66d1ce09ebd72709f8d739630c39f440445173fd ]
    
    xfs_iomap_write_direct() reserves blocks for the whole count in an
    unsigned int. For a pNFS layout the client chooses that count, and an
    RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.
    
    xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
    the count at that. nfsd asks again for the rest. The other callers get
    the same mapping as before.
    
    Suggested-by: Darrick J. Wong <djwong@kernel.org>
    Suggested-by: Christoph Hellwig <hch@lst.de>
    Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 40d02a1450d3c..f7c10a8e254a2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -253,6 +253,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
