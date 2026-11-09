Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268284;
	b=XyGybOB7PGFR8b9oPv7A5k9+2DKMdY5V4PIMGIoW1AxP2tjDcpe3ZmUpoL+SOPOr1bKp
	 TC/ZdQC+FQbVVjbZUEiLUCChRof637q8ZdRpwOh0olrQVnGwAqD8foFc8YPvKhGSXoq7n
	 kyEsWkcpbtYHQ4Sa5irOr/SXLZx+2WYsC2z8NombSO1NCS/pt2UBbdVPNvCQueL88Kd4a
	 FNszBPdW6rhpH5UB6raZl6nf19MCI0OtPKgtzvnLp+aVusw6w4nXTOjmC8FT014VQ7bJ1
	 rXKBXZ54hXfa9HFi/875SM8wrfIvzP67lKjkFAYZWccQC0k7+xJtVT2Zs2IxmeGyYRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268284;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3nsKLbIo3JWkcZfzoh6Lrn89v1qhI10KpQxbB3s7xNI=;
	b=XDf9L+oioaEdwb8WpDi+FjtphQNP++16DsXSCpUFGHbA2uero7c3d2HaF544z0MVOvEP
	 0lnNNPuGMaFJcve+rndadjgwf/LJhTdOTBaWNqmxnF231B/wJ/NLTzHGW99+o3zxD6ME1
	 NRuSvQFvOSk+qF/PuUeGWXayQG3HheOwHwdfYbmtkfs2U5ClDdFXhrqEqW1XdtQkHa6nv
	 YMSHxvYslB6TiDOB9FJymFzebI9P5VP5STJP7TLG4f3QbNY+BRYhH7leEHjX8OaG6yLL0
	 rIJ1iDTk5bYr7wHhfrCIT+SnsQ7xn8DmN37qj/gQMvlEFeQyD4TOGEimTasZJBtPz4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0nSWnbU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78635606A32A;
	Mon,  9 Nov 2026 23:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0nSWnbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AB11F008BC;
	Mon,  9 Nov 2026 23:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268284;
	bh=3nsKLbIo3JWkcZfzoh6Lrn89v1qhI10KpQxbB3s7xNI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=X0nSWnbUy+tXqnO7SfzpM5U1ST4fIw+88/rUoOTuHUe3L3iRIK+uAGaN2PpRmVfIw
	 T/pVvAL9a7pbf8KhxG0lc0ZooZrMEkD3LMEExW4loKtc1yD2voyzuaI4zNl/CwgCfY
	 2MN5RObvgNfO1dI/ioU/AQKzYv+milfqlbjhgHfzsxn+8hR+YRa23vObOhlYUUejXi
	 PeyEOcBc4YoKlN4TBXkXTtkvtNF2xVzpHu1hqBVjTGtofAaFhadl2zwfWYtcIbsQL6
	 1SnGSLlY8GE1kH2h8F5r2Guw/XRkePYAxv0woynmFrpK0xBGdPlRjPx9a/hrx2Lk/p
	 YeI7UmVedLocg==
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 07/10] xfs: test for reflink after the dio write checks
Date: Mon, 09 Nov 2026 18:51:18 -0500
Message-ID: <20261109235111.14129-8-mason@kernel.org>
In-Reply-To: <20261109235111.14129-1-mason@kernel.org>
References: <20261109235111.14129-1-mason@kernel.org>
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

A direct write that is not block aligned can expose stale disk contents
on XFS if it races with the first clone of the file.

xfs_file_dio_write_unaligned() falls back to buffered I/O if the file is
reflinked, and tests for that right after it takes the iolock. But
xfs_file_write_checks() runs after the test and can drop the iolock, for
example if S_NOSEC is not set. A clone can run in that gap:

    direct write                        clone
    ============                        =====
    takes the iolock shared
    sees that the file is not reflinked
    drops the iolock
                                        shares the blocks
    takes the iolock exclusive
    writes a part of a new COW block
    maps the whole block into the file
      /* the rest was never written */

The fix used here is to move the test after xfs_file_write_checks().

Fixes: ed1128c2d0c8 ("xfs: reduce exclusive locking on unaligned dio")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8ee88910b487..d888470d092a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -877,9 +877,15 @@ xfs_file_dio_write_unaligned(
 	if (ret)
 		return ret;
 
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
+	if (ret)
+		goto out_unlock;
+
 	/*
 	 * We can't properly handle unaligned direct I/O to reflink files yet,
-	 * as we can't unshare a partial block.
+	 * as we can't unshare a partial block.  xfs_file_write_checks() can
+	 * drop the iolock and take it again, and the file can be reflinked in
+	 * between, so test for that only now.
 	 */
 	if (xfs_is_cow_inode(ip)) {
 		trace_xfs_reflink_bounce_dio_write(iocb, from);
@@ -887,10 +893,6 @@ xfs_file_dio_write_unaligned(
 		goto out_unlock;
 	}
 
-	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
-	if (ret)
-		goto out_unlock;
-
 	/*
 	 * If we are doing exclusive unaligned I/O, this must be the only I/O
 	 * in-flight.  Otherwise we risk data corruption due to unwritten extent
-- 
2.55.0

