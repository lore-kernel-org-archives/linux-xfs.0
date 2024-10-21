Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78DC1EABAD;
	Mon, 21 Oct 2024 10:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506998; cv=none; b=pBa+D80SxKM6WiH0VoSepK2bIRtqq+BHuR+a5RBUg+hMd2Iffmatj7X0DT+lBMlsKWLolhEhtSwjYcUHnai6hZOJLPrsMwTMCtbKgAKvfcPaGSNuFbMJ0P3NJ3UbIkBP3z3EtaXbEkC2AYvVxNag59L1B1D8SrGSmw9S6gA3tRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506998; c=relaxed/simple;
	bh=RyLpf4q9ZzyjTc2rPK0zmoQ8iTDrZGjUoEW0O5brpUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdscXFRdAkI+BdgI5r93uWmd+tipYJy0jtMSu2+7jOh7VfB2E4miBEByLFg6WCHrNXvFKvQobFFUobcQ8usvYPC0oZexFUjCo8eARtsFCKb0mSjrQ0ezFdAYVWgxKz05ssvGo7fGt5SRnYtsenks1D9G4vtTpzWnH3bHK5/kUIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/bGUrwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/bGUrwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1179CC4CEC3;
	Mon, 21 Oct 2024 10:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506998;
	bh=RyLpf4q9ZzyjTc2rPK0zmoQ8iTDrZGjUoEW0O5brpUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/bGUrwzODPuZhAgCB0/HHituuGN5MTqlv5aZE8j06PBVjZg/RqmvQ64Y+2KTdrp2
	 aGWng97MrczOfVdI0S1988ZQtiIxZWKKnyYlcU6W+gv3ggnj8bieRONPKYmvMXoyoN
	 873zbCgQ5z6OjRoGSg14J23wfNf13VgnGYFmw5mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 025/124] xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
Date: Mon, 21 Oct 2024 12:23:49 +0200
Message-ID: <20241021102257.699105467@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit d69bee6a35d3c5e4873b9e164dd1a9711351a97c upstream.

[backport: resolve conflict due to xfs_mod_freecounter refactor]

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
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1549,6 +1549,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1578,6 +1579,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1611,6 +1613,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1643,6 +1646,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			}
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1680,6 +1684,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1767,6 +1772,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1814,6 +1820,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount = temp;
 		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_next(ifp, &bma->icur);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case 0:
@@ -1934,11 +1941,9 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
-	if (da_new != da_old) {
-		ASSERT(state == 0 || da_new < da_old);
+	if (da_new != da_old)
 		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
-				false);
-	}
+				true);
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:


