Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4FD729DFF
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 17:24:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6DA28F806F
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 15:24:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LXTrzIV0dSiS8TUd for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 15:24:28 -0700 (PDT)
Date: Sat, 11 Apr 2015 08:24:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: DIO requires an ioend for writes
Message-ID: <20150410222425.GM13731@dastard>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<1428673080-23052-2-git-send-email-david@fromorbit.com>
	<20150410202137.GA2846@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150410202137.GA2846@laptop.bfoster>
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
Cc: xfs@oss.sgi.com

On Fri, Apr 10, 2015 at 04:21:37PM -0400, Brian Foster wrote:
> On Fri, Apr 10, 2015 at 11:37:56PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Right now unwritten extent conversion information is passed by
> > making the end IO private data non-null, which does not enable us to
> > pass any information from submission context to completion context,
> > which we need to use the standard IO completion paths.
> > 
> > Allocate an ioend in block allocation for direct IO and attach it to
> > the mapping buffer used during direct IO block allocation. Factor
> > the mapping code to make it obvious that this is happening only for
> > direct IO writes, and and place the mapping info and IO type
> > directly into the ioend for use in completion context.
> > 
> > The completion is changed to check the ioend type to determine if
> > unwritten extent completion is necessary or not.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c | 79 ++++++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 61 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 3a9b7a1..d95a42b 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1233,6 +1233,57 @@ xfs_vm_releasepage(
> >  	return try_to_free_buffers(page);
> >  }
> >  
> > +static void
> > +xfs_get_blocks_map_buffer(
> > +	struct inode		*inode,
> > +	struct buffer_head	*bh_result,
> > +	int			create,
> > +	int			direct,
> > +	struct xfs_bmbt_irec	*imap,
> > +	xfs_off_t		offset,
> > +	ssize_t			size)
> > +{
> > +	struct xfs_ioend	*ioend;
> > +	int			type;
> > +
> > +	if (!create) {
> > +		/*
> > +		 * Unwritten extents do not report a disk address for
> > +		 * the read case (treat as if we're reading into a hole).
> > +		 */
> > +		if (!ISUNWRITTEN(imap))
> > +			xfs_map_buffer(inode, bh_result, imap, offset);
> > +		return;
> > +	}
> 
> This logic was kind of ugly to begin with, but I think the refactoring
> exposes it further. There's rather twisty logic here just for a case

Yup, I isolated it first to make it easy to change, not necessarily
easier to read ;)

....

> So if we pull some of the bits from xfs_get_blocks_map_buffer() back up,
> I end up with something like the the following here. Compile tested
> only, but illustrates the point:
> 
>         /*
>          * Map the buffer as long as we have physical blocks and this isn't a
>          * read of an unwritten extent. Treat reads into unwritten extents as
>          * holes and thus do not return a mapping.
>          */
>         if (imap.br_startblock != HOLESTARTBLOCK &&
>             imap.br_startblock != DELAYSTARTBLOCK &&
>             (create || !ISUNWRITTEN(&imap))) {
>                 xfs_map_buffer(inode, bh_result, &imap, offset);
> 		/* unwritten implies create due to check above */
>                 if (ISUNWRITTEN(&imap))
>                         set_buffer_unwritten(bh_result);
>                 /* direct writes have a special mapping */
>                 if (create && direct) {
>                         error = xfs_map_direct(inode, bh_result, &imap, offset);
>                         if (error)
>                                 return error;
>                 }
>         }
> 
> I renamed the helper to xfs_map_direct(), killed everything therein up
> through the !direct check and killed both the create and direct params.
> Thoughts?

Yeah, that looks neater; I'll split and rework it in a similar
manner to this. Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
