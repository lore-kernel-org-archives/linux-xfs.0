Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41811 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDP0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 11:26:55 -0400
Date: Sun, 4 Aug 2019 23:26:46 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] common/rc: check 'chattr +/-x' on dax device.
Message-ID: <20190804152646.GA2665@desktop>
References: <20190731022949.2463-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731022949.2463-1-ruansy.fnst@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc: darrick.wong@oracle.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jul 31, 2019 at 10:29:49AM +0800, Shiyang Ruan wrote:
> 'chattr +/-x' only works on a dax device.  When checking if the 'x'
> attribute is supported by XFS_IO_PROG:
>     _require_xfs_io_command "chattr" "x"    (called by xfs/260)
> it's better to do the check on a dax device.

Hmm, I don't think it's necessary, test should _require_scratch_dax,
which should _notrun the test already, before checking chattr +/-x
support. Do you see any specific problem caused by this issue when
running xfs/260?

> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  common/rc | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e0b087c1..91ab2900 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2094,11 +2094,23 @@ _require_xfs_io_command()
>  		if [ -z "$param" ]; then
>  			param=s
>  		fi
> +
> +		# Attribute "x" should be tested on a dax device
> +		if [ "$param" = "x" ]; then
> +			_require_scratch_dax
> +			_scratch_mount

$SCRATCH_DEV is wiped before every test, it's wrong to assume the device
is directly mountable. And checking chattr +/-x support doesn't require
scratch device, so it's better not to introduce this dependency
implicitly.

Thanks,
Eryu

> +			testfile=$SCRATCH_MNT/$$.xfs_io
> +		fi
> +
>  		# Test xfs_io chattr support AND
>  		# filesystem FS_IOC_FSSETXATTR support
>  		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
>  		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
>  		param_checked="+$param"
> +
> +		if [ "$param" = "x" ]; then
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
