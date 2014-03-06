Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C07207F52
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 16:56:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52990AC005
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 14:55:59 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uKK7u8OLRWYJxQGL for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 14:55:56 -0800 (PST)
Date: Fri, 7 Mar 2014 09:55:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH] xfs: make superblock version checks reflect reality
Message-ID: <20140306225541.GL6851@dastard>
References: <1394088890-10713-1-git-send-email-david@fromorbit.com>
	<20140306180534.GA305@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140306180534.GA305@infradead.org>
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

On Thu, Mar 06, 2014 at 10:05:34AM -0800, Christoph Hellwig wrote:
> On Thu, Mar 06, 2014 at 05:54:50PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We only support filesystems that have v2 directory support, and than
> > means all the checking and handling of superblock versions prior to
> > this support being added is completely unnecessary overhead.
> > 
> > Strip out all the version 1-3 support, sanitise the good version
> > checking to reflect the supported versions, update all the feature
> > supported functions and clean up all the support bit definitions to
> > reflect the fact that we no longer care about Irix bootloader flag
> > regions for v4 feature bits.
> 
> Good idea in general, I like it.
> 
> > Because the feature bit checking is all inline code, this relatively
> > small cleanup has a noticable impact on code size:
> 
> I initially though moving it out of line might not be a bad idea,
> but it seems after your diet it's lean enough to not bother.

Yeah, i think that chopping out all the branches from the code makes
it simple enough that it can remain inline.

> > +/*
> > + * We only support superblocks that have at least V2 Dir capability. Any feature
> > + * bit added after v2 dir capability is also indicates a supported superblock
> > + * format.
> > + */
> > +#define XFS_SB_NEEDED_FEATURES		\
> > +	(XFS_SB_VERSION_DIRV2BIT	| \
> > +	 XFS_SB_VERSION_LOGV2BIT	| \
> > +	 XFS_SB_VERSION_SECTORBIT	| \
> > +	 XFS_SB_VERSION_BORGBIT		| \
> >  	 XFS_SB_VERSION_MOREBITSBIT)
> 
> This seems a bit odd.  Shouldn't we simply check for
> XFS_SB_VERSION_DIRV2BIT as we actually rely on that?  What if SGI had
> backported any of those other features to some IRIX branch?

They did. logv2 came from irix, and the borgbit did too. Hence we
can be guaranteed that if any of these bits exist on irix, then
dirv2 fields are present in the superblock, too.

> I'd vote to kill XFS_SB_NEEDED_FEATURES and just check the dirv2 bit
> explicitly.

Ok. The only real reason I did this was in case there's a single bit
error that clears the dirv2 bit, but it still contains other bits
that indicate that the superblock is recent enough that we
understand it's contents and what should bein the fs.  e.g. for
db/repair purposes - if the dir2 bit is not set, but any of the
above bits are set and the m_dirblklog is and it is sane, we can
assume that we've lost the feature bit and repair it.

> > +/*
> > + * Supported feature bit list is just all bits in the versionnum field because
> > + * we've used them all up and understand them all.
> > + */
> > +#define	XFS_SB_VERSION_OKBITS		\
> > +	(XFS_SB_VERSION_NUMBITS		| \
> > +	 XFS_SB_VERSION_ALLFBITS)
> >  
> 
> > +#define	XFS_SB_VERSION2_OKBITS		\
> >  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> >  	 XFS_SB_VERSION2_ATTR2BIT	| \
> >  	 XFS_SB_VERSION2_PROJID32BIT	| \
> >  	 XFS_SB_VERSION2_FTYPE)
> 
> > +/*
> > + * The first XFS version we support is filesytsems with V2 directories.
> > + */
> 
> is a v4 superblock with v2 directories?

*nod*

> 
> Also filesystem is mis-spelled.
> 
> >  static inline int xfs_sb_good_version(xfs_sb_t *sbp)
> >  {
> > +	/* We only support v4 and v5 */
> > +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4 ||
> > +	    XFS_SB_VERSION_NUM(sbp) > XFS_SB_VERSION_5)
> > +		return 0;
> > +
> > +	/*
> > +	 * Version 5 feature checks are done separately.
> > +	 */
> > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> >  		return 1;
> 
> How about doing this a little different?
> 
> static inline int xfs_sb_good_version(struct xfs_sb *sbp)
> {
> 	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> 		return 1;
> 	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
> 		return xfs_sb_good_v4_features(sbp);
> 	return 0;
> }
> 
> then move the bulk of the function into xfs_sb_good_v4_features?

Makes sense.

> 
> 
> > +	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> > +	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
> > +	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
> >  			return 0;
> > +	if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
> > +		return 0;
> 
> Given that XFS_SB_MAX_SHARED_VN we might as well make that and != 0
> check and document that we don't support any shared superblocks.

Should I just drop it out of the supported feature matrix and drop
all other checks on that field? That way we can then remove all the
the crap that tries to validate it from xfs_repair, too. I have no
idea what is actually valid for this field, so I think we should
simply drop support of it from everything.

> >  static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
> >  {
> > +	return !!(sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT);
> >  }
> 
> Should this become a bool?

Yeah, I thought about that. Probably should, then the compiler will
add the cast rather than having to use !! to bring it back to a bool
value.

> 
> >  
> >  static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
> >  {
> > +	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
> >  }
> 
> I'd rather not keep the wrappers for adding these flags - the callers
> already know sb internals, might as well not keep a false abstraction
> here.

Ok, but I'd like to keep that to a separate cleanup....

> 
> >  static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
> >  {
> > -	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> > -		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > -		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
> > +	return !!(sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT);
> >  }
> 
> As we reject filesystems without the nlink bit we should just be able
> to kill all code protected by xfs_sb_version_hasnlink checks, shouldn't
> we?
> Same for addnlink.
> dirv2 is another candidate.

Yes, that's true - but I think those are good candidates for
separate patches that follow up on this one.

> > @@ -536,11 +493,13 @@ static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
> >  {
> >  	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
> >  	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
> > +	sbp->sb_bad_features2 |= XFS_SB_VERSION2_ATTR2BIT;
> >  }
> >  
> >  static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
> >  {
> >  	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
> > +	sbp->sb_bad_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
> 
> Where is this coming from?  Seems unrelated to the other changes.

I noticed that these feature bits weren't updating the bad_features2
field and keeping it consistent with features2, which they should.
I'll separate this out into another patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
