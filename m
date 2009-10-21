Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LJXDkS027407 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 14:33:13 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 10/14] repair: cleanup helpers for tracking block usage
Date: Wed, 21 Oct 2009 14:33:05 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADF0@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175841.479553130@bombadil.infradead.org>
From: "Alex Elder" <aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Rename get_agbno_state/set_agbno_state to get_bmap/set_bmap because
> those names are more self-descriptive.  Remove the superblous mount
> argument to the as the current filesystem is a global in repair.
> Remove the fsbno taking variant as they just complicated the code.
> Bring all uses of them into the canonical form.

Another big pile o' whitespace changes here, wish they were
separated so it was clearer to see what *really* changed...

One bad bug indicated in comments below, but easy to fix.

But this looks good otherwise.

> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfsprogs-dev/repair/scan.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/scan.c	2009-08-21 19:05:32.000000000 +0000
> +++ xfsprogs-dev/repair/scan.c	2009-08-21 19:06:51.000000000 +0000

. . .

> @@ -476,19 +480,15 @@ scanfunc_allocbt(
>  	/*
>  	 * check for btree blocks multiply claimed
>  	 */
> -	state = get_agbno_state(mp, agno, bno);
> -
> -	switch (state)  {
> -	case XR_E_UNKNOWN:
> -		set_agbno_state(mp, agno, bno, XR_E_FS_MAP);
> -		break;
> -	default:
> -		set_agbno_state(mp, agno, bno, XR_E_MULT);
> +	state = get_bmap(agno, bno);
> +	switch (state != XR_E_UNKNOWN)  {

BUG.      You mean "if (state != XR_E_UNKNOWN)"???

> +		set_bmap(agno, bno, XR_E_MULT);
>  		do_warn(
>  _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
>  				name, state, agno, bno, suspect);
>  		return;
>  	}
> +	set_bmap(agno, bno, XR_E_FS_MAP);
> 
>  	numrecs = be16_to_cpu(block->bb_numrecs);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
