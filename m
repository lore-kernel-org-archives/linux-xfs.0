Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402053161B1;
	Thu, 26 Feb 2026 23:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772148883; cv=none; b=PnyO+qC3quOcWnRghh6xei/queWASLVXEXW9sZ5TxYiDkjVXLzCY+2GUk5R/fY4FtvXBcRJj/KBtorDpJGtVVxiQWxuZVivCxXP3djAWaBGxEmWVsBVTFxdQsBSkDP4aM+7iKUO6nR1/n8Vt4AMlxoVjiTmVCKsaVCxmUWpgufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772148883; c=relaxed/simple;
	bh=G2Z7NtCHIUHHKGxjUBF3fdUwmVbb9a6Zf/tXL6GG43M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=j3UwGsytndIPs4EEdeDu/3Kgq2uTtGTd6bEku+qBZ+2Hb6HW58gWvr+ziS2+ybewkkczBaFIHDZbHV0txQy9TQs1x0h8w/Ww6g1sL1Su4TDEDqjR3obCPc7ZN/MqjkGXaZeyJjvKxep3Qz0/6UVil6iIqEd8oFETbrrY2TW3BH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGG4KyyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGG4KyyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DC2C116C6;
	Thu, 26 Feb 2026 23:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772148883;
	bh=G2Z7NtCHIUHHKGxjUBF3fdUwmVbb9a6Zf/tXL6GG43M=;
	h=Date:From:To:Cc:Subject:From;
	b=GGG4KyyWtsu8Nma3uN6kDBbJrN7Hfq8ui26uIuQppUcvjLVQJXOphL7uhL22O/Lzk
	 ThQlv3RbmQa2+gITC31CICayHyigruVymgwZEf1MxHzwm0w7XDjNkgk916LhxkVGT6
	 d6LapOWKN3+XkHRry3himAiRfX5EHIiwJNa9GhkpIcZcjvxXpfu0WQt8tyf6877KKL
	 Crm2CvVXpKySLxHwcSu2jT3BMBuDJOwKpM56e6g1sVlKiBJjXG2OFJ8bUd7bNztE2j
	 vKQicSUNr9jWY8/N1IqTzGwOHgds6kunka/VRiEg801vZP5ocslBo9/U0JvmnFcWmy
	 CKzSGjmJkxBxA==
Date: Thu, 26 Feb 2026 15:34:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] iomap: reject delalloc mappings during writeback
Message-ID: <20260226233442.GH13853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Filesystems should never provide a delayed allocation mapping to
writeback; they're supposed to allocate the space before replying.
This can lead to weird IO errors and crashes in the block layer if the
filesystem is being malicious, or if it hadn't set iomap->dev because
it's a delalloc mapping.

Fix this by failing writeback on delalloc mappings.  Currently no
filesystems actually misbehave in this manner, but we ought to be
stricter about things like that.

Cc: <stable@vger.kernel.org> # v5.5
Fixes: 598ecfbaa742ac ("iomap: lift the xfs writeback code to iomap")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v2: futureproof new iomap types
---
 fs/iomap/ioend.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 4d1ef8a2cee90b..60546fa14dfe4d 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -215,17 +215,18 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	WARN_ON_ONCE(!folio->private && map_len < dirty_len);
 
 	switch (wpc->iomap.type) {
-	case IOMAP_INLINE:
-		WARN_ON_ONCE(1);
-		return -EIO;
+	case IOMAP_UNWRITTEN:
+		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
+		break;
+	case IOMAP_MAPPED:
+		break;
 	case IOMAP_HOLE:
 		return map_len;
 	default:
-		break;
+		WARN_ON_ONCE(1);
+		return -EIO;
 	}
 
-	if (wpc->iomap.type == IOMAP_UNWRITTEN)
-		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
 	if (folio_test_dropbehind(folio))
