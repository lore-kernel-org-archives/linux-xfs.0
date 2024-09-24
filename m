Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195631AC8BD;
	Tue, 24 Sep 2024 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203145; cv=none; b=i6+YFutje5aQ2rndfww7NE4fMTuaXQMKKhLXlvLIsd+42rg8zLlefgX4b6PaRVJIWNebIKfherPQytmawbRyqZRbrYRNiuoD/NKM5lcWNQL2oEao3PECImzMLPUd2s7pgacuMaj0x7lWH9jq94+7Gt4E2nqg0oC3Dr97r6OSt8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203145; c=relaxed/simple;
	bh=DoKK0T6owU2oCFgEuUA7DpIrCpu5ek5m34Ax1vWHHVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq2U/NS/eyZHQd3/h43KZeg2MLfyinTN06mtk8p9Jh6Vshvq1YK0xweY3y9/QGcc8mo/Hq71HejvPNo1ALTu0aY6vALi+Xr9picnds8GqDlVAN0jnIUE5zUWGd6gH+ZMx7DGld3Z4EXT0aIPO4dhXn6yfbuM5giYfWC5b2LoTws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NI75MJJW; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NI75MJJW"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d86f71353dso4109338a91.2;
        Tue, 24 Sep 2024 11:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203143; x=1727807943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TvNSLk2c8FU/nJcg36ArGm0aCSGcQH9Hwo8obidMwk=;
        b=NI75MJJWG555oACsTW/WkJ0L/pT5Mht/H2W6EftM9pwWpENVS2XzYAP2dic8dyVOex
         6ue9XieHvy6stZ/RJ7+3nzdH5fvkvCAVtbJi7E8QJQ12sBjaKi1wEiQu4yfu+5k/xDHI
         mDGqQuV7ew1hY10o7p5ieDgp1vX8Drf/xk7AE0qEXrCOqYBzM3a4Ib91jMBW3tj6W2eT
         RmD6Npe3OILgCXB37tWmvr+5JuOgjNOK8I10eBWLXAmOPHqgaIZji1OHL9+O6FymNkby
         viAoTL94eR8JkW4dR+Lft6ZmDtji+HGRmd2X01ENOxPBm+rvk98rUBw8cr4vM0nPhlmW
         EIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203143; x=1727807943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0TvNSLk2c8FU/nJcg36ArGm0aCSGcQH9Hwo8obidMwk=;
        b=gdZFLKy4Z5Ys3w5fTo9GyCGDYu8COUiISOZ4+HMcXcSTnm+ji87rKUxvOX0m2LQnBf
         5l60RnBcmgZrxaZcCTFFhPs7tEJ+5asnzpeY2fulju/rLanjEgLbN6M9d3DJEyu2Tv7s
         Xy+HXIc0EO//kKreTUlCmQ0ctPb1mAq2OLs30KSfbA/M8B7h2FAxzFzflQfPo0tirprk
         f9p5pn9J92fkcqOpKjTKLtrt1x52+Aww465VbjkvKDm2FOs6UBEP+S3rtN4QayP7cUEL
         gYRFePNIUT888xDOqZRhbELoVpGWmRBMGEbWu1TJLAXAMbW6kcI2MU3XJPqTfjvi9395
         l8Ww==
X-Gm-Message-State: AOJu0Yz1brYjn4gOl3oKOY+jx5XdZTSqG2AVR7/xLouYA6so/2wNg+tv
	WuYBazmH7tbQ04m2wYaT99KTV1UKM07MOoCKg61j7fMJNgWR6VZjCA78U716
X-Google-Smtp-Source: AGHT+IE+1UDUXSi+l7BAe/WJjLhmbdlM445IYyHfEjRi+Nk+hFeqOLmcq7TghTTGbOl7d+ZYGCHVKQ==
X-Received: by 2002:a17:90a:8c14:b0:2d8:adea:9940 with SMTP id 98e67ed59e1d1-2e06ae5ec4fmr121821a91.16.1727203143081;
        Tue, 24 Sep 2024 11:39:03 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:02 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 04/26] xfs: don't use BMBT btree split workers for IO completion
