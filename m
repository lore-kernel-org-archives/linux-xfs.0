Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86FR8oO088307 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 10:27:09 -0500
Date: Tue, 6 Sep 2011 11:27:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/25] xfs: introduce xfs_bmapi_delay()
Message-ID: <20110906152706.GA14728@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060641.979845427@bombadil.infradead.org>
	<1315002238.2069.88.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315002238.2069.88.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> > +	xfs_extnum_t		lastx;	/* last useful extent number */
> > +	int			eof;	/* we've hit the end of extents */
> > +	int			n = 0;	/* current extent index */
> > +	int			error = 0;
> > +
> > +	ASSERT(*nmap >= 1);
> > +	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
> > +	ASSERT(!(flags & ~XFS_BMAPI_ENTIRE));
> > +
> 
> Rearrange the following test to use the pattern (assigning error)
> used in xfs_bmapi_read().

Hmm - given that error is used as a boolean there I don't actually like
that pattern very much as error is generally used to hold an errno
value.

> 
> > +	if (unlikely(XFS_TEST_ERROR(
> > +	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
> > +	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
> 
> Are you certain that XFS_DINODE_FMT_LOCAL is not possible here?
> I tried to trace it back but I'm still not sure.  The transaction
> pointer passed is null, so it would have tripped an assertion
> in the previous code.  (A simple explanation would reassure me.)

We can't hit it because we do not support the local format for regular
files at all, and we do not support delayed allocations for anything
but regular files.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
