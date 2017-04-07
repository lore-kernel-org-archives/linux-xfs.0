Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41140 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933185AbdDGRX2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 13:23:28 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v37HNMLF007649
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 17:23:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v37HNLe3000687
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 17:23:22 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v37HNL2I019321
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 17:23:21 GMT
Date: Fri, 7 Apr 2017 10:23:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/1] xfsprogs/db: fix a segfault by bailing out the print
 on a corrupted block
Message-ID: <20170407172320.GJ4864@birch.djwong.org>
References: <1491551344-5236-1-git-send-email-shan.hai@oracle.com>
 <1491551344-5236-2-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491551344-5236-2-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 07, 2017 at 03:49:04PM +0800, Shan Hai wrote:
> The print command of the xfs_db would cause segfault on a corrupted
> or CRC error block, fix it by bailing out the print when encountered
> a corrupted or CRC error block, below is an example to reproduce the
> segfault:
> 
> mkfs.xfs -f /dev/sda1
> xfs_db -r -c "agf 0" -c "addr rmaproot" -c "p" /dev/sda1
> Metadata CRC error detected at xfs_rmapbt block 0x0/0x1000
> Segmentation fault (core dumped)
> 
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  db/print.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/db/print.c b/db/print.c
> index e31372f..08bb39a 100644
> --- a/db/print.c
> +++ b/db/print.c
> @@ -69,11 +69,19 @@ print_f(
>  	char	**argv)
>  {
>  	pfunc_t	pf;
> +	int err;
>  
>  	if (cur_typ == NULL) {
>  		dbprintf(_("no current type\n"));
>  		return 0;
>  	}
> +
> +	err = iocur_top->bp->b_error;
> +	if ((err == -EFSCORRUPTED) || (err == -EFSBADCRC)) {

The double parentheses aren't needed for integer comparison.

Also, no need to send a cover letter if you're only sending one patch.

--D

> +		dbprintf(_("data corrupted or CRC error\n"));
> +		return 0;
> +	}
> +
>  	pf = cur_typ->pfunc;
>  	if (pf == NULL) {
>  		dbprintf(_("no print function for type %s\n"), cur_typ->name);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
