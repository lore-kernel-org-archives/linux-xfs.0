Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34342 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752802AbeCPAVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 20:21:22 -0400
Date: Fri, 16 Mar 2018 11:19:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Message-ID: <20180316001955.GN18129@dastard>
References: <20180313042126.GB18129@dastard>
 <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
 <20180313224522.GZ7000@dastard>
 <20180314131659.wnmt5zxfhrfsld7n@rh_laptop>
 <20180314133258.GB7000@dastard>
 <20180314135752.5a2vmjr7cuavusiw@rh_laptop>
 <20180314212441.GC7000@dastard>
 <20180315061557.5jajfodpkjdmcrld@rh_laptop>
 <20180315100646.GE7000@dastard>
 <20180315103207.scrm5e4cvkj26m4k@rh_laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180315103207.scrm5e4cvkj26m4k@rh_laptop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lukas Czerner <lczerner@redhat.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>, linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Thu, Mar 15, 2018 at 11:32:07AM +0100, Lukas Czerner wrote:
> 
> And where the "cdcd" data is comming from ? Not from the
> 
> "pwrite -S 1 0 64k"
> 
> that's producing "0101".

Ah, too much context switching. Makes me look like the village
idiot...

Ok, I just spent some time looking at this in detail (event traces,
etc) and it is indeed as the test describes - an whole delalloc
extent allocation on partial overwrite. THe partial overwrite is
triggered by the fpunch/fzero code, and it appears the delalloc
converison is not paying attention to the start offset of the
writeback:

xfs_writepage:        dev 7:0 ino 0x7603 pgoff 0xf000 size 0x10000 delalloc 1
.....
xfs_alloc_near_greater: dev 7:0 agno 0 agbno 3784 minlen 16 maxlen 16
.....
xfs_write_extent:     dev 7:0 ino 0x7603 offset 0 block 3784 count 16 flag 0

IOWs, as I've said from the start (based on the test description)
this has nothing to do with the corruption issue CrashMonkey is
creating.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
