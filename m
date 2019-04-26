Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfDZN5B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Apr 2019 09:57:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A0EF8E581
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 13:57:00 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34EDE277C6
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 13:57:00 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: track extra block allocation count separate from total count
Date: Fri, 26 Apr 2019 09:56:59 -0400
Message-Id: <20190426135659.37675-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Physical block allocation uses the total block count calculation to
try and select an AG that can satisfy the extent allocation itself
along with any additional btree blocks that might be allocated in
the same transaction. The file extent allocation code invokes the
block allocator with the optimal allocation parameters and loosens
the requirements for subsequent retries if the allocation fails. For
example, alignment is dropped first, then minlen is reduced from
maxlen to the originally selected minlen, then total is reduced to
minlen and the allocation mode is changed, etc.

For large extent allocations with an args.total value that exceeds
the allocation length (i.e., non-delalloc), the args.total value
tends to dominate despite these fallbacks. For example, an aligned extent
allocation request of tens to hundreds of MB that cannot be
satisfied from a particular AG is not going to succeed after
dropping the alignment requirement or reducing minlen because
xfs_alloc_space_available() will never select an AG that doesn't
satisfy the total requirement. The allocation will eventually reduce
total and ultimately succeed if a minlen extent is available
somewhere, but the first several retries are effectively pointless.

Beyond simply being inefficient, another side effect of this
behavior is dropping alignment requirements too aggressively from
larger allocations. For example, consider a 1GB fallocate request on
a 15GB fs with 16 AGs and 128k stripe unit:

 # xfs_io -c "falloc 0 1g" /mnt/file
 # <xfstests>/src/t_stripealign /mnt/file 32
 /mnt/file: Start block 347176 not multiple of sunit 32

Despite the filesystem being completely empty, the fact that the
allocation request cannot be satisifed from a single AG means the
first extent isn't allocated until xfs_bmap_btalloc() drops total to
minlen, which occurs after we've dropped the 32 block alignment
requirement.

Dealing with this problem requires a couple related changes. First,
the bmap allocator code should respect the fact that the block
allocator code always attempts to allocate as large an extent as
possible and reduce the minlen requirement before throwing away
alignment. Second, dropping minlen is ineffective unless the AG
selection code can separate the extent allocation length from the
surplus block requirement requested by the caller. Accomplish this
with an optional 'extra' field that contains only the surplus block
count and can be used optionally instead of the total count. The
extra field is hardcoded for the purpose of this RFC.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Do folks have any thoughts on something like this? This is just an RFC
that demonstrates improving on the issue in one particular codepath, but
something that occurred to me when writing up the commit log is that
doing something like the following on xfs_bmapi_write():

	if (total > len) {
		bma.extra = total - len;
		bma.total = 0;
	}

... might be a decent first step to generalize this for all callers. I
have to audit the other callers to be sure and get a handle on
subsequent cleanups. E.g., the existing hardcoded total assignment in
xfs_bmapi_convert_delalloc() looks kind of bogus (if the delalloc extent
happens to exceed the block reservation) because of how
xfs_alloc_space_available() works.

Thoughts? Flames?

