Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D96B7F5F
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 13:30:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18B71AC005
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:30:38 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0Ig02iAvOFCjCe0E for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 11:30:22 -0800 (PST)
Date: Tue, 3 Feb 2015 06:30:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: struct xfs_sb is no longer tied to the on-disk
	format
Message-ID: <20150202193020.GJ6282@dastard>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-2-git-send-email-david@fromorbit.com>
	<20150202084102.GA28121@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202084102.GA28121@infradead.org>
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

On Mon, Feb 02, 2015 at 12:41:02AM -0800, Christoph Hellwig wrote:
> >  /*
> > - * Superblock - in core version.  Must match the ondisk version below.
> > - * Must be padded to 64 bit alignment.
> > - */
> > -typedef struct xfs_sb {
> > -	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
> > -	__uint32_t	sb_blocksize;	/* logical block size, bytes */
> 
> > -static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
> > +static inline int xfs_sb_version_hasfinobt(struct xfs_sb *sbp)
> 
> So xfs_format.h now requires struct xfs_sb to be defined before it
> can be included?  I guess we need to move these macros around as well.

Yes, that's why I moved it to xfs_super.h, which is included from
xfs_linux.h. I just wanted to move it from xfs_format.h to
/somewhere/ to demonstrate that it isn't part of the on-disk format
anymore.

> > diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> > index 2b830c2..a02236b 100644
> > --- a/fs/xfs/xfs_super.h
> > +++ b/fs/xfs/xfs_super.h
> > @@ -61,6 +61,87 @@ struct xfs_mount;
> >  struct xfs_buftarg;
> >  struct block_device;
> >  
> > +/*
> > + * Superblock - in core version.  This does not have ot match the size and shape
> > + * of the on-disk superblock, but must contain all the fields that we use in the
> > + * on-disk superblock.
> > + */
> > +struct xfs_sb {
> 
> Is this really the right header?  xfs_super.h only really is for bits
> related to linux super block operastions.

No, probably not, but it was expedient and good enough for an RFC
and sanity testing. I thought about xfs_mount.h, but then realised
that just introduces a new dependency between xfs_mount.h and
libxfs, which is something I'm trying to reduce.

> I'd expect to move it close to stuct xfs_mount, and maybe even merge
> it into that in the long run.

I guess moving the structure there is fine, but we still want all
the version functions to be shared with userspace, which then makes
for an interesting set of dependencies. Any other ideas?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
