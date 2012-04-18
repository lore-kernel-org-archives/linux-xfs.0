Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3I1bnkc128517 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 20:37:49 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mY8CLABqRGGaakwU for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 18:37:47 -0700 (PDT)
Date: Wed, 18 Apr 2012 11:37:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC]xfs: using GFP_NOFS for blkdev_issue_flush
Message-ID: <20120418013746.GL6734@dastard>
References: <4F8BC112.9090508@fusionio.com>
 <4F8BC30D.5040601@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F8BC30D.5040601@kernel.org>
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
To: Shaohua Li <shli@kernel.org>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Apr 16, 2012 at 02:58:21PM +0800, Shaohua Li wrote:
> On 4/16/12 2:49 PM, Shaohua Li wrote:
> >
> >flush request is issued in transaction commit code path usually, so
> >looks using
> >GFP_KERNEL to allocate memory for flush request bio falls into the classic
> >deadlock issue (memory reclaim recursion). Use GFP_NOFS to avoid recursion
> >from reclaim context. Per Dave Chinner, there is only blkdev_issue_flush
> >might
> >be buggy here. But using GFP_NOFS by default for all calls should not
> >matter.

Can you update the commit message like I suggested previously?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
