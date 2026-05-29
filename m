Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24714219FE
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 19:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780081930; cv=none; b=WC0lxTUSlEgcLsp3Y1l+Cvn0dV7NxZmOjwUlIKPFCXSAUtDJn3S45kp5pNdwPzqb5H0SCbuauOUYLfSQ01cX7Mxd0yz+n6eenLBMHrtPgqyPBDcrHDOBhq7SeNZ2unw99wCdyaInE9CqlDMqYit+SSOtJ3gJszBsLG8qRXWh05M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780081930; c=relaxed/simple;
	bh=YLNPjjiAfCvu2EBqMYZsT+325sprKCnOx6Rt96Wmvho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TDl1C+NFjBpc7a2ozdlb5x7+hD9faop659Bi4XASFqlpukSvLpJXg5GbNjoFNpBqIq+wAoIFdJyNFO06i5OL+NnX/fMLTXZL2znHTjY40LeN/TRVDtlv3iWmH5579WzCVrA1vgB+gqUVdQAhjKnSAenSfe/RALeQxpH0EY9PwgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redpanda.com; spf=pass smtp.mailfrom=redpanda.com; dkim=pass (2048-bit key) header.d=redpanda.com header.i=@redpanda.com header.b=ZmzTfsXZ; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=redpanda.com header.i=@redpanda.com header.b="ZmzTfsXZ"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8b98482b253so227890796d6.1
        for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 12:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redpanda.com; s=google; t=1780081927; x=1780686727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nzaumKtRXQCmCnhwsw64N8vwi4INNB2egDR8KN4hCE0=;
        b=ZmzTfsXZsPFZtaj+7VdSvCrSuZH00zqLOBobFwn2GqlNWOS2BozEuxSyuiY+pBTBcK
         j5nOvgkxTS44uZM47XjrwSLylTukEqg5/2VTGkWoVJdi2WlwRa6pCO9KVKI1I3p1vL9P
         32PAguwwtXMb+kH1XbYmskqRahdvab6ZP9BxZ2Gu32EjC1eozijhbKt40ZJz7bMzX7M3
         l4SXGlI39w5KwxBlVIfN894rw/J0Ybm+lVRaPWlsBLlH+98WItyBBHMKmcGv1frLL1TO
         JtXxmHRtItosY53apXUqDOxjZp7NVV5TaCnCRmJqhRlD+WP8Crz9K9/vfixVVzMl1czI
         +M6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780081927; x=1780686727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzaumKtRXQCmCnhwsw64N8vwi4INNB2egDR8KN4hCE0=;
        b=APUpLiLK1x05xmndTxEw2z6XP6J8eb51sD/nhh0V+TfLLXQLGLDM319tK2zV403UKp
         FiYDMLGfhvk+oTQmisZRNfRIxyOli4IMXQ57yreEdQ7pacIr4SMFwsISY8GzkbvwjvlT
         ONzdkS0rNBHEsnRCnT7Yg+sKlUErMtuIxbnPD/gVb+V2f1wc0YP3hw4KMsEwaHKdRh06
         PKCKNklRvI8BbHanEpgJbm1D6s/uEEXC4u+TWORRAE7P/03iOCgUzklqknuNaBbkRvMb
         OjtDqZhWZTiVKUG/I68SJwZ1I1zer25umyiPDyk5NJ+16+4x9DIQF7Y8VEyR4PiPBKI7
         TxbA==
X-Gm-Message-State: AOJu0YwC5xbV5g8aDVVriupIGlqYOHIa8nkeRx0kAkfd17514R+F6/oe
	LEUx16fW2IhVw1tuBA4oE83Ls86uqJoVpRfAMfKf5jBfAZZpeXPYIe9whwmomyayph9G4CE4rh3
	R9lVTehh+Su3+hzln0ukitdB7s9V/fGppn1uRs5wa8HjGUHu33JRoY9/N7U8jUlzB+rwKrStG4B
	E=
X-Gm-Gg: Acq92OHsFC5SAwNOg+OHuiW2AmqLZCUq/6UAcSGEctfFhT8jaUFAmDO1pW4558MJX/v
	+cFIwi4JA8dTaZkGHePTUr++Rd2iId5OUuX8OtHP02iXE6pu6bXSgEdGji2WIUiqxq8nF1BqQJb
	pD+cms2NszwU56T/Wg6iFqKRdcH4lGUjXmN+GWK1SJO94bAfGOm20+phrES+zROs3j9jN3ImbuS
	8VdF20qE/iFHe3L7UJNHPO38x1ytn6uZfkqsxPVuhmP9+6aYG2rEEIRUl8lGWYOunKg0pMuWS0l
	TRLLZ/zMgebhdh89l9pe+Zgq1r2YLM4WQDWVKmEHBePLKV/v/x4lOzRGxH1uyyNbP0dYliR6JH2
	rYzAEJa3FM92hvDaLmsV8JHxa474W6pRALbyjbkGzZ6YwVOiS8KXXvmlQ4tt8JDKovYpWsBajDT
	wvFRGoKmAwFvjgNjt7V+TYwWzLwLlXf/0AmLJ6v2WTPwKYfDjX
