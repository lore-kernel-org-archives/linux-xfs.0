Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268275;
	b=c2C/47uU24NyqRigSdjP5KzomaFfcvjgHmc0mivA1eegjeXyG1tH4rd0vL/VDQmPFu40
	 6mUjY1BOakGbw2atxKJAou+jmWqoRJldtK83BbXoFPWo0rmqQ59qnQmjLbI5ajQevVe7h
	 Fh82HGRotw5wI7DzURtm5w/Gr+LRhLG5gV9AfMqa4a+7xD8zWO/s2ow7HURtVQqitbMpc
	 ukfPIYs4F4TiBv7yG0NT6Ba7swT9ohWwLhtgfdpXdvkXXqdcBpEQrwh1QHmqDcnZQw0hm
	 MP9tuFvt2b9R/SS6F8ir9eozZss9bXupIpEeaqo4OkhacSNpSM0+ds3UkwNkOoKT9HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268275;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=p2+AdEQAI1mdAG1uwf6Uu9KN9NfYUJ185+AlLbO9WrI=;
	b=zXthoOd/R8jNn/UQzaXLRAq2mPtDLR9q11753+RtPhUFIdW+if2U68AjLK9r79tEi8oW
	 qwoikZxvbUBSgjciTm+pueOQAeMOhu9K0Iz4ZHcT6LB3cef3znIfnLXIc2+WGDMBLVxuK
	 223d5f2Z/WgFbx1A/eDs8ohGCM07FL6FcIkFA0AHkULFRSTruONXM+fOHwU4/jBcAK4e+
	 QjsnoD7nMUwRHRGDsPBucytwMN1WsY8+TdNqWveGHZAzw3RWq124kR4vlW7pDJvQDKmUO
	 nx0CVgVb14Hx88aorfI+ZeBwefnLj8tRhIjhdFnLR0uSaD6JjFtZPK9OpREzklwHCTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bcjTV0/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF41606A333;
	Mon,  9 Nov 2026 23:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcjTV0/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047181F008A1;
	Mon,  9 Nov 2026 23:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268275;
	bh=p2+AdEQAI1mdAG1uwf6Uu9KN9NfYUJ185+AlLbO9WrI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=bcjTV0/aIQSq7H1u9y5QbV1pVnhjOAj8ZYgU+jKNxaewElqahK8fnPooRv3oLvnf5
	 GGlm8yEOKe6cLuSvSgTZWDcU5Jz/VnFeIAGrPlRoIV64ZeLU62nlMtI9S242AZ/2gK
	 Q2ANqiw8pID5/DnSZ6c0yRsuHwwpXEcZFYzUgqfsP+93PHpVawi3N1tjf9jeecDAdG
	 wP/F+0evLUo8x7r+1UK/amFasmme31ROa4Z6H5ls/Jv7ZJwXxnPgfl79qcx0c8XN5W
	 /BIJEZLeZ8+KqMhn6OPIQj8vO1d9gEhfmqQSWvOr9IeA8ASaiqmwNliVodY8Z8vuh6
	 ZZyoJSNSVncpA==
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
Subject: [PATCH v6 01/10] xfs: don't skip the flush before shifting extents
Date: Mon, 09 Nov 2026 18:51:12 -0500
Message-ID: <20261109235111.14129-2-mason@kernel.org>
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

