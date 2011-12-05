Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB59Z2cn125558 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 03:35:03 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C8811F41ADF
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 01:34:59 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AKePKMkCTtp230QY for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 01:34:59 -0800 (PST)
Date: Mon, 5 Dec 2011 20:34:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/16] xfs: flatten the dquot lock ordering
Message-ID: <20111205093437.GA28326@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.808570926@bombadil.infradead.org>
	<20111205050428.GP7046@dastard>
	<20111205091121.GA22018@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205091121.GA22018@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 05, 2011 at 04:11:21AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 05, 2011 at 04:04:28PM +1100, Dave Chinner wrote:
> > > @@ -509,46 +518,27 @@ xfs_qm_dqpurge_int(
> > >  	 */
> > >  	xfs_qm_detach_gdquots(mp);
> > >  
> > > -      again:
> > > -	nmisses = 0;
> > 
> > I don't think that nmisses is initialised to zero correctly anymore.
> 
> We do a
> 
>         int                     nmisses = 0;
> 
> at the top of the function.  Now that there are no retry loops that's
> sufficient.

Hmmmm. My unmodified tree just has the declaration without
initialisation, and I didn't find any place where the initialisation
was added in the preceding patches. I'll go back and have another
look.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
