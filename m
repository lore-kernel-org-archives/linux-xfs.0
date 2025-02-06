Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C176C23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881307; cv=none; b=LakXTLKC71oO7MCLDabFs5G1U2VTJoP0jJMFkMLu6jsyqIEex912ogi1oe0PsP4+GJyoCpgRTYxRDo8PjBfLv1FD2jwreq2f/NajNT4lwuKGKwD2IEh3Q5YQ3Nq5AWt4NVRsDgyIR0vEZBo0KulzGLak90QP3CghTtnMFB6zsHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881307; c=relaxed/simple;
	bh=1ZI6SBq5e4VMF7WCR4KuSUIlVRiklt4AHPT/rURa1qs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfWvjZLR2Y3jg7FcBtW3r7cl+HaVENU1ZjjvpUUiRdj1qinisZAADzsIHROfydLKXbO2Li2pAenXLOxWYjdTyXb64jjsDWOGZFYkBp9h5fvMCSSDpmhJIvCoRknznzLE76imlQXFnuOXP8gD9bfrDIgwOIGQ93BB7Vlkn9kMqmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkM814fM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkM814fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E8CC4CEDD;
	Thu,  6 Feb 2025 22:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881307;
	bh=1ZI6SBq5e4VMF7WCR4KuSUIlVRiklt4AHPT/rURa1qs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rkM814fM5nFd2K3cP+MOIUIKz0kLisHTFC5GqCupFPMH/M5DYIgYgL1KASwo0jdzh
	 3IFY3J1W/Mo160u01+i19q0V5AKh/3n62HK91rLPODpa74wfwbCkLrTgQYSHHWHu9h
	 IlljoQtPVYBuC34gilAx40QwkoS+PYxQIEY3VQf1qVHATixrQGHEyiRPjjxzKO9YWj
	 vHMDDiZui5SpyqRYat0aaqy7Cp8Rn5lX1hFbY9mcZLldLeJRkIvmdVkILdhaixmczh
	 wCStkO3BstI46vfn1XQPNqqVyQAuD//bt7UyIgkGy9Q+hazss6DVErsgVAiBMolMYo
	 OME59R/AsdO4Q==
Date: Thu, 06 Feb 2025 14:35:06 -0800
Subject: [PATCH 17/17] xfs_scrub: try harder to fill the bulkstat array with
 bulkstat()
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086317.2738568.6808179914591920294.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Sometimes, the last bulkstat record returned by the first xfrog_bulkstat
call in bulkstat_for_inumbers will contain an inumber less than the
highest allocated inode mentioned in the inumbers record.  This happens
either because the inodes have been freed, or because the the kernel
encountered a corrupt inode during bulkstat and stopped filling up the
array.

In both cases, we can call bulkstat again to try to fill up the rest of
the array.  If there are newly allocated inodes, they'll be returned; if
we've truly hit the end of the filesystem, the kernel will return zero
records; and if the first allocated inode is indeed corrupt, the kernel
will return EFSCORRUPTED.

As an optimization to avoid the single-step code, call bulkstat with an
increasing ino parameter until the bulkstat array is full or the kernel
tells us there are no bulkstat records to return.  This speeds things
up a bit in cases where the allocmask is all ones and only the second
inode is corrupt.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/bitmask.h |    6 +++
 scrub/inodes.c    |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+), 1 deletion(-)


diff --git a/libfrog/bitmask.h b/libfrog/bitmask.h
index 719a6bfd29db38..47e39a1e09d002 100644
--- a/libfrog/bitmask.h
+++ b/libfrog/bitmask.h
@@ -42,4 +42,10 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 	return 0;
 }
 
