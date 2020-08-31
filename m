Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90393C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC4E20719
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IVFLV5zO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgHaQey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:34:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgHaQey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:34:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGYE9n046254;
        Mon, 31 Aug 2020 16:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EOvLpjbkEJBdmOd3sJGiEbk3uUHwCX5LJgZaMXV5p5w=;
 b=IVFLV5zOMv0/p2VWQYpKrZH7b5Xtmroo1OZScSsfD7OyoDf1R6DezkOgUy3y8qNmKBdf
 Ix0PYoiuIFllE35hHDWMjHRY0u7jzBYPrvfKf8q058yErBhKVoWko+3MnkmdIGYNGP6B
 vF/FKnx8pPJsPfc526UrqkxElw27nRLpI7MmZPTGiME8ya5i36YCSFxhnFvkmyQ5xdTe
 HBGlmQsuQsFzDxKfCmqu7SpReiWwbkUbkPznTP9ENRXpl+8xyCpUBwlQWmk6BlSEhSxl
 8MeVy3WQ28SlieA2PllCKTjidSNQtOyOkdbYc3/Xd0zVuZFjZGAimKRforKNP7gxHjm8 Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eyky7x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:34:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGP9np179724;
        Mon, 31 Aug 2020 16:34:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kkvj87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:34:49 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VGYmhC006079;
        Mon, 31 Aug 2020 16:34:48 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:34:47 -0700
Date:   Mon, 31 Aug 2020 09:34:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 03/10] xfs: Check for extent overflow when deleting an
 extent
Message-ID: <20200831163451.GL6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-4-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310099
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:42AM +0530, Chandan Babu R wrote:
> Deleting a file range from the middle of an existing extent can cause
> the per-inode extent count to increase by 1. This commit checks for
> extent count overflow in such cases.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
>  fs/xfs/xfs_bmap_item.c         | 4 ++++
>  fs/xfs/xfs_bmap_util.c         | 5 +++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 7fc2b129a2e7..2642e4847ee0 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -39,6 +39,12 @@ struct xfs_ifork {
>   * extent to a fork and there's no possibility of splitting an existing mapping.
>   */
>  #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
> +/*
> + * Removing an extent from the middle of an existing extent can cause the extent
> + * count to increase by 1.
> + * i.e. | Old extent | Hole | Old extent |
> + */
> +#define XFS_IEXT_REMOVE_CNT		(1)

The first thought that popped into my head after reading the subject
line was "UH-oh, is this going to result in undeletable files when the
extent counts hit max and the user tries to rm?"

Then I realized that "when deleting an extent" actually refers to
punching holes in the middle of files, not truncating them.

So I think at the very least the subject line should be changed to
say that we're talking about hole punching, not general file deletion;
and the constant probably ought to be called XFS_IEXT_PUNCH_CNT to make
that clearer.

Aside from that the logic seems ok to me.

(Also PS I'm not reviewing these patches in order...)

--D

>  
>  /*
>   * Fork handling.
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ec3691372e7c..b9c35fb10de4 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -519,6 +519,10 @@ xfs_bui_item_recover(
>  	}
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, whichfork, XFS_IEXT_REMOVE_CNT);
> +	if (error)
> +		goto err_inode;
> +
>  	count = bmap->me_len;
>  	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
>  			bmap->me_startoff, bmap->me_startblock, &count, state);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 7b76a48b0885..59d4da38aadf 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -891,6 +891,11 @@ xfs_unmap_extent(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_REMOVE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
>  	if (error)
>  		goto out_trans_cancel;
> -- 
> 2.28.0
> 
