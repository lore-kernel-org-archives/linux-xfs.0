Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAB87801D
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 17:36:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B2888F8035
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 15:36:23 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DviYysEvaOXgryiI for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 15:36:18 -0800 (PST)
Date: Mon, 4 Mar 2013 10:36:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs_repair: skip freelist scan of corrupt agf in
	no-modify mode
Message-ID: <20130303233615.GK26081@dastard>
References: <51313DE8.5080104@sandeen.net>
 <51326DC0.8030403@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51326DC0.8030403@sandeen.net>
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

On Sat, Mar 02, 2013 at 03:23:12PM -0600, Eric Sandeen wrote:
> In xfs_repair's no-modify mode (-n), verify_set_agf doesn't fix up
> bad freelist blocks that it finds.  When we get to scan_freelist,
> this can wreak havoc if, for example, first > last and the loop
> never exits; we index agfl->agfl_bno[i] off into the weeds.
> 
> To fix this, re-check the values in no-modify mode, and if
> they're off, warn about it and skip the scan.
> 
> Reported-by: Ole Tange <tange@binf.ku.dk>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Remove dumb mistakes :/
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 5345094..1d39bdc 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1066,6 +1066,18 @@ scan_freelist(
>  		return;
>  	}
>  	agfl = XFS_BUF_TO_AGFL(agflbuf);
> +
> +	if (no_modify) {
> +		/* agf values not fixed in verify_set_agf, so recheck */
> +		if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp) ||
> +		    be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp)) {
> +			do_warn(_("agf %d freelist blocks bad, skipping "
> +				  "freelist scan\n"), i);
> +			return;
> +		}
> +	} else /* should have been fixed in verify_set_agf() */
> +		ASSERT(0);
> +
>  	i = be32_to_cpu(agf->agf_flfirst);
>  	count = 0;
>  	for (;;) {

Looks ok, but IIRC there are overruns in these functions for the
same reason (i.e. unchecked use of agf->agf_flfirst as an array
index)

db/check.c::scan_freelist()
db/freesp.c::scan_freelist()

I found lots of almost-but-not-quite-exact code duplication like
this recenty when doing CRC updates to the userspace code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
