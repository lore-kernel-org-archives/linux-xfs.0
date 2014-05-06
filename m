Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FB327FDD
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:39:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0AE8AAC008
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:39:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	UZW9jLwtMwQm1o6w for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:39:14 -0700 (PDT)
Date: Tue, 6 May 2014 18:39:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: make superblock version checks reflect reality
Message-ID: <20140506083911.GF5421@dastard>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-2-git-send-email-david@fromorbit.com>
	<20140506082948.GA18865@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506082948.GA18865@infradead.org>
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

On Tue, May 06, 2014 at 01:29:48AM -0700, Christoph Hellwig wrote:
> > +/*
> > + * The first XFS version we support is a v4 superblock with V2 directories.
> > + */
> > +static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
> >  {
> > +	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
> > +		return false;
> >  
> > +	/* check for unknown features in the fs */
> > +	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> 
> Given that sb_versionnum is a __uint16_t and XFS_SB_VERSION_OKBITS is
> 0xffff this will never evaluate to false and a sane compiler should warn
> about it.  How about remove this check and XFS_SB_VERSION_OKBITS?

It gets changed later to this:

#define XFS_SB_VERSION_OKBITS           \
        ((XFS_SB_VERSION_NUMBITS | XFS_SB_VERSION_ALLFBITS) & \
		~XFS_SB_VERSION_SHAREDBIT)

So we don't ever consider the shared bit valid. IOWs, it's not
0xffff ;)

> The various has_ macros are a bit confusing to me, as some explicitly
> check for 5 superblocks, and some assume the caller handles them in
> some way, but I think this is something we can leave for later cleanups.
> 
> >   * For example, for a bit defined as XFS_SB_VERSION2_FUNBIT, has a macro:
> >   *
> > - * SB_VERSION_HASFUNBIT(xfs_sb_t *sbp)
> > + * SB_VERSION_HASFUNBIT(struct xfs_sb *sbp)
> 
> >   *	((xfs_sb_version_hasmorebits(sbp) &&
> >   *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
> >   */
> 
> This should be updated to the lowe case convention inlines we've used
> for a long time.  Or just removed as new features should go into v5
> superblocks..

I'll update it.

> Modulo these minor bits:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
