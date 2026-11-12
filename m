Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519974;
	b=YIlGPSOVxOEQ4SjdCJncd1jtgt/hAmgTnj6tEcyZ3nvME1TwQf5PXFrH1fiNPvqlt60h
	 bloC/IpBxok5rZEP/gS8+OL/4DnK7bZFNlfzdeMb3XrS3/f8kA32dVuaZyNOINdne3KoG
	 YQV/QDkoZ2u5cjXXNDOJoeIRZN6VgV4DzFwG1f7d72UIv7ENvNr27d9OgZG81hzRHEGrK
	 AlY5MByrJutdaU1XBD0K2pY4N6YliKxAVF39GRKF2jr7sEM6gXzh8uEghqA8/T2vvOvR+
	 7oR69tYwwUHv846TAioNbmH87v/h14zvBphh1eUIsJpWQ6kCqBqWr+dcnmTSOYOfVyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519974;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=C3hb7Mizp+9AW+C3MfKeLR69A8Bj7z1Yqo/IjZCkVfQ=;
	b=wgrqaugdJiuq3v1DLQdiul5h63wBVXVcyz9SkYSIn6ekAjuuo8giWgm447KG//YNnbvP
	 er8kU6S/UBAm9/PE9G3CBaIwAcG5TGUYSYk8V3Sd+jF07A99i+3tztBemmCqkwivvKI6i
	 c5uqRNVqDclfX9gL/7Mh8xn6p4D7+gqJ7IDECqbcvmNmioMJzUQ89smFOnP4x/4/A6Q6D
	 jm9KTmMm3FGRKFWquGZgOLMvC5F3COlvm6c5NfOq3u9aiePYHqECLa5rr8NZBnHADWDva
	 jdPwYgiqC3hoFDwRD91rjMMj2AisoeePUjYGUKe4608889TtowgEMA6EczuwCFvTD7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6PuyKJv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C605B606A32D;
	Thu, 12 Nov 2026 21:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6PuyKJv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EA61F000CA;
	Thu, 12 Nov 2026 21:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519974;
	bh=C3hb7Mizp+9AW+C3MfKeLR69A8Bj7z1Yqo/IjZCkVfQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=K6PuyKJvMoFeUO6XMKSDVtJS0ZKS/ZospKHmQUpO1J9WuUcLDu2NDpgVkclKWrbGP
	 GjSlX67hhTdTVD2Ef6k2Mcc3KAI87m9jwHA6I1HnFvr5RGNkWNXeeXR3Lrp992epIZ
	 prCZfO97SLy8jkW6ShYtuCtH5RuJ1RX0sjkrykHyhO1tT1ISt6yJsfT+VCFKYz1Qkg
	 3Ln8xPLuhd7G5ZRuDMU3DwTUAhjOt6FQb/C3edaRLNPSMJlaEfdrXOwSSVWg8Zo/dN
	 u/HF7fmfuB8UDv8IZ+3aB8NTOYyRzixsfRuJu1viSH5+WWp2SMu2xQRWmiF4MTXMXK
	 hElsfPf9hn6uw==
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
Subject: [PATCH v9 04/14] iomap: don't punch delalloc under a dirty EOF block
Date: Thu, 12 Nov 2026 16:46:08 -0500
Message-ID: <20261112214604.67875-5-mason@kernel.org>
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
    v6->v9: no change

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

