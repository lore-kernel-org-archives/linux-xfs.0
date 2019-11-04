Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DB2CA9ED3
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5DE62089C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DKQ9ILYk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfKDUhr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:37:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43612 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729074AbfKDUhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:37:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KYcjn109740;
        Mon, 4 Nov 2019 20:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2dA4GhnHEyePnELTZJ9GT31LjKFIsBsqnPdD/IMR59A=;
 b=DKQ9ILYkthgugZ2lQIfGHsleyibb3y7Z4PXGaW0fbEOeWeysmwSykWAKb0xJO0YmqTh9
 GiuLlCciIabk2y5KWrYCgEweFXGblNT8rLsylhHA2QE/ik1bRPtOGG3ANiwnIhJK1geh
 9UHn7MKHkuO1XEkZy31+wrcsJSo4bOrFQMDfYFa/1xW1JzHHy4B7GKZZKdvwWiDr1sLo
 Y0w7Kn8U6bHwGfWnrHVDCpZc5uYsZ+yq1/CSKIC4zWrQClSSuRm0wnNZ1YyfX15XDEfo
 X7i/LZ/EUZbZqNiY4excak/zc44xXEC2GqvsYJurwO+0WFunAeq7zsx+0GHQNOk3yRCr dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12er1s5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:37:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KXmbm117391;
        Mon, 4 Nov 2019 20:37:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w1kxn0twt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:37:42 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4KbfZG014605;
        Mon, 4 Nov 2019 20:37:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:37:41 -0800
Date:   Mon, 4 Nov 2019 12:37:34 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/34] xfs: remove the ->data_dot_entry_p and
 ->data_dotdot_entry_p methods
Message-ID: <20191104203734.GY4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-24-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-24-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:08PM -0700, Christoph Hellwig wrote:
> Replace the only user of the ->data_dot_entry_p and ->data_dotdot_entry_p
> dir ops methods with direct calculations using ->data_dot_offset and
> ->data_dotdot_offset.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 52 ----------------------------------
>  fs/xfs/libxfs/xfs_dir2.h       |  4 ---
>  fs/xfs/libxfs/xfs_dir2_block.c |  4 +--
>  3 files changed, 2 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 1c72b46344d6..84f8355072b4 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -111,26 +111,6 @@ xfs_dir3_data_entry_tag_p(
>  		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
>  }
>  
> -/*
> - * location of . and .. in data space (always block 0)
> - */
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_data_dot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_data_dotdot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR2_DATA_ENTSIZE(1));
> -}
> -
>  static struct xfs_dir2_data_entry *
>  xfs_dir2_data_first_entry_p(
>  	struct xfs_dir2_data_hdr *hdr)
> @@ -141,15 +121,6 @@ xfs_dir2_data_first_entry_p(
>  				XFS_DIR2_DATA_ENTSIZE(2));
>  }
>  
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_ftype_data_dotdot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1));
> -}
> -
>  static struct xfs_dir2_data_entry *
>  xfs_dir2_ftype_data_first_entry_p(
>  	struct xfs_dir2_data_hdr *hdr)
> @@ -160,23 +131,6 @@ xfs_dir2_ftype_data_first_entry_p(
>  				XFS_DIR3_DATA_ENTSIZE(2));
>  }
>  
> -static struct xfs_dir2_data_entry *
> -xfs_dir3_data_dot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir3_data_dotdot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1));
> -}
> -
>  static struct xfs_dir2_data_entry *
>  xfs_dir3_data_first_entry_p(
>  	struct xfs_dir2_data_hdr *hdr)
> @@ -242,8 +196,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  				XFS_DIR2_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
> -	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
> -	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
>  	.data_first_entry_p = xfs_dir2_data_first_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
> @@ -264,8 +216,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
> -	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
> -	.data_dotdot_entry_p = xfs_dir2_ftype_data_dotdot_entry_p,
>  	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
> @@ -286,8 +236,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
>  
> -	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
> -	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
>  	.data_first_entry_p = xfs_dir3_data_first_entry_p,
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 61cc9ae837d5..0198887a1c54 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -45,10 +45,6 @@ struct xfs_dir_ops {
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t	data_entry_offset;
>  
> -	struct xfs_dir2_data_entry *
> -		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
> -	struct xfs_dir2_data_entry *
> -		(*data_dotdot_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  	struct xfs_dir2_data_entry *
>  		(*data_first_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  	struct xfs_dir2_data_entry *
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 5877272dc63e..34e0cdf03950 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1148,7 +1148,7 @@ xfs_dir2_sf_to_block(
>  	/*
>  	 * Create entry for .
>  	 */
> -	dep = dp->d_ops->data_dot_entry_p(hdr);
> +	dep = (void *)hdr + dp->d_ops->data_dot_offset;

Same complaint about (void *) arithmetic as last time.

Also, why not leave a static inline helper function or two to
encapsulate the pointer arithmetic and ensure type checking?

--D

>  	dep->inumber = cpu_to_be64(dp->i_ino);
>  	dep->namelen = 1;
>  	dep->name[0] = '.';
> @@ -1162,7 +1162,7 @@ xfs_dir2_sf_to_block(
>  	/*
>  	 * Create entry for ..
>  	 */
> -	dep = dp->d_ops->data_dotdot_entry_p(hdr);
> +	dep = (void *)hdr + dp->d_ops->data_dotdot_offset;
>  	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
>  	dep->namelen = 2;
>  	dep->name[0] = dep->name[1] = '.';
> -- 
> 2.20.1
> 
