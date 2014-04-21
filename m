Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 574427F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 18:52:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A173304053
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:52:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wCZJpyrG9bGjepOV for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 16:52:52 -0700 (PDT)
Date: Tue, 22 Apr 2014 09:52:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 02/10] xfs: consolidate xfs_bulkstat_single
Message-ID: <20140421235249.GG18672@dastard>
References: <535078AD.5050209@oracle.com>
	<20140421141148.GA27064@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140421141148.GA27064@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Apr 21, 2014 at 07:11:48AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 18, 2014 at 08:58:21AM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > In xfs_bulkstat_single(), call xfs_bulkstat_one() and xfs_bulkstat()
> > would return different error if either failed, we'd better return the
> > proper error in this case.  Moreover, the function argument done is
> > useless in terms of xfs_ioc_bulkstat(), hence we can get rid of it.
> 
> I've looked at xfs_bulkstat_single I really can't see how falling back
> to the full xfs_bulkstat could fix any error.  We probably should just
> get rid of the fallback and instead do something like the (lightly tested)
> patch below:
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: xfs: remove xfs_bulkstat_single
> 
> xfs_bukstat_one doesn't have any failure case that would go away when
> called through xfs_bulkstat, so remove the fallback and the now unessecary
> xfs_bulkstat_single function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

*nod*

I like this approach :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
