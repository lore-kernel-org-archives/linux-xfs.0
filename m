Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46730 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbfGUVnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jul 2019 17:43:25 -0400
Date: Mon, 22 Jul 2019 07:42:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't trip over uninitialized buffer on extent read
 of corrupted inode
Message-ID: <20190721214213.GO7689@dread.disaster.area>
References: <20190718230617.7439-1-mcgrof>
 <20190719193032.11096-1-mcgrof@kernel.org>
 <20190719230729.GS19023@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719230729.GS19023@42.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Fri, Jul 19, 2019 at 11:07:29PM +0000, Luis Chamberlain wrote:
> On Fri, Jul 19, 2019 at 07:30:32PM +0000, Luis Chamberlain wrote:
> > [mcgrof: fixes kz#204223 ]
> 
> This patch can be ingored for now for stable. It does not actually
> fix the issue, just delays it a bit. Once I stress test over 1000
> runs with some other fixes I have I'll send a new set of stable
> fixes.

generic/388 is one of the tests we expect to uncover interesting
failures over time.  i.e. every time we fix a problem in these
tests, it will expose another issue that we haven't been able to
exercise until easier-to-hit failures have been fixed.

The best you can do right now is minimise the occurence of failures
by backporting fixes - this test (like generic/475) will continue to
uncover new shutdown and recovery issues as they are exposed by
new fixes. Expecting it to pass 1000 times without failure on an
older stable kernel is, IMO, a somewhat unrealistic expectation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
