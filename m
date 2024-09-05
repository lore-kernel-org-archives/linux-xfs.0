Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1E2185937
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560517; cv=none; b=EUZECitSiL+2+vTUt4HMsyzsXn8O1vr4BoOPQwd9H9Egr8r+AEPZ+fCNRBGGVnotA5zc0wO20KvEsAKq4fr0fQni0xCLjALAMWEJVF9fLnSnhtzAS5AOXOCq78b9FSZLrfQ+hwtDv8mbCPL7v4NKxlMtLgog2pwA95Ki2gKuj6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560517; c=relaxed/simple;
	bh=rJimvfVsU4AeVGq4g+d5N1fHApAqDUdZuaDR9bJWmto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhAbvd7mvGGoLWonBqDVJdPiJ/Z7Ekw8A6VXYTgcgzqO8v2R4HgpA/5dYScv12Yy+OJqsD7EOPiqjedqFNM5Ht5e3nXZ7dJLs8txVaRtDbHT26DNWKvCBKCHd2b618gwMMILwmiQUHHLr/3NalQHIhMlihl79APnpTY+fQTLvKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVK6pdmE; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVK6pdmE"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7178df70f28so969222b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560515; x=1726165315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5esp8iz/87TcLE1PAAVXsZdj3gH8pz4NYQj4IXXZ/gw=;
        b=AVK6pdmEKcp8wfyHjC6bfxeud8qKTGOXrBijq5VH0trDHUO0yCXszOodhLeFCLEzX1
         6YFFxiQSRK4cR6516CfEXuRbCNt0mCFQod91unmn1Z6PLfr79HkqCgTmwNZRLCgATIFB
         SxPi8t6Xl4AtMeG6P7CaFVPYdgSPbcvuC6YnbvnDbpgkJU//jwoe+HvqeOPK0W/XBfW3
         0KKNhXcugF7EcVi0XYuwRfm3Xj8Oo3xxiwDklu0E0+4doKZw7G5voABipLOimTDW6qh3
         SOLO57jB7xXnMTQH+h23U6xB2t/mqiCo4Ar7frg5kZBeL+AHjwIFEazbUVo6XOcVhuEc
         MV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560515; x=1726165315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5esp8iz/87TcLE1PAAVXsZdj3gH8pz4NYQj4IXXZ/gw=;
        b=UMVEchILq4++zoa4eLEQhHhzAacQtrIfZ8jzEkwj4CDZwpXvkijy8FNF1H6qe+cv30
         u029JpWCYVoa5L/wLyNrrtl/wS2Uc/I/Qx8+BbUSqMrj+xI7FVxs2XRSbQ4HDJsr3YEN
         48q9dTCnIgXiZp9WtBlgy1P9+gek/D+JvJfFcQSJW550I6IIzDU3H2EAuf4QgyOshJAr
         A95VH22rgHHxLI6uHeGfAHotibH6bxtnsS5GZI4CBMHPoclnxSYZO+gAyUoUp83VyUvj
         Fzlddmbq38sn0ThYOMdluK9vzCVmCoLC9/jzj2p9RkkGKI6ugL5ai3ztcLA8B6WZXtUd
         ZhLg==
X-Gm-Message-State: AOJu0Yyd0Y55MU4YcHupZ/jeveThkTkE0EB5Vgqo7bek9xmLshDyKlnc
	Ms5Jn/0v6D0Ta3RuHGjUyKlLRScGs+2qzIlT0cLLgH9Ek3YPIl1q4v3S0EmJ
X-Google-Smtp-Source: AGHT+IGB8hzmnDsc2YyFyctZq2uxoC+8m5cYZqUwOLEWRvDvwBpti/DYybunlJdUQvsDEjDfQYpB+Q==
X-Received: by 2002:a17:902:e54f:b0:205:7574:3b79 with SMTP id d9443c01a7336-20699ae8293mr112690885ad.25.1725560515450;
        Thu, 05 Sep 2024 11:21:55 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:55 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 04/26] xfs: don't use BMBT btree split workers for IO completion
Date: Thu,  5 Sep 2024 11:21:21 -0700
Message-ID: <20240905182144.2691920-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

