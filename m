Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86A0E7CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 10:27:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56A41304032
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 08:27:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VC0GHkde2Zvj9GB3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 08:27:19 -0700 (PDT)
Date: Mon, 23 May 2016 10:27:15 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_repair: further improvement on secondary superblock
	search method
Message-ID: <20160523152715.GA27527@redhat.com>
References: <1463085496-17919-1-git-send-email-billodo@redhat.com>
	<20160523145116.GE9319@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160523145116.GE9319@infradead.org>
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

On Mon, May 23, 2016 at 07:51:16AM -0700, Christoph Hellwig wrote:
> On Thu, May 12, 2016 at 03:38:16PM -0500, Bill O'Donnell wrote:
> > +verify_sb_blocksize(xfs_sb_t *sb)
> > +{
> > +	__uint32_t	bsize;
> > +	int		i;
> > +
> > +	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
> > +	if (sb->sb_blocksize == 0)
> > +		return(XR_BAD_BLOCKSIZE);
> > +
> > +	bsize = 1;
> > +
> > +	for (i = 0; bsize < sb->sb_blocksize &&
> > +		i < sizeof(sb->sb_blocksize) * NBBY; i++)
> > +		bsize <<= 1;
> > +
> > +	if (i < XFS_MIN_BLOCKSIZE_LOG || i > XFS_MAX_BLOCKSIZE_LOG)
> > +		return(XR_BAD_BLOCKSIZE);
> > +
> > +	/* check sb blocksize field against sb blocklog field */
> > +	if (i != sb->sb_blocklog)
> > +		return(XR_BAD_BLOCKLOG);
> 
> Couldn't we do this much simpler?
> 
> 	if (sb->sb_blocksize == 0)
> 		return XR_BAD_BLOCKSIZE;
> 	if (sb->sb_blocksize != (1 << sb->sb_blocklog))
> 		return XR_BAD_BLOCKLOG;
> 	if (sb->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG ||
> 	    sb->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG)
> 		return XR_BAD_BLOCKLOG;

Makes sense, yes.

> 
> >  	/*
> > +	 * Attempt to find secondary sb with a coarse approach,
> > +	 * first trying agblocks and blocksize read from sb, providing
> > +	 * they're sane.
> >  	 */
> > +	if (verify_sb_blocksize(rsb) == 0) {
> > +		skip = rsb->sb_agblocks * rsb->sb_blocksize;
> > +		if ((skip >= XFS_AG_MIN_BYTES) && (skip <= XFS_AG_MAX_BYTES))
> 
> no need for the inner braces here.

Check.

Thanks for the review!
-Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
