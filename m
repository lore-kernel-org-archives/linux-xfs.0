Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752381AbdJ3FBO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Oct 2017 01:01:14 -0400
Date: Mon, 30 Oct 2017 13:01:12 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 9/6] generic/459: fix test running errors
Message-ID: <20171030050112.GD17339@eguan.usersys.redhat.com>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <20171027004446.GG5486@magnolia>
 <20171028170856.GB4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171028170856.GB4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sat, Oct 28, 2017 at 10:08:56AM -0700, Darrick J. Wong wrote:
> If the DISCARD of the thin device somehow fails with this message:
> 
> device-mapper: thin: Data device (dm-1) discard unsupported: Disabling discard passdown.
> 
> Then we can end up with arbitrary gunk in the thin device.  This causes
> mkfs to fail because it's afraid to format the device.  Don't be afraid,
> just zap it.  FWIW mkfs.xfs thinks that the thinp device has an xfs
> external log because sometimes the thinp device just happen to be backed
> by the log of the previous test's scratch fs.
> 
> Fix this by making the _mkfs_dev helper always format the device, per
> Eryu Guan's suggestion.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 7e453e0..c441199 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -642,7 +642,10 @@ _mkfs_dev()
>  	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* \
>  		2>$tmp.mkfserr 1>$tmp.mkfsstd
>  	;;
> -
> +    xfs)
> +	yes | $MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* \
> +		2>$tmp.mkfserr 1>$tmp.mkfsstd
> +	;;

I think the 'yes' pipe can be omitted, I'll fix that on commit.

Thanks,
Eryu

>      *)
>  	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* \
>  		2>$tmp.mkfserr 1>$tmp.mkfsstd
