Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17443 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbcITEkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2016 00:40:18 -0400
Date: Mon, 19 Sep 2016 21:39:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS reflink and development tip git trees updated
Message-ID: <20160920043942.GE10172@birch.djwong.org>
References: <20160905053317.GA15302@birch.djwong.org>
 <20160919161100.GA19849@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160919161100.GA19849@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 19, 2016 at 09:11:00AM -0700, Christoph Hellwig wrote:
> Can you rebase (and repost the series) on top of the preparations
> in for-next that Dave just pushed out?
> 
> That should make reviewing a whole lot easier.

I'm on vacation all week (in the desert with tcp-over-cactus) but I
don't want the reflink review to stall, so here's a branch atop the
for-next branch that Dave announced last night:

https://github.com/djwong/linux/tree/for-dave-for-4.9-3

The scary parts are the rework that I had to do to integrate with hch's
delalloc rewrite.  I think all the changes to xfs_file_iomap_begin_delay
are right (the regression tests all pass, at least) but it could use
another set of eyes.

No changes to the userland tools, they're still at:

https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-2

--D
