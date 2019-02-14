Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfBNP5k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 10:57:40 -0500
Date: Thu, 14 Feb 2019 07:57:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: small fixes and optimizations for delalloc and reflink
Message-ID: <20190214155734.GG32253@magnolia>
References: <20190211125427.16577-1-hch@lst.de>
 <20190212000337.GA23989@magnolia>
 <20190213180253.GA19484@lst.de>
 <20190214081120.GA11119@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214081120.GA11119@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Thu, Feb 14, 2019 at 09:11:20AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 13, 2019 at 07:02:53PM +0100, Christoph Hellwig wrote:
> > On Mon, Feb 11, 2019 at 04:03:37PM -0800, Darrick J. Wong wrote:
> > > I pulled this series in and saw a bunch of new regressions in
> > > generic/127 generic/269 generic/476 generic/521 generic/522 xfs/442 with
> > > quota, rmap, and reflink enabled.  The regressions were all the
> > > XFS_WANT_CORRUPTED_GOTO near the top of xfs_rmap_unmap_shared.
> > 
> > Quick status update:  I managed to reproduce this ones on xfs/442 only
> > yesterday.  But as soon as I started bisecting it it disappeared again..
> 
> And another full overnight run couldn't report this even once.
> 
> How reproducible is the issue for you?   Are you sure it never happens
> with the baseline, given that this series really doesn't touch anything
> interacting with the rmap?

Nearly every time, so I'll go digging and report back what I find.

(It's odd, because I didn't see anything obvious in the patches that
would cause this...)

--D
