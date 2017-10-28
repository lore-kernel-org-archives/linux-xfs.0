Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23715 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdJ1RID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Oct 2017 13:08:03 -0400
Date: Sat, 28 Oct 2017 10:07:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 9/6] generic/459: fix test running errors
Message-ID: <20171028170757.GA4911@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <20171027004446.GG5486@magnolia>
 <20171027202521.GK5486@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027202521.GK5486@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Oct 27, 2017 at 01:25:21PM -0700, Darrick J. Wong wrote:
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
> index 7e453e0..a985f4d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -642,7 +642,10 @@ _mkfs_dev()
>  	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* \
>  		2>$tmp.mkfserr 1>$tmp.mkfsstd
>  	;;
> -
> +    xfs)
> +	yes | $MKFS_PROG -f -t $FSTYP -- $MKFS_OPTIONS $* \

The '-f' should be after the '--', will resend patch.

--D

> +		2>$tmp.mkfserr 1>$tmp.mkfsstd
> +	;;
>      *)
>  	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* \
>  		2>$tmp.mkfserr 1>$tmp.mkfsstd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
