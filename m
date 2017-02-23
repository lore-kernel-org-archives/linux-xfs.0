Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145804.g3errmtqheghz6lx@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mga09.intel.com ([134.134.136.24]:5755 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdBWHuq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Feb 2017 02:50:46 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 1/7] fs, xfs: convert xfs_bui_log_item.bui_refcount from
 atomic_t to refcount_t
Date: Thu, 23 Feb 2017 07:50:15 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C4F30B@IRSMSX102.ger.corp.intel.com>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-2-git-send-email-elena.reshetova@intel.com>
 <20170221225534.GB23007@dastard>
 <2236FBA76BA1254E88B949DDB74E612B41C4EB40@IRSMSX102.ger.corp.intel.com>
 <20170222220741.GC23007@dastard>
In-Reply-To: <20170222220741.GC23007@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

> On Wed, Feb 22, 2017 at 11:20:31AM +0000, Reshetova, Elena wrote:
> > > On Tue, Feb 21, 2017 at 05:49:01PM +0200, Elena Reshetova wrote:
> > > > refcount_t type and corresponding API should be
> > > > used instead of atomic_t when the variable is used as
> > > > a reference counter. This allows to avoid accidental
> > > > refcounter overflows that might lead to use-after-free
> > > > situations.
> > >
> > > I'm missing something: how do you overflow a log item object
> > > reference count?
> >
> > We are currently converting all reference counters present in kernel to a
> safer refcount_t type.
> 
> Yes, I see that you are taking anything that you *think* is an
> object lifetime reference counter and changing it.
> 
> > Agreed, in some cases it might be easier or harder to actually create/trigger
> an overflow, but since it can be caused even by a bug in the legitimate code
> (current version or its future iterative), it is good idea to do "safe defaults" and
> stop worrying about the problem.
> >
> > Do you have any reasons why it should not be converted?
> 
> It's core dirty metadata object code.  Any change to code in this
> area needs to be gone over with a fine tooth comb, because bugs can
> result in filesystem and/or journal corruption issues that may not
> be noticed until a system crashes and log recovery fails and the
> user loses their entire filesystem....
> 
> Hence the repeated comments about needing to actually test the code
> you are changing.

Sure, we are now in the process of testing this run-time as was suggested using xfstests. 
I will only repost this series after we done with testing and fix issues.
 
Best Regards,
Elena.


> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
