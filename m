Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD199C3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 01:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74E29215EA
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 01:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOON+qrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfH2B1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 21:27:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45112 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfH2B1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 21:27:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so648027pgp.12
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 18:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lybQwmkSywGY6VJPerqA1d4tZAxxHJ7vK0Gvnr9Vtvc=;
        b=UOON+qrM0pHG7/vVxYs95AOICSCJJBMQPJ/kyngXdGrrwRqkIJ/xQXn6fluwvb9fkX
         m1UPbT3XDkv1XtuUTuf7cuF6SVpd5ltUg3bG46RasNuZVHg9FNP4Myg8VW3+p8rPQolS
         ISLrOkuhlodgYDKwyi2zJVI5Auh2e3pmQ5evLJKSA/Zc+g9ODMwYqXbv4FbToMRAUDzD
         6/OHz+5esMRZ08aVkTravWkGJcDffoEIJe6Uaq5ilgb3zSI9N2VvlvJa94goKFpsyZBc
         SVXwmpAx2robpKOLl2UXT3DRvde6grvO73gX3dSRPiibrqHUjvKfNezFhyGKHQPShcH0
         VZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lybQwmkSywGY6VJPerqA1d4tZAxxHJ7vK0Gvnr9Vtvc=;
        b=jRbyYMKFUxoMpxkNmnD7UXDgRRxmzsepS+a9EEW/BNSWrQWBE6Tchte4VXKtOVClbJ
         MJUxth2q5US4TDcIS0dkwktiBZEqu2ULW1KPxsnmNBORaJz0ZPrhoBWIy9VzGsQsrqD7
         D0wq/h4TKhB8iqry24U9LpSOK2y/vsyht/abUqIzAwTjWyRTozo4sW5AT+05AX1Meipv
         mHZlsu05mOqu0cC00BUGpBCBVS17xRHezWTnQUBxpmOTSzmB+9nVrtiR5G9patK4sJtb
         S9To3wn0f3fyktKeC++Fp3CO0jkXAyy4uXhJCJujdMXiG/wuas82vaPEgKxXULNnN8V4
         98qQ==
X-Gm-Message-State: APjAAAXLG9X7dR7KEMtX6djEwm9fn9eCxauWpDew4EetL6dsEspPLmOX
        sqhFyqLYX9qjoOEbK2HgsA==
X-Google-Smtp-Source: APXvYqxKwYyhErFUJ+yBeO0bv3zh7DPhc/FNPqy+6qbaF5DA2yk0pxgsmOSdTIBDhiZMiFMr3Ae6gg==
X-Received: by 2002:a63:c246:: with SMTP id l6mr6097961pgg.210.1567042027426;
        Wed, 28 Aug 2019 18:27:07 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id 65sm672853pff.148.2019.08.28.18.27.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 18:27:06 -0700 (PDT)
Subject: Re: [PATCH v3] xfs: Fix ABBA deadlock between AGI and AGF when
 performing rename() with RENAME_WHITEOUT flag
To:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <55d0f202-62a7-0b1c-a386-2395b19b47c5@gmail.com>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <51bf333b-7694-68dc-4434-d15cbb24ccfb@gmail.com>
Date:   Thu, 29 Aug 2019 09:27:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <55d0f202-62a7-0b1c-a386-2395b19b47c5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

ping...
Because there isn't this patch in the latest xfs-for-next branch 
update...


