Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DFEC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED2B921835
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c2W3BW8i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfLQRCt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:02:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56586 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQRCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 12:02:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHGdAie185226;
        Tue, 17 Dec 2019 17:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/XNCjIRZvh1KTNHjBM3crNGdR8yh+/nSD+E/1JaBLkc=;
 b=c2W3BW8ilRAFTRAr0PBWdi666HN6JezsqesRiXsJ1ZKwHNaGc6MII3m9eEOE3zpcYivY
 ctESnRyfXXcn7SMpQeawh2b9laUINAwsUZNszCXJ9hN2/z1DUy1aFdB9MJYucGcP/gYS
 io8hTyeJlvMcm4tkaAJA8e7nwZKLN04ttnYJpC77nSk83Xb9lJbZHa5Duyv0K5koxfo8
 l3Ji1Bo+TD8XmLPhe0A/auQrkQyPQbhI/TiU5qSpvlSz5B2+fozsSTWSzSAgQDzxIHk3
 qA7sKIHzH64wJnRZ118QQNmPXeDWAeGSUqGMuRohz7ARK+tzz5qFmx/bBFZpsljGjPht vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wvqpq82h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 17:02:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHGcrNL002191;
        Tue, 17 Dec 2019 17:02:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wxm72p71p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 17:02:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBHH2hix013929;
        Tue, 17 Dec 2019 17:02:43 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 09:02:43 -0800
Subject: Re: [PATCH 1/3] xfs: open code insert range extent split helper
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-2-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d1d7f488-c10a-2c34-39b7-09b537994d89@oracle.com>
Date:   Tue, 17 Dec 2019 10:02:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191213171258.36934-2-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/13/19 10:12 AM, Brian Foster wrote:
> The insert range operation currently splits the extent at the target
> offset in a separate transaction and lock cycle from the one that
> shifts extents. In preparation for reworking insert range into an
> atomic operation, lift the code into the caller so it can be easily
> condensed to a single rolling transaction and lock cycle and
> eliminate the helper. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok to me.

Reviewed by: Allison Collins <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c | 32 ++------------------------------
>   fs/xfs/libxfs/xfs_bmap.h |  3 ++-
>   fs/xfs/xfs_bmap_util.c   | 14 +++++++++++++-
>   3 files changed, 17 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a9ad1f991ba3..2bba0f983e4f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6021,8 +6021,8 @@ xfs_bmap_insert_extents(
>    * @split_fsb is a block where the extents is split.  If split_fsb lies in a
>    * hole or the first block of extents, just return 0.
>    */
> -STATIC int
> -xfs_bmap_split_extent_at(
> +int
> +xfs_bmap_split_extent(
>   	struct xfs_trans	*tp,
>   	struct xfs_inode	*ip,
>   	xfs_fileoff_t		split_fsb)
> @@ -6138,34 +6138,6 @@ xfs_bmap_split_extent_at(
>   	return error;
>   }
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
>   /* Deferred mapping is only for real extents in the data fork. */
>   static bool
>   xfs_bmap_is_update_needed(
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 14d25e0b7d9c..f3259ad5c22c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -222,7 +222,8 @@ int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
>   int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>   		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
>   		bool *done, xfs_fileoff_t stop_fsb);
> -int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
> +int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
> +		xfs_fileoff_t split_offset);
>   int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>   		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
>   		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2efd78a9719e..829ab1a804c9 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1139,7 +1139,19 @@ xfs_insert_file_space(
>   	 * is not the starting block of extent, we need to split the extent at
>   	 * stop_fsb.
>   	 */
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
>   	if (error)
>   		return error;
>   
> 
