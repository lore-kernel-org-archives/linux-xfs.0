Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CGpWLI047092 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 11:51:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FAB9C09058
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 09:53:01 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 7oIJNcgYr6GmWjrd for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 09:53:01 -0700 (PDT)
Message-ID: <4AD35EEC.4080707@sandeen.net>
Date: Mon, 12 Oct 2009 11:53:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 01/14] repair: merge scanfunc_bno and scanfunc_cnt
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175839.915684396@bombadil.infradead.org>
In-Reply-To: <20090902175839.915684396@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> Those two functions are almost identical. The big difference is that 
> we only
> move blocks from XR_E_FREE1 to XR_E_FREE state when processing the cnt btree.
>
> Besides that we print bno vs cnt in the messages and obviously validate a
> slightly different magic number in the header.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>

Generally seems fine to me, a couple of nitpicks below, take 'em or leave 'em.

> Index: xfsprogs-dev/repair/scan.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/scan.c	2009-08-21 18:24:26.000000000 +0000
> +++ xfsprogs-dev/repair/scan.c	2009-08-21 18:40:59.000000000 +0000
> @@ -439,15 +439,16 @@ _("out-of-order bmap key (file offset) i
>  }
>  
>  void
> -scanfunc_bno(
> +scanfunc_allocbt(
>  	struct xfs_btree_block	*block,
>  	int			level,
>  	xfs_agblock_t		bno,
>  	xfs_agnumber_t		agno,
>  	int			suspect,
> -	int			isroot
> -	)
> +	int			isroot,
> +	__uint32_t		magic)
>  {
> +	const char 		*name;
>  	xfs_agblock_t		b, e;
>  	int			i;
>  	xfs_alloc_ptr_t		*pp;
> @@ -456,16 +457,18 @@ scanfunc_bno(
>  	int			numrecs;
>  	int			state;
>  
> -	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC) {
> -		do_warn(_("bad magic # %#x in btbno block %d/%d\n"),
> -			be32_to_cpu(block->bb_magic), agno, bno);
> +	name = (magic == XFS_ABTB_MAGIC) ? "bno" : "cnt";

Should we explicitly test that this is either 
XFS_ABTC_MAGIC or XFS_ABTB_MAGIC here to avoid any programming-error
type problems?
> +
> +	if (be32_to_cpu(block->bb_magic) != magic) {
> +		do_warn(_("bad magic # %#x in bt%s block %d/%d\n"),
> +			be32_to_cpu(block->bb_magic), name, agno, bno);
>  		hdr_errors++;
>  		if (suspect)
>  			return;
>  	}
>  	if (be16_to_cpu(block->bb_level) != level) {
> -		do_warn(_("expected level %d got %d in btbno block %d/%d\n"),
> -			level, be16_to_cpu(block->bb_level), agno, bno);
> +		do_warn(_("expected level %d got %d in bt%s block %d/%d\n"),
> +			level, be16_to_cpu(block->bb_level), name, agno, bno);
>  		hdr_errors++;
>  		if (suspect)
>  			return;
> @@ -483,8 +486,8 @@ scanfunc_bno(
>  	default:
>  		set_agbno_state(mp, agno, bno, XR_E_MULT);
>  		do_warn(
> -_("bno freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
> -				state, agno, bno, suspect);
> +_("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
> +				name, state, agno, bno, suspect);
>  		return;
>  	}
>  
> @@ -520,15 +523,27 @@ _("bno freespace btree block claimed (st
>  				continue;
>  			for (b = be32_to_cpu(rp[i].ar_startblock);
>  			     b < e; b++)  {
> -				if (get_agbno_state(mp, agno, b)
> -							== XR_E_UNKNOWN)
> +				state = get_agbno_state(mp, agno, b);
> +				switch (state) {
> +				case XR_E_UNKNOWN:
>  					set_agbno_state(mp, agno, b,
>  							XR_E_FREE1);
> -				else  {
> +					break;
> +				case XR_E_FREE1:
> +					/*
> +					 * no warning messages -- we'll catch
> +					 * FREE1 blocks later
> +					 */
> +					if (magic != XFS_ABTB_MAGIC) {

Why not make this explicitly "if (magic == XFS_ABTC_MAGIC)" - I guess it seems potentially
more future-proof to me though I don't suppose we'll ever get a new type here.  :)
The positive test seems clearer to me but *shrug*.

Rest looks fine.  I suppose we should do the same to the functions in db/* someday.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
