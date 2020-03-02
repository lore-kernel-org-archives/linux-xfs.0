Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3246C3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD982465E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T36gdAFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCBSMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:12:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54282 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSMf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 13:12:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HsuOq110618
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=N+0tEwdzpxymmIJ5QKd50ScrvgZzgqrlx7Kt13MSG+4=;
 b=T36gdAFmp64+muZAxDb8a9jxQifpY2mU/mRcnSvLPEbQPLjUAE5ZvzGkMJuzJFy2oMaY
 swwF6UhnMh5FT2gQFgGEtI8MDtj/ZwqBWxZc0HNAXyMFoJUB20N0yWppmC7D3Nye0X5H
 zAER8SigQh+Q3yIP26pPwSABxXZU0qeG4ba+bg+oyxWtCJwlvNfNmPM7I2cufokZH+si
 lQFNYXNaPYK8QrjcoC7m7vKuz/pVvmvvuAxjDB2oBQwhJswnokUqM7encZqzuraKQhXB
 qdaVqD4u8YJ9nBWpEiri2f00lYHBv+m7ti9tgduPfC3GEu1bzbeegcb2a85i79R24sj4 bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yghn2wamb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:12:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HqxHl155430
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yg1gvkw68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:12:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 022ICVt3025320
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:31 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 10:12:31 -0800
Subject: Re: [PATCH 4/4] xfs: check owner of dir3 blocks
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294094178.1729975.1691061577157111397.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d9c4145d-efef-54aa-d106-5923ef5f49b9@oracle.com>
Date:   Mon, 2 Mar 2020 11:12:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158294094178.1729975.1691061577157111397.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/28/20 6:49 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 block headers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Same question here with the release buffer api change.

Allison
> ---
>   fs/xfs/libxfs/xfs_dir2_block.c |   34 +++++++++++++++++++++++++++++++++-
>   1 file changed, 33 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index d6ced59b9567..408a9d7c8c24 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -20,6 +20,7 @@
>   #include "xfs_error.h"
>   #include "xfs_trace.h"
>   #include "xfs_log.h"
> +#include "xfs_health.h"
>   
>   /*
>    * Local function prototypes.
> @@ -114,6 +115,23 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
>   	.verify_struct = xfs_dir3_block_verify,
>   };
>   
> +static xfs_failaddr_t
> +xfs_dir3_block_header_check(
> +	struct xfs_inode	*dp,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = dp->i_mount;
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
> +
> +		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
> +			return __this_address;
> +	}
> +
> +	return NULL;
> +}
> +
>   int
>   xfs_dir3_block_read(
>   	struct xfs_trans	*tp,
> @@ -121,11 +139,25 @@ xfs_dir3_block_read(
>   	struct xfs_buf		**bpp)
>   {
>   	struct xfs_mount	*mp = dp->i_mount;
> +	xfs_failaddr_t		fa;
>   	int			err;
>   
>   	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, 0, bpp,
>   				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
> -	if (!err && tp && *bpp)
> +	if (err || !*bpp)
> +		return err;
> +
> +	/* Check things that we can't do in the verifier. */
> +	fa = xfs_dir3_block_header_check(dp, *bpp);
> +	if (fa) {
> +		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> +		(*bpp)->b_flags &= ~XBF_DONE;
> +		xfs_trans_brelse(tp, *bpp);
> +		*bpp = NULL;
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (tp)
>   		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
>   	return err;
>   }
> 
