Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795425329;
	b=WdO8ChFGXwFJuVv6SodoZV0dPpLWsTlujbwGbVXLJB21stWeopBR0Mqg8x1+kykvKZi8
	 9uFxTphQhVljX9m2rVNr1DTGZaSNVpj61ucUb2CjLXdrWUT7lZ1dja0OIVlqmf9MRbfSh
	 BPO7zf+MKsw3tI3DcSrBxgbBTtOjgyV1TNO2tjykI2wKP0UfRV+LJsFWw/hZecRVbsGU4
	 Vu5dCWseUnwMERpDplu9UPZHeNjbhi3FSvaFX/avNpRm8G7ADzA+edkAeIwQrpKwQ7ckl
	 iPvO1zmxSfTx6mJdZNMT+WWMcsnqNXHaYokfQq3d0Xo69xINaHAPWVM9vazbuldtiag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795425329;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5QiqAXHt2Hqs0mxyFBDVb49lsswWbsrik6JHjFagC0E=;
	b=r7wtbGrOZWeBIcoIe/k0yuSopj+3BSaMYvWB4AFyyGDCGd/2srDb/e8N3LlgQQWxrtVB
	 9Zi9cvz6Ldl2LvT0VGdmc0hB5CkdofdtPPiqBBixvAuUKE3P+aHpH2cYNXzeDjFdgOsXA
	 OjCKanuFZXTTlvmrTpvqvllP5R0t782EUT6T93AX6rc0JHDP0Ku/AaMRT50gSxApeGzZH
	 5X/GDdIWASZdzd2SR8SOzkxOYbnx1Q3bASJ4ZRHuUzSVV00yyO52nyOU4Y4XxlRXmrvd0
	 hE5Zh1EccE/ca6of9jcQUmo6JK6/ycwods8S/xoiGyLUn8lMbeeSju+CFmF371Zbp7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rXosVCnm;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593E9606A31E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 09:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 593E9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rXosVCnm
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-38431138772so3899912eec.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 01:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795425328; x=1796030128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5QiqAXHt2Hqs0mxyFBDVb49lsswWbsrik6JHjFagC0E=;
        b=rXosVCnmkvQMppNL8dpOXhyAzDEi1IGOP1Nx3aBGlOPkY0cbK1y6eIGw8YSsw4YWwa
         1ptMwAxATLDGC5bQWLJtvxvDqB4BYH20JUrj67akh6uhInyajbXef6jplynZYq5UX6y+
         U3JamRm+sP+7OfnaTYC2SiwrmiimcfQxLy5Bkq6QZegq+1wbWUeKD2CPMvsrZnloQccu
         ngZUC30bVvRpoRPLbO1k1hn2H9ai93wC/IMod+rud+wlKQMKjUJoMfkykazDwcPXxOaB
         +19ddIUnPh/hV4alyMjT2AGM+nvWhRtLA5VplAgwtPHLxyVF8jEpeVMGY1UJMPdy788K
         10pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795425328; x=1796030128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5QiqAXHt2Hqs0mxyFBDVb49lsswWbsrik6JHjFagC0E=;
        b=0SU0Tj4rAszlyouc0fk0xn+ZVxpdNBcYSclv47vpCcsAxC1jSe7jw39A7uyGQxN5Fz
         xqEhcv6XcpheIwDTGjBJwrnNfrm2bnmH9gRk3revTdix0XOWgWFWRhYKZtXHNpYtkSeJ
         c1RfyCzpdduFNFXaQ9D/0esbSjqd4LMJc/B3XuqnpR0dRd42nwVAUL427C4mM0o8KHpF
         epPRsAFf79KbGIvUZkHcrQmc7U7q2OzElLy2HS88T5XlNdQkh0gztGd9x3SVv2V55S6R
         lYYMlDV1JMk381/py8V9Dpbxz78yAL0vL7WKkQCAnxPO5+zSgEQ1jP0wg12s0Fef6t3Z
         DY5g==
X-Gm-Message-State: APuU4Z/MxqyYs0eELRW4y+cgqhQ9pQF+FFaVLd2qdC0WoZyBXG4hb/wm
	B88ZJ0n8EQupUJOqM5MDmlq8+5poLvR88UPw9YHiRcVGE4+uc29pdoKA
X-Gm-Gg: AZFdTZewiPcEu210w6LmORN5IUAU+om4tVAjMH90AibHXyMFJGCzM6JrPZGQQldrLum
	wnmkVeIL4/JFIT/vCcsLDE0TDMcR4wAv+47kQFlt2+x8tPTjDwuGR+dBNI3HyEs5Q4mYRZNjXoU
	blx4EcxwDqVBzQBRyo5TGALw+pq3eDn6/7zaupBgVJVZ80VnKrYlKiIRo/Zp/vNxyX9F2mHeyfZ
	m/3bcs0hztyRSSwrMXQLSOKcjQskaygMDRHrtsitJ3Jo/go2caJ7aJBGuUlrx4Ft7u7KUjIt8+A
	xdZsrU2V4QVtZlS7ojyy+WoxdkoXVq1t9bZXFsv8ZlIin2LgcEbqDtcUQZnJ59RNXsDMGVGuT5M
	wJKu2Scu+JCOS7BdBRIduFzfd5C54tT0jVpPc5DY0KpFboFnwe/SxAXtMBzj+Key0npXWbZycSG
	HJmh0w91RC0YLuWnfv8oS/KaaLgvjHB+Dc0f10HX3/djhQ68cbH8xqJ+ghsvdLAXvaQZF87CC6h
	M6Rdo7sx9P/d54vjn+gYuSp5WvVKRrUMMLthJ8Uy7j+ZB2jexOWtkocq9u5loYtSlACVElpgpBW
	95HyVpd86mEQYXZhcBRlzQlhduG0VuD/zpbcm/CHDA==
