Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52022 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750710AbdAXJHt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 04:07:49 -0500
Date: Tue, 24 Jan 2017 10:07:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: reset ag_max_usable when retrying failed per-ag
        reservation init
Message-ID: <20170124090747.GA18668@lst.de>
References: <20170123211221.GB31202@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170123211221.GB31202@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 01:12:21PM -0800, Darrick J. Wong wrote:
> It's possible for the per-AG reservation initialization to return ENOSPC
> when fdblocks says there isn't free space.  This is a valid state for
> the reservation tracker since subsequent extent freeing activity will
> simply be captured by the reservation mechanism, but if we subsequently
> retry a failed initialization, we need to undo the changes we made to
> ag_max_usable prior to recreating the reservation.

Hmm.  I'd prefer to just not change any fields in __xfs_ag_resv_init
unless it succeeds.  So far untested and un-changelogged patch below,
I'll kick off a test run soon:

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 4773c1e..769d6e3 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -201,22 +201,27 @@ __xfs_ag_resv_init(
 	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_ag_resv		*resv;
 	int				error;
+	xfs_extlen_t			reserved;
 
-	resv = xfs_perag_resv(pag, type);
 	if (used > ask)
 		ask = used;
-	resv->ar_asked = ask;
-	resv->ar_reserved = resv->ar_orig_reserved = ask - used;
-	mp->m_ag_max_usable -= ask;
-
-	trace_xfs_ag_resv_init(pag, type, ask);
+	reserved = ask - used;
 
-	error = xfs_mod_fdblocks(mp, -(int64_t)resv->ar_reserved, true);
-	if (error)
+	error = xfs_mod_fdblocks(mp, -(int64_t)reserved, true);
+	if (error) {
 		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
 				error, _RET_IP_);
+		return error;
+	}
 
-	return error;
+	mp->m_ag_max_usable -= ask;
+
+	resv = xfs_perag_resv(pag, type);
+	resv->ar_asked = ask;
+	resv->ar_reserved = resv->ar_orig_reserved = reserved;
+
+	trace_xfs_ag_resv_init(pag, type, ask);
+	return 0;
 }
 
 /* Create a per-AG block reservation. */
