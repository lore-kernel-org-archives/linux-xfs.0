Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DB8C3F2CD
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54E962146E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n+EvRLde"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCBSMV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:12:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55080 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSMU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 13:12:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HrlNQ163545
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xGchPJKpxd6rUv0pVcdNJCEkg30ZzrSSo1oYOfLWjgw=;
 b=n+EvRLdePQ1sGF3uyrmCOHSKbxMBtzTIi3bxHWbC32QZOC56HGyUFHYB0i15pjeT+HWX
 Tic3Hw5ke2JM9Dc0oMSghLG/oTu+rFLBsqLVdRUyxXe2Bn78JYG+2ltjAGhdmXY3ZnXJ
 70a2EsJ3y98LhJGrNR2pUghWRlzQbpRk7FqoATqK0Cp+V0JdLJQtH1niFKY95Aj4DKGW
 bp7I4Cw6ZElk/fGQ4b/M5k/brkaLjgm3idSV5LEgPeUpi8BVRqW1Mv6gQLvPQyWlftrz
 Bzigz3+cUFiU2xXJ3igP0XCYrgcbNz7x/Gts+h9O07PD1CH2NqIOaTVNnRfLomxWQmoL yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yffcu9gxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:12:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HqbcK061579
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yg1rg44jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:12:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 022ICIFh015760
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:18 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 10:12:18 -0800
Subject: Re: [PATCH 3/4] xfs: check owner of dir3 data blocks
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294093423.1729975.14006020261164830361.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <41400676-7ed3-4e9e-a0c2-8fddc25569b4@oracle.com>
Date:   Mon, 2 Mar 2020 11:12:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158294093423.1729975.14006020261164830361.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/28/20 6:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 data block headers.
"Check the owner field of dir3 data block headers, and release the 
buffer on error." ?

It's a bit of an api change though isnt it?  Do we need to go find all 
the callers and make sure there's not going to be a double release if 
error == -EFSCORRUPTED ?

Allison

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_dir2_data.c |   32 +++++++++++++++++++++++++++++++-
>   1 file changed, 31 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index b9eba8213180..e5910bc9ab83 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -394,6 +394,22 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
>   	.verify_write = xfs_dir3_data_write_verify,
>   };
>   
> +static xfs_failaddr_t
> +xfs_dir3_data_header_check(
> +	struct xfs_inode	*dp,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = dp->i_mount;
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
> +
> +		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
> +			return __this_address;
> +	}
> +
> +	return NULL;
> +}
>   
>   int
>   xfs_dir3_data_read(
> @@ -403,11 +419,25 @@ xfs_dir3_data_read(
>   	unsigned int		flags,
>   	struct xfs_buf		**bpp)
>   {
> +	xfs_failaddr_t		fa;
>   	int			err;
>   
>   	err = xfs_da_read_buf(tp, dp, bno, flags, bpp, XFS_DATA_FORK,
>   			&xfs_dir3_data_buf_ops);
> -	if (!err && tp && *bpp)
> +	if (err || !*bpp)
> +		return err;
> +
> +	/* Check things that we can't do in the verifier. */
> +	fa = xfs_dir3_data_header_check(dp, *bpp);
> +	if (fa) {
> +		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> +		(*bpp)->b_flags &= ~XBF_DONE;
> +		xfs_trans_brelse(tp, *bpp);
> +		*bpp = NULL;
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (tp)
>   		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
>   	return err;
>   }
> 
