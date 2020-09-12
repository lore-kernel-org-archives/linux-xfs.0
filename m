Return-Path: <SRS0=ZFeo=CV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67815C43461
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Sep 2020 16:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B8F20756
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Sep 2020 16:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xa0enjCX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgILQF7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:05:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33830 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgILQF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Sep 2020 12:05:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08CG52El061990;
        Sat, 12 Sep 2020 16:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AHM7kFx4ZAUxWN494ElwZfoKhlVkNV8Y/7kwgEQqn8c=;
 b=Xa0enjCXg8Gq9saYZ3vuDbjhxD+79Jt56J19sEN8Vsv4tF9EAtSAyGptp/+jIO6aWO6G
 5mWhY2DByG78PgHVOQT+YIbdk2IwYfdo7o01M3Vk3wN+3UxMa+1sGpv3jlyuaAYIf5EL
 /NAbz48HU0qdo3zklZe25RdrfckN3+HwmlXpi1bZje9ncOOuinnji3CADk10TeTJcre3
 jAzAsidTesOmDbkOdR8Thry3+Oi+ijZIGApSqRaKuKWuodnaf2rvPhaA59du1VbC+kW3
 8ZA6o07+J/sd4l6jMrrVFQNNbZDm/999BfY0KIkuUvahyizlrNEqwsl/WRAdfOhboPX3 Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9ks8sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 12 Sep 2020 16:05:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08CFxdTU048529;
        Sat, 12 Sep 2020 16:03:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33gnnj9nyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Sep 2020 16:03:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08CG3sWt007038;
        Sat, 12 Sep 2020 16:03:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Sep 2020 16:03:54 +0000
Date:   Sat, 12 Sep 2020 09:03:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Set xfs_buf type flag when growing summary/bitmap
 files
Message-ID: <20200912160353.GW7955@magnolia>
References: <20200912130015.11473-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912130015.11473-1-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9742 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009120151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9742 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009120152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 12, 2020 at 06:30:15PM +0530, Chandan Babu R wrote:
> The following sequence of commands,
> 
>   mkfs.xfs -f -m reflink=0 -r rtdev=/dev/loop1,size=10M /dev/loop0
>   mount -o rtdev=/dev/loop1 /dev/loop0 /mnt
>   xfs_growfs  /mnt

Please turn this into an fstest. :)

> ... causes the following call trace to be printed on the console,
> 
> XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> Call Trace:
>  xfs_buf_item_format+0x632/0x680
>  ? kmem_alloc_large+0x29/0x90
>  ? kmem_alloc+0x70/0x120
>  ? xfs_log_commit_cil+0x132/0x940
>  xfs_log_commit_cil+0x26f/0x940
>  ? xfs_buf_item_init+0x1ad/0x240
>  ? xfs_growfs_rt_alloc+0x1fc/0x280
>  __xfs_trans_commit+0xac/0x370
>  xfs_growfs_rt_alloc+0x1fc/0x280
>  xfs_growfs_rt+0x1a0/0x5e0
>  xfs_file_ioctl+0x3fd/0xc70
>  ? selinux_file_ioctl+0x174/0x220
>  ksys_ioctl+0x87/0xc0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x3e/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This occurs because the buffer being formatted has the value of
> XFS_BLFT_UNKNOWN_BUF assigned to the 'type' subfield of
> bip->bli_formats->blf_flags.
> 
> This commit fixes the issue by assigning one of XFS_BLFT_RTSUMMARY_BUF
> and XFS_BLFT_RTBITMAP_BUF to the 'type' subfield of
> bip->bli_formats->blf_flags before committing the corresponding
> transaction.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Otherwise seems fine to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6209e7b6b895..192a69f307d7 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -767,8 +767,12 @@ xfs_growfs_rt_alloc(
>  	struct xfs_bmbt_irec	map;		/* block map output */
>  	int			nmap;		/* number of block maps */
>  	int			resblks;	/* space reservation */
> +	enum xfs_blft		buf_type;
>  	struct xfs_trans	*tp;
>  
> +	buf_type = (ip == mp->m_rsumip) ?
> +		XFS_BLFT_RTSUMMARY_BUF : XFS_BLFT_RTBITMAP_BUF;
> +
>  	/*
>  	 * Allocate space to the file, as necessary.
>  	 */
> @@ -830,6 +834,8 @@ xfs_growfs_rt_alloc(
>  					mp->m_bsize, 0, &bp);
>  			if (error)
>  				goto out_trans_cancel;
> +
> +			xfs_trans_buf_set_type(tp, bp, buf_type);
>  			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
>  			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
>  			/*
> -- 
> 2.28.0
> 
