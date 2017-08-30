Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46322 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdH3QRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:17:47 -0400
Date: Wed, 30 Aug 2017 09:17:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 02/14] common/rc: fix _require_xfs_io_command params
 check
Message-ID: <20170830161738.GN4757@magnolia>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-3-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504104706-11965-3-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 05:51:34PM +0300, Amir Goldstein wrote:
> When _require_xfs_io_command is passed command parameters,
> the resulting error from invalid parameters may be ignored.
> 
> For example, the following bogus params would not abort the test:
> _require_xfs_io_command "falloc" "-X"
> _require_xfs_io_command "fiemap" "-X"
> 
> Fix this by looking for the relevant error message.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  common/rc | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 9d7b783..44b98f6 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2212,9 +2212,14 @@ _require_xfs_io_command()
>  	echo $testio | grep -q "Function not implemented" && \
>  		_notrun "xfs_io $command support is missing (missing syscall?)"
>  
> -	if [ -n "$param" -a $param_checked -eq 0 ]; then
> +	[ -n "$param" ] || return
> +
> +	if [ $param_checked -eq 0 ]; then
>  		$XFS_IO_PROG -c "help $command" | grep -q "^ $param --" || \
>  			_notrun "xfs_io $command doesn't support $param"
> +	else
> +		echo $testio | grep -q "invalid option" && \
> +			_notrun "xfs_io $command doesn't support $param"
>  	fi
>  }
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
