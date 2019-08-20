Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825EAC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 06:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5394222CF8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 06:45:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tMJBPDZV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfHTGpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 02:45:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33874 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbfHTGpm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 02:45:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so2781049pfp.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 23:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qL2TS9Uo+N/bRNOzZy9bfaoWnc9i2ZNKG2/G7qvSZ38=;
        b=tMJBPDZVFL3fOlq7uu/Y3FsF4vJngoExieNaG/v+x8jhbsHcYgFgFtLdsOVp5+AKBR
         8TtqKuiAem8QbETGjs3wqMuIU8Tu2btzFxovI01PMMSjGJwEfKD5UY+liNYBWP1jwHX+
         JsF9hMhthHDtv3KkmV4s7ifbREDICV+k33S3swau6LwjY6cbc55Bme3sMGNxeVyJECx4
         zHCVYsFCJyBv7LHzz0aWGhGBzDjm08bGshZCAieteMCtyXt0Rq4X5Tr2Ck13VtiOZQ4Y
         cglPwaCwQQkfwCNfCzBN4HrH94jXcGN0gXA+kZqZad4Mq5tavi9un/S04jKiHY2/fe2G
         7dMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qL2TS9Uo+N/bRNOzZy9bfaoWnc9i2ZNKG2/G7qvSZ38=;
        b=SsLjoXbHJnMvrWormj3DQoYz+/qqeIWsSjNZL/oeE1tj+Wcpy9WHXIL9BTx/4uY0KM
         TQSr209neTWGjCSnEzqS7UotYG9Xc36X2JesY2NFCDIzdOGuCLhobUJlb0ycZunhzjYI
         RRzWnth92ih9kZI6PlQ8w/OP51zNg2zAeU/IfkGLIbWGweJ9xsHBucoIw8/Zabi3EnXb
         h0u35rHirzoaAcgyobCts6I6K81w4lKsD9jRDaEzXPUC8nCFr+4mXoKmJBTUhh1Jz5f9
         zb0sU8yBJi1PPoHK/leCjjGNzV8cJ1DNsKaBUne0FLXNPqR6At/STdM4RAp7yuQCBbeo
         nL/A==
X-Gm-Message-State: APjAAAWLfq4kkXrRhV0zDhdP0x1+/eiJ8UWT1UhmptVsw5rqzj8HPwiA
        NbG2zl8sOjQp0aMmlSOxbQ==
X-Google-Smtp-Source: APXvYqzI4NsTBmGMFP7YgudWbk6XZPwzTYYYbjb7i1zr6VlobuHOmUZj3jWtdLGrC0tkR44lHVVAPw==
X-Received: by 2002:a63:5550:: with SMTP id f16mr24287771pgm.426.1566283541422;
        Mon, 19 Aug 2019 23:45:41 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id ay7sm15153043pjb.4.2019.08.19.23.45.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 23:45:40 -0700 (PDT)
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
Date:   Tue, 20 Aug 2019 14:45:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819151335.GB2875@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/8/19 23:13, Brian Foster wrote:
> On Mon, Aug 19, 2019 at 09:06:39PM +0800, kaixuxia wrote:
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
>> In this patch we move the xfs_iunlink_remove() call to between
>> xfs_dir_canenter() and xfs_dir_createname(). By doing xfs_iunlink
>> _remove() firstly, we remove the AGI/AGF lock inversion problem.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
>>   fs/xfs/xfs_inode.c | 20 +++++++++++++++++---
>>   1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 6467d5e..48691f2 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -3294,6 +3294,18 @@ struct xfs_iunlink {
>>   			if (error)
>>   				goto out_trans_cancel;
>>   		}
>> +
>> +		/*
>> +		 * Handle the whiteout inode and acquire the AGI lock, so
>> +		 * fix the AGI/AGF lock inversion problem.
>> +		 */
> 
> The comment could be a little more specific. For example:
> 
> "Directory entry creation may acquire the AGF. Remove the whiteout from
> the unlinked list first to preserve correct AGI/AGF locking order."

Right, makes more sense.

> 
>> +		if (wip) {
>> +			ASSERT(VFS_I(wip)->i_nlink == 0);
>> +			error = xfs_iunlink_remove(tp, wip);
>> +			if (error)
>> +				goto out_trans_cancel;
>> +		}
>> +
>>   		/*
>>   		 * If target does not exist and the rename crosses
>>   		 * directories, adjust the target directory link count
>> @@ -3428,9 +3440,11 @@ struct xfs_iunlink {
>>   	if (wip) {
>>   		ASSERT(VFS_I(wip)->i_nlink == 0);
>>   		xfs_bumplink(tp, wip);
>> -		error = xfs_iunlink_remove(tp, wip);
>> -		if (error)
>> -			goto out_trans_cancel;
>> +		if (target_ip != NULL) {
>> +			error = xfs_iunlink_remove(tp, wip);
>> +			if (error)
>> +				goto out_trans_cancel;
>> +		}
> 
> The comment above this hunk needs to be updated. I'm also not a big fan
> of this factoring of doing the removal in the if branch above and then
> encoding the else logic down here. It might be cleaner and more
> consistent to have a call in each branch of the if/else above.
> 
> FWIW, I'm also curious if this could be cleaned up further by pulling
> the -ENOSPC/-EEXIST checks out of the earlier branch, following that
> with the whiteout removal, and then doing the dir_create/replace. For
> example, something like:
> 
> 	/* error checks before we dirty the transaction */
> 	if (!target_ip && !spaceres) {
> 		error = xfs_dir_canenter();
> 		...
> 	} else if (S_ISDIR() && !(empty || nlink > 2))
> 		error = -EEXIST;
> 		...
> 	}
> 
> 	if (wip) {
> 		...
> 		xfs_iunlink_remove();
> 	}
> 
> 	if (!target_ip) {
> 		xfs_dir_create();
> 		...
> 	} else {
> 		xfs_dir_replace();
> 		...
> 	}
> 
> ... but that may not be any cleaner..? It could also be done as a
> followup cleanup patch as well.

Yep, it is cleaner that making the whole check before the transaction
becomes dirty, just return the error code if check failed and
the filesystem is clean.

Dave gave another solution in the other subthread that using
XFS_DIR3_FT_WHT, it's a bit more work for this bug, include
refactoring the xfs_rename() and xfs_lookup(), not sure whether
it's worth the complex changes for this bug.

> 
> Brian
> 
>>   		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>>
>>   		/*
>> -- 
>> 1.8.3.1
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
