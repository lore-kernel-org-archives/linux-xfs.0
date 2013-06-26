Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F04B87F3F
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 21:20:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7856FAC003
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:20:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	J4fhv7idz1CdDKaF for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 19:20:04 -0700 (PDT)
Date: Wed, 26 Jun 2013 12:19:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: use xfs_io fiemap instead of filefrag V2
Message-ID: <20130626021943.GE29376@dastard>
References: <1372083696-10402-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372083696-10402-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Mon, Jun 24, 2013 at 10:21:36AM -0400, Josef Bacik wrote:
> Btrfs has always failed shared/218 because of the way we allocate extents on
> disk.  The last part of 218 writes contiguously holey from the start of the file
> forward, which for btrfs means we get 16 extents but they are physically
> contigous.  filefrag -v shows all 16 extents, but prints out that there is 1
> extent, because they are physically contiguous.  This isn't quite right and
> makes the test fail.  So instead of using filefrag use xfs_io -c fiemap which
> will print the whole map and then get the count from there.  With this patch
> btrfs now passes the test, I also verified that ext4 and xfs still pass this
> test.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: change _require_defrag to check for xfs_io having fiemap support as per
> Eric's suggestion.
> 
>  common/defrag |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/common/defrag b/common/defrag
> index f04fd42..a4bc976 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -38,13 +38,13 @@ _require_defrag()
>      esac
>  
>      _require_command $DEFRAG_PROG
> -    _require_command $FILEFRAG_PROG
> +    _require_xfs_io_fiemap
>  }
>  
>  _extent_count()
>  {
> -	$FILEFRAG_PROG $1 | awk '{print $2}'
> -	$FILEFRAG_PROG -v $1  >> $seqres.full 2>&1
> +	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep -v hole | wc -l
> +	$XFS_IO_PROG -c "fiemap" $1  >> $seqres.full 2>&1

Looks good, but you can do that with a single fiemap execution:

	$XFS_IO_PROG -c "fiemap" $1 | tee -a $seqres.full |\
				    | tail -n +2 | grep -v hole | wc -l

Still good either way

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
