Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCC5C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 144B92084F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RIUSiwaX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfKLQfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:35:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfKLQfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 11:35:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGYF0q141023;
        Tue, 12 Nov 2019 16:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7U+vJ5ykd6RtiT5knkekFyIeP1pWckdTw7PC6g25Xmo=;
 b=RIUSiwaXlAfB0+gRNGrZ7TgCdJpGanJmiFhk3J85NsWla8llqLsf8hIcmENrhlfTIPXR
 9/G/Ng0swxqG/GumHJL0zqwy/2b9Cm+IAhLb4YoPMvyReteousx7n7CNx3IgZFK3qhNH
 Aeq13SKITfbva6ump//QRkwSumPRj01M6B35Oz7DDycoXjojCDr9GOWand1cE3CN8xIC
 ch+Kf0TOO/TKcSmP5hKWxSs7YCJXnRUzlAZSwKsaT3qVWgryzCzK3Ek5DU7VNHJS81LD
 N7TGrWuRUDHG7vtyyDolKKE0+qCf9q/XpGmCa/XxKX7LKxC4U6J+UPIoXQr2F5yAX0Zg QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w5p3qnyfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:34:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGSUFN099074;
        Tue, 12 Nov 2019 16:34:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w7vpmjgu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:34:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xACGYHhH018401;
        Tue, 12 Nov 2019 16:34:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 08:34:16 -0800
Date:   Tue, 12 Nov 2019 08:34:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v4] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191112163414.GA6219@magnolia>
References: <1573557210-6241-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573557210-6241-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 07:13:30PM +0800, kaixuxia wrote:
> When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
> need to hold the AGF lock to allocate more blocks, and then invoking
> the xfs_droplink() call to hold AGI lock to drop target_ip onto the
> unlinked list, so we get the lock order AGF->AGI. This would break the
> ordering constraint on AGI and AGF locking - inode allocation locks
> the AGI, then can allocate a new extent for new inodes, locking the
> AGF after the AGI.
> 
> In this patch we check whether the replace operation need more
> blocks firstly. If so, acquire the agi lock firstly to preserve
> locking order(AGI/AGF). Actually, the locking order problem only
> occurs when we are locking the AGI/AGF of the same AG. For multiple
> AGs the AGI lock will be released after the transaction committed.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
> Changes in v4:
>  -Remove the typedef usages.
>  -Invoke xfs_dir2_sf_replace_needblock() in
>   xfs_dir2_sf_replace() directly.
> 
>  fs/xfs/libxfs/xfs_dir2.h    |  2 ++
>  fs/xfs/libxfs/xfs_dir2_sf.c | 28 +++++++++++++++++++++++-----
>  fs/xfs/xfs_inode.c          | 15 +++++++++++++++
>  3 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index f542447..01b1722 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t ino,
>  				xfs_extlen_t tot);
> +extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> +				xfs_ino_t inum);
>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t inum,
>  				xfs_extlen_t tot);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 85f14fc..0e112e1 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -945,6 +945,27 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
>  }
>  
>  /*
> + * Check whether the sf dir replace operation need more blocks.
> + */
> +bool
> +xfs_dir2_sf_replace_needblock(
> +	struct xfs_inode	*dp,
> +	xfs_ino_t		inum)
> +{
> +	int			newsize;
> +	struct xfs_dir2_sf_hdr	*sfp;
> +
> +	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> +		return false;
> +
> +	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
> +	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
> +
> +	return inum > XFS_DIR2_MAX_SHORT_INUM &&
> +	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
> +}
> +
> +/*
>   * Replace the inode number of an entry in a shortform directory.
>   */
>  int						/* error */
> @@ -980,17 +1001,14 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
>  	 */
>  	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
>  		int	error;			/* error return value */
> -		int	newsize;		/* new inode size */
>  
> -		newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
>  		/*
>  		 * Won't fit as shortform, convert to block then do replace.
>  		 */
> -		if (newsize > XFS_IFORK_DSIZE(dp)) {
> +		if (xfs_dir2_sf_replace_needblock(dp, args->inumber)) {
>  			error = xfs_dir2_sf_to_block(args);
> -			if (error) {
> +			if (error)
>  				return error;
> -			}
>  			return xfs_dir2_block_replace(args);
>  		}
>  		/*
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 18f4b26..5dc3796 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3196,6 +3196,7 @@ struct xfs_iunlink {
>  	struct xfs_trans	*tp;
>  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
>  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> +	struct xfs_buf		*agibp;
>  	int			num_inodes = __XFS_SORT_INODES;
>  	bool			new_parent = (src_dp != target_dp);
>  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> @@ -3361,6 +3362,20 @@ struct xfs_iunlink {
>  		 * In case there is already an entry with the same
>  		 * name at the destination directory, remove it first.
>  		 */
> +
> +		/*
> +		 * Check whether the replace operation need more blocks.
> +		 * If so, acquire the agi lock firstly to preserve locking
> +		 * order (AGI/AGF). Only convert the shortform directory to
> +		 * block form maybe need more blocks.

The comment still seems a little clunky.  How about:

"Check whether the replace operation will need to allocate blocks.  This
happens when the shortform directory lacks space and we have to convert
it to a block format directory.  When more blocks are necessary we must
lock the AGI first to preserve locking order (AGI -> AGF)."

> +		 */
> +		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
> +			error = xfs_read_agi(mp, tp,
> +				XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);

The second line needs a double indent.

I can fix both of these on commit if Brian doesn't have any further
suggestions.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +			if (error)
> +				goto out_trans_cancel;
> +		}
> +
>  		error = xfs_dir_replace(tp, target_dp, target_name,
>  					src_ip->i_ino, spaceres);
>  		if (error)
> -- 
> 1.8.3.1
> 
