Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14670 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932201AbdKCAXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 20:23:08 -0400
Date: Fri, 3 Nov 2017 11:23:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfs refcount conversions
Message-ID: <20171103002305.GZ5858@dastard>
References: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
 <20171020232111.GT3666@dastard>
 <20171023134149.GD3165@worktop.lehotels.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023134149.GD3165@worktop.lehotels.local>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, keescook@chromium.org

[I missed this followup, other stuff]

On Mon, Oct 23, 2017 at 03:41:49PM +0200, Peter Zijlstra wrote:
> On Sat, Oct 21, 2017 at 10:21:11AM +1100, Dave Chinner wrote:
> > On Fri, Oct 20, 2017 at 02:07:53PM +0300, Elena Reshetova wrote:
> > IMO, that makes it way too hard to review sanely for code that:
> > 
> > 	a) we already know works correctly
> 
> But how do you know if you have unknown ordering requirements?

Because back when it was converted to atomic-based object reference
counts, I went through all the memory-barriers.txt stuff to make
sure it was OK. That was years ago, and I've forgotten it all and
the life-cycle constaints that lead us to use atomics in this
manner.

Now, I've got to go determine what the difference between atomic and
refcounts are and work them out myself because nobody has documented
it. And I have to go look at all the commit logs to work out in that
has any effect on the objects using the atomics, because that's no
longer in my head. There probably isn't an issue here, but such
changes are not done without review, and that's what is needed to
review the change.

That's the problem here - I have to work out what the differences in
ordering constraints between refcounts and atomics are myself
because it's not actually documented anywhere for reviewiers to
understand.  That's a significant burden to put on a reviewer for
what is supposed to be a "no-op" change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
