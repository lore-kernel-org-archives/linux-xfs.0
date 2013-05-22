Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E15C129E03
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 20:26:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D4FDAC006
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 18:26:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Q1EmHHVFzHq86Eby for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 18:26:23 -0700 (PDT)
Date: Wed, 22 May 2013 11:26:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/258 questions (mount issue)...
Message-ID: <20130522012620.GA29466@dastard>
References: <519C14A1.8000009@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519C14A1.8000009@gmail.com>
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
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 08:43:13PM -0400, Michael L. Semon wrote:
> Hi!  When using xfstests generic/258 with along with $TEST_RTDEV
> $TEST_LOGDEV, it tends to scream bloody murder about corrupted
> partitions and such.  In fact, the commands in the test seem to do
> the right thing when executed by hand.  So once again, I grasped for
> straws and came up with this:
> 
> --- xfstests/tests/generic/258.orig	2013-05-21 20:19:38.430754829 -0400
> +++ xfstests/tests/generic/258	2013-05-21 20:10:11.509021368 -0400
> @@ -62,7 +62,7 @@
>  # unmount, remount, and check the timestamp
>  echo "Remounting to flush cache"
>  umount $TEST_DEV
> -mount $TEST_DEV $TEST_DIR
> +_test_mount
> 
>  # Should yield -315593940 (prior to epoch)
>  echo "Testing for negative seconds since epoch"
> 
> My questions are these:
> 
> 1) Was there a better way to do this?

No, your change is correct. Can you clean up the description of the
problem you had and add a Signed-off-by?

> 2) Not knowing the policy on umounting $TEST_DEV, could this have
> been a test for $SCRATCH_DEV?

There are a handful of other tests that also unmount the TEST_DEV.
Perhaps adding a _test_umount() wrapper to common/rc (similar to
_scratch_umount) would be best. At least shared/243 needs the same
_test_mount treatment as this test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
