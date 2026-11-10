Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337464;
	b=y8OJYW99wK1L9FGwiFFpNVQ3I1E1/OKy/62XczMiJV6UTM4kPoZ7QS18QG2fYxR/Q8m5
	 bN3VthiNHPgUZJVBbPH1VqD6t82cbagWLM8oymZmOZUOtISeOdjMkIYX7cACgjebww5kJ
	 uqmwoCYtUELnBFWbO5SC0sb403OGgEDP6M3GtdxDcV6xaDia1apqWJ+W2XGaJsxDZYEJO
	 CJESu83XDEqB1f5psiKUeSAUaCG5GyMO+NlUKiG8xswkwjL2LA7LTgbzoDIhb5ogywqVJ
	 audULWOocXfDAJ/CQklyPgukrSIrx17B2j331eAuSAa9w1IR0Wu0RIUFHd1ndh60rPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337464;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QwBt0aHcGILOxw9KEsVZmCH3EFRR/4TIqtYPWeCGL6Q=;
	b=UdcFC31WHlAqgzr6MnxfTrBSid2GWO6heLAS6Gc3GnsS/S2Geas6VxYO8Z5tCO9OZn8Y
	 JksYUPY6WDbzNCm4cSVbVbtFcI0/u8B1cKE0CN803C6LH/QPBkOKCb/k75gXINlEpmJdh
	 uEoNzsGTuVWaXIfFt5Oa4VAizUecbcqqXpIzp2TbcIWam4Bqa4ymXJt3mqTP14W6x7ca3
	 aiOXCwrRbtI/baTqp0trFbv0WL89S2tj3TTgIqebRUWrDINpgk186xa/ALXfaxvRameTm
	 EHMEP8FMzzKuontjQSIbHyiW/YAlokhPLzuCFYREuhbHlxtq/kK4JHiRYw9P8q3z1xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AXLROVxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB370606A32D;
	Tue, 10 Nov 2026 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AXLROVxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4441F008A6;
	Tue, 10 Nov 2026 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337463;
	bh=QwBt0aHcGILOxw9KEsVZmCH3EFRR/4TIqtYPWeCGL6Q=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=AXLROVxw4JunZjuevG8ug/HP5A5U8xnCZ93xsZVSkAhTNlGYJ7P5AD/YEUyx1WS8J
	 3rqTXpGaBQF9SVocbb/1P7PmOchzyj0nyJUjmWNT2bnM4/JMkn1/dNNqSM3s7Ukvpc
	 d7ZULvkkF+/jkVYkM4l01JmDVv7O2euik9a/ClBisTl9tcVA33k46PBUj9FOE5UzWo
	 sJkiX/lL5ydTGbtXHIlQ4dNAX9KLEz6mt74L9oW61wmUC6RJhkRymo/nOYLjUbqodM
	 GLnolAvbeSUG1xqk0JRJQF7PtA0SXk3HPhj/gxJZ/ybb/w+sVoWZMGadVG7Xzg+nWe
	 Ymq4+C+v9LJdA==
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
Subject: [PATCH v7 01/11] xfs: don't skip the flush before shifting extents
Date: Tue, 10 Nov 2026 14:04:19 -0500
Message-ID: <20261110190417.32650-3-mason@kernel.org>
In-Reply-To: <20261110190417.32650-1-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
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

On an XFS file larger than 4 EiB, collapse range and insert range can
drop dirty data without writing it back, and then fail with
EFSCORRUPTED.

xfs_prepare_shift() flushes the page cache from its offset to EOF, but
passes i_size as the length. Above 4 EiB the end of that range can
overflow and turn negative. filemap_write_and_wait_range() then writes
nothing, but truncate_pagecache_range() takes the end as unsigned and
drops every folio from the start of the range onward.

A delalloc extent under a dropped folio stays in the data fork, and the
shift returns -EFSCORRUPTED for it.

The fix used here is to pass i_size - offset as the length.

Fixes: 7f9f71be84bc ("xfs: extent shifting doesn't fully invalidate page cache")
Fixes: feeb9b269523 ("filemap: skip write and wait if end offset precedes start")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v6->v7:
    - No change.

 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 865aec3ae5ab..537c6b29417c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -980,7 +980,7 @@ xfs_prepare_shift(
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
 	 */
-	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
+	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip) - offset);
 	if (error)
 		return error;
 
-- 
2.55.0

