Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC6917F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 16:27:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C379304032
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 14:27:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JQFGSqV8KXg1iGzc for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 14:27:00 -0700 (PDT)
Date: Mon, 28 Apr 2014 07:26:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 05/10] xfs: fix error handling in xfs_bulkstat
Message-ID: <20140427212643.GY18672@dastard>
References: <535078B8.4020905@oracle.com>
	<20140425064815.GB20871@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140425064815.GB20871@infradead.org>
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

On Thu, Apr 24, 2014 at 11:48:15PM -0700, Christoph Hellwig wrote:
> > Moreover, this fix also get rid of the redundant user buffer count
> > pre-checkups as it has already been validated in upper callers.
> 
> > -	if (!ubcountp || *ubcountp <= 0) {
> > -		return EINVAL;
> > -	}
> 
> Probably better to have this as a separate patch.
> 
> > -			/*
> > -			 * Loop as long as we're unable to read the
> > -			 * inode btree.
> > -			 */
> > -			while (error) {
> > -				agino += XFS_INODES_PER_CHUNK;
> > -				if (XFS_AGINO_TO_AGBNO(mp, agino) >=
> > -						be32_to_cpu(agi->agi_length))
> > -					break;
> > -				error = xfs_inobt_lookup(cur, agino,
> > -							 XFS_LOOKUP_GE, &tmp);
> > -				cond_resched();
> > -			}
> 
> This code goes back to 1995, but I still can't see how it would make
> sense.  I think we should get rid of this, but I'd also love to have
> Dave and Eric double check it as well.

I can't see it makes much sense, except for handling IO errors
that occur during something like a path failover where a retry would
then succeed. However, I think that we'd do better for userspace to
handle this problem - a short bulkstat followed by userspace retry
rather than a potential endless loop in the kernel is a much better
way to handle the problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
