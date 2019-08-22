Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50C9C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 05:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665E6233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 05:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2pJ1hLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfHVFpw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 01:45:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41158 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbfHVFpw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 01:45:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id 196so3133635pfz.8
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 22:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V3A6DYNeJX6gWjQefmTcHId27pzuK6svaW+q8A4F6rw=;
        b=F2pJ1hLjDjiYR64lIiJokS2cCeZDydureVfrrvi4d9OPCynCCe5K6vFRL9hNWsraoR
         vgx+PICUmfkyNujZe2xt+fQdca0tSg9wWuqCN26DFy6bZZCzKizb+5I6yPGYHJEfvoeh
         Sry4sspluJy5yyJOOQVUylmezdqMWrY8cr4OPc6QWtDiNcOGdEyey8kQtA4Ygn0ugpln
         FxnX10/Sm0v0k3T1z+Lz0KCZfhQL5rnSnc+rSJIJ/nM6g2ENRgHyi+ugXMkge9jgpk27
         +yCoZeSrWy1zaSrdn20xHMv2GvRPG1j8cskadZTnvFpibHkoj/d3Ibug/yIkneWHwtvU
         xcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V3A6DYNeJX6gWjQefmTcHId27pzuK6svaW+q8A4F6rw=;
        b=fH2B2uOjLvR05rhoa3k0kJf79cDl0+31SaKjNWV8J1oP5aRT4dHyKMvKGvUy7hTWBX
         a9tUcAUVJJSM+YGrWb61ocMrNRDRNiAyxPrcmdfsR9f2I9b/Tx30rmEYCb/MF28+iZKn
         G1S53GZyoA3Lto8d+CXguSLZXAAOBMY3NPwI93cULF2w2fad7rhRjNIU372eVSwKdiHz
         tMF6obr/Mue5duaBZ6myzRrl0YzXYy18RjfGftkXKHMsv2iPbWfrz2z27wZgRJ3zq12r
         A3N3+C5oh4jwbXaZBKAW6kf1UR+psW5ZXXkGeCYX9aH+4XwxW+Cc52uKdSpnTf50DALc
         Q7bQ==
X-Gm-Message-State: APjAAAUQSqjw15HpL+KhbJCz6oNlzkHYA0uHvZg0E6yqU/Fbowakw8YR
        uQOaOKNfvv/3RZQrCf1fimIj2ww=
X-Google-Smtp-Source: APXvYqxCg9iJRQGGkNNW9PilZimAFEX7qsU0HVUV/5o8eljalnHYtcPL9JwJjtIIyS1Vq6tz4xMsRg==
X-Received: by 2002:a63:755e:: with SMTP id f30mr32335491pgn.246.1566452751377;
        Wed, 21 Aug 2019 22:45:51 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id z28sm31064958pfj.74.2019.08.21.22.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 22:45:50 -0700 (PDT)
Subject: Re: [PATCH v4] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <72adde91-556c-8af3-e217-5a658697972e@gmail.com>
 <20190822050143.GV1119@dread.disaster.area>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <3d6e190f-f88e-ef75-8dc1-9b0958706e38@gmail.com>
Date:   Thu, 22 Aug 2019 13:45:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822050143.GV1119@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2019/8/22 13:01, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 12:33:23PM +0800, kaixuxia wrote:
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
> 
> 'So we get an ABBA deadlock between the AGI and AGF here."
> 
> Can you also change the subject line to "AGI and AGF" instead of
> "agi&agf" which isn't easily searchable? e.g. "xfs: fix ABBA
> deadlock between AGI and AGF in rename()".

