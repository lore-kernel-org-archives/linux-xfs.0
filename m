Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753698AbdKII4M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 03:56:12 -0500
Date: Thu, 9 Nov 2017 16:56:08 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 1/4] dmflakey: support multiple dm targets for a
 dm-flakey device
Message-ID: <20171109085608.GV17339@eguan.usersys.redhat.com>
References: <20171109073252.36001-1-houtao1@huawei.com>
 <20171109073252.36001-2-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109073252.36001-2-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

On Thu, Nov 09, 2017 at 03:32:49PM +0800, Hou Tao wrote:
> dm-flakey can be used to emulate IO write error, however, when
> we also need to prevent the IO error for a specific range of the
> block device (eg., the log region of a XFS), we need to specify
> multiple dm targets for the dm device.
> 
> Option --table can not accommodate the multiple dm targets case,
> so let dmsetup get the possible-multiple-targets table from
> standard input.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  common/dmflakey | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/dmflakey b/common/dmflakey
> index 4434307..16b82d2 100644
> --- a/common/dmflakey
> +++ b/common/dmflakey
> @@ -77,7 +77,7 @@ _load_flakey_table()
>  	$DMSETUP_PROG suspend $suspend_opt flakey-test
>  	[ $? -ne 0 ] && _fatal "failed to suspend flakey-test"
>  
> -	$DMSETUP_PROG load flakey-test --table "$table"
> +	echo -e "$table" | $DMSETUP_PROG load flakey-test

Sorry for not bringing this up earlier, but adding some comments would
be good here.

Thanks,
Eryu

>  	[ $? -ne 0 ] && _fatal "failed to load table into flakey-test"
>  
>  	$DMSETUP_PROG resume flakey-test
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
