Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 15:04:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VM3qoa024957
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:03:52 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2900A56904D
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:03:52 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 5oBk7ay0fmKnftoU for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:03:52 -0700 (PDT)
Date: Sat, 1 Nov 2008 09:03:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031220349.GC19509@disturbed>
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org> <20081031001249.GM4985@disturbed> <20081031004814.GN4985@disturbed> <20081031203716.GB11514@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031203716.GB11514@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 04:37:16PM -0400, Christoph Hellwig wrote:
> On Fri, Oct 31, 2008 at 11:48:14AM +1100, Dave Chinner wrote:
> > @@ -1118,8 +1118,7 @@ xfs_fs_write_super(
> >  	struct super_block	*sb)
> >  {
> >  	if (!(sb->s_flags & MS_RDONLY))
> > +		xfs_sync_fsdata(XFS_M(sb), SYNC_WAIT);
> 
> Not commenting on the rest yet, but I'm sure you noticed that before
> your patch we ever called xfs_sync_fsdata with SYNC_WAIT at all.  I
> think with the current codebase there is nothing to guarantee we ever
> write the superblock out to disk as xfs_wait_buftarg specificly
> excludes the superblock (XBF_FS_MANAGED)

Almost. unmount calls xfs_unmountfs_writesb() which does a
synchronous write of the superblock. But in the current code sync(1)
certainly never, ever triggers a superblock write we wait for...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
