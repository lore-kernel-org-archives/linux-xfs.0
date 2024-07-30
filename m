Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF6F1373
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300592; cv=none; b=os9mELP25qg8uUMpTIITknc9UPmShzGjxOI3nWovlJPSnxsy81cyvzgzIkArlX0/imcrQ5x8P332dJn3dGQKG9SUFrfvhfJyPSZGnFlxE3Pen6apN4O128vhdN8A5Bm+JEnHDFP7ERm1KTqlkgbOndFz9BR6j51f2NXFlNxILSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300592; c=relaxed/simple;
	bh=tNUKVazbnVPJ8lL6F9D9i9jfsuQrsy2GT03xye9nuyM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FphkffHaaKnp9NKwB2HBMY+kKwNjak1AD2W5vHNDAwrgTLaTfwL7ZWgBgfNWlrFJ33Rl1L5BqOFmaQ7KBnttKd7olOqR2AnQRBqeKisabVekpWkcXkEqq9BGyfD5pBB46oK3Isqw61zbquqnQSMbrU+6aBCSmNLSpl7crWhGG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngEs+pmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngEs+pmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A941C32786;
	Tue, 30 Jul 2024 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300592;
	bh=tNUKVazbnVPJ8lL6F9D9i9jfsuQrsy2GT03xye9nuyM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ngEs+pmGq2lQ2YEmyQ/L3J37jqzjrUOtcjgPEwOevtkAGm6qFI8st1dIK0rV5Btid
	 T8e5cX5xzh59wcUMfs4sxs5wcgJOeSHwtX0EhYuVSm8X2DTLtRNm4i2W5wagdjDmPB
	 p4cBod5RcfBsn9ZCsNGWqNXECMM++qYVK6qodTkGVlQZBPh4vpQJxIvCbgqZaxadCW
	 RRfc7ciHCDQSCegxSxEnWHT5rC0OI4xNGHB/cjOOOi8toUefqg+OcmUWLXDJsnd+qF
	 9aRafsuOwE+LItFqekXlHFzJe+cerbNgn5nY7Y9X+XPtxpnHkQAx4KtuFptXBjk3vD
	 ishg+6NWkXblw==
Date: Mon, 29 Jul 2024 17:49:51 -0700
Subject: [PATCH 100/115] xfs: fix xfs_bmap_add_extent_delay_real for partial
 conversions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843866.1338752.16860089417780659312.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: d69bee6a35d3c5e4873b9e164dd1a9711351a97c

xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
and converts them to a real extent.  It is written to deal with any
potential overlap of the to be converted range with the delalloc extent,
but it turns out that currently only converting the entire extents, or a
part starting at the beginning is actually exercised, as the only caller
always tries to convert the entire delalloc extent, and either succeeds
or at least progresses partially from the start.

If it only converts a tiny part of a delalloc extent, the indirect block
calculation for the new delalloc extent (da_new) might be equivalent to that
of the existing delalloc extent (da_old).  If this extent conversion now
requires allocating an indirect block that gets accounted into da_new,
leading to the assert that da_new must be smaller or equal to da_new
unless we split the extent to trigger.

Except for the assert that case is actually handled by just trying to
allocate more space, as that already handled for the split case (which
currently can't be reached at all), so just reusing it should be fine.
Except that without dipping into the reserved block pool that would make
it a bit too easy to trigger a fs shutdown due to ENOSPC.  So in addition
to adjusting the assert, also dip into the reserved block pool.

Note that I could only reproduce the assert with a change to only convert
the actually asked range instead of the full delalloc extent from
xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4279ab83d..9af65a182 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1564,6 +1564,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1594,6 +1595,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1628,6 +1630,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1662,6 +1665,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			}
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1700,6 +1704,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1790,6 +1795,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1839,6 +1845,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount = temp;
 		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_next(ifp, &bma->icur);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case 0:
@@ -1961,12 +1968,10 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
-	if (da_new < da_old) {
+	if (da_new < da_old)
 		xfs_add_fdblocks(mp, da_old - da_new);
-	} else if (da_new > da_old) {
-		ASSERT(state == 0);
-		error = xfs_dec_fdblocks(mp, da_new - da_old, false);
-	}
+	else if (da_new > da_old)
+		error = xfs_dec_fdblocks(mp, da_new - da_old, true);
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:

