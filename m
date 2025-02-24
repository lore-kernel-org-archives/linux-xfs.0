Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344C02505B7;
	Mon, 24 Feb 2025 09:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740391069; cv=none; b=CDCDTddcGNurCPJPVW39XktWLeKCncBY/F5a2pciUXu0ivNvYLdSS63GnV9klJtp8WE6zs2fCY0TMCUMmAafNDE8SzH3yrsaAbHXaRdNDU6C8WFvANd2lMxdwQxY+9FuZ/xfHgi0sT55l1e9urNszhoWW084Zzy5sdoXmwEJw7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740391069; c=relaxed/simple;
	bh=iE537x/MELrUY0Qtk8aCd5YLeWWHG15hTl09B9wGRWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQF99Ogla2XncNWI19M3IJU952sY2Oey+5XltVQ7vkN7+I0Do/BBp+tqJ9JQjaMRn+JicHHiANkrohn5T4rmeG7Er1/IShdy6lCoBzoc8Gqu52HuXiqZTtljeIf6hgMFBWb3gNVpGcf3atH/z7GLLBQh3RDsEUd+R6IEMYZtGr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfIFXDJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfIFXDJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098C3C4CEE8;
	Mon, 24 Feb 2025 09:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740391068;
	bh=iE537x/MELrUY0Qtk8aCd5YLeWWHG15hTl09B9wGRWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TfIFXDJen3mMesTjG7OhjLyO68Lu9krViqA7VC3vhkwnLojy4G3CBiTdUmL3na5zf
	 ey2d8msVYSk18M5THfX+RJdtV/35HTBjjiieiPT1B9lKgRxUblNdrLhnR090a4dUDp
	 FkP/7/PnwOILK+QWx4uFaUo67l3z3VqYe5pzZuknUTsNQ5E5UX2KyDSU5kOlq4JXSs
	 Z1Bwr4k9KLgdBR37JAv6X9l6o/j1iGueZhQVbXva5c1h8hjI9PZAm1jeoz8P9C78du
	 Upp41f6hNuhj6KQ/6UrooNmrkqTQr4K66zIME/NA1If65Ly8AwVuuEYnio7f84sn8m
	 j8jH/pA1AvlLQ==
Date: Mon, 24 Feb 2025 20:27:44 +1030
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH 3/8][next] xfs: Avoid -Wflex-array-member-not-at-end warnings
Message-ID: <e1b8405de7073547ed6252a314fb467680b4c7e8.1739957534.git.gustavoars@kernel.org>
References: <cover.1739957534.git.gustavoars@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1739957534.git.gustavoars@kernel.org>

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Change the type of the middle struct members currently causing trouble
from `struct bio` to `struct bio_hdr`.

We also use `container_of()` whenever we need to retrieve a pointer to
the flexible structure `struct bio`, through which we can access the
flexible-array member in it, if necessary.

With these changes fix 27 of the following warnings:

fs/xfs/xfs_log_priv.h:208:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/xfs/xfs_log.c      | 15 +++++++++------
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f8851ff835de..7e8b71f64a46 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1245,7 +1245,7 @@ xlog_ioend_work(
 	}
 
 	xlog_state_done_syncing(iclog);
-	bio_uninit(&iclog->ic_bio);
+	bio_uninit(container_of(&iclog->ic_bio, struct bio, __hdr));
 
 	/*
 	 * Drop the lock to signal that we are done. Nothing references the
@@ -1663,7 +1663,8 @@ xlog_write_iclog(
 	 * writeback throttle from throttling log writes behind background
 	 * metadata writeback and causing priority inversions.
 	 */
-	bio_init(&iclog->ic_bio, log->l_targ->bt_bdev, iclog->ic_bvec,
+	bio_init(container_of(&iclog->ic_bio, struct bio, __hdr),
+		 log->l_targ->bt_bdev, iclog->ic_bvec,
 		 howmany(count, PAGE_SIZE),
 		 REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE);
 	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
@@ -1692,7 +1693,8 @@ xlog_write_iclog(
 
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
-	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
+	if (xlog_map_iclog_data(container_of(&iclog->ic_bio, struct bio, __hdr),
+				iclog->ic_data, count))
 		goto shutdown;
 
 	if (is_vmalloc_addr(iclog->ic_data))
@@ -1705,16 +1707,17 @@ xlog_write_iclog(
 	if (bno + BTOBB(count) > log->l_logBBsize) {
 		struct bio *split;
 
-		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
+		split = bio_split(container_of(&iclog->ic_bio, struct bio, __hdr),
+				  log->l_logBBsize - bno,
 				  GFP_NOIO, &fs_bio_set);
-		bio_chain(split, &iclog->ic_bio);
+		bio_chain(split, container_of(&iclog->ic_bio, struct bio, __hdr));
 		submit_bio(split);
 
 		/* restart at logical offset zero for the remainder */
 		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
 	}
 
-	submit_bio(&iclog->ic_bio);
+	submit_bio(container_of(&iclog->ic_bio, struct bio, __hdr));
 	return;
 shutdown:
 	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f3d78869e5e5..32abc48aef24 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -205,7 +205,7 @@ typedef struct xlog_in_core {
 #endif
 	struct semaphore	ic_sema;
 	struct work_struct	ic_end_io_work;
-	struct bio		ic_bio;
+	struct bio_hdr		ic_bio;
 	struct bio_vec		ic_bvec[];
 } xlog_in_core_t;
 
-- 
2.43.0

