Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:31864
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750977AbeEUWuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 18:50:24 -0400
Date: Tue, 22 May 2018 08:50:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: test inode allocation state missmatch corruption
Message-ID: <20180521225021.GS23861@dastard>
References: <20180521015857.7339-1-zlang@redhat.com>
 <20180521090411.GM29080@desktop.hz.ali.com>
 <20180521155530.GH4910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521155530.GH4910@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, May 21, 2018 at 08:55:30AM -0700, Darrick J. Wong wrote:
> On Mon, May 21, 2018 at 05:04:11PM +0800, Eryu Guan wrote:
> > On Mon, May 21, 2018 at 09:58:57AM +0800, Zorro Lang wrote:
> > > +$XFS_IO_PROG -fc 'pwrite 0 $blksz' -c fsync $SCRATCH_MNT/dir/newfile 2>&1 | \
> > > +	grep -i "Structure needs cleaning" | _filter_scratch
> > > +
> > > +# filter a intentional internal errors
> > > +_check_dmesg _filter_dmesg
> > > +
> > > +# success, all done
> > > +status=0
> 
> Does this test leave the scratch fs mounted but shut down if the kernel
> hasn't been patched?  The _require_scratch_nocheck means that the broken
> fs doesn't get scraped off the system and subsequent tests can go all
> wacky when operations on $SCRATCH_MNT error out...

There's another discussion going on about fix this because xfs/132
triggers the same issue (it's a problem with _check_filesystem() not
cycling the mount after the test when _require_scratch_nocheck() is
used).

I didn't see it here in testing because there was no test run after
the new test I proposed. Same here - its xfs/999, and no test is run
after it so this sort of thing isn't noticed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
