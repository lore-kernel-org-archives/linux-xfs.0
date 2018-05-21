Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:6464 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753756AbeEUWLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 18:11:01 -0400
Date: Tue, 22 May 2018 08:10:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180521221057.GP23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
 <20180518034600.GW23858@magnolia>
 <20180520001648.GN23861@dastard>
 <20180521153354.GH23858@magnolia>
 <20180521170530.GH24680@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521170530.GH24680@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Mon, May 21, 2018 at 10:05:30AM -0700, Luis R. Rodriguez wrote:
> On Mon, May 21, 2018 at 08:33:54AM -0700, Darrick J. Wong wrote:
> > On Sun, May 20, 2018 at 10:16:48AM +1000, Dave Chinner wrote:
> > > On Thu, May 17, 2018 at 08:46:00PM -0700, Darrick J. Wong wrote:
> > > > <shrug> Bikeshedding more, what if either option accepted either an
> > > > absolute path, or a file in $sysconfdir/etc/mkfs.xfs.d/ ? 
> > > 
> > > I kinda assumed that config files could be located anywhere, but we
> > > only searched the sysconfig path if it didn't point at a local
> > > file...
> > 
> > <shrug> openat() semantics are fine enough with me, I think.
> 
> Well this is a big difference, and I think being clear on this would
> be good. If the user specified:
> 
> 	-c foo
> 	
> and the file 'foo' is present but also exists on
> $sysconfdir/etc/mkfs.xfs.d/foo do we use the local file if the user
> did not pass ./foo ?

I would have expected "foo" to be considered the same as "./foo".
It's a relative path.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
