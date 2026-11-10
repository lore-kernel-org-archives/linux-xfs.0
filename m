Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271774;
	b=DHVN8tH7Os4D8Iy6KbvVASb2O+Hb3kEKJpXOTPjXgRzJa+N0Xo2vlTybcyZEkF//3Shz
	 iw2jOKlQ36CeQXQoA938wSd/IiOXom4I2AAl4lEtwqg9UtFUx9AssUmPRqMP7Vhgs2ZHI
	 JhvfGF8S+9OvfFPIbuY+x0ybyMDSeWUylkCiADQ5bY3F5di1jAhGV0BBWRq6f7K0VUHhr
	 iymk6SqpDlyOqhGUIYC6G3YDeBMJqk6j15xI7Pj+ATBGx88yLzGuCheTRJPWO7efYfKOL
	 Ka1h+4Owhd562mtTSxkM14T5RCJVvPMu9nBZqK5mKugdeNnS6I3pUPh1r+FxPiaH1ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=zYYgxLOPpfo6VcTd/iBy/DX6BeQey5KtPH7ECwORXlg=;
	b=rfFT7y7NpI836LX9mgfHe2yMXW3edaqJlPaaRyF59YQfeQzE8hXgcK82NoZcI8xNGndK
	 ULdsSbFu4J6PEWNRg4g2D//Z599X0JTnDUiBA70rgvUStLxwZS0eaBQKleG4t+Qzsrndt
	 /1FtCu1/HhP6AL1i1ydHeViTySYd1thJel8+b2yMfvdtxUYhwnCkbHNKZuxqd54sLRc1/
	 0wBQLIy9dORJRUGGbqypyPf9nlVpJtc9TKix19KGJrMGhGB0MpFIEzNOtcXZ5UyMo4/ko
	 30w1yr1Qzzx4w2fzsBqtotgyKIKkUsMbUrZRd/5QSV3woi28oglyWoMTX/XoeKIjRsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z8JCTazM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCAC606A31C;
	Tue, 10 Nov 2026 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z8JCTazM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39971F008BD;
	Tue, 10 Nov 2026 00:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271774;
	bh=zYYgxLOPpfo6VcTd/iBy/DX6BeQey5KtPH7ECwORXlg=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Z8JCTazMkp2YyooJvvIbqvQw1D49eE4FhLYFpSygMuVNlNZOexHFi4YFdDPGqx3Ch
	 L/K5x56jHNhBKfMgv9yU5EKprEd8aBkX1Rvs6HJn7HZTn9lcPhMM0W8DLhd+ZjIGun
	 Aak742AYW8hYR2BmWI7ZUA+9zCxDBthnNOGJHyEYj/DPhqIFB/prFOkCgeuRhzeMHA
	 7EcRBf68EFZ+Sq+UQdU7yeLv5yzlV86IsdCGupxmdrWmklUgpX9lnWY1k3yBS4yzEI
	 D0LUMGjBCYy/Opbd5AIN+eyeSThFrSxRwFcpNhRgzxafMT6qEWpmbFKKZK+80UmJot
	 hqocYC+Kr+gAw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: cap the block count of xfs_iomap_write_direct() at one extent" has been added to the 6.1-stable tree
Date: Mon,  9 Nov 2026 19:49:31 -0500
Message-ID: <20261110004931.3538814-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-cap-the-block-count-of-xfs_iomap_write_direct-at.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 7bcc14719635a06c699966bd511dfd571bda7fc9
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
index 28a1c19dfdb3a..f2542bac50c35 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -245,6 +245,14 @@ xfs_iomap_write_direct(
 
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
