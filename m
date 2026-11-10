Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270131;
	b=nr/EDr2TUwrR4u8CLstOByr4+4zQg/uazd4C8bshOIEOt/F8ppzFgCaE6njMbUTahU+I
	 h4Q9pSweG7Ogq1a6/IhADN/qP4Qz/r3SHwdddhhMOMRBLAa8GBTVFU+FzYnrSoxReUbML
	 7t85lLBkL9s4JqwVgPdDa/Pyl1mbZwW7hFXwE8kcuhqiIu/IsibWdfdv88lw+Qx49PFaF
	 EY8GtINIX0ymLwaIgHbLpZmtxBW9zW0gobkaNSWylB1haZcC77E46DD6acLpnLjba/1+t
	 SNhEfwFCrRIw6W+HhM26XBJDSBA7xfsGMT02f9nCro+nxUFphKBe9DvA9mgzFikWI8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=ldWNWV6qHkI8iCZPc2kYyPRgNLTPf7YnsaqdNxnlock=;
	b=SiAcLWOAKp/2K7CYxm7sHCYjimeMWU9S2Auhf18AJ2EHhVzr3Ec01X2ekDAb1NhgjCtR
	 bDLqVffFlv0S0lFGIzQ7j4Bfoi6UfPRjj5a/S7hGplIf65jnhLU3Oe4TRIzYwzHd7iMi6
	 GXKPtYt5JU9v49xKu4pcM6DpuJZYZlxxJe/Q2EibIyanb2ijzP1ybK9oaRAo1mMo81+lz
	 K+cd5iBAoGmp3klevWozoNT/3rWrtzqMXHzoN4H5PCzgPfYOV8/lGLesWd/RxwGMw1874
	 PsDhdc3iC+CbpNr34+eZx+ka9XTG586Jf7iTGg7e4tWH8ZrLP6rNaqDUIwW9q3yWfow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPbmXIv9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD209606A325;
	Tue, 10 Nov 2026 00:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPbmXIv9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030811F008A1;
	Tue, 10 Nov 2026 00:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270130;
	bh=ldWNWV6qHkI8iCZPc2kYyPRgNLTPf7YnsaqdNxnlock=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=JPbmXIv9iiSoJ4mIA1xM1oK0bdcLgNXi28SV6cAG4WVFXxOlS8Y6rQqRRD82m7zRv
	 bLRtsz7TG91Ov2rEzVRkIbEh1xaDRFBECccy+K6G42QlUq7KYbJ3QRoPlriBVrtDNu
	 20TMe2DvaDa+bjaj4Jhy7TNMokuLmLjx6VGEYM9qVak85HrC6UodCIkqGQBL22uG7A
	 VxhwR+4vlGvkkUf619GEjO7fplnuqkLDTgZR5b/grWoOeu07Lzz43y1ID6OCtFFz5t
	 Bee/lla9cTrRPieJW1wkUS/amJFjN44Pl7DwmsJCQcuLqCFFIWtcvlljwJ/yKfy4Ri
	 uzH61OKmXjX3Q==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: cap the block count of xfs_iomap_write_direct() at one extent" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:22:08 -0500
Message-ID: <20261110002208.3505709-1-sashal@kernel.org>
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

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-cap-the-block-count-of-xfs_iomap_write_direct-at.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 689a19f23b4b00517670ccb2b8cf433482e558f6
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
index a1c88df45dd0d..c7dea4242e8bf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -282,6 +282,14 @@ xfs_iomap_write_direct(
 
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
