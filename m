Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793270131;
	b=HGhl4nNOFRHEIA6S15KkGGl8mTs2On5CzEPDIQKQenrLGQDlCqrL+heWVp/7rhivLROP
	 5I87yB1Os3ZhaqKJ1Ur7ySKlm0z46Np1L06Hnv4lF/hGGDU0kOONtvtonl5kEInJoVBve
	 u3y71th7uCXisc3KQbStLCEKlOCcEjGSUUaKMbffD39rJo//XYoXyeowwIFOx2oXlU9je
	 nmtfLxNNCLYz9zjK1hcUT9CqTSJ9MbSM2zhWKFgRkbqm2J8ZB0JIS5eeMotW0clyynB/D
	 7RN+wZhX1rD5HwN46IafYpo6ceDg0YYQEWoOSKPJnnHJAmgnxPxtrecwviOh3CsDYcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270131;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=cBWGva/S1/B3O37SqIcaxTQf0kaXIYVi4a/92o3xmgM=;
	b=gWny38m5Vr1WUZnUE2Dn2z+aKIA5DcfZdC7jgkf+088YPeB2uXKuPaSuMJFBwx9Jp3cq
	 FzjxYGoiDWZxypPYC49YhprGpk7LsXZ0zryN/bBJ60ih9tmFBPgIU4eS7oLFTw3bhHEDa
	 3tk2moLzVS80twBkzOly1OeQSjNcMYDF9iHhLG2o0PClAlw9rhih2s7KJ225S8h+yaDEe
	 vyl6KzrbGTYAaB/hroP25VC9qZpERTYQxYc+rdyF9VIeR0s86Vns+j3iUhGHC9297qe5/
	 MhDb6W+2Tx4NrERLcFvNPYw/wVDZLAlLwY0O1KA/boCw+oHkQHW5mSvkqrfyvvdZw1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hC0TQ07F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67981606A32A;
	Thu, 29 Oct 2026 10:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hC0TQ07F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F2F1F01828;
	Thu, 29 Oct 2026 10:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270131;
	bh=cBWGva/S1/B3O37SqIcaxTQf0kaXIYVi4a/92o3xmgM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hC0TQ07FmlEwsruA6EVt0hXwQX16x+89fdfYuTuCfpRAq3pfj1YswJqlffF5Iy10u
	 utSCLbIYlWgfAf5CSiqU6sVFYk9V7EcYPi6rAvKSlbXlsbE+8HhMrdOW/Xbme3yALq
	 q8rAej7uA/a/fKncb5PXkM7VZdtOPWvwQyI3oy7gRd8TgOt7O4hzaaluXPncL8d0+d
	 02m5mwuq5mJUcns9705NpXEQTlrPtnoedtSzsAdOVUWREwSAyYDsO/hTZmDdGTdT2Z
	 Rat+QxPhrwYdtgdE0qWtQGizN35mcIjZAHzb8H08i3mBXD4/NBDpd98f/acfEMX9Zt
	 siB69CMjmtNRg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 11:34:48 +0100
Subject: [PATCH 1/2] iomap: don't mark unwritten parts of a folio uptodate
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org>
In-Reply-To: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <clm@meta.com>, 
 Josef Bacik <josef@toxicpanda.com>, Matthew Wilcox <willy@infradead.org>, 
 Zhang Yi <yi.zhang@huaweicloud.com>, Joanne Koong <joannelkoong@gmail.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2839; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZeXH9ONHEkqA3dhk443w8Rc6MDPLr/YBJKFGLJOsmcU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9VszK9g5f3WLhkzxh27/30xuzdbZu8FzRcNQr/sT+2
 4t8s7ksOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbSY87IsG75ns5rt28vfL2+
 SXrF2lvb78+fk6lypS32eptjjNDFzDUM/2yZP584bjfhm31r8PywzS62bm8bjfT7Xmw+ZZMyOVj
 lDRcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

For a buffered write into a hole, an unwritten or new extent, or past
EOF __iomap_write_begin() zeroes the parts of the blocks outside of the
write and then marks the blocks uptodate. That includes the range of the
write itself which still holds whatever was in the folio before. It only
becomes valid once the copy from userspace has filled it in.

But the copy can come up short and __iomap_write_end() only rejects a
short copy if the folio isn't uptodate. If the zeroed blocks were all
that was missing the folio is uptodate by then, the short copy is
accepted, and the rest of the range is exposed to readers and can end up
on disk. A source buffer that ends in an unmapped page is enough:

        ftruncate(fd, 4096);
        pwrite(fd, p, 3000, 100);    /* 16 bytes at p, then PROT_NONE */
        pread(fd, buf, 4096, 0);

The write returns 16 and the read returns 2984 bytes of whatever was in
that page before. If other blocks of the folio aren't uptodate the short
copy is rejected but the zeroed blocks keep their uptodate bits and the
retry with the copied length leaves the same bytes behind.

Only mark blocks uptodate in __iomap_write_begin() after reading them.
__iomap_write_end() marks the zeroed blocks uptodate once the copy has
succeeded and rejects a short copy.

Willy reported this back in 2024 (cf. [1]) and Zhang Yi posted the same
fix (cf. [2]) but it never got merged.

[1]: https://lore.kernel.org/all/ZqsN5ouQTEc1KAzV@casper.infradead.org
[2]: https://lore.kernel.org/all/20240812121159.3775074-6-yi.zhang@huaweicloud.com

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 907873073b03..d6e2f1ded5ca 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -920,6 +920,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 		if (iomap_block_needs_zeroing(iter, block_start)) {
 			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
+			/* uptodate once copied, see __iomap_write_end() */
 			folio_zero_segments(folio, poff, from, to, poff + plen);
 		} else {
 			const struct iomap *iomap = iomap_iter_srcmap(iter);
@@ -943,8 +944,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 
 			if (iomap->flags & IOMAP_F_ZERO_TAIL)
 				folio_zero_segment(folio, to, poff + plen);
+			iomap_set_range_uptodate(folio, poff, plen);
 		}
-		iomap_set_range_uptodate(folio, poff, plen);
 	} while ((block_start += plen) < block_end);
 
 	return 0;

-- 
2.53.0

