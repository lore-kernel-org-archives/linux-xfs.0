Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 17:37:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P0bmg7000405
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:37:48 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7751447C354
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:39:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 79zLsRGiWJQmyhaH for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:39:22 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1Kiet8-000704-Ie
	for xfs@oss.sgi.com; Thu, 25 Sep 2008 00:39:22 +0000
Date: Wed, 24 Sep 2008 20:39:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 3/3] Future Directions - Reliability
Message-ID: <20080925003922.GA11841@infradead.org>
References: <20080923075910.GA5448@disturbed> <20080923080504.GD5448@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923080504.GD5448@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, Sep 23, 2008 at 06:05:04PM +1000, Dave Chinner wrote:
> Another failures that we often have reported is that XFS has 'hung' and
> traige indicates that the filesystem appears to be waiting for a metadata
> I/O completion to occur. We have seen in the past I/O errors not being
> propagated from the lower layers back into the filesystem causing these
> sort of problems. We have also seen cases where there have been silent
> I/O errors and the first thing to go wrong is 'XFS has hung'.
> 
> To catch situations like this, we need to track all I/O we have in flight and
> have some method of timing them out.  That is, if we haven't completed the I/O
> in N seconds, issue a warning and enter an exception handling process that
> attempts to deal with the problem.
> 
> My initial thoughts on this is that it could be implemented via the MRU cache
> without much extra code being needed.  The complexity with this is that we
> can't catch data read I/O because we use the generic I/O path for read. We do
> our own data write and metadata read/write, so we can easily add hooks to track
> all these types of I/O. Hence we will initially target just metadata I/O as
> this would only need to hook into the xfs_buf I/O submission layer.

I don't think this is something we want to do in XFS itself, as this
would fit much better in the bio layer (and propagation through the
pagecache).  That way we have it in one places instead of growing this
in various filesystems later on.
