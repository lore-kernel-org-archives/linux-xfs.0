Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556A2C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24C4021A49
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eJJJsguE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKMEXd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:23:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33480 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfKMEXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:23:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4JBUI135269
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 04:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=m91ZWDhgtsJXnLLYeDb0lXBbO4IqN6BEcHWPdkFXLIE=;
 b=eJJJsguEfjjhB1qYeXj40ozZ3S+Ff3nz4plagAjuMYg4PWwPG7G77Tkrz4x2qkAaz5Bf
 JJb7lxyhElmAibMtpCEUZR+n5SVLDDZnv4QrXsuxiQ7uob/dMl0xMFH/ikYzUTA5+b1w
 Bn/Pk6DmAn0OYb2kHtdMpXItL3ZXzwGxJoE9YY0wbMuUc95LY9tDUHHyUOYmURcCHSNa
 lugsk/85NSTbbDzI/nDXTlcMrCXtxOT3AmrTqMtB4LDnoBucQyX1v+yYMKuk04/Ts1Em
 Gc5oysHqRT8OeLlLo1liw8jScuidNm/IU4RvQ9xm4KHwjbtGMzDT4bXel43nDOnsXp6w Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w5p3qsdhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 04:23:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4NPu1130748
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 04:23:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w7vpnjd3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 04:23:30 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAD4NGDx010533
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 04:23:16 GMT
Received: from localhost (/10.159.254.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:23:16 -0800
Date:   Tue, 12 Nov 2019 20:23:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unused variable from
 xfs_dir2_block_lookup_int
Message-ID: <20191113042315.GI6219@magnolia>
References: <20191113041310.GG6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113041310.GG6219@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130036
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 08:13:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove an unused variable.

NAK, I'll just roll this into the devirtualize m_dirops patch.

--D

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_block.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index f9d83205659e..328a8dd53a22 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -660,13 +660,11 @@ xfs_dir2_block_lookup_int(
>  	int			high;		/* binary search high index */
>  	int			low;		/* binary search low index */
>  	int			mid;		/* binary search current idx */
> -	xfs_mount_t		*mp;		/* filesystem mount point */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	enum xfs_dacmp		cmp;		/* comparison result */
>  
>  	dp = args->dp;
>  	tp = args->trans;
> -	mp = dp->i_mount;
>  
>  	error = xfs_dir3_block_read(tp, dp, &bp);
>  	if (error)
