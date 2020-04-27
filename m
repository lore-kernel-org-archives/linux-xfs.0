Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E199C4CECC
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7855920B1F
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:58:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gvAq/5LJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgD0R6J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:58:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgD0R6I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:58:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHtP1c097330;
        Mon, 27 Apr 2020 17:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IAT6oGbnCh0kGFU01wPF1fiyFLgkTCeYjXonYtNd65g=;
 b=gvAq/5LJW1hsPT4fAyESAjc5DK7btqvX37ChMOoqXWm8Siq47jM1PGanhH0t+X2QC7hx
 FWcYyoKQGzPyoYx7NlAGa1tQa7jcnRHiUVnbROgG+opjMPdnMGLCzcIUnZ65f93I4oSh
 5zFI0sVWG1hLNWGAQqKl1A/p2rZ0mWDqhB5Or+llCm00DWr4MfFPUPWe+WcWZ69flvFI
 zDb9GW71lKWzruAdROsc3lAuh9ixtGsmQtDToADVoxvwEf/eNpXcveZqw2rShUwK1tzK
 m0JPjNYaWWq0+nBx61w5HIrNEPNZKUGJceYjwY3gNZTSU86xsAzU+19XORPDwdlnVg4v GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01nhpa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:57:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHuvHu047040;
        Mon, 27 Apr 2020 17:57:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my0a4n4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:57:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RHv7PK016894;
        Mon, 27 Apr 2020 17:57:07 GMT
Received: from localhost (/10.159.145.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:57:07 -0700
Date:   Mon, 27 Apr 2020 10:57:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove unnecessary check of the variable resblks in
 xfs_symlink
Message-ID: <20200427175706.GU6742@magnolia>
References: <1587187851-11130-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587187851-11130-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 18, 2020 at 01:30:51PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Since the "no-allocation" reservations has been removed, the resblks
> value should be larger than zero, so remove the unnecessary check.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Seems fine to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_symlink.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 13fb4b919648..973441992b08 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -243,8 +243,7 @@ xfs_symlink(
>  	 */
>  	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
> -	if (resblks)
> -		resblks -= XFS_IALLOC_SPACE_RES(mp);
> +	resblks -= XFS_IALLOC_SPACE_RES(mp);
>  	/*
>  	 * If the symlink will fit into the inode, write it inline.
>  	 */
> @@ -265,8 +264,7 @@ xfs_symlink(
>  		if (error)
>  			goto out_trans_cancel;
>  
> -		if (resblks)
> -			resblks -= fs_blocks;
> +		resblks -= fs_blocks;
>  		ip->i_d.di_size = pathlen;
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -- 
> 2.20.0
> 
