Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:61700 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751960AbdKCITb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Nov 2017 04:19:31 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 0/5] xfs refcount conversions
Date: Fri, 3 Nov 2017 08:19:27 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B802B90AE@IRSMSX102.ger.corp.intel.com>
References: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
 <20171020232111.GT3666@dastard>
 <20171023134149.GD3165@worktop.lehotels.local>
 <20171103002305.GZ5858@dastard>
In-Reply-To: <20171103002305.GZ5858@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>
Cc: "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>



> [I missed this followup, other stuff]
> 
> On Mon, Oct 23, 2017 at 03:41:49PM +0200, Peter Zijlstra wrote:
> > On Sat, Oct 21, 2017 at 10:21:11AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 20, 2017 at 02:07:53PM +0300, Elena Reshetova wrote:
> > > IMO, that makes it way too hard to review sanely for code that:
> > >
> > > 	a) we already know works correctly
> >
> > But how do you know if you have unknown ordering requirements?
> 
> Because back when it was converted to atomic-based object reference
> counts, I went through all the memory-barriers.txt stuff to make
> sure it was OK. That was years ago, and I've forgotten it all and
> the life-cycle constaints that lead us to use atomics in this
> manner.
> 
> Now, I've got to go determine what the difference between atomic and
> refcounts are and work them out myself because nobody has documented
> it. And I have to go look at all the commit logs to work out in that
> has any effect on the objects using the atomics, because that's no
> longer in my head. There probably isn't an issue here, but such
> changes are not done without review, and that's what is needed to
> review the change.
> 
> That's the problem here - I have to work out what the differences in
> ordering constraints between refcounts and atomics are myself
> because it's not actually documented anywhere for reviewiers to
> understand.  That's a significant burden to put on a reviewer for
> what is supposed to be a "no-op" change.

The memory ordering changes are currently documented in refcount.c
file itself, but I agree that we should try to provide more information. 
That's why we are having this separate thread now going and searching
for suitable examples and more elaborate explanation. 

So, hopefully very soon we will end up with having what you are asking for. 

Best Regards,
Elena.


> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
