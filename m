Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85B897F7D
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 18:32:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64E67304039
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 16:32:44 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FFcq5HfoC8Nyecwq for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 16:32:42 -0700 (PDT)
Date: Thu, 2 Jul 2015 09:32:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/14] libxfs: adjust refcounts in reflink btree
Message-ID: <20150701233228.GV22807@dastard>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625233923.4992.89446.stgit@birch.djwong.org>
	<20150701010654.GQ22807@dastard>
	<20150701231022.GC10043@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150701231022.GC10043@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 04:10:22PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 01, 2015 at 11:06:54AM +1000, Dave Chinner wrote:
> > On Thu, Jun 25, 2015 at 04:39:23PM -0700, Darrick J. Wong wrote:
> > > Provide a function to adjust the reference counts for a range of
> > > blocks in the reflink btree.
.....
> > > +{
> > > +	struct xfs_btree_cur	*cur;
> > > +	int			error;
> > > +	int			i, have;
> > > +	bool			real_crl;	/* cbno/clen is on disk? */
> > > +	xfs_agblock_t		lbno, cbno, rbno;	/* rlextent start */
> > > +	xfs_extlen_t		llen, clen, rlen;	/* rlextent length */
> > > +	xfs_nlink_t		lnr, cnr, rnr;		/* rlextent refcount */
> > 
> > "num" is the usual shorthand for "number". And in this case, nr is
> > extremely ambiguous: Number of records, number of reflinks, some
> > other number? I can't easily tell when I read the code, so the
> > variable names need to be better. factoring will certainly help
> > here.
> 
> "refc" as shorthand for reference count, perhaps?

refcnt is the usual self-documenting shorthand ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
