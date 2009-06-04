Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54Axm1b237745 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 05:59:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE1E32CFE5C
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 04:00:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hRefzU367HQoPRQ0 for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2009 04:00:06 -0700 (PDT)
Date: Thu, 4 Jun 2009 07:00:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] xfs: introduce a per-ag inode iterator
Message-ID: <20090604110006.GA22115@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.869514000@bombadil.infradead.org>
	<4A26F2A9.8050300@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A26F2A9.8050300@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 03, 2009 at 05:01:13PM -0500, Eric Sandeen wrote:
> Ok so here we are looking for EFSCORRUPTED from the "execute" function.
>  This might be xfs_sync_inode_data, xfs_sync_inode_attr, or
> xfs_reclaim_inode_now.  But ...

> 
> xfs_sync_inode_valid can return 0, ENOENT, or EFSCORRUPTED.
> 
> Aren't we losing the error here...

We can get the EFSCORRUPTED from xfs_iflush.

> >  
> > +	error = xfs_sync_inode_valid(ip, pag);
> > +	if (error)
> > +		return 0;
> 
> and here?
> 
> so xfs_sync_inode_data / xfs_sync_inode_attr are the "execute" in
> xfs_inode_ag_walk():

If you look at the old code we return early with 0 for the
XFS_FORCED_SHUTDOWN case, which is the only reason xfs_sync_inode_valid 
return xfs_sync_inode_valid in the new code.  We don't actually break
out of the loop in the new code, but don't do any action so the
behaviour is as similar as it gets.  An EFSCORRUPTED later in the
execute function (which AFAICS can only come from xfs_iflush) will
end up pssed down to xfs_inode_ag_iterator.

I can't say that I like this too much.  And in the end only
xfs_fs_quota_sync actually every propagates the return value from
xfs_sync_inodes, and then just directly to userspace.

So I think we are safe just propagating the EFSCORRUPTED down and
make all this a lot more logical.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
