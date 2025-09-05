Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E0731D744;
	Fri,  5 Sep 2025 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087738; cv=none; b=pN07aN23SlVYhdxA4y2ecW892tcUUWxTASL7szWTLwrcbBGGWXfPwh8wv5RlBcdDxxkcrw1rgt4pEEPNc/OR8YiwvmYsgX+niZOrpRWO8ZrDQUogxQyqKGUqWE+ngAsIv0izaIEjnJsgV4YNb87KzoA138ZpzhyDlveoH4KlrK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087738; c=relaxed/simple;
	bh=DhIWwzzcMbZ0F3+d+p1uoFqdPGgZjU4MKpUdNi5Pxpw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NiB/EbHBZgao8mzGltPhNf3zONPuCfZtfB+zgAP7nYhGsV+I2DrdZW/f/6nLzRFXcdl1dJ3gtQ1MV84JED8dJrYgPa8+QwY7uG4o60GK7X/VJMdOVOobteMcnTHMo1RKKsUB0hlLmWPGijJZ02XbTB8EZ6EUsPJq8MFZizPhipE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fk12c90a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fk12c90a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B616C4CEF1;
	Fri,  5 Sep 2025 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087738;
	bh=DhIWwzzcMbZ0F3+d+p1uoFqdPGgZjU4MKpUdNi5Pxpw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fk12c90a7tqB1KydIbUJwChem5n4/aQI1DUfL6DDM9X0+ImaDlHE5bavRoSgAd7jg
	 WvnaSp6Eal0QCV3uCELjYe1fPlcdH4cmUFMTi/XZ46NlfKU5VmIrivCRQyP8jl7rDS
	 jnG4/UswFFvSjwaHM2HdI9vK966Fad50kKfm6pdr0lwkKN6M7+CIcE7q3SuFGSA2B9
	 oFpD8yMuBaQwPZ0jl8KVUbOK1l9IPENCBkSmYq5OFLXrHH1BISLXX91KF13F83/h3s
	 ny8qOCroKAxyPKnV5ELJMJlK1TYsqUYcVwfPrSxCfS/mkBnA+yizc3cD4F2R5JhTFk
	 BhLYLt9ubn5AA==
Date: Fri, 05 Sep 2025 08:55:37 -0700
Subject: [PATCH 1/9] xfs: use deferred intent items for reaping crosslinked
 blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <175708765079.3402543.4664236105821111640.stgit@frogsfrogsfrogs>
In-Reply-To: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
References: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're removing rmap records for crosslinked blocks, use deferred
intent items so that we can try to free/unmap as many of the old data
structure's blocks as we can in the same transaction as the commit.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/reap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 8703897c0a9ccb..86d3d104b8d950 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -416,8 +416,6 @@ xreap_agextent_iter(
 		trace_xreap_dispose_unmap_extent(pag_group(sc->sa.pag), agbno,
 				*aglenp);
 
-		rs->force_roll = true;
-
 		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
 			/*
 			 * If we're unmapping CoW staging extents, remove the
@@ -426,11 +424,14 @@ xreap_agextent_iter(
 			 */
 			xfs_refcount_free_cow_extent(sc->tp, false, fsbno,
 					*aglenp);
+			rs->force_roll = true;
 			return 0;
 		}
 
-		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
-				*aglenp, rs->oinfo);
+		xfs_rmap_free_extent(sc->tp, false, fsbno, *aglenp,
+				rs->oinfo->oi_owner);
+		rs->deferred++;
+		return 0;
 	}
 
 	trace_xreap_dispose_free_extent(pag_group(sc->sa.pag), agbno, *aglenp);

