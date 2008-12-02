Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB20bKYf000715 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 18:37:20 -0600
Date: Tue, 02 Dec 2008 11:37:31 +1100
Subject: Re: [REVIEW] Fix unaligned accesses in IA64 in xfsprogs
From: "Barry Naujok" <bnaujok@sgi.com>
MIME-Version: 1.0
References: <op.ulg0j1bf3jf8g2@pc-bnaujok.melbourne.sgi.com>
	<20081201134205.GA7528@infradead.org>
Message-ID: <op.ulieotl73jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20081201134205.GA7528@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, 02 Dec 2008 00:42:05 +1100, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Mon, Dec 01, 2008 at 05:34:39PM +1100, Barry Naujok wrote:
>> xfs_repair is the main culprit when getting disk extents which aren't
>> properly aligned in memory. This patch does not call
>> xfs_bmbt_disk_get_all directly anymore but does an unaligned get on
>> the disk extent record and calls xfs_bmbt_get_all which is host-based
>> like the rest of the kernel routines do.
>
> What about just doin the get_unaligned in xfs_bmbt_disk_get_all?  That
> way we could just use it everywhere.  The only users that don't need
> the get_unaligned are in the tracing code, and I don't think we should
> be worried about that little bit of overhead.
>
>> @@ -277,21 +277,17 @@ convert_extent(
>>   	xfs_dfilblks_t		*cp,
>>   	int			*fp)
>>   {
>
> And then we could replace this helper with a direct call to
> xfs_bmbt_disk_get_all as the caller would be much cleaner with a
> xfs_bmbt_irec_t on the stack anyway..

Obviously modifying xfs_bmbt_disk_get_all yields a much smaller patch:

===========================================================================
xfsprogs/db/bmap.c
===========================================================================

--- a/xfsprogs/db/bmap.c	2008-12-02 11:21:00.000000000 +1100
+++ b/xfsprogs/db/bmap.c	2008-12-02 11:20:41.324928232 +1100
@@ -277,21 +277,14 @@ convert_extent(
  	xfs_dfilblks_t		*cp,
  	int			*fp)
  {
-	xfs_bmbt_irec_t irec, *s = &irec;
-	xfs_bmbt_rec_t rpcopy, *p = &rpcopy;
+	xfs_bmbt_irec_t		irec;

-	memmove(&rpcopy, rp, sizeof(rpcopy));
-	libxfs_bmbt_disk_get_all(p, s);
+	libxfs_bmbt_disk_get_all(rp, &irec);

-	if (s->br_state == XFS_EXT_UNWRITTEN) {
-		*fp = 1;
-	} else {
-		*fp = 0;
-	}
-
-	*op = s->br_startoff;
-	*sp = s->br_startblock;
-	*cp = s->br_blockcount;
+	*fp = irec.br_state == XFS_EXT_UNWRITTEN;
+	*op = irec.br_startoff;
+	*sp = irec.br_startblock;
+	*cp = irec.br_blockcount;
  }

  void

===========================================================================
xfsprogs/libxfs/xfs_bmap_btree.c
===========================================================================

--- a/xfsprogs/libxfs/xfs_bmap_btree.c	2008-12-02 11:21:00.000000000 +1100
+++ b/xfsprogs/libxfs/xfs_bmap_btree.c	2008-12-02 11:20:09.553355392 +1100
@@ -181,7 +181,8 @@ xfs_bmbt_disk_get_all(
  	xfs_bmbt_rec_t	*r,
  	xfs_bmbt_irec_t *s)
  {
-	__xfs_bmbt_get_all(be64_to_cpu(r->l0), be64_to_cpu(r->l1), s);
+	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
+				get_unaligned_be64(&r->l1), s);
  }

  /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
