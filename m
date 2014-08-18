Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 366F77F50
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 21:41:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4C97AC001
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 19:41:20 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NMCQQYGcT1kKIm5G for <xfs@oss.sgi.com>;
	Sun, 17 Aug 2014 19:41:18 -0700 (PDT)
Date: Mon, 18 Aug 2014 12:41:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump completes very prematurely in low RAM, commit found
Message-ID: <20140818024114.GK20518@dastard>
References: <53F15EEF.4090308@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F15EEF.4090308@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Aug 17, 2014 at 10:03:27PM -0400, Michael L. Semon wrote:
> Hi!  I had some phantom issues that are chasing me through this 3.17
> merge window period.  While chasing those issues, I decided to do an
> xfsdump of a v5/finobt XFS system rescued from PEBKAC issues.  The
> xfsdump completed rather prematurely, ending like this test case
> output...
> 
> xfsdump: dumping special file ino 4194523 mode 0x21b0
> xfsdump: dumping special file ino 4194524 mode 0x21b0
> xfsdump: dumping special file ino 4194525 mode 0x21b0
> xfsdump: dumping special file ino 4194526 mode 0x21b0
> xfsdump: dumping special file ino 4194527 mode 0x21b0
> xfsdump: ending media file
> xfsdump: media file size 4512992 bytes
> xfsdump: ending stream: 23 seconds elapsed
> xfsdump: dump size (non-dir files) : 4452088 bytes
> xfsdump: dump complete: 23 seconds elapsed
> xfsdump: Dump Summary:
> xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
> xfsdump: Dump Status: SUCCESS
> 
> That looks fine for a lack of obvious error messages.  However, it
> should end like this:
> 
> xfsdump: dumping regular file ino 13653551 offset 0 to offset 12154 (size 12154)
> xfsdump: dumping regular file ino 13653555 offset 0 to offset 16554 (size 16554)
> xfsdump: dumping regular file ino 13653556 offset 0 to offset 185 (size 185)
> xfsdump: dumping regular file ino 13653557 offset 0 to offset 471 (size 471)
> xfsdump: dumping special file ino 13653558 mode 0xa1ff
> xfsdump: ending media file
> xfsdump: media file size 1999127056 bytes
> xfsdump: ending stream: 465 seconds elapsed
> xfsdump: dump size (non-dir files) : 1963549104 bytes
> xfsdump: dump complete: 465 seconds elapsed
> xfsdump: Dump Summary:
> xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
> xfsdump: Dump Status: SUCCESS

What's the inode number progression of a successful dump at the
point at which the incomplete dump ends? i.e. around inode 4194527?
That number is one inode chunk short of 2^22, which implies that
there is a failure or some kind moving from one AG to the next.
The progrssion of inode numbers will tell me whether this is the
case or not...

> Bisect brought me here:
> 
> root@oldsvrhw:/usr/src/kernel-git/linux# git bisect bad
> c7cb51dcb0a38624d42eeabb38502fa54a4d774b is the first bad commit
> [33mcommit c7cb51dcb0a38624d42eeabb38502fa54a4d774b[m
> Author: Jie Liu <jeff.liu@oracle.com>
> Date:   Thu Jul 24 12:18:47 2014 +1000
> 
>     xfs: fix error handling at xfs_inumbers
>     From: Jie Liu <jeff.liu@oracle.com>
>     To fetch the file system number tables, we currently just ignore the
>     errors and proceed to loop over the next AG or bump agino to the next
>     chunk in case of btree operations failed, that is not properly because
>     those errors might hint us potential file system problems.
>     This patch rework xfs_inumbers() to handle the btree operation errors
>     as well as the loop conditions.
>     Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
>     Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> :040000 040000 ec78dc86468ee00df7a63bba97a135b8c6a84a95 2e447774a8f85b1b8d43ffa9fd28cbea3402d717 M	fs
> 
> Maybe Jeff's patch is doing its job.  After all, on several successful
> test runs, the kernel was sending messages like (paraphrased) "BUG: bad
> state in page table" to remote syslog.  The Pentium III PC has too
> little memory (512 MB) to do this job.  However, I think that the
> xfsdump should last more than 23 seconds before causing issues.

Memory should not matter for counting the number of inodes or
extracting them from the kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
