Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445359;
	b=IJGDhUSisJ5jOJ8UBZOyGUkKFWATzuZs4HjKii+wE6ztye28Y2yNY5Hw8o+2ih7WByNg
	 fVJ9yojwUXl4AeOl5CojmXQWYCTxk3tnN3DWowo6xM8BGMkgs5R8x96qz99YrlkKjVus6
	 s6H6V7U1V6Ewr7eFqc/3n9LccG9eKwkMEHsSX6OHeLrEtim94MuF0sYFSASJ38AaBr4tv
	 4uHCfhRk8lluMvkKze6Bq8FqHueByhucNjrPYZVf+jJ8QANTVlQRGXxEKCWIT90qWTGK8
	 xa8ioZ7+IT3F3ZFUwKAg3jF6gEiYgU+iSTXY7EQ4zJrSEOL/B0clv/7YS9LDOmfLeJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445359;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WJzkgppT+OTshL2uvT2FBQPlOQsWWgpQVtiL2RyArLs=;
	b=WBcbgsC+fQtwxZvf1MxXm6WPLmsB1KbKFypUj4kK+XjLqfHvmX6/P+E7wsoCTy25LjC9
	 bOqMhBHJLSvrEM0r940ySO+7e9/8uJNKNQaGJrGT1fTxXaKRBGr8yYye03d1/ZVZe+1qc
	 AURvCR2UBQ7kcn7ojoNYAoNdIbvKF+rxf9SbFJ8W5pDVlusG3BuUCPdMPTT9l0Ga7Mh8T
	 wc9Q4jrnR/n4oRlICyJNksW125zRJ8NbH+VXoIdagmqzTGVS+Q1q5kvHnsLg8mhQxpimD
	 orF+jP5IuAHe2hlyclC52fhqeadrMAtSfoBwxE/m0Vk09AvHpkhnLEgvh2C6RmQIFDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNghZxpo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D7660A2629;
	Thu, 12 Nov 2026 01:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNghZxpo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55961F00A06;
	Thu, 12 Nov 2026 01:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445359;
	bh=WJzkgppT+OTshL2uvT2FBQPlOQsWWgpQVtiL2RyArLs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=CNghZxpo1mPgG0GIz6FVNO2KSeyuc8TmuNsSFvh8tWl+ltnDWGd45P6v9V+dfdhJn
	 Pl/cnTwaIYHrzFfuMt/Potl7z3W9iX5wc+M7fltonthXKEPpbFNR0nCxZrbNfrLSQb
	 o/cIJaVm+k4KCvcXFUsJrM5GdLtaw3/f+D40/IptymchJi27DjK+3Cj52wUwfrIRby
	 2Qb2BF/fDn0Grr85UiIvE51l6rpKHL9pTGFVpzvKHJ9m8UN7Sx6QwobjGWH8DFXJra
	 hIdd84hxEbHNqLeAGWkhfFpgL19dLd2PUdygzo/O0aacbrT/9EdUyDrQvyD0vD3wR5
	 XOhFVQiPzXM/w==
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
Subject: [PATCH v8 04/15] iomap: don't punch delalloc under a dirty EOF block
Date: Wed, 11 Nov 2026 20:02:33 -0500
Message-ID: <20261112010229.51029-5-mason@kernel.org>
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

After a failed buffered write, writeback on XFS can write in place to
the shared block that contains EOF, and corrupt the other file that
shares it.

After a failed buffered write, iomap_write_delalloc_release() punches
the delalloc reservation of the write, except under dirty folios, which
still need it. It looks for dirty folios only up to i_size, and punches
the rest unconditionally. But XFS rounds that punch down to a block
boundary, so the block that contains EOF loses its COW fork reservation,
and writeback goes to the shared block:

    block size 4096, i_size 5000, reservation 4096 to 8192
    searched for dirty folios:  4096 to 5000
    punched unconditionally:    5000 to 8192
    rounded to blocks by XFS:   4096 to 8192

The fix used here is to look for dirty folios up to the end of the block
that contains EOF.

Fixes: f43dc4dc3eff ("iomap: buffered write failure should not truncate the page cache")
Fixes: f6f91d290c8b ("xfs: punch delalloc extents from the COW fork for COW writes")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v7->v8:
    - No change.
    
    v6->v7:
    - No change.

 fs/iomap/buffered-io.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d6e2f1ded5ca..d0980a7f27d1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1495,9 +1495,34 @@ static void iomap_write_delalloc_scan(struct inode *inode,
  * mapping_seek_hole_data() will return it, and we will skip the punch because
  * the folio is dirty. THis is incorrect - we always need to punch out delalloc
  * beyond EOF in this case as writeback will never write back and covert that
- * delalloc block beyond EOF. Hence we limit the cached data scan range to EOF,
- * resulting in always punching out the range from the EOF to the end of the
- * range the iomap spans.
+ * delalloc block beyond EOF. Hence we limit the cached data scan range, and
+ * always punch out the range from the end of the scan to the end of the range
+ * the iomap spans.
+ *
+ * The scan cannot simply end at EOF, because EOF is a byte offset and a
+ * delalloc reservation covers whole blocks. If EOF lies inside a block, it
+ * splits that block in two:
+ *
+ *	[block start, EOF)	File data. If it is dirty it will be written
+ *				back, so the block must keep its delalloc
+ *				backing.
+ *	[EOF, block end)	Beyond EOF. By the rule above, this would always
+ *				be punched out.
+ *
+ * Both parts share one reservation, and it cannot be split: a punch of a part
+ * of a block takes away the reservation for the whole block. If the scan ended
+ * at EOF, we would skip the punch for the first part because it is dirty, and
+ * then punch the second part, which takes the reservation away from under the
+ * dirty data in the first part. On XFS, writeback that has lost a COW fork
+ * reservation like this writes in place, over a block that is shared with
+ * another file.
+ *
+ * Hence we treat the EOF block as a whole, and let the cached data over it
+ * decide: the scan range is rounded up to the end of the block that EOF lies
+ * in. If the data over the EOF block is dirty, the scan moves the punch start
+ * past the block. If it is clean, the block is punched like any other block in
+ * the range. Only blocks that start at or beyond EOF are punched
+ * unconditionally. If EOF is block aligned, the round up changes nothing.
  *
  * Intervals are of the form [start_byte, end_byte) (i.e. open ended) because it
  * matches the intervals returned by mapping_seek_hole_data(). i.e. SEEK_DATA
@@ -1511,7 +1536,8 @@ void iomap_write_delalloc_release(struct inode *inode, loff_t start_byte,
 		iomap_punch_t punch)
 {
 	loff_t punch_start_byte = start_byte;
-	loff_t scan_end_byte = min(i_size_read(inode), end_byte);
+	loff_t scan_end_byte = min_t(u64, end_byte,
+			round_up((u64)i_size_read(inode), i_blocksize(inode)));
 
 	/*
 	 * The caller must hold invalidate_lock to avoid races with page faults
-- 
2.55.0

