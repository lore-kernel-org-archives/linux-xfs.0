Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 20:26:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T3Q78I031983
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:26:07 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C7E21B1B485
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:26:05 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id guocWQAScag37G39 for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:26:05 -0700 (PDT)
Date: Wed, 29 Oct 2008 14:26:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029032601.GF4985@disturbed>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029031645.GE4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 02:16:45PM +1100, Dave Chinner wrote:
> On Wed, Oct 29, 2008 at 01:16:53AM +0100, Nick Piggin wrote:
> > XFS: fix fsync errors not being propogated back to userspace.
> > ---
> > Index: linux-2.6/fs/xfs/xfs_vnodeops.c
> > ===================================================================
> > --- linux-2.6.orig/fs/xfs/xfs_vnodeops.c
> > +++ linux-2.6/fs/xfs/xfs_vnodeops.c
> > @@ -715,7 +715,7 @@ xfs_fsync(
> >  	/* capture size updates in I/O completion before writing the inode. */
> >  	error = filemap_fdatawait(VFS_I(ip)->i_mapping);
> >  	if (error)
> > -		return XFS_ERROR(error);
> > +		return XFS_ERROR(-error);
> 
> <groan>
> 
> Yeah, that'd do it. Good catch. I can't believe I recently fixed a
> bug that touched these lines of code without noticing the inversion.
> Sometimes I wonder if we should just conver the entire of XFS to
> return negative errors - mistakes in handling negative error numbers
> in the core XFS code happen all the time.

Ok, I was right - these problems happen all the time. The above call
should really call xfs_flush_pages() to do the flush and wait. I
note that xfs_flush_pages() returns negative errors, and all the
callers expect positive errors. I bet the same occurs for
xfs_flushinval_pages() and xfs_tosspages() which are the wrappers
that core XFS code is supposed to be using for flushing and
invalidating file ranges....

I'll write up a patch that covers all of these.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
