Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1635195FEC;
	Mon, 21 Oct 2024 10:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506965; cv=none; b=CbK+pie5G7wm8+9o0CLDkNThIkvONe8jknPvPCI0VPC65HCaYTnYJScHWNdjPUeX6inTK2SvsNgMJnpW7kp1iJoaOa9jaWS0kBMJdb3IuRRMn0yn4bAFWIpa6JgPmOkBa7aC4u5XAl317QWA7QVYctFB5Wqwia7bw02VjUnMk/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506965; c=relaxed/simple;
	bh=1kKanxVfAf7S3DNaRMJuO0WGYYIOERHXK1WNkSXC7Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFQsCtL5rKRi9ud2sY6r9hmxVlq07RcGSFoi9knHU7D0soTViA6KxivJKjnx2BTozx1u+p339vq0jMTNeaU5v7OhCeLPbXxx0RVrKumxCQajxldVgAml1qrW9LovYkRDP7mqsxdYxks4iSNzBMhDhEf5Mj/wmX+248xxW97PoUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVSyEiLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVSyEiLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8F1C4CEC3;
	Mon, 21 Oct 2024 10:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506965;
	bh=1kKanxVfAf7S3DNaRMJuO0WGYYIOERHXK1WNkSXC7Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVSyEiLBc+CIIqL9MvcgVPJhyIMuVyuiB9f2vjVCBTYhzIEOoCHT02AoraN/2so+l
	 K0UBqSLCBhEaRH8ahC88N203fTDifEkbesxSkGapsRe6LoHOtX5HfX62ojLVgiEY/W
	 sRBchu1Q2bJQVoi5Gq47Pa0PpNAlROK2sgYK41L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 044/124] xfs: restrict when we try to align cow fork delalloc to cowextsz hints
Date: Mon, 21 Oct 2024 12:24:08 +0200
Message-ID: <20241021102258.434209222@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 288e1f693f04e66be99f27e7cbe4a45936a66745 upstream.

xfs/205 produces the following failure when always_cow is enabled:

#  --- a/tests/xfs/205.out	2024-02-28 16:20:24.437887970 -0800
#  +++ b/tests/xfs/205.out.bad	2024-06-03 21:13:40.584000000 -0700
#  @@ -1,4 +1,5 @@
#   QA output created by 205
#   *** one file
#  +   !!! disk full (expected)
#   *** one file, a few bytes at a time
#   *** done

This is the result of overly aggressive attempts to align cow fork
delalloc reservations to the CoW extent size hint.  Looking at the trace
data, we're trying to append a single fsblock to the "fred" file.
Trying to create a speculative post-eof reservation fails because
there's not enough space.

We then set @prealloc_blocks to zero and try again, but the cowextsz
alignment code triggers, which expands our request for a 1-fsblock
reservation into a 39-block reservation.  There's not enough space for
that, so the whole write fails with ENOSPC even though there's
sufficient space in the filesystem to allocate the single block that we
need to land the write.

There are two things wrong here -- first, we shouldn't be attempting
speculative preallocations beyond what was requested when we're low on
space.  Second, if we've already computed a posteof preallocation, we
shouldn't bother trying to align that to the cowextsize hint.

Fix both of these problems by adding a flag that only enables the
expansion of the delalloc reservation to the cowextsize if we're doing a
non-extending write, and only if we're not doing an ENOSPC retry.  This
requires us to move the ENOSPC retry logic to xfs_bmapi_reserve_delalloc.

I probably should have caught this six years ago when 6ca30729c206d was
being reviewed, but oh well.  Update the comments to reflect what the
code does now.

Fixes: 6ca30729c206d ("xfs: bmap code cleanup")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   31 +++++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.c       |   34 ++++++++++++----------------------
 2 files changed, 39 insertions(+), 26 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3974,20 +3974,32 @@ xfs_bmapi_reserve_delalloc(
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	int			error;
-	xfs_fileoff_t		aoff = off;
+	xfs_fileoff_t		aoff;
+	bool			use_cowextszhint =
+					whichfork == XFS_COW_FORK && !prealloc;
 
+retry:
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
+	aoff = off;
 	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
 		prealloc = alen - len;
 
-	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK) {
+	/*
+	 * If we're targetting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the COW extent size hint if there's sufficient free space.
+	 *
+	 * Unlike the data fork, the CoW cancellation functions will free all
+	 * the reservations at inactivation, so we don't require that every
+	 * delalloc reservation have a dirty pagecache.
+	 */
+	if (use_cowextszhint) {
 		struct xfs_bmbt_irec	prev;
 		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
 
@@ -4006,7 +4018,7 @@ xfs_bmapi_reserve_delalloc(
 	 */
 	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * Split changing sb for alen and indlen since they could be coming
@@ -4051,6 +4063,17 @@ out_unreserve_blocks:
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
+out:
+	if (error == -ENOSPC || error == -EDQUOT) {
+		trace_xfs_delalloc_enospc(ip, off, len);
+
+		if (prealloc || use_cowextszhint) {
+			/* retry without any preallocation */
+			use_cowextszhint = false;
+			prealloc = 0;
+			goto retry;
+		}
+	}
 	return error;
 }
 
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1127,33 +1127,23 @@ xfs_buffered_write_iomap_begin(
 		}
 	}
 
-retry:
-	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks,
-			allocfork == XFS_DATA_FORK ? &imap : &cmap,
-			allocfork == XFS_DATA_FORK ? &icur : &ccur,
-			allocfork == XFS_DATA_FORK ? eof : cow_eof);
-	switch (error) {
-	case 0:
-		break;
-	case -ENOSPC:
-	case -EDQUOT:
-		/* retry without any preallocation */
-		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc_blocks) {
-			prealloc_blocks = 0;
-			goto retry;
-		}
-		fallthrough;
-	default:
-		goto out_unlock;
-	}
-
 	if (allocfork == XFS_COW_FORK) {
+		error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+				end_fsb - offset_fsb, prealloc_blocks, &cmap,
+				&ccur, cow_eof);
+		if (error)
+			goto out_unlock;
+
 		trace_xfs_iomap_alloc(ip, offset, count, allocfork, &cmap);
 		goto found_cow;
 	}
 
+	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+			end_fsb - offset_fsb, prealloc_blocks, &imap, &icur,
+			eof);
+	if (error)
+		goto out_unlock;
+
 	/*
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.


