Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5FC387F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 13:22:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E44F8F804B
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 11:22:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id H4bnlRCQaj2Snm1P for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 11:22:55 -0700 (PDT)
Message-ID: <51C499FE.5000908@sandeen.net>
Date: Fri, 21 Jun 2013 13:22:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: use xfs_io fiemap instead of filefrag
References: <1371751743-20850-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1371751743-20850-1-git-send-email-jbacik@fusionio.com>
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
Cc: xfs@oss.sgi.com

On 6/20/13 1:09 PM, Josef Bacik wrote:
> Btrfs has always failed shared/218 because of the way we allocate extents on
> disk.  The last part of 218 writes contiguously holey from the start of the file
> forward, which for btrfs means we get 16 extents but they are physically
> contigous.  filefrag -v shows all 16 extents, but prints out that there is 1
> extent, because they are physically contiguous. 

I'd call that a filefrag bug but TBH filefrag has been so fragile, I don't
mind just switching to xfs_io.

> This isn't quite right and
> makes the test fail.  So instead of using filefrag use xfs_io -c fiemap which
> will print the whole map and then get the count from there.  With this patch
> btrfs now passes the test, I also verified that ext4 and xfs still pass this
> test.  Thanks,

Seems fine other than I think we need a:

_require_xfs_io_fiemap

somewhere; either in the tests that call _extent_count, or maybe just at the
top of common/defrag, although that's a little bigger hammer.

-Eric

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  common/defrag |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/common/defrag b/common/defrag
> index f04fd42..a7e5488 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -43,8 +43,8 @@ _require_defrag()
>  
>  _extent_count()
>  {
> -	$FILEFRAG_PROG $1 | awk '{print $2}'
> -	$FILEFRAG_PROG -v $1  >> $seqres.full 2>&1
> +	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep -v hole | wc -l
> +	$XFS_IO_PROG -c "fiemap" $1  >> $seqres.full 2>&1
>  }
>  
>  # Defrag file, check it, and remove it.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
