Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD6WHd0144033 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 00:32:18 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4214C2BB0BD
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 22:32:16 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EzCRyCMfOTTaotZe for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 22:32:16 -0800 (PST)
Date: Tue, 13 Dec 2011 17:32:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] update 068 to reproduce an unfreeze hanging up problem
Message-ID: <20111213063212.GC14273@dastard>
References: <20111213094245.4004.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111213094245.4004.61FB500B@jp.fujitsu.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Dec 13, 2011 at 09:42:46AM +0900, Masayoshi MIZUMA wrote:
> update 068 to reproduce an unfreeze hanging up problem which is unfreeze
> function, thaw_super(), sometimes hangs up if flush kernel thread does
> writeback to the same filesystem concurrently.

That's not exactly what I asked to be done when I reviewed the
original patch -  I asked you to "make 068 generic" because it
already exercises freeze/thaw under a stressful workload. What I
expected was a change to "supported_fs" and the scratch mkfs
command so it will run on all filesystems.

test 068 will catch problems like the one your specific test
catches, but maybe not every time. Test 068 will catch problems your
test case won't, though - it's a trade-off between having lots of
tests that are similar but slightly different (difficult to
maintain, increases runtime, etc), and having one test that
exercises the functionality in a simple manner likely to detect
problems.

Test 068 is likely to detect problems because it:

	a) allows fsstress to try to do stuff while the filesystem
	is frozen by waiting a short time before thawing, hence load
	processes can get stuck either during the freeze of once the
	freeze is complete. Without that window, we are much less
	likely to test opeations on a frozen filesystem.

	b) allows more dirty data/metadata to build up between
	thaw/freeze commands, rather than running them as quickly as
	possible. This means freeze has more work to do, extenting
	the different phases of the freeze, making it more likely we
	have processes hit in different phases and hence test
	different parts of the freeze process.

IOWs, test 068 gives good coverage across most aspects of
freezing/thawing filesystems under load - and a lot of that woul dbe
lost by changing the test to mimic the ext4 specific test case you
have. It will still be able to trigger the problem you are trying to
expose, but it also has a much better chance of triggering problems
at different points of the freeze/thaw lifecycle that your specific
test....

> The problem occurs on ext4 and ext3. They are reported at
> ext4:
> http://marc.info/?l=linux-ext4&m=132339590004560&w=2
> ext3:
> http://marc.info/?l=linux-ext4&m=131536612113658&w=2
> 
> This test runs freeze/unfreeze under heavy load. If the problem is
> reproduced, this test will hang up because "xfs_freeze -u" hangs up...

> -ITERATIONS=10
> +ITERATIONS=50

....

> -    procs=2
> -    nops=200
> +    procs=100
> +    nops=1000

>      while [ -f "$tmp.running" ]
> -      do
> -      #	-w ensures that the only ops are ones which cause write I/O
> -      $FSSTRESS_PROG -d $STRESS_DIR -w -p $procs -n $nops $FSSTRESS_AVOID \
> +    do
> +      $FSSTRESS_PROG -d $STRESS_DIR -p $procs -n $nops $FSSTRESS_AVOID \
>  	  > /dev/null 2>&1

And this is one of those cases - it is the write operations
that are the ones that cause trouble for freeze/thaw, so changing
the test to use read operations simply reduces the stress that is
being put on the filesytem freeze...

Also, you don't need lots of processes and ops to keep the filesystems
busy while freeze/thaw cycles are going on - if fsstress completes,
it simply gets started again. Hence it doesn't need to be configured
to run for a long time by ramping up processes and opcount. Yes, the
proc count could probably be increased a bit to increase the freeze
load, but i don't think that will improve the test all that much...

> @@ -99,13 +98,11 @@ do
>  	xfs_freeze -f "$SCRATCH_MNT" | tee -a $seq.full
>  	[ $? != 0 ] && echo xfs_freeze -f "$SCRATCH_MNT" failed | \
>  	    tee -a $seq.full
> -	sleep 2

And this simulates typical freeze/do something/thaw cycles. It also
allows fsstress to execute operations while the filesytem is frozen
and potentially try to grab things like the superblock lock because
fsstress issued a sync() system call. Dropping the sleep makes the
test less likely to find problems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
