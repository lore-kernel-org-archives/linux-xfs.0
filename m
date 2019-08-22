Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F470C3A59E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 02:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54B222339E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 02:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B55EYnog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfHVCIF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 22:08:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41028 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729805AbfHVCIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 22:08:05 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so2432917pls.8
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 19:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hgOALN0sFaGowM5PVyNJfEy9jEW5V5Ciqgi6C7xL+Uc=;
        b=B55EYnogA0dgSjXmB1mjpZtIMzaPH5f1bc3GdlkILzKobac1YzHM1WV5nyomvSL39d
         qZZqZVBhcsMGekOvHWWiGHfkGqYsPPQ3+yqSj+FGv1zktVSnCo1KeqD6mdUWb1ghtPkA
         6A6ZhXBrbfG8D0oZG9XIGjI3eK6C64dhVCD3KhrQlbNGa2n/p+HqIUgjPqwEXXKWaLEG
         mn+Ar2cU54s97dv/HSbpFumTgD4V3qJXaufQxkXTFJk3aIORnRvl0e3A4mOFsiJwyCjz
         P2K5W1Nqv+iDk0qLZThSCQLbQYlwNHX3mJtzQaNmCea0m4JF2Vjf5hJb3Zp/cDwcgV6w
         Iyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hgOALN0sFaGowM5PVyNJfEy9jEW5V5Ciqgi6C7xL+Uc=;
        b=brkfETJkqLHB+u0JcPZd/UnGpmqODJzWlfzVfwRMn93MkVwB4veiwgbvjapEH4HTaS
         Wp9uVWkyR3bnHv28wQFclN37LLeCpru8F0cMCilgNZvvTQFSVAzxa4lkWHOfadfIe81+
         Utfts3e5uIab7FJr1ZXdTlksy7drOUD7s60H0OPUeQki3mJ4/mDpmSl2D1cr0O4F5W0d
         qP4L5olS0Dcj1qZjkuLTmIfcQ6YeMKyxYLl+BcTuXLE6chSvxQ4q8A4JBPlvcoDq/0Fr
         HrfYEEpct55hNg4Rzi7LpLrbmV/HcyL7pFM3GTjgbufkTfZePH6H9sfiMjJ5kmaOY1a/
         6a1g==
X-Gm-Message-State: APjAAAVix1TQ2ZkNM27szzxW7wWVFjcp8LxWmE+SyPbU+c+KQCjPhyN3
        9yKQ2eZG7SjJGpV5smCBxA==
X-Google-Smtp-Source: APXvYqyWdIjVDeN+1zP8COXY5A4qFjrMVmTYu6a+PCaputchIDkz/pJ3b1eGH2Yfr8DEcy7I4AFCrQ==
X-Received: by 2002:a17:902:b193:: with SMTP id s19mr26708420plr.16.1566439684445;
        Wed, 21 Aug 2019 19:08:04 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id c71sm25979687pfc.106.2019.08.21.19.08.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 19:08:03 -0700 (PDT)
Subject: Re: [PATCH v3] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <cc2a0c81-ee9e-d2bd-9cc0-025873f394c0@gmail.com>
 <20190821112533.GB16669@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <7fef5acc-eabd-4ee0-c6a1-f2974a3f0c42@gmail.com>
Date:   Thu, 22 Aug 2019 10:07:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821112533.GB16669@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/8/21 19:25, Brian Foster wrote:
> On Wed, Aug 21, 2019 at 12:46:18PM +0800, kaixuxia wrote:
>> When performing rename operation with RENAME_WHITEOUT flag, we will
>> hold AGF lock to allocate or free extents in manipulating the dirents
>> firstly, and then doing the xfs_iunlink_remove() call last to hold
>> AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
>>
>> The big problem here is that we have an ordering constraint on AGF
>> and AGI locking - inode allocation locks the AGI, then can allocate
>> a new extent for new inodes, locking the AGF after the AGI. Hence
>> the ordering that is imposed by other parts of the code is AGI before
>> AGF. So we get the ABBA agi&agf deadlock here.
>>
> ...
>>
>> In this patch we move the xfs_iunlink_remove() call to
>> before acquiring the AGF lock to preserve correct AGI/AGF locking
>> order.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
> 
> FYI, I see this when I pull in this patch:
> 
> warning: Patch sent with format=flowed; space at the end of lines might be lost.
> 
> Not sure what it means or if it matters. :P

