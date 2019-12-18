Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B584C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 02:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B84821582
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 02:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PUc5M+bn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLRCSh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 21:18:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfLRCSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 21:18:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI2FCeT076596;
        Wed, 18 Dec 2019 02:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=yjaYCBJuu+SWa5GeVjQLohwA7fwwYFkL9vqsAB5SPrk=;
 b=PUc5M+bnYnqz2JovWViJjMQRGOaARiN84H576HCJOfVC1Iw1BYwU+gh2MXn2y7F87xQ9
 5PnzOVMGkd540Z0U/mcFKbmniCD5YIP2w3EbKPDsykHhnLZc7h9unqJ7Js7cZqy7VqDI
 ryzPThWmY1Ggh3XlmR6Al1rX2/66C7vddLXYOgqCVf12AW/+oKP5FZf12If65QkbeAUS
 C9mo0YoY9x1nNznAM89gNBum78MnPuJvisACi1QnhGjGZGwi232wW8KV1n2uwziKmJSm
 8rELPOjKleAzMPoHtYue8Jvolyfg/eGkbaONH+ectJkr6RIYqWkI8/5h4MlYmVhyZX7T Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wvq5ujn8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 02:18:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI29HP1136485;
        Wed, 18 Dec 2019 02:16:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wxm7534e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 02:16:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBI2GV0x017586;
        Wed, 18 Dec 2019 02:16:31 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 18:16:31 -0800
Date:   Tue, 17 Dec 2019 18:16:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: open code insert range extent split helper
Message-ID: <20191218021630.GG12765@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213171258.36934-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180017
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 12:12:56PM -0500, Brian Foster wrote:
> The insert range operation currently splits the extent at the target
> offset in a separate transaction and lock cycle from the one that
> shifts extents. In preparation for reworking insert range into an
> atomic operation, lift the code into the caller so it can be easily
> condensed to a single rolling transaction and lock cycle and
> eliminate the helper. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 32 ++------------------------------
>  fs/xfs/libxfs/xfs_bmap.h |  3 ++-
>  fs/xfs/xfs_bmap_util.c   | 14 +++++++++++++-
>  3 files changed, 17 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a9ad1f991ba3..2bba0f983e4f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6021,8 +6021,8 @@ xfs_bmap_insert_extents(
>   * @split_fsb is a block where the extents is split.  If split_fsb lies in a
>   * hole or the first block of extents, just return 0.
>   */
> -STATIC int
> -xfs_bmap_split_extent_at(
> +int
> +xfs_bmap_split_extent(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		split_fsb)
> @@ -6138,34 +6138,6 @@ xfs_bmap_split_extent_at(
>  	return error;
>  }
>  
> -int
> -xfs_bmap_split_extent(
> -	struct xfs_inode        *ip,
> -	xfs_fileoff_t           split_fsb)
> -{
> -	struct xfs_mount        *mp = ip->i_mount;
> -	struct xfs_trans        *tp;
> -	int                     error;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> -			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> -	if (error)
> -		return error;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -
> -	error = xfs_bmap_split_extent_at(tp, ip, split_fsb);
> -	if (error)
> -		goto out;
> -
> -	return xfs_trans_commit(tp);
> -
> -out:
> -	xfs_trans_cancel(tp);
> -	return error;
> -}
> -
>  /* Deferred mapping is only for real extents in the data fork. */
>  static bool
>  xfs_bmap_is_update_needed(
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 14d25e0b7d9c..f3259ad5c22c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -222,7 +222,8 @@ int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
>  int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
>  		bool *done, xfs_fileoff_t stop_fsb);
> -int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
> +int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
> +		xfs_fileoff_t split_offset);
>  int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
>  		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2efd78a9719e..829ab1a804c9 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1139,7 +1139,19 @@ xfs_insert_file_space(
>  	 * is not the starting block of extent, we need to split the extent at
>  	 * stop_fsb.
>  	 */
> -	error = xfs_bmap_split_extent(ip, stop_fsb);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +
> +	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
> +	if (error)
> +		goto out_trans_cancel;
> +
> +	error = xfs_trans_commit(tp);
>  	if (error)
>  		return error;
>  
> -- 
> 2.20.1
> 
