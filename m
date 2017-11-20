Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49265 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdKTVvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 16:51:01 -0500
Date: Mon, 20 Nov 2017 13:51:00 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171120215100.GB8933@bombadil.infradead.org>
References: <20171117193925.GM5119@magnolia>
 <20171120161829.GA25991@bombadil.infradead.org>
 <20171120202606.GN5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171120202606.GN5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Tue, Nov 21, 2017 at 07:26:06AM +1100, Dave Chinner wrote:
> On Mon, Nov 20, 2017 at 08:18:29AM -0800, Matthew Wilcox wrote:
> > On Fri, Nov 17, 2017 at 11:39:25AM -0800, Darrick J. Wong wrote:
> > > If two programs simultaneously try to write to the same part of a file
> > > via direct IO and buffered IO, there's a chance that the post-diowrite
> > > pagecache invalidation will fail on the dirty page.  When this happens,
> > > the dio write succeeded, which means that the page cache is no longer
> > > coherent with the disk!
> > 
> > This seems like a good opportunity to talk about what I've been working
> > on for solving this problem.  The XArray is going to introduce a set
> > of entries which can be stored to locations in the page cache that I'm
> > calling 'wait entries'.
> 
> What's this XArray thing you speak of?

Ah, right, you were on sabbatical at LSFMM this year where I talked
about it.  Briefly, it's a new API for the radix tree.  The data structure
is essentially unchanged (minor enhancements), but I'm rationalising
existing functionality and adding new abilities.  And getting rid of
misfeatures like the preload API and implicit GFP flags.

My current working tree is here:

http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/xarray-2017-11-20

Ignoring the prep patches, the excitement is all to be found with the
commits which start 'xarray:'

If you want an example of it in use, I'm pretty happy with this patch
that switches the brd driver entirely from the radix tree API to the
xarray API:

http://git.infradead.org/users/willy/linux-dax.git/commitdiff/dbf96ae943e43563cbbaa26e21b656b6fe8f4b0f

I've been pretty liberal with the kernel-doc, but I haven't written out
a good .rst file to give an overview of how to use it.
