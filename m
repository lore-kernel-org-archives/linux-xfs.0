Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A419B7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 18:12:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83408304032
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 16:12:51 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Eu3siw81xhqgGyRs for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 16:12:45 -0800 (PST)
Date: Tue, 9 Feb 2016 11:12:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] repair: parallelise phase 7
Message-ID: <20160209001234.GP27429@dastard>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
	<1454627108-19036-2-git-send-email-david@fromorbit.com>
	<20160208085555.GD5534@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208085555.GD5534@infradead.org>
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
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 12:55:55AM -0800, Christoph Hellwig wrote:
> > +	irec = findfirst_inode_rec(agno);
> > +
> > +	while (irec != NULL)  {
> > +		for (j = 0; j < XFS_INODES_PER_CHUNK; j++)  {
> > +			ASSERT(is_inode_confirmed(irec, j));
> > +
> > +			if (is_inode_free(irec, j))
> > +				continue;
> > +
> > +			ASSERT(no_modify || is_inode_reached(irec, j));
> > +
> > +			nrefs = num_inode_references(irec, j);
> > +			ASSERT(no_modify || nrefs > 0);
> > +
> > +			if (get_inode_disk_nlinks(irec, j) != nrefs)
> > +				update_inode_nlinks(wq->mp,
> > +					XFS_AGINO_TO_INO(wq->mp, agno,
> > +						irec->ino_startnum + j),
> > +					nrefs);
> > +		}
> > +		irec = next_ino_rec(irec);
> 
> Wouldn't this look be slightly cleaner as:
> 
> 	for (irec = findfirst_inode_rec(agno);
> 	     irec;
> 	     irec = next_ino_rec(irec)) {

Yup, done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
