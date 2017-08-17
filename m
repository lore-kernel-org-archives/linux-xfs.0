Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2730 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751572AbdHQLgu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 07:36:50 -0400
Date: Thu, 17 Aug 2017 21:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6 v2] mkfs: remove intermediate getstr followed by
 getnum
Message-ID: <20170817113647.GT21024@dastard>
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-2-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170815150812.32237-2-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 15, 2017 at 05:08:09PM +0200, Jan Tulak wrote:
> Some options loaded a number as a string with getstr and converted it to
> number with getnum later in the code, without any reason for this
> approach.  (They were probably forgotten in some past cleaning.)

Ah, no. That was done very intentionally.

> @@ -1672,7 +1674,7 @@ main(
>  					xi.dname = getstr(value, &dopts, D_NAME);
>  					break;
>  				case D_SIZE:
> -					dsize = getstr(value, &dopts, D_SIZE);
> +					dbytes = getnum(value, &dopts, D_SIZE);
>  					break;

At this point here, the size can be specified in filesystem blocks
or sectors.  We don't know what those sizes are yet - they might be
given to us later on the CLI so haven't been parsed yet.

Hence we can't convert from a string to a number yet, because the
units to do the conversion aren't defined.

Same goes for all the other 3 sizes that use strings.

> @@ -2254,10 +2255,7 @@ _("rmapbt not supported with realtime devices\n"));
>  	}
>  
>  
> -	if (dsize) {
> -		uint64_t dbytes;
> -
> -		dbytes = getnum(dsize, &dopts, D_SIZE);
> +	if (dbytes) {
>  		if (dbytes % XFS_MIN_BLOCKSIZE) {
>  			fprintf(stderr,
>  			_("illegal data length %lld, not a multiple of %d\n"),

By this time, we've validated the command line provided block/sector
sizes or have used and validated the default size. Hence we can now
convert from a string to a number as all the units we need are
defined.

IOWs, changing this code will break "size=XXXb" and "size=XXXs" CLI
size specification in unexpected ways.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
