Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfG3OrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 10:47:24 -0400
Date: Tue, 30 Jul 2019 07:47:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] common/rc: check 'chattr +/-x' on dax device.
Message-ID: <20190730144710.GR1561054@magnolia>
References: <20190730084009.26257-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730084009.26257-1-ruansy.fnst@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc: guaneryu@gmail.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jul 30, 2019 at 04:40:09PM +0800, Shiyang Ruan wrote:
> 'chattr +/-x' only works on a dax device.  When checking if the 'x'
> attribute is supported by XFS_IO_PROG:
>     _require_xfs_io_command "chattr" "x"    (called by xfs/260)
> it's better to do the check on a dax device mounted with dax option.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  common/rc | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e0b087c1..73ee5563 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2094,11 +2094,22 @@ _require_xfs_io_command()
>  		if [ -z "$param" ]; then
>  			param=s
>  		fi
> +
> +		# Attribute "x" should be tested on a dax device
> +		if [ "$param" == "x" ]; then
> +			_scratch_mount "-o dax"
> +			testfile=$SCRATCH_MNT/$$.xfs_io

NAK, the dax mount option is not intended to remain as a long-term
interface.

Also, "==" is a bashism (which probably is fine for fstests)

Also, there's no _require_scratch which means this can totally blow up
if the user doesn't specify a scratch device.

--D

> +		fi
> +
>  		# Test xfs_io chattr support AND
>  		# filesystem FS_IOC_FSSETXATTR support
>  		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
>  		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
>  		param_checked="+$param"
> +
> +		if [ "$param" == "x" ]; then
> +			_scratch_unmount
> +		fi
>  		;;
>  	"chproj")
>  		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
> -- 
> 2.17.0
> 
> 
> 
