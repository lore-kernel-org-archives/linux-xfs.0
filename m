Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbdKUFjV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 00:39:21 -0500
Date: Tue, 21 Nov 2017 13:39:19 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 2/3] common: Implement fiemap's range query check
Message-ID: <20171121053919.GJ2749@eguan.usersys.redhat.com>
References: <1510747821-13270-1-git-send-email-nborisov@suse.com>
 <1510747900-13440-1-git-send-email-nborisov@suse.com>
 <1510747900-13440-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510747900-13440-2-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com

On Wed, Nov 15, 2017 at 02:11:39PM +0200, Nikolay Borisov wrote:
> Allow for users of xfstest to assert the presence of fiemap's
> range query capabilities by requesting the "ranged" parameter.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

I think this patch could be folded into patch 3, the change comes with
users of the change.

> ---
>  common/rc | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e2a8229..c98c224 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2053,6 +2053,12 @@ _require_xfs_io_command()
>  			-c "$command 4k 8k" $testfile 2>&1`
>  		;;
>  	"fiemap")
> +		if echo "$param" | grep -q "ranged"; then

Please add comments on the special "ranged" param.

> +			param=$(echo "$param" | sed "s/ranged//")
> +			$XFS_IO_PROG -F -f -c "pwrite 0 5k" -c "fsync" $testfile > /dev/null 2>&1
> +			lines=$($XFS_IO_PROG -c "fiemap 6k" $testfile 2>&1 | wc -l)
> +			[ $lines -eq 1 ] || _notrun "xfs_io $command ranged support is missing"

I don't see why we're expecting $lines to be 1, maybe I was testing
Eric's version of ranged query patch, I always see file name followed by
a extent description, so that's two lines. e.g.

testfile:
        0: [8..15]: 1300882584..1300882591

But how about just checking for "[offset [len]]" string in help message?
Because we know the test is asking for fiemap ranged support at this
point due to the special "ranged" param.

Thanks,
Eryu

> +		fi
>  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
>  			-c "fiemap -v $param" $testfile 2>&1`
>  		param_checked=1
> -- 
> 2.7.4
> 