On 2019/8/27 10:54, kaixuxia wrote:
> When performing rename operation with RENAME_WHITEOUT flag, we will
> hold AGF lock to allocate or free extents in manipulating the dirents
> firstly, and then doing the xfs_iunlink_remove() call last to hold
> AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> 
> The big problem here is that we have an ordering constraint on AGF
> and AGI locking - inode allocation locks the AGI, then can allocate
> a new extent for new inodes, locking the AGF after the AGI. Hence
> the ordering that is imposed by other parts of the code is AGI before
> AGF. So we get an ABBA deadlock between the AGI and AGF here.
> 
> Process A:
> Call trace:
>  ? __schedule+0x2bd/0x620
>  schedule+0x33/0x90
>  schedule_timeout+0x17d/0x290
>  __down_common+0xef/0x125
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  down+0x3b/0x50
>  xfs_buf_lock+0x34/0xf0 [xfs]
>  xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_buf_get_map+0x37/0x230 [xfs]
>  xfs_buf_read_map+0x29/0x190 [xfs]
>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>  xfs_read_agf+0xa6/0x180 [xfs]
>  ? schedule_timeout+0x17d/0x290
>  xfs_alloc_read_agf+0x52/0x1f0 [xfs]
>  xfs_alloc_fix_freelist+0x432/0x590 [xfs]
>  ? down+0x3b/0x50
>  ? xfs_buf_lock+0x34/0xf0 [xfs]
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_alloc_vextent+0x301/0x6c0 [xfs]
>  xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
>  ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
>  xfs_dialloc+0x116/0x290 [xfs]
>  xfs_ialloc+0x6d/0x5e0 [xfs]
>  ? xfs_log_reserve+0x165/0x280 [xfs]
>  xfs_dir_ialloc+0x8c/0x240 [xfs]
>  xfs_create+0x35a/0x610 [xfs]
>  xfs_generic_create+0x1f1/0x2f0 [xfs]
>  ...
> 
> Process B:
> Call trace:
>  ? __schedule+0x2bd/0x620
>  ? xfs_bmapi_allocate+0x245/0x380 [xfs]
>  schedule+0x33/0x90
>  schedule_timeout+0x17d/0x290
>  ? xfs_buf_find+0x1fd/0x6c0 [xfs]
>  __down_common+0xef/0x125
>  ? xfs_buf_get_map+0x37/0x230 [xfs]
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  down+0x3b/0x50
>  xfs_buf_lock+0x34/0xf0 [xfs]
>  xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_buf_get_map+0x37/0x230 [xfs]
>  xfs_buf_read_map+0x29/0x190 [xfs]
>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>  xfs_read_agi+0xa8/0x160 [xfs]
>  xfs_iunlink_remove+0x6f/0x2a0 [xfs]
>  ? current_time+0x46/0x80
>  ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
>  xfs_rename+0x57a/0xae0 [xfs]
>  xfs_vn_rename+0xe4/0x150 [xfs]
>  ...
> 
> In this patch we move the xfs_iunlink_remove() call to
> before acquiring the AGF lock to preserve correct AGI/AGF locking
> order.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 83 +++++++++++++++++++++++++++---------------------------
>  1 file changed, 42 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6467d5e..8ffd44f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3282,7 +3282,8 @@ struct xfs_iunlink {
>  					spaceres);
>  
>  	/*
> -	 * Set up the target.
> +	 * Check for expected errors before we dirty the transaction
> +	 * so we can return an error without a transaction abort.
>  	 */
>  	if (target_ip == NULL) {
>  		/*
> @@ -3294,6 +3295,46 @@ struct xfs_iunlink {
>  			if (error)
>  				goto out_trans_cancel;
>  		}
> +	} else {
> +		/*
> +		 * If target exists and it's a directory, check that whether
> +		 * it can be destroyed.
> +		 */
> +		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
> +		    (!xfs_dir_isempty(target_ip) ||
> +		     (VFS_I(target_ip)->i_nlink > 2))) {
> +			error = -EEXIST;
> +			goto out_trans_cancel;
> +		}
> +	}
> +
> +	/*
> +	 * Directory entry creation below may acquire the AGF. Remove
> +	 * the whiteout from the unlinked list first to preserve correct
> +	 * AGI/AGF locking order. This dirties the transaction so failures
> +	 * after this point will abort and log recovery will clean up the
> +	 * mess.
> +	 *
> +	 * For whiteouts, we need to bump the link count on the whiteout
> +	 * inode. After this point, we have a real link, clear the tmpfile
> +	 * state flag from the inode so it doesn't accidentally get misused
> +	 * in future.
> +	 */
> +	if (wip) {
> +		ASSERT(VFS_I(wip)->i_nlink == 0);
> +		error = xfs_iunlink_remove(tp, wip);
> +		if (error)
> +			goto out_trans_cancel;
> +
> +		xfs_bumplink(tp, wip);
> +		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> +		VFS_I(wip)->i_state &= ~I_LINKABLE;
> +	}
> +
> +	/*
> +	 * Set up the target.
> +	 */
> +	if (target_ip == NULL) {
>  		/*
>  		 * If target does not exist and the rename crosses
>  		 * directories, adjust the target directory link count
> @@ -3312,22 +3353,6 @@ struct xfs_iunlink {
>  		}
>  	} else { /* target_ip != NULL */
>  		/*
> -		 * If target exists and it's a directory, check that both
> -		 * target and source are directories and that target can be
> -		 * destroyed, or that neither is a directory.
> -		 */
> -		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
> -			/*
> -			 * Make sure target dir is empty.
> -			 */
> -			if (!(xfs_dir_isempty(target_ip)) ||
> -			    (VFS_I(target_ip)->i_nlink > 2)) {
> -				error = -EEXIST;
> -				goto out_trans_cancel;
> -			}
> -		}
> -
> -		/*
>  		 * Link the source inode under the target name.
>  		 * If the source inode is a directory and we are moving
>  		 * it across directories, its ".." entry will be
> @@ -3417,30 +3442,6 @@ struct xfs_iunlink {
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	/*
> -	 * For whiteouts, we need to bump the link count on the whiteout inode.
> -	 * This means that failures all the way up to this point leave the inode
> -	 * on the unlinked list and so cleanup is a simple matter of dropping
> -	 * the remaining reference to it. If we fail here after bumping the link
> -	 * count, we're shutting down the filesystem so we'll never see the
> -	 * intermediate state on disk.
> -	 */
> -	if (wip) {
> -		ASSERT(VFS_I(wip)->i_nlink == 0);
> -		xfs_bumplink(tp, wip);
> -		error = xfs_iunlink_remove(tp, wip);
> -		if (error)
> -			goto out_trans_cancel;
> -		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> -
> -		/*
> -		 * Now we have a real link, clear the "I'm a tmpfile" state
> -		 * flag from the inode so it doesn't accidentally get misused in
> -		 * future.
> -		 */
> -		VFS_I(wip)->i_state &= ~I_LINKABLE;
> -	}
> -
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
> 

-- 
kaixuxia
