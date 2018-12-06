Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59272 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbeLFUJc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 15:09:32 -0500
Date: Thu, 6 Dec 2018 21:09:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181206200930.GA31797@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181206010550.GN24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206010550.GN24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

I see the 050 one, and it looks odd.

> --- /tmp/xfstests/tests/generic/075.out	2017-02-28 09:23:56.049065953 -0800
> +++ /var/tmp/xfstests//generic/075.out.bad	2018-12-03 22:11:12.392566688 -0800

This and a few other fsx tests assume you can always fallocate
on XFS.  I sent a series for this:

https://www.spinics.net/lists/linux-xfs/msg23433.html

But I need to rework some of the patches a little more based on the
review feedback.

Similarly the badly fragmented warnings are simply expected, that
is the nature of an always out of place write fs.  But the quota
run turned up a few more failures than I expected for the always_cow
mode, I can look into them.  But so far 95% of the always_cow bugs
were either issues with the text, or genuine XFS COW path bugs not
otherwise uncovered..
