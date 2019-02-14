Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48673 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfBNILW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Feb 2019 03:11:22 -0500
Date: Thu, 14 Feb 2019 09:11:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: small fixes and optimizations for delalloc and reflink
Message-ID: <20190214081120.GA11119@lst.de>
References: <20190211125427.16577-1-hch@lst.de> <20190212000337.GA23989@magnolia> <20190213180253.GA19484@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213180253.GA19484@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Wed, Feb 13, 2019 at 07:02:53PM +0100, Christoph Hellwig wrote:
> On Mon, Feb 11, 2019 at 04:03:37PM -0800, Darrick J. Wong wrote:
> > I pulled this series in and saw a bunch of new regressions in
> > generic/127 generic/269 generic/476 generic/521 generic/522 xfs/442 with
> > quota, rmap, and reflink enabled.  The regressions were all the
> > XFS_WANT_CORRUPTED_GOTO near the top of xfs_rmap_unmap_shared.
> 
> Quick status update:  I managed to reproduce this ones on xfs/442 only
> yesterday.  But as soon as I started bisecting it it disappeared again..

And another full overnight run couldn't report this even once.

How reproducible is the issue for you?   Are you sure it never happens
with the baseline, given that this series really doesn't touch anything
interacting with the rmap?
