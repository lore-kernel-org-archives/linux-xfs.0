Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 15:19:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VMJj1H026418
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:19:45 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A693D13146A2
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:19:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Fu13QlsffIbGf1FH for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:19:46 -0700 (PDT)
Date: Fri, 31 Oct 2008 18:19:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031221946.GA29761@infradead.org>
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org> <20081031001249.GM4985@disturbed> <20081031004814.GN4985@disturbed> <20081031203716.GB11514@infradead.org> <20081031220349.GC19509@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031220349.GC19509@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Nov 01, 2008 at 09:03:49AM +1100, Dave Chinner wrote:
> > >  	if (!(sb->s_flags & MS_RDONLY))
> > > +		xfs_sync_fsdata(XFS_M(sb), SYNC_WAIT);
> > 
> > Not commenting on the rest yet, but I'm sure you noticed that before
> > your patch we ever called xfs_sync_fsdata with SYNC_WAIT at all.  I
> > think with the current codebase there is nothing to guarantee we ever
> > write the superblock out to disk as xfs_wait_buftarg specificly
> > excludes the superblock (XBF_FS_MANAGED)
> 
> Almost. unmount calls xfs_unmountfs_writesb() which does a
> synchronous write of the superblock. But in the current code sync(1)
> certainly never, ever triggers a superblock write we wait for...

True, missed it due to the opencoding.  With my patch to kill the
shared readonly bits we should be able to make it use xfs_sync_fsdata
for consistency.
