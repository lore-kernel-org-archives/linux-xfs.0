Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ONrCPt139608 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 17:53:13 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 456B61056542
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 15:55:34 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dZBzBtySor6FspXP for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 15:55:34 -0800 (PST)
Date: Tue, 25 Jan 2011 10:55:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] libxfs: sync files with 2.6.38 kernel code
Message-ID: <20110124235532.GG11040@dastard>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-4-git-send-email-david@fromorbit.com>
	<20110124085751.GB4378@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110124085751.GB4378@infradead.org>
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

On Mon, Jan 24, 2011 at 03:57:51AM -0500, Christoph Hellwig wrote:
> > +/* XXX: fix this up! */
> >  #define	OFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
> >  const field_t	inode_flds[] = {
> > -	{ "core", FLDT_DINODE_CORE, OI(OFF(core)), C1, 0, TYP_NONE },
> > -	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
> > -	  TYP_INODE },
> > -	{ "u", FLDT_DINODE_U, OI(OFF(u)), C1, 0, TYP_NONE },
> > +	{ "core", FLDT_DINODE_CORE, OI(OFF(magic)), C1, 0, TYP_NONE },
> > +	{ "u", FLDT_DINODE_U, inode_u_offset, C1, FLD_OFFSET, TYP_NONE },
> 
> I think the right way to fix this is to copy over all fields from
> the dinode core, and keep a "virtual" core field and the inode_core
> table for backwards compatiblity.

OK. By "virtual" core field, do you mean something like what I have
about, or something different?

> > +	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
> > +	  TYP_INODE },
> 
> I think this one should only be added to the real dinode, not the core.

Good catch. I mixed up what was in xfs_icdinode and xfs_dinode
there.

> 
> >  #define XFS_BUF_LOCK			0
> >  #define XFS_BUF_TRYLOCK			0
> > +#define XBF_LOCK			XFS_BUF_LOCK
> > +#define XBF_TRYLOCK			XFS_BUF_TRYLOCK
> > +#define XBF_DONT_BLOCK			0
> 
> Please kill off the XFS_BUF_* flags, just like in kernelspace.

Will do.

Thanks for spending the time to look over these huge patches,
Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
