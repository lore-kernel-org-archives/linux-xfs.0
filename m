Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A94AD7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:29:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 899DA304077
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:29:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GPurRLwLIrY7zhmy for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:29:39 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:29:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: btrfs, add test for btrfs properties
Message-ID: <20140416002925.GW15995@dastard>
References: <1397591424-25439-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397591424-25439-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 08:50:24PM +0100, Filipe David Borba Manana wrote:
> This test case verifies the btrfs properties feature, a new feature
> introduced in the linux kernel version 3.14.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
...
> ---
>  common/rc           |   9 +++
>  tests/btrfs/048     | 220 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/048.out |  78 +++++++++++++++++++
>  tests/btrfs/group   |   1 +
>  4 files changed, 308 insertions(+)
>  create mode 100755 tests/btrfs/048
>  create mode 100644 tests/btrfs/048.out
> 
> diff --git a/common/rc b/common/rc
> index acf419b..d4ba74f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2262,6 +2262,15 @@ _run_btrfs_util_prog()
>  	run_check $BTRFS_UTIL_PROG $*
>  }
>  
> +_require_btrfs_properties()
> +{
> +	$BTRFS_UTIL_PROG | grep 'btrfs property ' > /dev/null 2>&1
> +	if [ $? -ne 0 ]
> +	then
> +		_notrun "Missing btrfs-progs with properties support, skipped this test"
> +	fi

if [ ... ]; then

....

> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here="`pwd`"
> +tmp=/tmp/$$
> +
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +send_files_dir=$TEST_DIR/btrfs-test-$seq

You should define this after including the common/* files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
