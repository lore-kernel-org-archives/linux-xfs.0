Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 539A47F9F
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 06:10:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B0A3304053
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 04:10:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7BqkCGJppKDg4uHI for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 04:10:14 -0700 (PDT)
Date: Thu, 13 Mar 2014 22:10:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] common: add flink support to _require_xfs_io_command
Message-ID: <20140313111010.GH4263@dastard>
References: <20140313101302.996355155@bombadil.infradead.org>
	<20140313101433.318632549@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140313101433.318632549@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Mar 13, 2014 at 03:13:03AM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/rc |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 7f9db56..3bd4bcb 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1318,6 +1318,10 @@ _require_xfs_io_command()
>  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
>  			-c "fiemap -v" $testfile 2>&1`
>  		;;
> +	"flink" )
> +		testio=`$XFS_IO_PROG -T -F -c "flink $testfile" \
> +			$TEST_DIR 2>&1`
> +		;;
>  	*)
>  		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
>  	esac

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
