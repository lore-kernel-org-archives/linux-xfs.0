Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EC8D97F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 01:32:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79E22AC038
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 23:32:13 -0700 (PDT)
Date: Fri, 17 May 2013 09:31:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] xfs: bug widening binary "not" operation
Message-ID: <20130517063159.GO1360@mwanda>
References: <20130516075330.GB7494@elgon.mountain>
	<20130516230314.GH24635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130516230314.GH24635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Fri, May 17, 2013 at 09:03:14AM +1000, Dave Chinner wrote:
> As it is, the static checker missed the:
> 
> 	rounding = max_t(uint, ....);
> 
> The line before the above usage. I posted a patch to fix this this
> 2 weeks ago here:
> 
> http://oss.sgi.com/pipermail/xfs/2013-May/025986.html
> 

Ah.  Grand.  There is still a problem with the max_t().  The shift
operation will wrap before we do the cast.  It should be:

-	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+	rounding = max_t(xfs_off_t, 1ULL << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
