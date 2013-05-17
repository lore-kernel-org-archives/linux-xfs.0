Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 288D27F51
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:19:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07955304084
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:19:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KATLRJ7MNe7piRS0 for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 03:19:10 -0700 (PDT)
Date: Fri, 17 May 2013 20:19:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: bug widening binary "not" operation
Message-ID: <20130517101908.GS24635@dastard>
References: <20130516075330.GB7494@elgon.mountain>
	<20130516230314.GH24635@dastard> <20130517063159.GO1360@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130517063159.GO1360@mwanda>
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

On Fri, May 17, 2013 at 09:31:59AM +0300, Dan Carpenter wrote:
> On Fri, May 17, 2013 at 09:03:14AM +1000, Dave Chinner wrote:
> > As it is, the static checker missed the:
> > 
> > 	rounding = max_t(uint, ....);
> > 
> > The line before the above usage. I posted a patch to fix this this
> > 2 weeks ago here:
> > 
> > http://oss.sgi.com/pipermail/xfs/2013-May/025986.html
> > 
> 
> Ah.  Grand.  There is still a problem with the max_t().  The shift
> operation will wrap before we do the cast.  It should be:

It probably looks that way, but it can't overflow as
mp->m_sb.sb_blocklog has a maximum value of 16 (i.e. 64k maximum
filesystem block size).

> 
> -	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
> +	rounding = max_t(xfs_off_t, 1ULL << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);

So it is safe the way it is and this is not necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
