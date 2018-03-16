Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750748AbeCPFpi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Mar 2018 01:45:38 -0400
Date: Fri, 16 Mar 2018 06:45:16 +0100
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Message-ID: <20180316054516.fehsluoqo2h2zvrw@rh_laptop>
References: <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
 <20180313224522.GZ7000@dastard>
 <20180314131659.wnmt5zxfhrfsld7n@rh_laptop>
 <20180314133258.GB7000@dastard>
 <20180314135752.5a2vmjr7cuavusiw@rh_laptop>
 <20180314212441.GC7000@dastard>
 <20180315061557.5jajfodpkjdmcrld@rh_laptop>
 <20180315100646.GE7000@dastard>
 <20180315103207.scrm5e4cvkj26m4k@rh_laptop>
 <20180316001955.GN18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180316001955.GN18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>, linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Fri, Mar 16, 2018 at 11:19:55AM +1100, Dave Chinner wrote:
> On Thu, Mar 15, 2018 at 11:32:07AM +0100, Lukas Czerner wrote:
> > 
> > And where the "cdcd" data is comming from ? Not from the
> > 
> > "pwrite -S 1 0 64k"
> > 
> > that's producing "0101".
> 
> Ah, too much context switching. Makes me look like the village
> idiot...

that's how I was looking the past 4 emails ;)

Anyway good that we finally understand each other. I think it'd be worth
fixing the generic/042 to check for the actuall stale data not just
expecting the file to be empty as it still can do some good.

> 
> Ok, I just spent some time looking at this in detail (event traces,
> etc) and it is indeed as the test describes - an whole delalloc
> extent allocation on partial overwrite. THe partial overwrite is
> triggered by the fpunch/fzero code, and it appears the delalloc
> converison is not paying attention to the start offset of the
> writeback:
> 
> xfs_writepage:        dev 7:0 ino 0x7603 pgoff 0xf000 size 0x10000 delalloc 1
> .....
> xfs_alloc_near_greater: dev 7:0 agno 0 agbno 3784 minlen 16 maxlen 16
> .....
> xfs_write_extent:     dev 7:0 ino 0x7603 offset 0 block 3784 count 16 flag 0
> 
> IOWs, as I've said from the start (based on the test description)
> this has nothing to do with the corruption issue CrashMonkey is
> creating.

Yeah they're probably not seeing this because of added fsync.

-Lukas

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
