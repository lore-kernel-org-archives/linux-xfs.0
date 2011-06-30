Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U7IbiH188537 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 02:18:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88A8ED51794
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:18:36 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	amxig4rvtlNEwgD6 for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 00:18:36 -0700 (PDT)
Date: Thu, 30 Jun 2011 03:18:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/27] xfs: split xfs_itruncate_finish
Message-ID: <20110630071833.GA21960@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140338.286808024@bombadil.infradead.org>
	<20110630024428.GB561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630024428.GB561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jun 30, 2011 at 12:44:28PM +1000, Dave Chinner wrote:
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> > -	ASSERT((new_size == 0) || (new_size <= ip->i_size));
> > -	ASSERT(*tp != NULL);
> > -	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > -	ASSERT(ip->i_transp == *tp);
> > +	ASSERT(new_size == 0 || new_size <= ip->i_size);
> 
> If new_size == 0, then it will always be <= ip->i_size, so that's
> kind of a redundant check. I think this really should be two
> different asserts, one that validates the data fork new_size range,
> and one that validates the attr fork truncate to zero length only
> condition:
> 
> 	ASSERT(new_size <= ip->i_size);
> 	ASSERT(whichfork != XFS_ATTR_FORK || new_size == 0);

For now I was just keeping the existing assert, but changing this one
sounds ok.  OTOH I kept the whole routine fork agnostic, so I think
I'll rather just make the assert read:

	ASSERT(new_size <= ip->i_size);

and assume the one and only attr fork caller does the right thing.

> > @@ -1464,15 +1311,16 @@ xfs_itruncate_finish(
> >  		}
> >  
> >  		ntp = xfs_trans_dup(ntp);
> > -		error = xfs_trans_commit(*tp, 0);
> > -		*tp = ntp;
> > +		error = xfs_trans_commit(*tpp, 0);
> > +		*tpp = ntp;
> 
> I've always found this a mess to follow which transaction is which
> because of the rewriting of ntp. This is easier to follow:
> 
> 		ntp = xfs_trans_dup(*tpp);
> 		error = xfs_trans_commit(*tpp, 0);
> 		*tpp = ntp;
> 
> Now it's clear that we are duplicating *tpp, then committing it, and
> then setting it to the duplicated transaction. Now I don't have to
> go look at all the surrounding code to remind myself what ntp
> contains to validate that the fragment of code is doing the right
> thing.....

I've cleaned this up even further and added a local tp variable that
has the current transaction as a normal pointer.  *tpp is only assigned
back to in a single place after goto out, and ntp is only used for
the switching around to the duplicated transaction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
