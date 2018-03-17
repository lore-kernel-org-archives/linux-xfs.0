Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:19161 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751623AbeCQDQ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Mar 2018 23:16:29 -0400
Date: Sat, 17 Mar 2018 14:16:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Message-ID: <20180317031626.GO18129@dastard>
References: <20180313224522.GZ7000@dastard>
 <20180314131659.wnmt5zxfhrfsld7n@rh_laptop>
 <20180314133258.GB7000@dastard>
 <20180314135752.5a2vmjr7cuavusiw@rh_laptop>
 <20180314212441.GC7000@dastard>
 <20180315061557.5jajfodpkjdmcrld@rh_laptop>
 <20180315100646.GE7000@dastard>
 <20180315103207.scrm5e4cvkj26m4k@rh_laptop>
 <20180316001955.GN18129@dastard>
 <20180316054516.fehsluoqo2h2zvrw@rh_laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180316054516.fehsluoqo2h2zvrw@rh_laptop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lukas Czerner <lczerner@redhat.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>, linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Fri, Mar 16, 2018 at 06:45:16AM +0100, Lukas Czerner wrote:
> On Fri, Mar 16, 2018 at 11:19:55AM +1100, Dave Chinner wrote:
> > On Thu, Mar 15, 2018 at 11:32:07AM +0100, Lukas Czerner wrote:
> > > 
> > > And where the "cdcd" data is comming from ? Not from the
> > > 
> > > "pwrite -S 1 0 64k"
> > > 
> > > that's producing "0101".
> > 
> > Ah, too much context switching. Makes me look like the village
> > idiot...
> 
> that's how I was looking the past 4 emails ;)
> 
> Anyway good that we finally understand each other. I think it'd be worth
> fixing the generic/042 to check for the actuall stale data not just
> expecting the file to be empty as it still can do some good.

I've got a fixed version of it. It starts by setting the file size
to 128k and then fsyncing ths file, so after the shutdown we should
always see a file full of zeros. Of course, the extent layout can be
anything, as long as the data returned after remount is all zeros.

> > Ok, I just spent some time looking at this in detail (event traces,
> > etc) and it is indeed as the test describes - an whole delalloc
> > extent allocation on partial overwrite. THe partial overwrite is
> > triggered by the fpunch/fzero code, and it appears the delalloc
> > converison is not paying attention to the start offset of the
> > writeback:
> > 
> > xfs_writepage:        dev 7:0 ino 0x7603 pgoff 0xf000 size 0x10000 delalloc 1
> > .....
> > xfs_alloc_near_greater: dev 7:0 agno 0 agbno 3784 minlen 16 maxlen 16
> > .....
> > xfs_write_extent:     dev 7:0 ino 0x7603 offset 0 block 3784 count 16 flag 0
> > 
> > IOWs, as I've said from the start (based on the test description)
> > this has nothing to do with the corruption issue CrashMonkey is
> > creating.
> 
> Yeah they're probably not seeing this because of added fsync.

Yes - the fsync ensures data vs metadata ordering by writing and
waiting for data before flushing the log. In this case, there is
not data flush and so when the log is flushed in the shutdown,
the metadata hits the disk before the data, and that's where the
stale data exposure comes from.

THis is a well known issue - if allocation transactions are
committed before the data writes have been submitted, then a crash
can expose stale data - but it's very rarely seen with delalloc.
Historically it's always been seen with direct IO - that's why we
use unwritten extent allocation for direct IO at all times.

However, in XFS we can't do that with delayed allocation because
of the fact the information used by writeback is held on the
bufferhead and is not coherent with extent state. Hence we can't
change a delalloc extent to unwritten deep in the allocator, because
then the page writeback does the wrong thing as it expects to see a
delalloc extent not an unwritten extent. Fixing this problem is one
of the reasons we want to get rid of bufferheads from XFS.

I've got patches that have gone one round of review that remove
bufferhead state from the XFS writepage engine, but that will need
to fixed up and finished off before this problem can be fixed. IIRC,
when I wrote this test I'd just uncovered the problem, realised it
can't be fixed without bufferhead removal, and so the test was added
to remind us what needed fixing....

I actually have fixes that make XFS pass this test, but there's a
fair chunk of work still to be done before they are ready for
review. I'm thinking of closing this whole entirely by always using
unwritten extent allocate for delalloc writes inside EOF, which will
mean we could probably go back to using delalloc with extent size
hints, too (yay!)...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
