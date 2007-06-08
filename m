Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 23:24:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l586OfWt023758
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 23:24:43 -0700
Date: Fri, 8 Jun 2007 16:24:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] get rid of file_count abuse
Message-ID: <20070608062430.GY86004887@sgi.com>
References: <20070604143352.GA8721@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604143352.GA8721@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Jun 04, 2007 at 04:33:52PM +0200, Christoph Hellwig wrote:
> A check for file_count is always a bad idea.  Linux has the ->release
> method to deal with cleanups on last close and ->flush is only for the
> very rare case where we want to perform an operation on every drop of
> a reference to a file struct.

*nod*

> This patch gets rid of vop_close and surrounding code in favour of
> simply doing the page flushing from ->release.

Added to my qa tree, and mangled to move the filestreams stuff from
xfs_close to xfs_release as well.

Thanks, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
