Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272018;
	b=xHf90ysfU69JF2LYnlcRK4I3209Xd9RNOLCi+oBYcHLo+pkzu60OzgXB2OPBvlyTdHRN
	 C4erUoGpKaIzNcLLtvVD9n/d3cfZiWGpQ6Hzq2OPvxtA2Vn180oogA8LggmJQFa2bC3iO
	 oIFn838BHqkA8leNP8XcAOaIyu1ilZ8ITwqD2NKo0Aszge4pTIRTMR8ws18lQ706Duh29
	 3OfyywJuYLNkOGROYR2WuZzAx2Cia7q4hIIvWbAdmqUZeW6iOlW503f6FS2OIhb3rQ2Mn
	 6JXlkR/tmm209fAJ6Mp7UaD91p2ynkt7iXoWfjZRuxP0ua2poPiVpatE6O+ZbhFHq0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=ARbtvfYyIL6KheK5ncYw37TfHfh/PkTmfzy22/gJ5jI=;
	b=NPMHgnxYuvFsLtAD36gJ9Pq+bWLDN06Ud5sDlJL6GCpvE2MlPsIcXfcGfD7ZPz9kfjdt
	 NyVizZBw7fKgMcVMkpHLq6mVCTf2FQNySb/cqs5+D62eYdKMDdD9I9ROxRw0GxzgsI2DX
	 bRW4Gi9QrYuMGvPSWFdn4vy4puaNRrrh5D9wWwkusDjZjLx9aiyY/sj78o80Z3zuqxMtO
	 91cjjXztK0M0vrhh0CIvtzIPaEQtevRl7cal+Q04S4SMyxaD80GhcLNtFWUJlttAVy1N0
	 Zrp4JyGVyngXBEipOc1vem9DIymrMcHUohMjnWGamcE5ICFI0ksJhGXsy6F/5VOrKmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g6YB7Tp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11591606A321;
	Tue, 10 Nov 2026 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g6YB7Tp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420FB1F0089F;
	Tue, 10 Nov 2026 00:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272017;
	bh=ARbtvfYyIL6KheK5ncYw37TfHfh/PkTmfzy22/gJ5jI=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=g6YB7Tp0DJD7vJNs/72VOl1xYFH7aFuFoLp60tG2PHxF1JubERqyGgIs0CWpLz6BT
	 /7gVtC2lwSUB85EyErDWbQouo8YjfgvLf6/h3zcF2PZ2gZr10XLiTCGbCppGP4CusC
	 T/UhjdB5yLTJhXOpsg0CI6Y766FKBKYaYhGL4gI8ofAKpwBLJgsTvUBCw0DgGz/nce
	 9dZpvHTqCy4OpjwpMaENsiseeNPOgWCGmHwTDirSPKGMRZ85hpQ2Kb4ardulJVBqDM
	 S1XYmWYpZulHowKAFrHFtL7wjJtiyswuVeuGiIhr2dwXhtMJU1gF/h+3WbnbO4oAXl
	 GX7qaburriX1w==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp the pNFS layout range to the maximum file size" has been added to the 5.15-stable tree
Date: Mon,  9 Nov 2026 19:53:35 -0500
Message-ID: <20261110005336.3544596-1-sashal@kernel.org>
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

    xfs: clamp the pNFS layout range to the maximum file size

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-the-pnfs-layout-range-to-the-maximum-file-.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit af123e2658fed8875ddd70358718276845f2bb9b
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:03 2026 +0900

    xfs: clamp the pNFS layout range to the maximum file size
    
    [ Upstream commit 29f3c1be4e554c9dbc66e13333034e0947477cb6 ]
    
    xfs_fs_map_blocks() lets two bad layout ranges through. An offset of
    2^63 or more is negative and passes "offset > limit". A length above
    the limit, such as NFS4_UINT64_MAX, wraps "offset > limit - length"
    and stays unclamped. With NFS4_UINT64_MAX, a read layout is built from
    an uninitialized mapping.
    
    Reject a negative offset and one at the limit, and clamp the length.
    This needs "xfs: cap the block count of xfs_iomap_write_direct() at one
    extent".
    
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7f950cf39e4d4..0bf547d730990 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -124,10 +124,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
-		length = limit - offset;
+	length = min_t(u64, length, limit - offset);
 
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
