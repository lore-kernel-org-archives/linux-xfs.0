Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A19D57FF6
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 19:18:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14C9AAC001
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 17:18:14 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VuTzgb2jElTefWl2 for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 17:18:10 -0800 (PST)
Date: Sat, 2 Mar 2013 12:18:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: skip freelist scan of dodgy agf in no-modify
	mode
Message-ID: <20130302011806.GF23616@dastard>
References: <51313DE8.5080104@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51313DE8.5080104@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ole Tange <tange@binf.ku.dk>, xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 01, 2013 at 05:46:48PM -0600, Eric Sandeen wrote:
> In no-modify mode (-n), verify_set_agf doesn't fix up bad
> freelist blocks that it finds.  When we get to scan_freelist,
> this can wreak havoc if, for example, first > last and the loop
> never exits; we index agfl->agfl_bno[i] off into the weeds.
> 
> To fix this, re-check the values in no-modify mode, and if
> they're off, warn about it and skip the scan.
> 
> In addition, add a check to verify_set_agf() to ensure that
> first <= last.
> 
> Reported-by: Ole Tange <tange@binf.ku.dk>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 769022d..68789fe 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -86,6 +86,14 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
>  	 * check first/last AGF fields.  if need be, lose the free
>  	 * space in the AGFL, we'll reclaim it later.
>  	 */
> +	if (be32_to_cpu(agf->agf_flfirst) > be32_to_cpu(agf->agf_fllast)) {
> +		do_warn(_("flfirst %d in agf %d > fllast %d\n"),
> +			be32_to_cpu(agf->agf_flfirst),
> +			i, be32_to_cpu(agf->agf_fllast));
> +		if (!no_modify)
> +			agf->agf_fllast = agf->agf_flfirst = cpu_to_be32(0);
> +	}

I don't think that test is correct. The free list is circular and is
indexed as a pair of head/tail pointers. Hence flfirst > fllast can
be actually valid. e.g. flcount = 4, flfirst=126, fllast = 2 is a
valid free list.

> +
>  	if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp))  {
>  		do_warn(_("flfirst %d in agf %d too large (max = %zu)\n"),
>  			be32_to_cpu(agf->agf_flfirst),
> diff --git a/repair/scan.c b/repair/scan.c
> index 5345094..0f83fb4 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1067,6 +1067,17 @@ scan_freelist(
>  	}
>  	agfl = XFS_BUF_TO_AGFL(agflbuf);
>  	i = be32_to_cpu(agf->agf_flfirst);
> +	if (no_modify) {
> +		/* agf values not sanitized, so double check */
> +		if (i >= XFS_AGFL_SIZE(mp) ||
> +		    be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp) ||
> +		    i > be32_to_cpu(agf->agf_fllast))
> +			do_warn(_("agf %d freelist blocks bad, skipping scan\n"),

"skipping freelist scan"

> +				i);
> +			return;

Also, you might be missing a set of {} there - that will always
return immediately if no_modify is set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
