Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbeLQR7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 12:59:34 -0500
Date: Mon, 17 Dec 2018 09:59:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181217175922.GI24487@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181206010550.GN24487@magnolia>
 <20181206200930.GA31797@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206200930.GA31797@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 06, 2018 at 09:09:30PM +0100, Christoph Hellwig wrote:
> I see the 050 one, and it looks odd.
> 
> > --- /tmp/xfstests/tests/generic/075.out	2017-02-28 09:23:56.049065953 -0800
> > +++ /var/tmp/xfstests//generic/075.out.bad	2018-12-03 22:11:12.392566688 -0800
> 
> This and a few other fsx tests assume you can always fallocate
> on XFS.  I sent a series for this:
> 
> https://www.spinics.net/lists/linux-xfs/msg23433.html
> 
> But I need to rework some of the patches a little more based on the
> review feedback.

"the patches"... as in the fstests patches, or the always_cow series?

> Similarly the badly fragmented warnings are simply expected, that
> is the nature of an always out of place write fs.  But the quota
> run turned up a few more failures than I expected for the always_cow
> mode, I can look into them.  But so far 95% of the always_cow bugs
> were either issues with the text, or genuine XFS COW path bugs not
> otherwise uncovered..

<nod> generic/311 and generic/476 regularly trigger assertion warnings
about negative quota counts, which I have yet to diagnose.  FWIW
fstests' post-run quota checking never complains about problems, which
means we're probably just moving quota accounting in the wrong order or
something.

--D
