Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD6A97F7C
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 19:54:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8480304051
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 17:54:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4t393afPTBgjd2Jf for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 17:54:32 -0700 (PDT)
Date: Fri, 14 Aug 2015 10:54:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/11] xfsprogs: Add a way to compile without blkid
Message-ID: <20150814005430.GS3902@dastard>
References: <1439475055-5519-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439475055-5519-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 13, 2015 at 04:10:55PM +0200, Jan Tulak wrote:
> Because not all platforms have up-to-date blkid with required
> functions, allow at least partial functionality by adding
> --enable-blkid=yes/no optional configure argument.
> 
> When blkid is disabled, signature detection and device geometry
> detection doesn't work.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

.....
> +#else /* ifdef ENABLE_BLKID */
> +/*
> + * Without blkid, we can't do a good check for signatures.
> + * So instead of some messy attempts, just disable any checks
> + * and always return 'nothing found'.
> + */
> +static int
> +check_overwrite(
> +	char		*device)
> +{
> +	return 0;
> +}
> +#endif /* ENABLE_BLKID */

I'd default the other way around, and always report that something
was found. That way we don't accidentally overwrite a block device
when someone fat-fingers the blockdev. It will mean you have to use
the force flag on OSX until such time that blkid is made to work,
but I think that's better than just overwriting the blockdev without
question....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
