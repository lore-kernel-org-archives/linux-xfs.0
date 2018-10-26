Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbeJ0AZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 20:25:46 -0400
Date: Fri, 26 Oct 2018 08:48:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: print freecount in xfs_inobt_rec as unsigned
Message-ID: <20181026154804.GF28243@magnolia>
References: <3fb12611-2ce0-7e8d-0c65-dcbddf5e55b7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fb12611-2ce0-7e8d-0c65-dcbddf5e55b7@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Oct 24, 2018 at 05:20:08PM -0500, Eric Sandeen wrote:
> "freecount" in the xfs_inobt_rec is unsigned, so xfs_db should
> print it as such.
> 
> Not doing so tickles a bug in getbitval() where we try to handle
> sign extension for signed fields and fail badly on big endian
> machines, causing us to incorrectly report negative numbers when
> printing structures even when the number is nowhere near the
> signed maximum value.
> 
> So this fix works around that bug by properly marking this field
> as unsigned, because I have yet to convince myself of the proper
> fix for the underlying bug.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201453
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/db/btblock.c b/db/btblock.c
> index cbd2990..5a5b061 100644
> --- a/db/btblock.c
> +++ b/db/btblock.c
> @@ -513,7 +513,7 @@ const field_t	inobt_sprec_flds[] = {
>  	{ "holemask", FLDT_UINT16X, OI(ROFF(ir_u.sp.ir_holemask)), C1, 0,
>  	  TYP_NONE },
>  	{ "count", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_count)), C1, 0, TYP_NONE },
> -	{ "freecount", FLDT_INT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
> +	{ "freecount", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
>  	  TYP_NONE },
>  	{ "free", FLDT_INOFREE, OI(ROFF(ir_free)), C1, 0, TYP_NONE },
>  	{ NULL }
> 
