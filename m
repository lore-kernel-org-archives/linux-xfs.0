Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6025 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750764AbdKAAxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 20:53:54 -0400
Date: Wed, 1 Nov 2017 11:53:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: move error injection tags into their own file
Message-ID: <20171101005351.GL5858@dastard>
References: <20171031193128.GG4911@magnolia>
 <20171031232233.GI5858@dastard>
 <20171101001623.GE4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101001623.GE4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Tue, Oct 31, 2017 at 05:16:23PM -0700, Darrick J. Wong wrote:
> On Wed, Nov 01, 2017 at 10:22:33AM +1100, Dave Chinner wrote:
> > On Tue, Oct 31, 2017 at 12:31:28PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Move the error injection tag names into a libxfs header so that we can
> > > share it between kernel and userspace.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Simple enough, but there's an admin problem with this patch.
> > 
> > > new file mode 100644
> > > index 0000000..0cc1c05
> > > --- /dev/null
> > > +++ b/fs/xfs/libxfs/xfs_errortag.h
> > > @@ -0,0 +1,106 @@
> > > +/*
> > > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> > > + *
> > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > This isn't actually true. You're moving a bunch of code from
> > fs/xfs/xfs_error.h that is under:
> > 
> >  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
> >  * All Rights Reserved.
> > 
> > Moving code into a new file does not reassign the copyright on the
> > code to a new owner. Hence I think this is the appropriate way to
> > record the copyrights on this new file:
> > 
> >  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
> >  * Copyright (C) 2017 Oracle.
> >  * All Rights Reserved.
> > 
> > And there's no real need for author tags as we've got that
> > information in the git repo....
> 
> Works for me.  I wasn't really sure whose copyright really applied to
> changes like this -- the one in the source file?  The person who creates
> the new file?  Every last person who ever touched it?  etc.

It's not clear cut, and IANAL. My basic "try not to get into
trouble" rule is that when copying a significant chunk of code from
a file with a copyright notice is to preserve that notice with the
new copy of the code...

> They don't teach this stuff in maintainer school. :/

Nope, that they don't.

I'm careful about this stuff mainly because of the fact that the
Linux XFS code has a different history to almost all the other Linux
code. And that other code with a similar lineage (i.e. has a
SGI/Irix heritage) came under the spotlight in the SCO vs IBM
copyright war....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