+/* Get high bit set out of 64-bit argument, -1 if none set */
+static inline int xfrog_highbit64(uint64_t v)
+{
+	return fls64(v) - 1;
+}
+
 #endif /* __LIBFROG_BITMASK_H_ */
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 24a1dcab94c22d..2f3c87be79f783 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -20,6 +20,8 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 #include "libfrog/handle_priv.h"
+#include "bitops.h"
+#include "libfrog/bitmask.h"
 
 /*
  * Iterate a range of inodes.
@@ -56,6 +58,15 @@
  * avoid scanning inodes that are not in the inumber chunk.  In case (3) we
  * conclude that there were no inodes left to scan and terminate.
  *
+ * In case (2) and (4) we don't know why bulkstat returned fewer than C
+ * elements.  We might have found the end of the filesystem, or the kernel
+ * might have found a corrupt inode and stopped.  This we must investigate by
+ * trying to fill out the rest of the bstat array starting with the next
+ * inumber after the last bstat array element filled, and continuing until S'
+ * is beyond S0 + C, or the array is full.  Each time we succeed in loading
+ * new records, the kernel increases S' for us; if instead we encounter case
+ * (4), we can increment S' ourselves.
+ *
  * Inodes that are set in the allocmask but not set in the seen mask are the
  * corrupt inodes.  For each of these cases, we try to populate the bulkstat
  * array one inode at a time.  If the kernel returns a matching record we can
@@ -105,6 +116,87 @@ seen_mask_from_bulkstat(
 	return ret;
 }
 
+/*
+ * Try to fill the rest of orig_breq with bulkstat data by re-running bulkstat
+ * with increasing start_ino until we either hit the end of the inumbers info
+ * or fill up the bstat array with something.  Returns a bitmask of the inodes
+ * within inums that were filled by the bulkstat requests.
+ */
+static __u64
+bulkstat_the_rest(
+	struct scrub_ctx		*ctx,
+	const struct xfs_inumbers	*inums,
+	struct xfs_bulkstat_req		*orig_breq,
+	int				orig_error)
+{
+	struct xfs_bulkstat_req		*new_breq;
+	struct xfs_bulkstat		*old_bstat =
+		&orig_breq->bulkstat[orig_breq->hdr.ocount];
+	const __u64			limit_ino =
+		inums->xi_startino + LIBFROG_BULKSTAT_CHUNKSIZE;
+	__u64				start_ino = orig_breq->hdr.ino;
+	__u64				seen_mask = 0;
+	int				error;
+
+	assert(orig_breq->hdr.ocount < orig_breq->hdr.icount);
+
+	/*
+	 * If the first bulkstat returned a corruption error, that means
+	 * start_ino is corrupt.  Restart instead at the next inumber.
+	 */
+	if (orig_error == EFSCORRUPTED)
+		start_ino++;
+	if (start_ino >= limit_ino)
+		return 0;
+
+	error = -xfrog_bulkstat_alloc_req(
+			orig_breq->hdr.icount - orig_breq->hdr.ocount,
+			start_ino, &new_breq);
+	if (error)
+		return error;
+	new_breq->hdr.flags = orig_breq->hdr.flags;
+
+	do {
+		/*
+		 * Fill the new bulkstat request with stat data starting at
+		 * start_ino.
+		 */
+		error = -xfrog_bulkstat(&ctx->mnt, new_breq);
+		if (error == EFSCORRUPTED) {
+			/*
+			 * start_ino is corrupt, increment and try the next
+			 * inode.
+			 */
+			start_ino++;
+			new_breq->hdr.ino = start_ino;
+			continue;
+		}
+		if (error) {
+			/*
+			 * Any other error means the caller falls back to
+			 * single stepping.
+			 */
+			break;
+		}
+		if (new_breq->hdr.ocount == 0)
+			break;
+
+		/* Copy new results to the original bstat buffer */
+		memcpy(old_bstat, new_breq->bulkstat,
+		       new_breq->hdr.ocount * sizeof(struct xfs_bulkstat));
+		orig_breq->hdr.ocount += new_breq->hdr.ocount;
+		old_bstat += new_breq->hdr.ocount;
+		seen_mask |= seen_mask_from_bulkstat(inums, start_ino,
+					new_breq);
+
+		new_breq->hdr.icount -= new_breq->hdr.ocount;
+		start_ino = new_breq->hdr.ino;
+	} while (new_breq->hdr.icount > 0 && new_breq->hdr.ino < limit_ino);
+
+	free(new_breq);
+	return seen_mask;
+}
+
 #define cmp_int(l, r)		((l > r) - (l < r))
 
 /* Compare two bulkstat records by inumber. */
@@ -200,6 +292,12 @@ bulkstat_single_step(
 				sizeof(struct xfs_bulkstat), compare_bstat);
 }
 
+/* Return the inumber of the highest allocated inode in the inumbers data. */
+static inline uint64_t last_allocmask_ino(const struct xfs_inumbers *i)
+{
+	return i->xi_startino + xfrog_highbit64(i->xi_allocmask);
+}
+
 /*
  * Run bulkstat on an entire inode allocation group, then check that we got
  * exactly the inodes we expected.  If not, load them one at a time (or fake
@@ -229,6 +327,16 @@ bulkstat_for_inumbers(
 					inumbers->xi_startino, breq);
 	}
 
+	/*
+	 * If the last allocated inode as reported by inumbers is higher than
+	 * the last inode reported by bulkstat, two things could have happened.
+	 * Either all the inodes at the high end of the cluster were freed
+	 * since the inumbers call; or bulkstat encountered a corrupt inode and
+	 * returned early.  Try to bulkstat the rest of the array.
+	 */
+	if (last_allocmask_ino(inumbers) > last_bstat_ino(breq))
+		seen_mask |= bulkstat_the_rest(ctx, inumbers, breq, error);
+
 	/*
 	 * Bulkstat might return inodes beyond xi_startino + CHUNKSIZE.  Reduce
 	 * ocount to ignore inodes not described by the inumbers record.
@@ -241,7 +349,7 @@ bulkstat_for_inumbers(
 
 	/*
 	 * Fill in any missing inodes that are mentioned in the alloc mask but
-	 * weren't previously seen by bulkstat.
+	 * weren't previously seen by bulkstat.  These are the corrupt inodes.
 	 */
 	bulkstat_single_step(ctx, inumbers, seen_mask, breq);
 }

