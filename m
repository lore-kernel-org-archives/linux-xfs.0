Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445373;
	b=0YpQfFXXaK03eLB7PezyTN9l00W710Vuoo6HtsCbTtJwN6tbqkq6MOb/2GWuLmbafc5n
	 Yn4W323zi2UiipHjO7OYMngddA+HfpPZQDB1vE8eBpXzGyVp8jEY+gvZjfSacbmNuxvY4
	 raBf3eNwq7pvGnXn/bw08zBxDMhqL3/8d8GqIKRA1azom4eWIk7VDx43kvDvy/iEeODru
	 YYgzft+o1pi/0e4UDlqB59j9ZiNgqgpaO3otrU4qIS630nEy05aTzEyM4450PScFX+wyb
	 HqTXaSSMjFSARTGGZLjhVX2k4PU8m7vHUYIFKyC6onHrZc/U+/I+09Cu23PYMlXr8Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445373;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1NvT+krDmSD5Mne/wvXNG+j6Knb/tWR7T5atZL4jonI=;
	b=WLr/smUGucKwFJPyY/5R4jt/6vlSISNyI6CZ6yj26bvYm/U/ASwiS2dZ+JPwJvzuWCya
	 eWzTZ3OpvpE7nahSaAnZJU52NjwW6bEleXz/gQWqw5LLmGz1H08ApVnf6S1Pt9nTgpM7p
	 eMTXfSa7Tw0AtRcHFqemLx38O5PRbdG4noNjZP4Iga4OU5vWpsL2fQNbIh4w90/eGARj2
	 Hx+w7Xk5mZd6c4IyGjrSAhaXEvS9zb4ZlPsIoxFhTfujtgzQOxx+bFHoxwWd07p9Evv8e
	 8T8gr4UW2auQlXCN1k5MngW84/AfwWYSLBsDeWB2QGpDg/mn5acHJl7FGsdzKAGaIVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTjwuBiJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0040460A3809;
	Thu, 12 Nov 2026 01:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTjwuBiJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386F91F00A08;
	Thu, 12 Nov 2026 01:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445372;
	bh=1NvT+krDmSD5Mne/wvXNG+j6Knb/tWR7T5atZL4jonI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=XTjwuBiJD13VLadsXebY88aOPrX57xZck3mBQKeOPMN7NkxG5LJPT6ZBBjwLz50/9
	 Xham23hHJ+sO3In/ZdKLIV1syFX8dp+MnBwxNs8u+WwHrGmYbwup4rl5iRBjPL3hOs
	 qjavYoKsrHEapoU4K79CX7KTbpd3Rd8lp6POyr2rI969egYBvr6k4Xd2h4rEskSOZJ
	 fSu6XZMa9zbzKO5ehI9ciWyEVBw/dI4T3+2tJ2n0O17axdjCT41bU35pP5TpERL2Os
	 CtePsPsuT9hyBzowhUC+ys0hlTHPw6d01yE6mnQQ55Z0var9vOjEds+7CqUdVSON0z
	 Mm/LcCVGGkjKQ==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v8 12/15] xfs: test for an extsize hint again under the ILOCK
Date: Wed, 11 Nov 2026 20:02:41 -0500
Message-ID: <20261112010229.51029-13-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A store through a shared mapping can corrupt the data fork and the free
block counter on disk, if the realtime flag of the file is set during
the write fault and realtime extents are larger than one block.

Such a realtime inode has an extent size hint, and cannot use delayed
allocation. xfs_buffered_write_iomap_begin() tests for a hint before it
takes the ILOCK. FS_IOC_FSSETXATTR can change the flag of a file with no
blocks until then, since a fault never takes the IOLOCK:

    write fault                           FS_IOC_FSSETXATTR
    ===========                           =================
    xfs_buffered_write_iomap_begin()
      xfs_get_extsz_hint() is 0
                                          sets the realtime flag
      xfs_ilock_for_iomap()
      xfs_bmapi_reserve_delalloc()
        /* 1 block, 0 realtime extents */

The fix used here is to test for a hint again once the ILOCK is held,
and to allocate the blocks right away if the inode has got one.

Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v7->v8:
    - New patch.

 fs/xfs/xfs_iomap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d36650450cbb..b414e2cff346 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1903,6 +1903,16 @@ xfs_buffered_write_iomap_begin(
 		goto out_unlock;
 	}
 
+	/*
+	 * A write fault doesn't hold the IOLOCK, so the inode may have got an
+	 * extent size hint since the test above.
+	 */
+	if (xfs_get_extsz_hint(ip)) {
+		xfs_iunlock(ip, lockmode);
+		return xfs_direct_write_iomap_begin(inode, offset, count,
+				flags, iomap, srcmap);
+	}
+
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-- 
2.55.0