This is my Thunderbird edit config problem, will fix it. :) 
> 
> Otherwise this looks much better to me generally. Just some nits..
> 
>>  fs/xfs/xfs_inode.c | 61 ++++++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 38 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 6467d5e..cf06568 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -3282,7 +3282,8 @@ struct xfs_iunlink {
>>  					spaceres);
>>
>>  	/*
>> -	 * Set up the target.
>> +	 * Error checks before we dirty the transaction, return
>> +	 * the error code if check failed and the filesystem is clean.
> 
> I'm not sure what "filesystem is clean" refers to here. I think you mean
> transaction, but I'm wondering if something like the following is a bit
> more clear:
> 
> "Check for expected errors before we dirty the transaction so we can
> return an error without a transaction abort."
> 
>>  	 */
>>  	if (target_ip == NULL) {
>>  		/*
>> @@ -3294,6 +3295,40 @@ struct xfs_iunlink {
>>  			if (error)
>>  				goto out_trans_cancel;
>>  		}
>> +	} else {
>> +		/*
>> +		 * If target exists and it's a directory, check that both
>> +		 * target and source are directories and that target can be
>> +		 * destroyed, or that neither is a directory.
>> +		 */
> 
> Interesting that the existing comment refers to checking the source
> inode, but that doesn't happen in the code. That's not a bug in this
> patch, but are we missing a check here or is the comment stale?
> 
>> +		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
>> +			/*
>> +			 * Make sure target dir is empty.
>> +			 */
>> +			if (!(xfs_dir_isempty(target_ip)) ||
>> +			    (VFS_I(target_ip)->i_nlink > 2)) {
>> +				error = -EEXIST;
>> +				goto out_trans_cancel;
>> +			}
>> +		}
>> +	}
> 
> Code seems fine, but I think we could save some lines by condensing the
> logic a bit. For example:
> 
> 	/*
> 	 * ...
> 	 */
> 	if (!target_ip && !spaceres) {
> 		/* check for a no res dentry creation */
> 		error = xfs_dir_canenter();
> 		...
> 	} else if (target_ip && S_ISDIR(VFS_I(target_ip)->i_mode) &&
> 		   (!(xfs_dir_isempty(target_ip)) || 
> 		    (VFS_I(target_ip)->i_nlink > 2)))
> 		/* can't rename over a non-empty directory */
> 		error = -EEXIST;
> 		goto out_trans_cancel;
> 	}
> 
> Hm? Note that we use an 80 column limit, but we also want to expand
> short lines to that limit as much as possible and use alignment to make
> logic easier to read.
> 
>> +
>> +	/*
>> +	 * Directory entry creation below may acquire the AGF. Remove
>> +	 * the whiteout from the unlinked list first to preserve correct
>> +	 * AGI/AGF locking order.
>> +	 */
>> +	if (wip) {
>> +		ASSERT(VFS_I(wip)->i_nlink == 0);
>> +		error = xfs_iunlink_remove(tp, wip);
>> +		if (error)
>> +			goto out_trans_cancel;
>> +	}
>> +
>> +	/*
>> +	 * Set up the target.
>> +	 */
>> +	if (target_ip == NULL) {
>>  		/*
>>  		 * If target does not exist and the rename crosses
>>  		 * directories, adjust the target directory link count
>> @@ -3312,22 +3347,6 @@ struct xfs_iunlink {
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
>> @@ -3421,16 +3440,12 @@ struct xfs_iunlink {
>>  	 * For whiteouts, we need to bump the link count on the whiteout inode.
>>  	 * This means that failures all the way up to this point leave the inode
>>  	 * on the unlinked list and so cleanup is a simple matter of dropping
>> -	 * the remaining reference to it. If we fail here after bumping the link
>> -	 * count, we're shutting down the filesystem so we'll never see the
>> -	 * intermediate state on disk.
>> +	 * the remaining reference to it. Move the xfs_iunlink_remove() call to
>> +	 * before acquiring the AGF lock to preserve correct AGI/AGF locking order.
> 
> With this change, the earlier part of this comment about failures up
> this point leaving the whiteout on the unlinked list is no longer true.
> We've already removed it earlier in the function. Also, the new bit
> about "moving" the call is confusing because it describes more what this
> patch does vs the current code.
> 
> I'd suggest a new comment that combines with the one within this branch
> (not shown in the patch). For example:
> 
>         /*
>          * For whiteouts, we need to bump the link count on the whiteout inode.
>          * This means that failures all the way up to this point leave the inode
>          * on the unlinked list and so cleanup is a simple matter of dropping
>          * the remaining reference to it. If we fail here after bumping the link
>          * count, we're shutting down the filesystem so we'll never see the
>          * intermediate state on disk.
>          */
> 
> And then remove the comment inside the branch. FWIW, you could also add
> a sentence to the earlier comment where the wip is removed like: "This
> dirties the transaction so failures after this point will abort and log
> recovery will clean up the mess."

Thanks a lot for all the comments. I will address them and send
the new patch.
> 
> Brian
> 
>>  	 */
>>  	if (wip) {
>>  		ASSERT(VFS_I(wip)->i_nlink == 0);
>>  		xfs_bumplink(tp, wip);
>> -		error = xfs_iunlink_remove(tp, wip);
>> -		if (error)
>> -			goto out_trans_cancel;
>>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>>
>>  		/*
>> -- 
>> 1.8.3.1
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
