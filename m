Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DF3B7F53
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 13:41:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84983AC014
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 11:41:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f93bRCsgWm0WQbCB for
	<xfs@oss.sgi.com>; Thu, 08 May 2014 11:41:55 -0700 (PDT)
Message-ID: <536BCFF3.70302@redhat.com>
Date: Thu, 08 May 2014 13:41:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix flink test V2
References: <1399574310-13718-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1399574310-13718-1-git-send-email-jbacik@fb.com>
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
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 5/8/14, 1:38 PM, Josef Bacik wrote:
> I don't have flink support in my xfsprogs, but it doesn't fail with "command not
> found" or whatever, it fails because I don't have the -T option, whereas Eric
> gets an error about $TEST_DIR being a directory because his xfs_io tries to open
> the directory first before it parses the options.  So fix this by checking flink
> with these two cases and don't run if we hit either of them.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Looks good to me, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> V1->V2: check for "Is a directory" errors that Eric mentioned, move test up into
> the flink specific case.
> 
>  common/rc | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 5c13db5..f37b310 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1248,6 +1248,8 @@ _require_xfs_io_command()
>  	"flink" )
>  		testio=`$XFS_IO_PROG -T -F -c "flink $testfile" \
>  			$TEST_DIR 2>&1`
> +		echo $testio | egrep -q "invalid option|Is a directory" && \
> +			_notrun "xfs_io $command support is missing"
>  		;;
>  	*)
>  		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
