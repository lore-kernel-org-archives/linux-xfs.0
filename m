Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Feb 2007 15:46:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l14NkI3c024088
	for <xfs@oss.sgi.com>; Sun, 4 Feb 2007 15:46:20 -0800
Date: Mon, 5 Feb 2007 10:45:15 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: freezing sometimes leaves the log dirty
Message-ID: <20070204234515.GI44411608@melbourne.sgi.com>
References: <20070130220326.GM33919298@melbourne.sgi.com> <20070202114623.GA23187@infradead.org> <1170626215.18017.394.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170626215.18017.394.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Feb 05, 2007 at 08:56:55AM +1100, Nathan Scott wrote:
> On Fri, 2007-02-02 at 11:46 +0000, Christoph Hellwig wrote:
> > On Wed, Jan 31, 2007 at 09:03:26AM +1100, David Chinner wrote:
> > > +	/* flush inodes and push all remaining buffers out to disk */
> > > +	xfs_quiesce_fs(mp);
> > > +
> > > +	BUG_ON(atomic_read(&mp->m_active_trans) > 0);
> > > +
> > 
> > xfs_vfsops.c is considered common code, so you should probably use
> > ASSERT here, not BUG_ON.
> 
> There's also an ASSERT_ALWAYS macro IIRC, if you want the equivalent
> functionality of BUG_ON (i.e. always check).

True, I forgot about that one. Thx, Nathan....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