X-Received: by 2002:a05:6214:4499:b0:8cc:ce03:c017 with SMTP id 6a1803df08f44-8ccefb28fb8mr19550306d6.9.1780081927544;
        Fri, 29 May 2026 12:12:07 -0700 (PDT)
Received: from fedora.tail5a808e.ts.net ([72.228.86.65])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea24d2aesm24464196d6.45.2026.05.29.12.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 12:12:07 -0700 (PDT)
From: Brandon Allard <brandon@redpanda.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	linux-kernel@vger.kernel.org,
	Brandon Allard <brandon@redpanda.com>
Subject: [PATCH] xfs: coalesce contiguous unwritten suffix into iomap for NOWAIT writes
Date: Fri, 29 May 2026 15:11:00 -0400
Message-ID: <20260529191100.4142371-1-brandon@redpanda.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

In append-only direct-IO workloads with fallocate(with KEEP_SIZE +
ZERO_RANGE) writes can span the written/unwritten boundary of the
preallocated extent. This is from callers needing to overwrite the
previously written block if the last write didn't completely fill it.

Prior to commit 883a790a8440 ("xfs: don't allow NOWAIT DIO across extent
boundaries") these writes succeeded by issuing two bios: one against the
NORM head, one against the UNWRITTEN tail. That commit closed off the
two-bio path to prevent NOWAIT callers from observing short writes when
one bio succeeded and another returned -EAGAIN. The side effect is that
the workload above now returns -EAGAIN on the spanning write.

This patch restores the success path by coalescing the (NORM, UNWRITTEN)
pair into a single in-memory iomap when the two records are physically
contiguous on disk. The merged range is reported as UNWRITTEN so
iomap_dio submits a single contiguous bio and the completion handler
runs xfs_iomap_write_unwritten across the merged range.

Short writes are still prevented. The merged iomap describes a single
contiguous physical extent, so iomap_dio still submits a single bio
for the full range. The caller observes the same all-or-nothing
behaviour as a write into a single UNWRITTEN extent.

The completion of the write also remains correct.
xfs_bmapi_convert_unwritten returns early on the already-NORM prefix
without dirtying the transaction, while the UNWRITTEN suffix flips to
NORM and the two adjacent same-state records coalesce in the bmbt as a
side effect of xfs_bmap_add_extent_unwritten_real.

A companion regression test will be posted separately to
fstests@vger.kernel.org.

Signed-off-by: Brandon Allard <brandon@redpanda.com>

Tested with xfstests against linux-xfs HEAD on a 4k-block XFS via
virtme-ng (vng --memory=64G --overlay-rwdir=/tmp -- ./check -g auto).
1266/1271 PASS. The failures seem unrelated and reproduce on 7.0:
  * generic/753 - flaky dm-error + log-recovery loop, unrelated path
  * generic/754 - pending xfs_repair fix (test self-declares xfsprogs
    commit XXXXXXXXXXXXX as a precondition)
  * xfs/078     - newer mkfs.xfs AG/log geometry vs stale golden
  * xfs/216     - newer mkfs.xfs log-size heuristic vs stale golden
  * xfs/217     - same heuristic, larger-fs sibling of xfs/216
---
 fs/xfs/xfs_iomap.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index be86d43044df..d7164d00a7b2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -809,6 +809,41 @@ imap_spans_range(
 	return true;
 }
 
+/*
+ * If imap doesn't span the requested range but the immediately-following bmbt
+ * record is unwritten and physically contiguous, extend imap to cover it and
+ * report the merged range as unwritten.
+ */
+static bool
+imap_extend_into_unwritten(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	xfs_fileoff_t		end_fsb)
+{
+	struct xfs_bmbt_irec	next;
+	xfs_fileoff_t		next_off;
+	int			nimaps = 1;
+	int			error;
+
+	if (!xfs_bmap_is_written_extent(imap))
+		return false;
+
+	next_off = imap->br_startoff + imap->br_blockcount;
+	error = xfs_bmapi_read(ip, next_off, end_fsb - next_off, &next,
+			       &nimaps, 0);
+	if (error || nimaps == 0)
+		return false;
+
+	if (next.br_state != XFS_EXT_UNWRITTEN ||
+	    next.br_startblock != imap->br_startblock + imap->br_blockcount ||
+	    !imap_spans_range(&next, next_off, end_fsb))
+		return false;
+
+	imap->br_blockcount += next.br_blockcount;
+	imap->br_state = XFS_EXT_UNWRITTEN;
+	return true;
+}
+
 static bool
 xfs_bmap_hw_atomic_write_possible(
 	struct xfs_inode	*ip,
@@ -961,7 +996,14 @@ xfs_direct_write_iomap_begin(
 	 */
 	if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY)) {
 		error = -EAGAIN;
-		if (!imap_spans_range(&imap, offset_fsb, end_fsb))
+		/*
+		 * Sequential append workloads with adaptive preallocation can
+		 * span the NORM->UNWRITTEN boundary that unwritten conversion
+		 * leaves behind. Try to coalesce the next contiguous unwritten record
+		 * into imap before returning -EAGAIN.
+		 */
+		if (!imap_spans_range(&imap, offset_fsb, end_fsb) &&
+		    !imap_extend_into_unwritten(ip, &imap, end_fsb))
 			goto out_unlock;
 	}
 
-- 
2.48.1

