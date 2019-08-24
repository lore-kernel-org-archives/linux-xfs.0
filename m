Return-Path: <SRS0=f2ny=WU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B702EC3A5A2
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 02:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 718AD21726
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 02:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5tsDi9y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfHXCVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 22:21:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42087 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfHXCVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 22:21:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so6782664pgb.9
        for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2019 19:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CeaUTY85fxTyh2AfMcEYRujcVq14tVtnSLD1MARzInU=;
        b=H5tsDi9yxixfOhHCZnRdketVnZy+psqYg7Q1ytdYq2CMrw/T1EDz7OqXK135jsQxKU
         FgUORYqp6N2ejmjSMGn2+i2XY7HGChsCq/2JGPr/EGk0xk+AoT/tC6N9a04SpF/2eRMA
         O/Kou22KuJ3OORUCQ9Poggbh3Sq9F6NbrEcxYDr/kbowm+yLI8TJWniUz4521zdhkn11
         BoVEboFgKDe80iepodsUM9Hl/XWi9rHAJTAYLHYZw0e8AkTXI+g8Io1pSzWsY1z3zaoE
         zLRJqF3nIXaMUnu2zZu8I8ZvHEPSh5P+VKyNfZVIC821uyexEr1INrSQ9Jsn/LLYy73L
         T13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CeaUTY85fxTyh2AfMcEYRujcVq14tVtnSLD1MARzInU=;
        b=fwGPGwDBr+hqYCL206bpHF03ZzjZK+tr1Hh6znCl8Kryit74SsQGiBD92W4Wt+x3xf
         hl8ls8aAFjYEXT3sRpgSxG6E0V7yKkFFAJaDFq2pmWF1qxNtQGRvdbA+tPac3jP89YK+
         RWvyNQaqo2oS93K9PuJ8fh0OY19YgFwmNoJcloVBSHMRaToUJSWR9RdFTk2+HLJFmwPC
         z5OCevEPxwFXg5KNlnZdjLypM2s/NruykcFoUgdppquuCX7i9IYvjFOfULpAWh8oIBSA
         3mfqgKqGj3O3bddlGU5Vpq8spME6nYcTT4Ml6/dW81XT5nJy+CmuXjI/4akerMuz62MO
         rlWw==
X-Gm-Message-State: APjAAAU18oj5hvmN2G61F6+KMk+n2K+ZGsAJhu6xnp9tc1yXHp7znZlA
        GofunHk52VyycOWUHwnOkQ==
X-Google-Smtp-Source: APXvYqyOFFvbGIphQ0KxtKY5Lvl95sJ3TX80n1XH346U4snlryWLJBs55yutLN5H+5xWZAjZQnpo6A==
X-Received: by 2002:a62:be0c:: with SMTP id l12mr8712244pff.224.1566613293932;
        Fri, 23 Aug 2019 19:21:33 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id f7sm3960181pfd.43.2019.08.23.19.21.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 19:21:33 -0700 (PDT)
Subject: Re: [PATCH] xfs: Fix ABBA deadlock between AGI and AGF in rename()
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <08753b9e-4da1-ca61-af12-0b4aad8ed516@gmail.com>
 <20190823140713.GA54025@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <318da25c-06d2-e22f-3cae-ae130f1bb013@gmail.com>
Date:   Sat, 24 Aug 2019 10:21:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190823140713.GA54025@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/8/23 22:07, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 12:56:53PM +0800, kaixuxia wrote:
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
> ...
>>
>> In this patch we move the xfs_iunlink_remove() call to
>> before acquiring the AGF lock to preserve correct AGI/AGF locking
>> order.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_inode.c | 85 +++++++++++++++++++++++++++---------------------------
>>  1 file changed, 43 insertions(+), 42 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 6467d5e..584b9d1 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -3282,9 +3282,10 @@ struct xfs_iunlink {
>>  					spaceres);
>>  
>>  	/*
>> -	 * Set up the target.
>> +	 * Check for expected errors before we dirty the transaction
>> +	 * so we can return an error without a transaction abort.
>>  	 */
>> -	if (target_ip == NULL) {
>> +	if (!target_ip) {
> 
> Not sure there's really a point to this change now.
> 
>>  		/*
>>  		 * If there's no space reservation, check the entry will
>>  		 * fit before actually inserting it.
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
>> +		    (!(xfs_dir_isempty(target_ip)) ||
>> +		    (VFS_I(target_ip)->i_nlink > 2))) {
> 
> ^ This line needs one more space of indent because it's encapsulated by
> the opening brace one line up. The braces around xfs_dir_isempty() also
> look spurious, FWIW. With those nits fixed, the rest looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks! I will send the new patch to address them with your 
Reviewed-by.
> 
> Thanks for the patch.
> 
> Brian
> 
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
>> -- 
>> 1.8.3.1
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
