Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFFCC3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 03:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E65422CF8
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 03:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfH2DEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 23:04:44 -0400
Received: from sandeen.net ([63.231.237.45]:39164 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfH2DEo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Aug 2019 23:04:44 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9712D4CDD38;
        Wed, 28 Aug 2019 22:04:42 -0500 (CDT)
Subject: Re: [PATCH v3] xfs: Fix ABBA deadlock between AGI and AGF when
 performing rename() with RENAME_WHITEOUT flag
To:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <55d0f202-62a7-0b1c-a386-2395b19b47c5@gmail.com>
 <51bf333b-7694-68dc-4434-d15cbb24ccfb@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <51f1096c-6828-5249-16f8-63996ecfa2f4@sandeen.net>
Date:   Wed, 28 Aug 2019 22:04:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <51bf333b-7694-68dc-4434-d15cbb24ccfb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/28/19 8:27 PM, kaixuxia wrote:
> ping...
> Because there isn't this patch in the latest xfs-for-next branch 
> update...

1) V3 appears to have no changes from V2.  Why was V3 sent?

2) Neither version has a reviewed-by yet, Darrick has questions outstanding
   AFAICT, they may need to be answered prior to review and merge.

-Eric
 
> 
> On 2019/8/27 10:54, kaixuxia wrote:
>> When performing rename operation with RENAME_WHITEOUT flag, we will
>> hold AGF lock to allocate or free extents in manipulating the dirents
>> firstly, and then doing the xfs_iunlink_remove() call last to hold
>> AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
>>
>> The big problem here is that we have an ordering constraint on AGF
>> and AGI locking - inode allocation locks the AGI, then can allocate
>> a new extent for new inodes, locking the AGF after the AGI. Hence
>> the ordering that is imposed by other parts of the code is AGI before
>> AGF. So we get an ABBA deadlock between the AGI and AGF here.
>>
>> Process A:
>> Call trace:
>>  ? __schedule+0x2bd/0x620
>>  schedule+0x33/0x90
>>  schedule_timeout+0x17d/0x290
>>  __down_common+0xef/0x125
>>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>>  down+0x3b/0x50
>>  xfs_buf_lock+0x34/0xf0 [xfs]
>>  xfs_buf_find+0x215/0x6c0 [xfs]
>>  xfs_buf_get_map+0x37/0x230 [xfs]
>>  xfs_buf_read_map+0x29/0x190 [xfs]
>>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>>  xfs_read_agf+0xa6/0x180 [xfs]
>>  ? schedule_timeout+0x17d/0x290
>>  xfs_alloc_read_agf+0x52/0x1f0 [xfs]
>>  xfs_alloc_fix_freelist+0x432/0x590 [xfs]
>>  ? down+0x3b/0x50
>>  ? xfs_buf_lock+0x34/0xf0 [xfs]
>>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>>  xfs_alloc_vextent+0x301/0x6c0 [xfs]
>>  xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
>>  ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
>>  xfs_dialloc+0x116/0x290 [xfs]
>>  xfs_ialloc+0x6d/0x5e0 [xfs]
>>  ? xfs_log_reserve+0x165/0x280 [xfs]
>>  xfs_dir_ialloc+0x8c/0x240 [xfs]
>>  xfs_create+0x35a/0x610 [xfs]
>>  xfs_generic_create+0x1f1/0x2f0 [xfs]
>>  ...
>>
>> Process B:
>> Call trace:
>>  ? __schedule+0x2bd/0x620
>>  ? xfs_bmapi_allocate+0x245/0x380 [xfs]
>>  schedule+0x33/0x90
>>  schedule_timeout+0x17d/0x290
>>  ? xfs_buf_find+0x1fd/0x6c0 [xfs]
>>  __down_common+0xef/0x125
>>  ? xfs_buf_get_map+0x37/0x230 [xfs]
>>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>>  down+0x3b/0x50
>>  xfs_buf_lock+0x34/0xf0 [xfs]
>>  xfs_buf_find+0x215/0x6c0 [xfs]
>>  xfs_buf_get_map+0x37/0x230 [xfs]
>>  xfs_buf_read_map+0x29/0x190 [xfs]
>>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>>  xfs_read_agi+0xa8/0x160 [xfs]
>>  xfs_iunlink_remove+0x6f/0x2a0 [xfs]
>>  ? current_time+0x46/0x80
>>  ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
>>  xfs_rename+0x57a/0xae0 [xfs]
>>  xfs_vn_rename+0xe4/0x150 [xfs]
>>  ...
>>
>> In this patch we move the xfs_iunlink_remove() call to
>> before acquiring the AGF lock to preserve correct AGI/AGF locking
>> order.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_inode.c | 83 +++++++++++++++++++++++++++---------------------------
>>  1 file changed, 42 insertions(+), 41 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 6467d5e..8ffd44f 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -3282,7 +3282,8 @@ struct xfs_iunlink {
>>  					spaceres);
>>  
>>  	/*
>> -	 * Set up the target.
>> +	 * Check for expected errors before we dirty the transaction
>> +	 * so we can return an error without a transaction abort.
>>  	 */
>>  	if (target_ip == NULL) {
>>  		/*
>> @@ -3294,6 +3295,46 @@ struct xfs_iunlink {
>>  			if (error)
>>  				goto out_trans_cancel;
>>  		}
>> +	} else {
>> +		/*
>> +		 * If target exists and it's a directory, check that whether
>> +		 * it can be destroyed.
>> +		 */
>> +		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
>> +		    (!xfs_dir_isempty(target_ip) ||
>> +		     (VFS_I(target_ip)->i_nlink > 2))) {
>> +			error = -EEXIST;
>> +			goto out_trans_cancel;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Directory entry creation below may acquire the AGF. Remove
>> +	 * the whiteout from the unlinked list first to preserve correct
>> +	 * AGI/AGF locking order. This dirties the transaction so failures
>> +	 * after this point will abort and log recovery will clean up the
>> +	 * mess.
>> +	 *
>> +	 * For whiteouts, we need to bump the link count on the whiteout
>> +	 * inode. After this point, we have a real link, clear the tmpfile
>> +	 * state flag from the inode so it doesn't accidentally get misused
>> +	 * in future.
>> +	 */
>> +	if (wip) {
>> +		ASSERT(VFS_I(wip)->i_nlink == 0);
>> +		error = xfs_iunlink_remove(tp, wip);
>> +		if (error)
>> +			goto out_trans_cancel;
>> +
>> +		xfs_bumplink(tp, wip);
>> +		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>> +		VFS_I(wip)->i_state &= ~I_LINKABLE;
>> +	}
>> +
>> +	/*
>> +	 * Set up the target.
>> +	 */
>> +	if (target_ip == NULL) {
>>  		/*
>>  		 * If target does not exist and the rename crosses
>>  		 * directories, adjust the target directory link count
>> @@ -3312,22 +3353,6 @@ struct xfs_iunlink {
>>  		}
>>  	} else { /* target_ip != NULL */
>>  		/*
>> -		 * If target exists and it's a directory, check that both
>> -		 * target and source are directories and that target can be
>> -		 * destroyed, or that neither is a directory.
>> -		 */
>> -		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
>> -			/*
>> -			 * Make sure target dir is empty.
>> -			 */
>> -			if (!(xfs_dir_isempty(target_ip)) ||
>> -			    (VFS_I(target_ip)->i_nlink > 2)) {
>> -				error = -EEXIST;
>> -				goto out_trans_cancel;
>> -			}
>> -		}
>> -
>> -		/*
>>  		 * Link the source inode under the target name.
>>  		 * If the source inode is a directory and we are moving
>>  		 * it across directories, its ".." entry will be
>> @@ -3417,30 +3442,6 @@ struct xfs_iunlink {
>>  	if (error)
>>  		goto out_trans_cancel;
>>  
>> -	/*
>> -	 * For whiteouts, we need to bump the link count on the whiteout inode.
>> -	 * This means that failures all the way up to this point leave the inode
>> -	 * on the unlinked list and so cleanup is a simple matter of dropping
>> -	 * the remaining reference to it. If we fail here after bumping the link
>> -	 * count, we're shutting down the filesystem so we'll never see the
>> -	 * intermediate state on disk.
>> -	 */
>> -	if (wip) {
>> -		ASSERT(VFS_I(wip)->i_nlink == 0);
>> -		xfs_bumplink(tp, wip);
>> -		error = xfs_iunlink_remove(tp, wip);
>> -		if (error)
>> -			goto out_trans_cancel;
>> -		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>> -
>> -		/*
>> -		 * Now we have a real link, clear the "I'm a tmpfile" state
>> -		 * flag from the inode so it doesn't accidentally get misused in
>> -		 * future.
>> -		 */
>> -		VFS_I(wip)->i_state &= ~I_LINKABLE;
>> -	}
>> -
>>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>>  	if (new_parent)
>>
> 
