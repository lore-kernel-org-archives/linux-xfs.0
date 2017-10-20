Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47048 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751770AbdJTGzi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 02:55:38 -0400
Date: Fri, 20 Oct 2017 08:55:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-4.14] xfs: fix AIM7 regression
Message-ID: <20171020065536.GA11101@lst.de>
References: <20171019074705.24827-1-hch@lst.de> <20171019113848.GA8911@bfoster.bfoster> <20171019131407.GA20645@lst.de> <20171019224431.GO4755@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019224431.GO4755@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, Ye Xiaolong <xiaolong.ye@intel.com>, linux-xfs@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org

On Thu, Oct 19, 2017 at 03:44:31PM -0700, Darrick J. Wong wrote:
> > > The code looks fine, but this seems really strange. If the trylock
> > > fails, then wouldn't the blocking lock have slept anyways if done
> > > initially? Is there any more background info available on this, or
> > > perhaps a theory on why there is such a significant regression..?
> > 
> > No, unfortunately I don't have a theory, but I agree it is odd
> > behavior in the rwsem code.
> 
> <shrug> I want to know a little more about why there's a performance hit
> in the down_read_trylock -> down_read case.  Are we getting penalized
> for that?  Is it some weird interaction with lockdep?

I don't think the test bot did run with lockdep.  But feel free to take
a look at the mail thread titled

[lkp-robot] [fs]  91f9943e1c:  aim7.jobs-per-min -26.6% regression

on lkml.  Note that synthetic benchmarks on XFS always saw weird
effects from rwsem details.  I remember that a few years ago I had
to back to the mainline patch to move the rwsem fastpath out of line
because thay caused a major performance regressions on CIFS file
serving benchmarks on a very low end ARM NAS box.
