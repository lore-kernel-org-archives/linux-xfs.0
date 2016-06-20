Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3E127CA1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 14:34:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7F93304039
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 12:34:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UCeMnFPRWQAPg8ps (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 12:34:47 -0700 (PDT)
Date: Mon, 20 Jun 2016 12:34:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 010/119] xfs: create a standard btree size calculator code
Message-ID: <20160620193432.GB29055@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612633632.12839.13314497569643567486.stgit@birch.djwong.org>
	<20160620143148.GA2465@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160620143148.GA2465@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Mon, Jun 20, 2016 at 10:31:49AM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2016 at 06:18:56PM -0700, Darrick J. Wong wrote:
> > Create a helper to generate AG btree height calculator functions.
> > This will be used (much) later when we get to the refcount btree.
> > 
> > v2: Use a helper function instead of a macro.
> > v3: We can (theoretically) store more than 2^32 records in a btree, so
> >     widen the fields to accept that.
> > v4: Don't modify xfs_bmap_worst_indlen; the purpose of /that/ function
> >     is to estimate the worst-case number of blocks needed for a bmbt
> >     expansion, not to calculate the space required to store nr records.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> I think this one should probably be pushed out to where it is used
> (easier to review with an example imo). I don't see it used anywhere up
> through the rmapbt stuff, anyways...

Oh, heh, you're right.  At one point I was using it for the rmapbt, but
nowadays it's only used for per-AG reservations (reflink+rmap) as you
point out, so it could move.

> 
> >  fs/xfs/libxfs/xfs_btree.c |   27 +++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_btree.h |    3 +++
> >  2 files changed, 30 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 105979d..5eb4e40 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -4156,3 +4156,30 @@ xfs_btree_sblock_verify(
> >  
> >  	return true;
> >  }
> > +
> > +/*
> > + * Calculate the number of blocks needed to store a given number of records
> > + * in a short-format (per-AG metadata) btree.
> > + */
> > +xfs_extlen_t
> > +xfs_btree_calc_size(
> > +	struct xfs_mount	*mp,
> > +	uint			*limits,
> > +	unsigned long long	len)
> > +{
> > +	int			level;
> > +	int			maxrecs;
> > +	xfs_extlen_t		rval;
> > +
> > +	maxrecs = limits[0];
> > +	for (level = 0, rval = 0; len > 0; level++) {
> 
> len is unsigned, so len > 0 is kind of pointless. Perhaps check len > 1
> and kill the check in the loop?

Yup.  Thank you for pointing that out.

--D

> 
> Brian
> 
> > +		len += maxrecs - 1;
> > +		do_div(len, maxrecs);
> > +		rval += len;
> > +		if (len == 1)
> > +			return rval;
> > +		if (level == 0)
> > +			maxrecs = limits[1];
> > +	}
> > +	return rval;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 9a88839..b330f19 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -475,4 +475,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
> >  bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
> >  bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
> >  
> > +xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
> > +		unsigned long long len);
> > +
> >  #endif	/* __XFS_BTREE_H__ */
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
