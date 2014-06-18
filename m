Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 521B87F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 07:28:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4737F8F8033
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 05:28:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Cuh3RMNJV2ohBjHJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 05:28:13 -0700 (PDT)
Date: Wed, 18 Jun 2014 08:28:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfstests: test speculative preallocation reclaim on
	ENOSPC/EDQUOT
Message-ID: <20140618122803.GA57367@bfoster.bfoster>
References: <1402508170-61125-1-git-send-email-bfoster@redhat.com>
	<20140618004355.GZ4453@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140618004355.GZ4453@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jun 18, 2014 at 10:43:55AM +1000, Dave Chinner wrote:
> On Wed, Jun 11, 2014 at 01:36:10PM -0400, Brian Foster wrote:
> > XFS can allocate significant amounts of space to files via speculative
> > preallocation. Such preallocation may not be reclaimed automatically on
> > file close() if a file is repeatedly opened and extended. For smaller
> > filesystems with relatively large and slow growing files, this
> > preallocation can linger for some time, including contributing to out of
> > space conditions.
> > 
> > Create a situation where an fs is near out of space while several files
> > still have lingering, significant preallocations. Verify that new
> > writers reclaim the preallocated space rather than return ENOSPC. Repeat
> > a similar test for quota limits and EDQUOT.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Hi Brian,
> 
> My test machines all fail this test with output like this:
> 

This is most likely due to not having the corresponding eofblocks scan
on enospc patches (as noted on irc). The test creates the conditions
that currently lead to ENOSPC and tests that the scan frees up enough
space to allow writes to proceed.

Let me know if you continue to reproduce this and I'll dig further into
it...

Brian

> xfs/014  - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/014.out.bad)
>     --- tests/xfs/014.out       2014-06-18 09:32:59.000000000 +1000
>     +++ /home/dave/src/xfstests-dev/results//xfs/014.out.bad    2014-06-18 10:27:10.000000000 +1000
>     @@ -1,2 +1,7 @@
>      QA output created by 014
>      Silence is golden.
>     +/mnt/scratch/014.mnt/file.0: No space left on device
>     +pwrite64: No space left on device
>     +/mnt/scratch/014.mnt/file.2: No space left on device
>     +pwrite64: No space left on device
>     +pwrite64: Disk quota exceeded
> .....
> 
> or this from a 1k block size filesystem:
> 
> xfs/014  - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/014.out.bad)
>     --- tests/xfs/014.out       2014-06-18 09:32:59.000000000 +1000
>     +++ /home/dave/src/xfstests-dev/results//xfs/014.out.bad    2014-06-18 10:29:15.000000000 +1000
>     @@ -1,2 +1,7 @@
>      QA output created by 014
>      Silence is golden.
>     +pwrite64: No space left on device
>     +pwrite64: No space left on device
>     +pwrite64: No space left on device
>     +pwrite64: No space left on device
>     +pwrite64: Disk quota exceeded
> .....
> 
> I'm still going to commit the test as it stands, but could you see
> if you can reproduce this or suggest hints as to where it might be
> going wrong?
> 
> FWIW, patches to tee the stderr output to both the golden output and
> the $seqres.full file will make it much easier to determine what
> write is failing....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
