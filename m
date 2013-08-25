Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8AB007F50
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 11:54:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B9628F8035
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 09:54:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UUa4HeZRqYlj6AA1 for <xfs@oss.sgi.com>;
	Sun, 25 Aug 2013 09:54:32 -0700 (PDT)
Message-ID: <521A36C6.40006@sandeen.net>
Date: Sun, 25 Aug 2013 11:54:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
References: <2909046.09LYLQvZ6q@localhost.localdomain>
In-Reply-To: <2909046.09LYLQvZ6q@localhost.localdomain>
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
To: chandan <chandan@linux.vnet.ibm.com>
Cc: sekharan@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 8/25/13 10:06 AM, chandan wrote:
> The patch adds the function _require_le_4k_blocksize to perform the
> block size check on $TEST_DEV and $SCRATCH_DEV.
> 
> Signed-off-by: chandan <chandan@linux.vnet.ibm.com>

Can you explain why this is necessary?

What failures do you see, on what filesystems?

That kind of info needs to be in the changelog so reviewers
can understand the need for the change (and to be sure
it's not papering over an actual bug for block sizes
> 4k...)

Thanks,
-Eric

> ---
>  common/rc         | 10 ++++++++++
>  tests/generic/255 |  1 +
>  2 files changed, 11 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index ae80b12..d8ee132 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2106,6 +2106,16 @@ _require_dumpe2fs()
>  	fi
>  }
>  
> +_require_le_4k_blocksize()
> +{
> +	test_dev_bs=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	scratch_dev_bs=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
> +
> +	if (( $test_dev_bs > 4096 || $scratch_dev_bs > 4096 )); then
> +		_notrun "This test requires a filesystem with a block size less than or equal to 4k."
> +	fi
> +}
> +
>  _create_loop_device()
>  {
>  	file=$1
> diff --git a/tests/generic/255 b/tests/generic/255
> index dd329b4..763e861 100755
> --- a/tests/generic/255
> +++ b/tests/generic/255
> @@ -49,6 +49,7 @@ _supported_os Linux
>  _require_xfs_io_falloc_punch
>  _require_xfs_io_falloc
>  _require_xfs_io_fiemap
> +_require_le_4k_blocksize
>  
>  testfile=$TEST_DIR/255.$$
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