Brian

 fs/xfs/libxfs/xfs_alloc.c |  2 +-
 fs/xfs/libxfs/xfs_alloc.h |  1 +
 fs/xfs/libxfs/xfs_bmap.c  | 18 +++++++++++++++---
 fs/xfs/libxfs/xfs_bmap.h  |  1 +
 fs/xfs/xfs_bmap_util.c    |  4 ++--
 fs/xfs/xfs_trace.h        |  9 ++++++---
 6 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 857a53e58b94..f8832857daa5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2063,7 +2063,7 @@ xfs_alloc_space_available(
 	agflcount = min_t(xfs_extlen_t, pag->pagf_flcount, min_free);
 	available = (int)(pag->pagf_freeblks + agflcount -
 			  reservation - min_free - args->minleft);
-	if (available < (int)max(args->total, alloc_len))
+	if (available < (int)max(args->total, alloc_len + args->extra))
 		return false;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d6ed5d2c07c2..d08d76715996 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -64,6 +64,7 @@ typedef struct xfs_alloc_arg {
 	xfs_extlen_t	prod;		/* prod value for extent size */
 	xfs_extlen_t	minleft;	/* min blocks must be left after us */
 	xfs_extlen_t	total;		/* total blocks needed in xaction */
+	xfs_extlen_t	extra;		/* extra blocks needed in xaction */
 	xfs_extlen_t	alignment;	/* align answer to multiple of this */
 	xfs_extlen_t	minalignslop;	/* slop for minlen+alignment calcs */
 	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4637ae1ae91c..c9d309ff95ff 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3271,6 +3271,7 @@ xfs_bmap_btalloc_nullfb(
 
 	args->type = XFS_ALLOCTYPE_START_BNO;
 	args->total = ap->total;
+	args->extra = ap->extra;
 
 	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
 	if (startag == NULLAGNUMBER)
@@ -3485,6 +3486,7 @@ xfs_bmap_btalloc(
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.total = ap->total;
+		args.extra = ap->extra;
 		args.minlen = ap->minlen;
 	}
 	/* apply extent size hints if obtained earlier */
@@ -3578,6 +3580,15 @@ xfs_bmap_btalloc(
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
+	if (args.fsbno == NULLFSBLOCK && nullfb &&
+	    args.minlen > ap->minlen) {
+		args.minlen = ap->minlen;
+		args.type = atype;
+		args.fsbno = ap->blkno;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			return error;
+	}
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		/*
 		 * allocation failed, so turn off alignment and
@@ -3589,9 +3600,7 @@ xfs_bmap_btalloc(
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
-	if (args.fsbno == NULLFSBLOCK && nullfb &&
-	    args.minlen > ap->minlen) {
-		args.minlen = ap->minlen;
+	if (args.fsbno == NULLFSBLOCK && nullfb) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = ap->blkno;
 		if ((error = xfs_alloc_vextent(&args)))
@@ -4328,6 +4337,9 @@ xfs_bmapi_write(
 		bma.prev.br_startoff = NULLFILEOFF;
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
+	if (!bma.total)
+		bma.extra = XFS_EXTENTADD_SPACE_RES(mp, whichfork);
+
 	n = 0;
 	end = bno + len;
 	obno = bno;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 8f597f9abdbe..5f008dec9c15 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -34,6 +34,7 @@ struct xfs_bmalloca {
 	int			logflags;/* flags for transaction logging */
 
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
+	xfs_extlen_t		extra;	/* extra blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	bool			eof;	/* set if allocating past last extent */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2db43ff4f8b5..8eedea183351 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -967,8 +967,8 @@ xfs_alloc_file_space(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-					allocatesize_fsb, alloc_type, resblks,
-					imapp, &nimaps);
+					allocatesize_fsb, alloc_type, 0, imapp,
+					&nimaps);
 		if (error)
 			goto error0;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2464ea351f83..389a282bd8c1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1571,6 +1571,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__field(xfs_extlen_t, prod)
 		__field(xfs_extlen_t, minleft)
 		__field(xfs_extlen_t, total)
+		__field(xfs_extlen_t, extra)
 		__field(xfs_extlen_t, alignment)
 		__field(xfs_extlen_t, minalignslop)
 		__field(xfs_extlen_t, len)
@@ -1592,6 +1593,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->prod = args->prod;
 		__entry->minleft = args->minleft;
 		__entry->total = args->total;
+		__entry->extra = args->extra;
 		__entry->alignment = args->alignment;
 		__entry->minalignslop = args->minalignslop;
 		__entry->len = args->len;
@@ -1604,9 +1606,9 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->firstblock = args->tp->t_firstblock;
 	),
 	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u "
-		  "prod %u minleft %u total %u alignment %u minalignslop %u "
-		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
-		  "datatype 0x%x firstblock 0x%llx",
+		  "prod %u minleft %u total %u extra %u alignment %u "
+		  "minalignslop %u len %u type %s otype %s wasdel %d "
+		  "wasfromfl %d resv %d datatype 0x%x firstblock 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1616,6 +1618,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->prod,
 		  __entry->minleft,
 		  __entry->total,
+		  __entry->extra,
 		  __entry->alignment,
 		  __entry->minalignslop,
 		  __entry->len,
-- 
2.17.2
