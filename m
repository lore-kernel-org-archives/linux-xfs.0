Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 00:35:46 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L7ZeBd026574
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 00:35:40 -0700
Date: Wed, 21 May 2008 03:36:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 981521 - Return actual name for CI match for dentry cache
Message-ID: <20080521073625.GA26580@infradead.org>
References: <20080521034449.67F4758C4C29@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521034449.67F4758C4C29@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, May 21, 2008 at 01:44:49PM +1000, Barry Naujok wrote:
> Return case-insensitive match for dentry cache
> 
> This implements the code to store the actual filename found
> during a lookup in the dentry cache and to avoid multiple entries
> in the dcache pointing to the same inode.
> 
> To avoid polluting the dcache, we implement a new directory inode
> operations for lookup. xfs_vn_ci_lookup() stores the correct case
> name in the dcache.
> 
> The "actual name" is only allocated and returned for a case-
> insensitive match and not an actual match.
> 
> Another unusual interaction with the dcache is not storing
> negative dentries like other filesystems doing a d_add(dentry, NULL)
> when an ENOENT is returned. During the VFS lookup, if a dentry
> returned has no inode, dput is called and ENOENT is returned.
> By not doing a d_add, this actually removes it completely from
> the dcache to be reused. create/rename have to be modified to
> support unhashed dentries being passed in.

This requires the d_add_ci helper which doesn't exist in the CVS on oss.