Date: Tue, 24 Sep 2024 11:38:29 -0700
Message-ID: <20240924183851.1901667-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit c85007e2e3942da1f9361e4b5a9388ea3a8dcc5b ]

When we split a BMBT due to record insertion, we offload it to a
worker thread because we can be deep in the stack when we try to
allocate a new block for the BMBT. Allocation can use several
kilobytes of stack (full memory reclaim, swap and/or IO path can
end up on the stack during allocation) and we can already be several
kilobytes deep in the stack when we need to split the BMBT.

A recent workload demonstrated a deadlock in this BMBT split
offload. It requires several things to happen at once:

1. two inodes need a BMBT split at the same time, one must be
unwritten extent conversion from IO completion, the other must be
from extent allocation.

2. there must be a no available xfs_alloc_wq worker threads
available in the worker pool.

3. There must be sustained severe memory shortages such that new
kworker threads cannot be allocated to the xfs_alloc_wq pool for
both threads that need split work to be run

4. The split work from the unwritten extent conversion must run
first.

5. when the BMBT block allocation runs from the split work, it must
loop over all AGs and not be able to either trylock an AGF
successfully, or each AGF is is able to lock has no space available
for a single block allocation.

6. The BMBT allocation must then attempt to lock the AGF that the
second task queued to the rescuer thread already has locked before
it finds an AGF it can allocate from.

At this point, we have an ABBA deadlock between tasks queued on the
xfs_alloc_wq rescuer thread and a locked AGF. i.e. The queued task
holding the AGF lock can't be run by the rescuer thread until the
task the rescuer thread is runing gets the AGF lock....

This is a highly improbably series of events, but there it is.

There's a couple of ways to fix this, but the easiest way to ensure
that we only punt tasks with a locked AGF that holds enough space
for the BMBT block allocations to the worker thread.

This works for unwritten extent conversion in IO completion (which
doesn't have a locked AGF and space reservations) because we have
tight control over the IO completion stack. It is typically only 6
functions deep when xfs_btree_split() is called because we've
already offloaded the IO completion work to a worker thread and
hence we don't need to worry about stack overruns here.

The other place we can be called for a BMBT split without a
preceeding allocation is __xfs_bunmapi() when punching out the
center of an existing extent. We don't remove extents in the IO
path, so these operations don't tend to be called with a lot of
stack consumed. Hence we don't really need to ship the split off to
a worker thread in these cases, either.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4c16c8c31fcb..6b084b3cac83 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2913,9 +2913,22 @@ xfs_btree_split_worker(
 }
 
 /*
- * BMBT split requests often come in with little stack to work on. Push
+ * BMBT split requests often come in with little stack to work on so we push
  * them off to a worker thread so there is lots of stack to use. For the other
  * btree types, just call directly to avoid the context switch overhead here.
+ *
+ * Care must be taken here - the work queue rescuer thread introduces potential
+ * AGF <> worker queue deadlocks if the BMBT block allocation has to lock new
+ * AGFs to allocate blocks. A task being run by the rescuer could attempt to
+ * lock an AGF that is already locked by a task queued to run by the rescuer,
+ * resulting in an ABBA deadlock as the rescuer cannot run the lock holder to
+ * release it until the current thread it is running gains the lock.
+ *
+ * To avoid this issue, we only ever queue BMBT splits that don't have an AGF
+ * already locked to allocate from. The only place that doesn't hold an AGF
+ * locked is unwritten extent conversion at IO completion, but that has already
+ * been offloaded to a worker thread and hence has no stack consumption issues
+ * we have to worry about.
  */
 STATIC int					/* error */
 xfs_btree_split(
@@ -2929,7 +2942,8 @@ xfs_btree_split(
 	struct xfs_btree_split_args	args;
 	DECLARE_COMPLETION_ONSTACK(done);
 
-	if (cur->bc_btnum != XFS_BTNUM_BMAP)
+	if (cur->bc_btnum != XFS_BTNUM_BMAP ||
+	    cur->bc_tp->t_firstblock == NULLFSBLOCK)
 		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
 
 	args.cur = cur;
-- 
2.46.0.792.g87dc391469-goog

