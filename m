Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2950DC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 12:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E83613BC
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 12:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhDTMPB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 08:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbhDTMPA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 08:15:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD694C06174A
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 05:14:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so20336653pjv.1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 05:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ve06XkWqMVwKM9Btow8xtMPMzbn+NcJPo7dqOWNu618=;
        b=ESPwTSr+Ewd2ccc5y8Zm86OdKvPRJx4/l7vFZH9mdT+2V1MS9J/I0Jr/pyqQjliCXF
         eUIXXXcYeuM1EbIXcQSPuELY6meFrh2gIbhAsyS+d8/QO3SqyZz10Vcy7qQ9lrdxa16j
         3972++m4llWUqSe6UZbTPncqjMNj1OlPz4O01yfHtnJAhHXKl/zCRI5OHm5Bod7hCDvH
         s8ACzOqksCGYRylarjbbDhILwZu+XuLLSYJU8AiwkBqBBpfH58ip5Kzk1DQ4MqUgDYoa
         briN6tAeffPq+32+J07fjrOPp48rjOVQ1EExLc5+HOf614DhbhMS8qHRGvCd6DRCrYiU
         E2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ve06XkWqMVwKM9Btow8xtMPMzbn+NcJPo7dqOWNu618=;
        b=jvwSZcHDlibYBY/U2fvJ0BVnuwwzjAaHOSSzqGn4m/0oivNR3wA76JkIG6e0GXClpw
         DKIhQkqSusrxRBFR5SUD70yCpb1jSLfnF35zvnWYr1VnafpxEmfy7cnGK7EsEsK0GydI
         cvKxRpCcVJdNkMr/Zbds5Riw25x4MoMknVZUFFkh+sZ1Y5e9fTH2MUurKlWAe+1ULaeJ
         crnMaUqU4qsfrtb/C0oMJzK/lto+PbJwAwmYvG3LegrNsxg9TDpa8ID6PwFj7k/ZliIR
         UWTd63Y1dEKalxg0QJH8BKQKuIGgSpYwkcDFqL6nnVQYjoCrgPHf0pFlWHQDCnw60Gn8
         9iWg==
X-Gm-Message-State: AOAM530gfXihY7KWb96lCGrZO+4cH9CcLPfdW2iTx7mGkmvy+AUNL3Hu
        NKq5yn5wIli+x8jUvpXifgFlCZaRZRo=
X-Google-Smtp-Source: ABdhPJzs/qf3Y4Lkb3lV8fcLdeR31Dr11BfzzYa/IqvF4WCOT6aKmFGxzxp4hkL6QIe1zgklC0vJvA==
X-Received: by 2002:a17:90a:ea0f:: with SMTP id w15mr4654216pjy.31.1618920869198;
        Tue, 20 Apr 2021 05:14:29 -0700 (PDT)
Received: from garuda ([122.171.129.84])
        by smtp.gmail.com with ESMTPSA id i11sm15718382pfa.108.2021.04.20.05.14.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Apr 2021 05:14:28 -0700 (PDT)
References: <20210416092045.2215-1-allison.henderson@oracle.com> <20210416092045.2215-6-allison.henderson@oracle.com> <87o8eaj1mr.fsf@garuda> <a83a5de6-2e6c-c4ec-12cd-b99522e83bc8@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
In-reply-to: <a83a5de6-2e6c-c4ec-12cd-b99522e83bc8@oracle.com>
Date:   Tue, 20 Apr 2021 17:44:26 +0530
Message-ID: <875z0hxie5.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Apr 2021 at 00:02, Allison Henderson wrote:
> On 4/18/21 10:15 PM, Chandan Babu R wrote:
>> On 16 Apr 2021 at 14:50, Allison Henderson wrote:
>>> This patch separate xfs_attr_node_addname into two functions.  This will
>>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>>> state management
>>>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>>>   1 file changed, 20 insertions(+)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index fff1c6f..d9dfc8d2 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>   				 struct xfs_da_state **state);
>>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>> @@ -1062,6 +1063,25 @@ xfs_attr_node_addname(
>>>   			return error;
>>>   	}
>>>
>>> +	error = xfs_attr_node_addname_clear_incomplete(args);
> Ok, so i think what we need here is an extra few lines below.  That's
> similar to the original exit handling
>
> 	if (error)
> 		goto out;
> 	retval = error = 0;

        "retval = 0;" should suffice.
        
>
> Looks good?
>
>>> +out:
>>> +	if (state)
>>> +		xfs_da_state_free(state);
>>> +	if (error)
>>> +		return error;
>>> +	return retval;
>>
>> I think the above code incorrectly returns -ENOSPC when the user is performing
>> an xattr rename operation and the call to xfs_attr3_leaf_add() resulted in
>> returning -ENOSPC,
>> 1. xfs_attr3_leaf_add() returns -ENOSPC.
>> 2. xfs_da3_split() allocates a new leaf and inserts the new xattr into it.
>> 3. If the user was performing a rename operation (i.e. XFS_DA_OP_RENAME is
>>     set), we flip the "incomplete" flag.
>> 4. Remove the old xattr's remote blocks (if any).
>> 5. Remove old xattr's name.
>> 6. If "error" has zero as its value, we return the value of "retval". At this
>>     point in execution, "retval" would have -ENOSPC as its value.
>>
> Thanks for the catch!
> Allison

-- 
chandan
