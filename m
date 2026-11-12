Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445354;
	b=ik+OI4WACG9Vc4kWSCvDBDfRG21F4dFVMutRuRdee/toHJMwMJ3oucj1PNXusMq1bF3F
	 hS0AIxxiGNPpua/pCT64hl/2EZnWovOt6FFxAwfSefNL5LrKf9GAoGFVfD840k/kop+aj
	 sVauVOZvV2i1+EQ0mB61ed7zP3ZzrptzYvByLqoYMlbFTBN5EOYsRaodWMCgXTKCpUDnq
	 FcqmCvq9i3P53i5kvfx6PKGi3V0dCZ6Xg89+MHwZBwiFtlUyH66UqqI+ex2MhS6Pc8v+F
	 /rm7OW2pAIrWvxRoiQXS///G1EwYi6wwyNTHCRIRVffyZCUN6hAtZn87z8k0IF8xy3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445354;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XQpLAovqM9mY9un73tRxcWVStioX9SQYj5iP9YI+sVw=;
	b=fMCVzQsmSc6k9zeOdahmKcwrzDTjnO9478TwHssFqOelo06WoueqE6R5+FXeVOlASSbx
	 VtV/tvfUS72kvLDHc5RdrrJ9mN4ZQdyypqT+BvFEYCk63IUKpuieV5lQBhgHeVIoHz91d
	 1jd7/6zoHQ3WZv2BR7k0k2PMuS7/uMoZk2qmsJ0W5ObnZd5gGI2Lbns0Nw0EiCmHhUA86
	 fiQLuQ56PbnZryxnCrpuJOFR9D5a8DraSj9ijG/eOrFJhE7KCjBUwIo3cTJ+IUq1QltJO
	 8OrMimr5HE+7a8YoVerEvmG4XkrUEdeiLgRcbDwML4z+kv8w1ga9k2Y/RT+6W+tjKPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SmULT/c0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D6560A260C;
	Thu, 12 Nov 2026 01:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SmULT/c0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9620B1F00A05;
	Thu, 12 Nov 2026 01:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445354;
	bh=XQpLAovqM9mY9un73tRxcWVStioX9SQYj5iP9YI+sVw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=SmULT/c07Q6wqcyLbVwSFaamJcTK7eo1aIUwI6FVxUdfw33rh7WFd4WwHMsDC2UAa
	 W8B8iKipHaqsrXrOJGnUQk7dYKYK08JdUW/RUdkrKFwU4XHi/MYMUHM50K2P3oQuVm
	 xszT0vipfKx/puXW/WLHNiLsQ/2b87mJgI9fsdknU4JZXIPohwEUXilGvyHiOpJx+I
	 Ti0AZxt2A8ntbXsD60VQBKPGKa7Up2i7G/z1k5BfzuYLUidEi9HdtLGoNZIHD5tDfQ
	 FlFOkuxCaWX3/cvDvi5L6zNgdJ7YuCFT/FgpLNZ9k9WXIMuOD6888tMlMKIn541fO0
	 vJDbki45/SYRg==
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
Subject: [PATCH v8 01/15] xfs: don't skip the flush before shifting extents
Date: Wed, 11 Nov 2026 20:02:30 -0500
Message-ID: <20261112010229.51029-2-mason@kernel.org>
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
    v7->v8:
    - No change.
    
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

