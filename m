Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25505 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727742AbeIEMsp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Sep 2018 08:48:45 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fxT2G-0003NC-31
        for linux-xfs@vger.kernel.org; Wed, 05 Sep 2018 18:19:36 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fxT2G-0007Gd-1o
        for linux-xfs@vger.kernel.org; Wed, 05 Sep 2018 18:19:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] mkfs: rework AG header initialisation ordering
Date: Wed,  5 Sep 2018 18:19:30 +1000
Message-Id: <20180905081932.27478-3-david@fromorbit.com>
In-Reply-To: <20180905081932.27478-1-david@fromorbit.com>
References: <20180905081932.27478-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When observing the behaviour of an 8EB mkfs execution, I noticed
that a phase where there are a massive number of read/modify/write
cycles occurring. I didn't wait for it to complete - it was obvious
that it was after all the AG headers had been written. That left the
AGFL initialisation as the likely cause.

When all the AG headers don't fit in the libxfs buffer cache, the
AGFL init requires re-reading the AGF, the AGFL, the free space tree
root blocks and the rmap tree root block. They all then get
modified and written back out. 10 IOs per AG. When you have 8
million AGs, that's a lot of extra IO.

Change the initialisation algorithm to initialise the AGFL
immediately after initialising the rest of the headers and
calculating the minimum AGFL size for that AG. This means the
modifications will all hit the buffer cache and this will remove the
IO penalty.

The "worst_freelist" size calculation doesn't change from AG to AG -
it's based on the physical configuration of the AG, and all AGs have
the same configuration. hence we only need to calculate this once,
not for every AG. That allows us to initialise the AGFL immediately
after the rest of the AG has been initialised rather than in a
separate pass.

TIme to make a filesystem from scratch, using a zeroed device so the
force overwrite algorithms are not triggered and -K to avoid
discards:

FS size		10PB	100PB	 1EB
current mkfs	26.9s	214.8s	2484s
patched		11.3s	 70.3s	 709s

In both cases, the IO profile looks identical for the initial AG
header writeout loop. The difference is that the old code then
does the RMW loop to init the AGFL, and that runs at about half the
speed. Hence runtime of the new code is reduce by around 65-70%
simply by avoiding all that IO.


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c153592c705e..d70fbdb6b15a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3374,7 +3374,7 @@ initialise_ag_headers(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp,
 	xfs_agnumber_t		agno,
-	int			*worst_freelist)
+	int			*freelist_size)
 {
 	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
 	struct xfs_agfl		*agfl;
@@ -3453,8 +3453,22 @@ initialise_ag_headers(
 		agf->agf_longest = cpu_to_be32(agsize -
 			XFS_FSB_TO_AGBNO(mp, cfg->logstart) - cfg->logblocks);
 	}
-	if (libxfs_alloc_min_freelist(mp, pag) > *worst_freelist)
-		*worst_freelist = libxfs_alloc_min_freelist(mp, pag);
+
+	/*
+	 * The AGFL size is the same for all AGs because all AGs have the same
+	 * layout. If this AG sameness ever changes in the future, we'll need to
+	 * revisit how we initialise the AGFLs.
+	 */
+	if (*freelist_size == 0)
+		*freelist_size = libxfs_alloc_min_freelist(mp, pag);
+	else if (*freelist_size < libxfs_alloc_min_freelist(mp, pag)) {
+		fprintf(stderr,
+_("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
+			progname, libxfs_alloc_min_freelist(mp, pag),
+			agno, *freelist_size);
+		exit(1);
+	}
+
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 	/*
@@ -3724,14 +3738,14 @@ static void
 initialise_ag_freespace(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	int			worst_freelist)
+	int			freelist_size)
 {
 	struct xfs_alloc_arg	args;
 	struct xfs_trans	*tp;
 	struct xfs_trans_res tres = {0};
 	int			c;
 
-	c = libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
+	c = libxfs_trans_alloc(mp, &tres, freelist_size, 0, 0, &tp);
 	if (c)
 		res_failed(c);
 
@@ -3797,7 +3811,7 @@ main(
 	int			quiet = 0;
 	char			*protofile = NULL;
 	char			*protostring = NULL;
-	int			worst_freelist = 0;
+	int			freelist_size = 0;
 
 	struct libxfs_xinit	xi = {
 		.isdirect = LIBXFS_DIRECT,
@@ -4025,16 +4039,12 @@ main(
 	}
 
 	/*
-	 * Initialise all the static on disk metadata.
+	 * Initialise all the AG headers on disk.
 	 */
-	for (agno = 0; agno < cfg.agcount; agno++)
-		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist);
-
-	/*
-	 * Initialise the freespace freelists (i.e. AGFLs) in each AG.
-	 */
-	for (agno = 0; agno < cfg.agcount; agno++)
-		initialise_ag_freespace(mp, agno, worst_freelist);
+	for (agno = 0; agno < cfg.agcount; agno++) {
+		initialise_ag_headers(&cfg, mp, sbp, agno, &freelist_size);
+		initialise_ag_freespace(mp, agno, freelist_size);
+	}
 
 	/*
 	 * Allocate the root inode and anything else in the proto file.
-- 
2.17.0
