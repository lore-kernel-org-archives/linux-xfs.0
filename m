Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268280;
	b=XzLTRhlcjge2pXDCkFQLw746tixVgxOxPVn4mynla1EB+G9NSH5Z9HLlzePPsH8IELg7
	 7IRMwFaF2VKEU0Q3bYFqRu+Ge9CG/d5C8vpb1qzmXLYaFlvILFh+90872kgQi4fDmzAGT
	 ul1RmaAgkzRc2lHTo+TBFn/j3puWGGH/gVh5If4MRqFUzO7w9JQarcer0s3z6XxB13eWc
	 FzSYcq/4CDpSwzZpkKqhuBhJdbFtFswOYPvQ7TIMjp9c3Q9zczexZhLUjNJdsej6hj8Il
	 XYXWFPQwpEb9HpeDvYnklvfWpT+2hw68Drd7bV0MZ+e9R/DoGhTjI99ZuRgcmxXnDsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268280;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ojny3GXsnm0Ra2ohVZXS1/GltzxL9d5vHYkxIh98clU=;
	b=q79QBctmE8g7f9UUKFlkPl5uDig8rRKzEgi2aZLKZInXYcbzwiEqrw9cf+GMUgZad9iF
	 sj2rGm3r9peyQvJ0GW6VBpoQkJUdmJbkp44hnRUZ6kHKhpSCa0vhot2QB4mtzoRxy6EmQ
	 hcX68yTejENna2vNMHc2r02HWhe7Z+WoUIpvOVRtFe/VTuutwwYRKmUkhZQVUpCTBW/bp
	 WoOr4znM92VRmm/DC7R2Im0wO8TWvgaE0BZF+fJL4GLA2iryC+Mlnul9R/iqbstB50+e9
	 rEcF+fGXrMQ+BFBaTlbbRDl1+h1jk5nm8o+7s4a6hFx74I/VYXrdRpFDkipP4CHiPlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VxXDNdjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A5060A2601;
	Mon,  9 Nov 2026 23:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VxXDNdjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C561F008A2;
	Mon,  9 Nov 2026 23:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268279;
	bh=ojny3GXsnm0Ra2ohVZXS1/GltzxL9d5vHYkxIh98clU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=VxXDNdjA4AKWy+6M0ZAKo2BYcqeDlDiUrK6o+E3uLIreFU7JVVXQ4SN0sogbBTaLb
	 4yqhLW8S1YJAj2hDeczXr5DIfAN3W1nMUdZAaoWAD+2wqFoE8DlJ2FFWfAnFHlGhgY
	 C0E2SCEE7LcetmjuepUZu1SRB23JEiftkMqVOf1Lce1JAGaUSYu6g6OwycnaNmhcMh
	 2k60lrPy6r36RBEM9A4t22Ea3dvASElMUSVdX8CD4xfGAa3yH0mHk6d3/PMCizQwLe
	 z+NsDEBkg1C0aYG2o7XlyWybP3xIuAzjzO2IM8tF1sdMK2BE87G04vj0zYoNV8+SM4
	 JdMKDPk88sdJw==
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
Subject: [PATCH v6 04/10] iomap: don't punch delalloc under a dirty EOF block
Date: Mon, 09 Nov 2026 18:51:15 -0500
Message-ID: <20261109235111.14129-5-mason@kernel.org>
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

