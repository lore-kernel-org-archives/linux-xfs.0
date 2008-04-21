Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 14:12:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3LLCTVe026381
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 14:12:33 -0700
Date: Tue, 22 Apr 2008 07:13:01 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080421211300.GO108924158@sgi.com>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com> <20080421085947.GA10399@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421085947.GA10399@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Mon, Apr 21, 2008 at 04:59:47AM -0400, Christoph Hellwig wrote:
> > +STATIC struct dentry *
> > +xfs_ci_dentry_update(
> > +	struct dentry	*dent,
> > +	struct inode	*dent_inode,
> > +	struct xfs_name	*name)
> > +{
> > +	int		err;
> > +	struct dentry	*real_dent;
> > +	struct dentry	*new_dent;
> > +	struct qstr	nls_name;
> 
> This helper should go into fs/dcache.c with a slightly move descritive
> name (d_add_ci?).
> 
> Also the naming is rather odd, please replace every occurance of
> dent with dentry, and the variable dent_inode should be just inode.
> 
> Also when moving this to dcache.c please provide a nice big kerneldoc
> comment describing it like Anton did for the ntfs lookup instance.

Perhaps this can be done (moving to dcache.c) as a followup patch
series that also removes the duplicate code from ntfs and other
places. Similarly for all the NLS stuff...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
