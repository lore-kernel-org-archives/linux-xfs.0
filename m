Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209661B5BC
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OjhLDE/E"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d3f29fea66so51100245ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359679; x=1705964479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bprujdq9x6vGUjX7hmrzPJN/IZ+ZvLny33A51Hvuzf0=;
        b=OjhLDE/ECv3hPWz1hMs9GQbmpW2GipGbXhsWoHSAJly36J/QIkYIrw2x5RjX/Modfm
         7PnnBcZCUKBjOLQ/KSoonaCyF7KKuEIGI948R7j6dy/ulHE7l1LfWNMIA6vrwHOQdX48
         P3llYjQtjmTYUxkG7XDBrSpVMveoeEXM610EEWfCnTs/K0zjgtooaL6tvLTKTGed168q
         muY2IzeRR3qx2Lg56uQqz7gQGcsiitME5eydjnH9F0IPboV3EkSL7C+JmcZeXXDyBvD4
         pvf2K2RcIqRVI0cPPHZQyu7fGhqJ705TGe6ROqRWIcVENSB93ECScqYBohQRs8XbQ+tS
         QE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359679; x=1705964479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bprujdq9x6vGUjX7hmrzPJN/IZ+ZvLny33A51Hvuzf0=;
        b=cm+FU1QBWo4I73evy7S2wW/KLe3dOhReRDfa3q7pFes5Qn0jBP8mK+jXt2ylmaLHpv
         ncZBVFuRQhybKGgRIZURewjWPLAP/qCmzMnSQcQSXZ5XyuQKaD8krB4e3gUzOEFYpMaZ
         y1HETTPSqwAeOtJ8EgU8SVQDsaN5qSFQ8sZ6jZBPMUOynDnFzHtGKXA+CYDqr0jR4kr7
         cixb6SvfqVoKA7CvKFS6fI23vN8/a1I7QoBKjUq+z6IPlxXyVG8IeKywg5ku44j/9k9K
         lqZufoI9PfcVkYPJKKerT34io+DCujCDWA00vmjPZaZ+jzYg4D60qNJPkvoRATaH56Lk
         0xOQ==
X-Gm-Message-State: AOJu0Yygb3854cUJscXcuVd2grJTzPIPXIHRHY6rnjmyqFd6VRBlzcZx
	1EQEs2WkHWN6Emnl38rSeM5FIvGDk9hrhWf+DR349qU+qrs=
X-Google-Smtp-Source: AGHT+IEiof1jeUl/P8MCSvHO3zALDxYJPl6CwcuUzGZhqGNXCpwzMiN1PzBQ1/m0xGV6eG7CXA73PA==
X-Received: by 2002:a17:902:e751:b0:1d4:6429:4e1c with SMTP id p17-20020a170902e75100b001d464294e1cmr4036272plf.4.1705359679338;
        Mon, 15 Jan 2024 15:01:19 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b001d538ee9ff3sm8076467pla.183.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtKA-0Z;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8fn-2ghT;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 06/12] xfs: use an empty transaction for fstrim
Date: Tue, 16 Jan 2024 09:59:44 +1100
Message-ID: <20240115230113.4080105-7-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240115230113.4080105-1-david@fromorbit.com>
References: <20240115230113.4080105-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

We currently use a btree walk in the fstrim code. This requires a
btree cursor and btree cursors are only used inside transactions
except for the fstrim code. This means that all the btree operations
that allocate memory operate in both GFP_KERNEL and GFP_NOFS
contexts.

This causes problems with lockdep being unable to determine the
difference between objects that are safe to lock both above and
below memory reclaim. Free space btree buffers are definitely locked
both above and below reclaim and that means we have to mark all
btree infrastructure allocations with GFP_NOFS to avoid potential
lockdep false positives.

If we wrap this btree walk in an empty cursor, all btree walks are
now done under transaction context and so all allocations inherit
GFP_NOFS context from the tranaction. This enables us to move all
the btree allocations to GFP_KERNEL context and hence help remove
the explicit use of GFP_NOFS in XFS.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8539f5c9a774..299b8f907292 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -8,6 +8,7 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
@@ -120,7 +121,7 @@ xfs_discard_extents(
 		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
 				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, &bio);
+				GFP_KERNEL, &bio);
 		if (error && error != -EOPNOTSUPP) {
 			xfs_info(mp,
 	 "discard failed for extent [0x%llx,%u], error %d",
@@ -155,6 +156,7 @@ xfs_trim_gather_extents(
 	uint64_t		*blocks_trimmed)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_trans	*tp;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
 	int			error;
@@ -168,11 +170,15 @@ xfs_trim_gather_extents(
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
+	error = xfs_trans_alloc_empty(mp, &tp);
 	if (error)
 		return error;
 
-	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
+	if (error)
+		goto out_trans_cancel;
+
+	cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_CNT);
 
 	/*
 	 * Look up the extent length requested in the AGF and start with it.
@@ -279,7 +285,8 @@ xfs_trim_gather_extents(
 		xfs_extent_busy_clear(mp, &extents->extent_list, false);
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
-	xfs_buf_relse(agbp);
+out_trans_cancel:
+	xfs_trans_cancel(tp);
 	return error;
 }
 
-- 
2.43.0

