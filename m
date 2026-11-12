Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519969;
	b=hsq80MvfSpzXW9HHuAScN44potmVuT2wjayk9jrt7jGIhfEIXo1OHd5O65mcpc+6x6hA
	 EiXjIzYRmDWBX+mageXw5gCldkkJm1aZkSPtQBRSChffL5LikRLADgXh8j/D6qzhqpT0a
	 RxGcRM+jywuBlgCUsA9guxSt9gdRpxt/8S5M0PHcgQ0UaV2H731CIOlpe2q/EuooJQ7iJ
	 pC2B+3g8q0bFqPIqFrzjUcaoulCxASrMuNN5r0MMV6kr2viATcZBoEpDq14/XzQr8exvs
	 CU1XUvRqRaYnOpIKJw1vWMRnmgj66ds5YMsLp+FZAstFD9xEdhbC4qEY32ACn8Fy+iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519969;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VlC7l+lvdhqvniJEYM0bym0+IQSPQAdz8J8PY4r+AoQ=;
	b=BusGTWwmsl7p17pXSdrMlDlk6IdTy9lFBc/VnmaIBo0+ck/JwyIxqkpuU2UctFsvpWWB
	 iQwSzfD6CopFKU35Z9/g+4wQxcp1pia88ugjlmDVq9pIedtJckqsZGlk3N8/8hF21UJF2
	 2Bue+UecsDuOIwZ5wdzDEO7pXBmspCMc0wrV66q825es33ngmpgXsr8nGbLZ3zhVm25e3
	 +79ttjK9P/8kEn6fLMyu+FC7KYkAFtbXVp5+GgJs84dPoUS140ao68qhp3EgI+cs8PinQ
	 kuN0cj4c/56+E0km7FW99aYnMWOwU24DvKBzqPvmTMvUFPYrhO3/ZuDlgtqhvm06XPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KW849d+N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E084606A338;
	Thu, 12 Nov 2026 21:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KW849d+N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A8C1F000C5;
	Thu, 12 Nov 2026 21:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519969;
	bh=VlC7l+lvdhqvniJEYM0bym0+IQSPQAdz8J8PY4r+AoQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=KW849d+NoetwiiyZu9EnGYam22FiemNJ/xWT1W0Fo0oME02yQ3yXBMzk7al5fzN5b
	 lxZEGJHfiYnViL0V0PT3O48PyltbclekBjwSLUZeVeTariRtvQ3mbz4MvEnMln0jqc
	 Gy0SF/iYG6skydXWXcPVOo/cwu9hNY4giE/Wx7Uror4CYSWQq6ds5qOFRLbYlBw1pw
	 /Ql4ybEdtYZgXCqpWvjvpTaUmdVfJ4DJD5xQUPKBCxk5LxW6setGasl7cvFNIIVWz2
	 JS/yoBP/WO3gHVPYNPbBp3JBvp5K8Va3DQF/bgN9EHm86q2Xy8TAhAeKVBlFcrbH/I
	 E331cRC3ce+Qw==
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
Subject: [PATCH v9 01/14] xfs: don't skip the flush before shifting extents
Date: Thu, 12 Nov 2026 16:46:05 -0500
Message-ID: <20261112214604.67875-2-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
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
    v6->v9: no change

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