X-Received: by 2002:a05:693c:8803:20b0:386:9b9c:ef1b with SMTP id 5a478bee46e88-3869b9cf99amr6973944eec.3.1795425328281;
        Mon, 23 Nov 2026 01:15:28 -0800 (PST)
Received: from a1-free ([161.33.196.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385672c6f31sm33641787eec.15.2026.11.23.01.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 01:15:27 -0800 (PST)
From: TAKANO Mitsuhiro <takano32@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	TAKANO Mitsuhiro <takano32@gmail.com>
Subject: [PATCH] iomap: fix kernel-doc warnings in iomap.h
Date: Mon, 23 Nov 2026 09:15:23 +0000
Message-ID: <20261123091523.3976398-1-takano32@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kernel-doc -Wall reports eight distinct warnings for include/linux/iomap.h,
each printed twice:

  struct member 'fbatch' not described in 'iomap_iter'
  struct member 'private' not described in 'iomap_iter'
  No description found for return value of 'iomap_length_trim'
  No description found for return value of 'iomap_length'
  function parameter 'iter' not described in 'iomap_iter_advance_full'
  No description found for return value of 'iomap_iter_advance_full'
  No description found for return value of 'iomap_iter_srcmap'
  No description found for return value of 'iomap_iter_next'

Document @fbatch (the batch of dirty folios iomap_zero_range() passes for
iomap_fill_dirty_folios() to fill) and @private (the file system's own
data, opaque to iomap), add the missing @iter to
iomap_iter_advance_full(), and add Return: sections.

iomap_iter_next() ended its description with "Returns 1 to continue
iterating, 0 once the range is fully consumed, or a negative errno on
error." without a colon, so kernel-doc found no return description.  Add
the colon, and say that 0 is also returned when the file system made no
progress without marking the mapping stale, as iomap_iter_continue() does.

Fix the two typos in the iomap_iter_srcmap() description, and the
&i->iomap that renders as a broken cross-reference, while there.

After:

  $ scripts/kernel-doc -Wall -none include/linux/iomap.h
  (no output)

No functional change.

The changelog and the added kernel-doc text were written with Hermes Agent
(deepseek-v4.1-flash); I reviewed them against the code and ran
kernel-doc -Wall on the file before and after.  No build was run, as only
comments change.

Signed-off-by: TAKANO Mitsuhiro <takano32@gmail.com>
---
 include/linux/iomap.h | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 372453dbf2d4..c82608169077 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -259,6 +259,9 @@ struct iomap_ops {
  * @flags: Zero or more of the iomap_begin flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
+ * @fbatch: Optional batch of dirty folios for zero-range processing, set up
+ *	by iomap_zero_range() and filled by iomap_fill_dirty_folios()
+ * @private: File system specific data for this iteration; opaque to iomap
  */
 struct iomap_iter {
 	struct inode *inode;
@@ -282,8 +285,9 @@ int iomap_iter_advance(struct iomap_iter *iter, u64 count);
  * @pos: File position to trim from.
  * @len: Length of the mapping to trim to.
  *
- * Returns a trimmed length that the operation applies to for the current
- * iteration.
+ * Return: The length that the operation applies to for the current
+ * iteration: @len, limited to the end of the current mapping and, if
+ * @iter->srcmap is not a hole, to the end of the source mapping.
  */
 static inline u64 iomap_length_trim(const struct iomap_iter *iter, loff_t pos,
 		u64 len)
@@ -299,7 +303,9 @@ static inline u64 iomap_length_trim(const struct iomap_iter *iter, loff_t pos,
  * iomap_length - length of the current iomap iteration
  * @iter: iteration structure
  *
- * Returns the length that the operation applies to for the current iteration.
+ * Return: The length of the current iteration: @iter->len, limited to the end
+ * of the current mapping and, if @iter->srcmap is not a hole, to the end of
+ * the source mapping.
  */
 static inline u64 iomap_length(const struct iomap_iter *iter)
 {
@@ -308,6 +314,9 @@ static inline u64 iomap_length(const struct iomap_iter *iter)
 
 /**
  * iomap_iter_advance_full - advance by the full length of current map
+ * @iter: iteration structure
+ *
+ * Return: Always 0.
  */
 static inline int iomap_iter_advance_full(struct iomap_iter *iter)
 {
@@ -319,9 +328,12 @@ static inline int iomap_iter_advance_full(struct iomap_iter *iter)
  * @i: iteration structure
  *
  * Write operations on file systems with reflink support might require a
- * source and a destination map.  This function retourns the source map
- * for a given operation, which may or may no be identical to the destination
- * map in &i->iomap.
+ * source and a destination map.  This function returns the source map
+ * for a given operation, which may or may not be identical to the destination
+ * map in ``i->iomap``.
+ *
+ * Return: The source map for the current iteration, or a pointer to
+ * ``i->iomap`` if there is no separate source map.
  */
 static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 {
@@ -350,7 +362,8 @@ int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
  * compile-time-constant @begin and @end callbacks, the compiler can call them
  * directly, avoiding the indirect-call overhead.
  *
- * Returns 1 to continue iterating, 0 once the range is fully consumed, or a
+ * Return: 1 to continue iterating, 0 once the range is fully consumed or the
+ * file system made no progress without marking the mapping stale, or a
  * negative errno on error.
  */
 static __always_inline int iomap_iter_next(const struct iomap_iter *iter,

base-commit: 4c7bbc7f82ff8820a4c9be8f662430bec640e2da
-- 
2.53.0

