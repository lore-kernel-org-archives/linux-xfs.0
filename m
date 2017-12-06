Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:34940 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751500AbdLFU6O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 15:58:14 -0500
Date: Wed, 6 Dec 2017 13:58:12 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH v2 1/3] xfs_io: fix compiler warnings in
 getfsmap code
Message-ID: <20171206205812.GA32648@linux.intel.com>
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-2-ross.zwisler@linux.intel.com>
 <20171206002743.GC5858@dastard>
 <20171206201014.GA27401@linux.intel.com>
 <20171206204749.GM19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171206204749.GM19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>

On Wed, Dec 06, 2017 at 12:47:49PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 06, 2017 at 01:10:14PM -0700, Ross Zwisler wrote:
> > On Wed, Dec 06, 2017 at 11:27:43AM +1100, Dave Chinner wrote:
> > > On Tue, Dec 05, 2017 at 04:56:49PM -0700, Ross Zwisler wrote:
> > > > I recently upgraded my compiler from
> > > > 	gcc (GCC) 6.4.1 20170727 (Red Hat 6.4.1-1)
> > > > to
> > > > 	gcc (GCC) 7.2.1 20170915 (Red Hat 7.2.1-2)
> > > > and started getting a bunch of compiler warnings in io/fsmap.c:
> > > > 
> > > >   fsmap.c: In function ‘fsmap_f’:
> > > >   fsmap.c:228:40: warning: ‘%lld’ directive output may be truncated writing
> > > >   between 1 and 17 bytes into a region of size between 12 and 28
> > > >   [-Wformat-truncation=]
> > > >      snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
> > > >   ^~~~
> > > >   fsmap.c:228:32: note: directive argument in the range [0, 36028797018963967]
> > > >      snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
> > > >   ^~~~~~~~~~~~~~~
> > > >   fsmap.c:228:3: note: ‘snprintf’ output between 8 and 40 bytes into a
> > > >   destination of size 32
> > > >      snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
> > > >      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >   (long long)BTOBBT(p->fmr_physical),
> > > >   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >   (long long)BTOBBT(p->fmr_physical + p->fmr_length - 1));
> > > >   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > 
> > > > The issue is that 'bbuf' is only defined to be 32 characters wide, but each
> > > > signed long long can potentially print as many as 19 characters
> > > > (9223372036854775807 is the max value).  The format we're using for bbuf is
> > > > "[%lld..%lld]:" which has 2 signed long longs plus 6 other characters
> > > > "[..]:\0", which means it's possible we'll print up to 44 characters,
> > > > overflowing our 32 char buffer.
> > > > 
> > > > Fix this by bumping all the buffer sizes in dump_map_verbose() to 64
> > > > characters.
> > > > 
> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > > Cc: Darrick J. Wong <darrick.wong@oracle.com>
> > > > Fixes: 3fcab549a234 ("xfs_io: support the new getfsmap ioctl")
> > > 
> > > FYI, I posted a fix for this weeks ago. I think Eric has already
> > > picked it up, but it hasn't been pushed out into the for-next branch
> > > yet.
> > 
> > I'm seeing similar new compiler warnings when compiling xfstests:
> > 
> > write_log.c: In function ‘wlog_open’:
> > write_log.c:124:37: warning: ‘%s’ directive writing up to 1023 bytes into a region of size 224 [-Wformat-overflow=]
> >     "Could not open write_log - open(%s, %#o, %#o) failed:  %s\n",
> >                                      ^~
> > write_log.c:124:4: note: directive argument in the range [1089, 2047]
> >     "Could not open write_log - open(%s, %#o, %#o) failed:  %s\n",
> >     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > etc.
> > 
> > I don't see any patches posted that fix these, as of yet.  As far as you know,
> > am I correct in thinking that these still need to be fixed?
> 
> It sure looks that way.

Cool, thanks.  I'll take a crack at them.
