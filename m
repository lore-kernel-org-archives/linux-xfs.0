Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F10E7F52
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 06:38:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 63F5D8F8039
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 04:38:50 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	o4PxvdsteH6j0WW6 for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 04:38:48 -0800 (PST)
Date: Mon, 24 Feb 2014 23:23:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add function _require_fssum()
Message-ID: <20140224122310.GO4317@dastard>
References: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 24, 2014 at 11:56:23AM +0000, Filipe David Borba Manana wrote:
> To avoid repeating detection of fssum presence in many btrfs tests, as
> suggested by Dave Chinner.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  common/rc       |    7 +++++++
>  tests/btrfs/007 |    5 +----
>  tests/btrfs/016 |    5 +----
>  tests/btrfs/030 |    5 +----
>  tests/btrfs/038 |    5 +----
>  tests/btrfs/039 |    5 +----
>  tests/btrfs/040 |    5 +----
>  tests/btrfs/041 |    5 +----
>  tests/btrfs/042 |    5 +----
>  9 files changed, 15 insertions(+), 32 deletions(-)
>  mode change 100644 => 100755 tests/btrfs/016
> 
> diff --git a/common/rc b/common/rc
> index 5df504c..cce05cc 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2144,6 +2144,13 @@ _require_cp_reflink()
>                 _notrun "This test requires a cp with --reflink support."
>  }
>  
> +_require_fssum()
> +{
> +	HERE=`pwd`
> +	FSSUM_PROG=$HERE/src/fssum
> +	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
> +}

$here is defined by check to be the root of the xfstests instance
that is running. There's 60+ tests that already us it. Hence:

_require_fssum()
{
	FSSUM_PROG=$here/src/fssum
	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
}

Is all you need here.

> +
>  # Given 2 files, verify that they have the same mapping but different
>  # inodes - i.e. an undisturbed reflink
>  # Silent if so, make noise if not
> diff --git a/tests/btrfs/007 b/tests/btrfs/007
> index 5df9ccb..5430613 100755
> --- a/tests/btrfs/007
> +++ b/tests/btrfs/007
> @@ -31,7 +31,6 @@ seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
> -here=`pwd`
>  tmp=`mktemp -d`
>  status=1

Yeah, redefining $here is a bad thing to do :/

And I'd missed that this was being done in all the new btrfs tests,
otherwise I would have pulled it up earlier.

It also points out that the btrfs tests are using a non-standard
$tmp directory - one that is in the xfstests source directory.
That's a bad thing, too - tests should be using:

tmp=/tmp/$$

to store small temporary files.

If /tmp is too small for what a test needs, then the test should be
using $TEST_DIR as the store for the temporary files to exercise
the filesystem under test as much as possible.  e.g. send image
files build form snapshots of SCRATCH_DEV should be stored on TEST_DIR,
not in $tmp; filesystem image files that are mounted by loopback
should be stored on TEST_DIR or SCRATCH_MNT, not $tmp. And so on.

i.e. the idea is that you direct as much of the IO to the test_DIR
and SCRATCH_MNT as possible, not to the filesystem that is hosting
$tmp or the xfstests source directory....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