OK , will follow it.
> 
>>  	/*
>> -	 * Set up the target.
>> +	 * Check for expected errors before we dirty the transaction
>> +	 * so we can return an error without a transaction abort.
>>  	 */
>> -	if (target_ip == NULL) {
>> +	if (!target_ip && !spaceres) {
>>  		/*
>>  		 * If there's no space reservation, check the entry will
>>  		 * fit before actually inserting it.
>>  		 */
>> -		if (!spaceres) {
>> -			error = xfs_dir_canenter(tp, target_dp, target_name);
>> -			if (error)
>> -				goto out_trans_cancel;
>> -		}
>> +		error = xfs_dir_canenter(tp, target_dp, target_name);
>> +		if (error)
>> +			goto out_trans_cancel;
>> +	} else if (target_ip && S_ISDIR(VFS_I(target_ip)->i_mode) &&
>> +		  (!(xfs_dir_isempty(target_ip)) ||
>> +		  (VFS_I(target_ip)->i_nlink > 2))) {
>> +		/*
>> +		 * If target exists and it's a directory, check that whether
>> +		 * it can be destroyed.
>> +		 */
>> +		error = -EEXIST;
>> +		goto out_trans_cancel;
>> +	}
> 
> I do think this would be better left separate if statements like
> this:
> 
> 	if (!target_ip) {
> 		/*
> 		 * If there's no space reservation, check the entry will
> 		 * fit before actually inserting it.
> 		 */
> 		if (!spaceres) {
> 			error = xfs_dir_canenter(tp, target_dp, target_name);
> 			if (error)
> 				goto out_trans_cancel;
> 		}
> 	} else {
> 		/*
> 		 * If target exists and it's a directory, check that whether
> 		 * it can be destroyed.
> 		 */
> 		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
> 		    (!(xfs_dir_isempty(target_ip)) ||
> 		    (VFS_I(target_ip)->i_nlink > 2))) {
> 			error = -EEXIST;
> 			goto out_trans_cancel;
> 		}
> 	}
> 
> I find this much easier to read and follow the logic, and we don't
> really care if it takes a couple more lines of code to make the
> comments and code flow more logically.

Right, it is much easier to read and understand the logical.
> 
>> @@ -3419,25 +3431,15 @@ struct xfs_iunlink {
>>  
>>  	/*
>>  	 * For whiteouts, we need to bump the link count on the whiteout inode.
> 
> Shouldn't this line be removed as well?

Because the xfs_bumplink() call below will do this.
> 
>> -	 * This means that failures all the way up to this point leave the inode
>> -	 * on the unlinked list and so cleanup is a simple matter of dropping
>> -	 * the remaining reference to it. If we fail here after bumping the link
>> -	 * count, we're shutting down the filesystem so we'll never see the
>> -	 * intermediate state on disk.
>> +	 * The whiteout inode has been removed from the unlinked list and log
>> +	 * recovery will clean up the mess for the failures up to this point.
>> +	 * After this point we have a real link, clear the tmpfile state flag
>> +	 * from the inode so it doesn't accidentally get misused in future.
>>  	 */
>>  	if (wip) {
>>  		ASSERT(VFS_I(wip)->i_nlink == 0);
>>  		xfs_bumplink(tp, wip);
>> -		error = xfs_iunlink_remove(tp, wip);
>> -		if (error)
>> -			goto out_trans_cancel;
>>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>> -
>> -		/*
>> -		 * Now we have a real link, clear the "I'm a tmpfile" state
>> -		 * flag from the inode so it doesn't accidentally get misused in
>> -		 * future.
>> -		 */
>>  		VFS_I(wip)->i_state &= ~I_LINKABLE;
>>  	}
> 
> Why not move all this up into the same branch that removes the
> whiteout from the unlinked list? Why separate this logic as none of
> what is left here could cause a failure even if it is run earlier?

Yep, it could not cause a failure if we move all this into the same
branch that xfs_iunlink_remove() call. We move the xfs_iunlink_remove()
first to preserve correct AGI/AGF locking order, and maybe it is better
we bump the link count after using the whiteout inode really, such as
xfs_dir_replace(...,wip,...) ...
> 
> Cheers,
> 
> Dave.
> 

-- 
kaixuxia
