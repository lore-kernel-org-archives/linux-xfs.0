Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 506C77F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 18:03:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31414304043
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 16:03:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RrRFxKrapMF2j0yF for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 16:03:16 -0700 (PDT)
Date: Fri, 17 May 2013 09:03:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: bug widening binary "not" operation
Message-ID: <20130516230314.GH24635@dastard>
References: <20130516075330.GB7494@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130516075330.GB7494@elgon.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 16, 2013 at 10:53:30AM +0300, Dan Carpenter wrote:
> The problem here is:
> 
> 	ioffset = offset & ~(rounding - 1);
> 
> "offset" and "ioffset" are type xfs_off_t (__s64) and "rounding" is
> unsigned int.  The "offset & ~(rounding - 1)" clears the high 32 bits
> and which is unintentional.
> 
> This is a static checker fix so I'm not sure how much difference this
> makes in real life.

It is a real problem, but one that is masked by the way we do range
flushing right now.

As it is, the static checker missed the:

	rounding = max_t(uint, ....);

The line before the above usage. I posted a patch to fix this this
2 weeks ago here:

http://oss.sgi.com/pipermail/xfs/2013-May/025986.html

But thanks for the independent confirmation of the problem, Dan. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
