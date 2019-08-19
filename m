Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74EDC3A59B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 07:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFDA20989
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 07:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u7wjky1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHSHtR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 03:49:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42756 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfHSHtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 03:49:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so714621pgb.9
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 00:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=58xjAWZpiBHcE0yTZboLso32/UV3SHMneclEyGzqerc=;
        b=u7wjky1AtCqK7tqE71oZwQojh6ngaKRySg7t+tSmMflKMYKExPhZUcotRGiw4Jp5OG
         UlLJ2u5FVtcW12sZHhwmnJiX6t23yQL3CcNQ9TmvWclIugOIX3NWGEWdRLqjFUNdWaJn
         whIj4ESgUmlJQIU8PhcFAZIvbS/mgcur/W1d1SEEup9CPmI5oV1WaDUcIMAK1ASYASSl
         XdCkWdDiJ2sDg8ikHsQofZeOsHxCwnY1qDmz3gVtlS8I4Mqa/yfNyOnwHzdGfLwVNtPe
         AGJ8PG9YRjp7OYjRhoqfLKYuPCGmEUazkd1AyjOH+grnpvuSfEsr6PHT/N7ehxdIPZ8G
         WJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=58xjAWZpiBHcE0yTZboLso32/UV3SHMneclEyGzqerc=;
        b=kXyOAB3X5P3fBG7Wn2MW+r2RCmHBGApWtROjWMS2pQa792Plez/A1oq7SsEItnM/lv
         2t1zt5WHqCSA5GydQAz+UBtxnJB1+A6kpUhu+i7TP6CRiaQ8z91u+q2dI/mr8yjjcnKw
         viMSKS5eWlXCY7MzrM2eJSf+5s9Sppwr7B69/KFEwDsifh2nqK2Nt+rlj4n9932SdE5/
         v7rn0JtYH9L6apkCGkJwlPog5f3O0egSXPOQlnMQhA+qHtHLmHCNusU8NM88tJmNmsJ+
         w4mQGZ0tGTvsVGje3Bxg4hVeT5Nh5wlnhdF6v9wvDVf+yvtwD70Du94UUzWzRr0UPM5j
         OaYA==
X-Gm-Message-State: APjAAAWwOMYo3qV5A72WtRJOvTAANjTc3baEFszHX46WuXxs4EaarKCQ
        Bed0bWAZKknzyvEJzXbC8g==
X-Google-Smtp-Source: APXvYqzLTCtAO3pvoWXjjCGRbHYjhsz/zMT718Ul/79C3IZPGqqE8fQFfYpKnvpUFQLLI2VxckJ4QQ==
X-Received: by 2002:a65:640a:: with SMTP id a10mr18425514pgv.338.1566200955930;
        Mon, 19 Aug 2019 00:49:15 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id e129sm3340313pfa.92.2019.08.19.00.49.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 00:49:15 -0700 (PDT)
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190815233630.GU6129@dread.disaster.area>
 <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
 <20190816145310.GB54929@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <eb8af23a-7bb4-855a-872b-21feb696de5e@gmail.com>
Date:   Mon, 19 Aug 2019 15:49:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816145310.GB54929@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/8/16 22:53, Brian Foster wrote:
> On Fri, Aug 16, 2019 at 04:09:39PM +0800, kaixuxia wrote:
>>
>>
>> On 2019/8/16 7:36, Dave Chinner wrote:
>>> On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
>>>> In this patch we make the unlinked list removal a deferred operation,
>>>> i.e. log an iunlink remove intent and then do it after the RENAME_WHITEOUT
>>>> transaction has committed, and the iunlink remove intention and done
>>>> log items are provided.
>>>
>>> I really like the idea of doing this, not just for the inode unlink
>>> list removal, but for all the high level complex metadata
>>> modifications such as create, unlink, etc.
>>>
>>> The reason I like this is that it moves use closer to being able to
>>> do operations almost completely asynchronously once the first intent
>>> has been logged.
>>>
>>
>> Thanks a lot for your comments.
>> Yeah, sometimes the complex metadata modifications correspond to the
>> long and complex transactions that hold more locks or other common
>> resources, so the deferred options may be better choices than just
>> changing the order in one transaction.
>>
> 
> I can't speak for Dave (who can of course chime in again..) or others,
> but I don't think he's saying that this approach is preferred to the
> various alternative approaches discussed in the other subthread. Note
> that he also replied there with another potential solution that doesn't
> involve deferred operations.
> 
> Rather, I think he's viewing this in a much longer term context around
> changing more of the filesystem to be async in architecture. Personally,
> I'd have a ton more questions around the context of what something like
> that looks like before I'd support starting to switch over less complex
> operations to be deferred operations based on the current dfops
> mechanism. The mechanism works and solves real problems, but it also has
> tradeoffs that IMO warrant the current model of selective use. Further,
> it's nearly impossible to determine what other fundamental
> incompatibilities might exist without context on bigger picture design.
> IOW, this topic really needs a separate thread that that starts with a
> high level architectural description for others to reason about, because
> I think it's already caused confusion.try the 
> 
> In short, while it might be worth keeping this patch around for future
> use, I still think this is overkill (and insufficient as Darrick already
> noted) for fixing the originally reported problem...

Yep.. Just putting the async deferred operations aside, maybe it is too
big for this patch, and focusing on the bug. Of course, we have alternative
solutions for the bug, if this patch is overkill (adding the log incompat bit).
I will try the lightweight and appropriate approaches discussed in the other
subthread, for example refactoring the dir code and move the xfs_iunlink_remove()
call to between the xfs_dir_canenter() and xfs_dir_createname().

> 
> Brian
> 
>>> Once we have committed the intent, we can treat the rest of the
>>> operation like recovery - all the information needed to perform the
>>> operation is in the intenti and all the objects that need to be
>>> locked across the entire operation are locked and joined to the
>>> defer structure. If the intent hits the log the we guarantee that it
>>> will be completed atomically and in the correct sequence order.
>>> Hence it doesn't matter once the intent is built and committed what
>>> context actually completes the rest of the transaction.
>>>
>>> If we have to do a sync transaction, because XFS_MOUNT_SYNC,
>>> XFS_MOUNT_DIRSYNC, or there's a sync flag on the inode(s), we can
>>> add a waitqueue_head to the struct xfs_defer and have the context
>>> issuing the transaction attach itself and wait for the defer ops to
>>> complete and wake it....
>>>
>>>
>>> .....
>>>
>>>> @@ -3752,6 +3755,96 @@ struct xfs_buf_cancel {
>>>>    }
>>>>
>>>>    /*
>>>> + * This routine is called to create an in-core iunlink remove intent
>>>> + * item from the iri format structure which was logged on disk.
>>>> + * It allocates an in-core iri, copies the inode from the format
>>>> + * structure into it, and adds the iri to the AIL with the given
>>>> + * LSN.
>>>> + */
>>>> +STATIC int
>>>> +xlog_recover_iri_pass2(
>>>> +	struct xlog			*log,
>>>> +	struct xlog_recover_item	*item,
>>>> +	xfs_lsn_t			lsn)
>>>> +{
>>>> +	xfs_mount_t		*mp = log->l_mp;
>>>> +	xfs_iri_log_item_t	*irip;
>>>> +	xfs_iri_log_format_t	*iri_formatp;
>>>> +
>>>> +	iri_formatp = item->ri_buf[0].i_addr;
>>>> +
>>>> +	irip = xfs_iri_init(mp, 1);
>>>> +	irip->iri_format = *iri_formatp;
>>>> +	if (item->ri_buf[0].i_len != sizeof(xfs_iri_log_format_t)) {
>>>> +		xfs_iri_item_free(irip);
>>>> +		return EFSCORRUPTED;
>>>> +	}
>>>> +
>>>> +	spin_lock(&log->l_ailp->ail_lock);
>>>> +	/*
>>>> +	 * The IRI has two references. One for the IRD and one for IRI to ensure
>>>> +	 * it makes it into the AIL. Insert the IRI into the AIL directly and
>>>> +	 * drop the IRI reference. Note that xfs_trans_ail_update() drops the
>>>> +	 * AIL lock.
>>>> +	 */
>>>> +	xfs_trans_ail_update(log->l_ailp, &irip->iri_item, lsn);
>>>> +	xfs_iri_release(irip);
>>>> +	return 0;
>>>> +}
>>>
>>> These intent recovery functions all do very, very similar things.
>>> We already have 4 copies of this almost identical code - I think
>>> there needs to be some factoring/abstrcting done here rather than
>>> continuing to copy/paste this code...
>>
>> Factoring/abstrcting is better than just copy/paste...
>> The log incompat feature bit is also needed because adding new
>> log item types(IRI&IRD)...
>> Any way, I will send the V2 patch for all the review comments.
>>
>>>
>>>> @@ -3981,6 +4074,8 @@ struct xfs_buf_cancel {
>>>>    	case XFS_LI_CUD:
>>>>    	case XFS_LI_BUI:
>>>>    	case XFS_LI_BUD:
>>>> +	case XFS_LI_IRI:
>>>> +	case XFS_LI_IRD:
>>>>    	default:
>>>>    		break;
>>>>    	}
>>>> @@ -4010,6 +4105,8 @@ struct xfs_buf_cancel {
>>>>    	case XFS_LI_CUD:
>>>>    	case XFS_LI_BUI:
>>>>    	case XFS_LI_BUD:
>>>> +	case XFS_LI_IRI:
>>>> +	case XFS_LI_IRD:
>>>>    		/* nothing to do in pass 1 */
>>>>    		return 0;
>>>>    	default:
>>>> @@ -4052,6 +4149,10 @@ struct xfs_buf_cancel {
>>>>    		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>>>>    	case XFS_LI_BUD:
>>>>    		return xlog_recover_bud_pass2(log, item);
>>>> +	case XFS_LI_IRI:
>>>> +		return xlog_recover_iri_pass2(log, item, trans->r_lsn);
>>>> +	case XFS_LI_IRD:
>>>> +		return xlog_recover_ird_pass2(log, item);
>>>>    	case XFS_LI_DQUOT:
>>>>    		return xlog_recover_dquot_pass2(log, buffer_list, item,
>>>>    						trans->r_lsn);
>>>
>>> As can be seen by the increasing size of this table....
>>>
>>>> @@ -4721,6 +4822,46 @@ struct xfs_buf_cancel {
>>>>    	spin_lock(&ailp->ail_lock);
>>>>    }
>>>>
>>>> +/* Recover the IRI if necessary. */
>>>> +STATIC int
>>>> +xlog_recover_process_iri(
>>>> +	struct xfs_trans		*parent_tp,
>>>> +	struct xfs_ail			*ailp,
>>>> +	struct xfs_log_item		*lip)
>>>> +{
>>>> +	struct xfs_iri_log_item		*irip;
>>>> +	int				error;
>>>> +
>>>> +	/*
>>>> +	 * Skip IRIs that we've already processed.
>>>> +	 */
>>>> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
>>>> +	if (test_bit(XFS_IRI_RECOVERED, &irip->iri_flags))
>>>> +		return 0;
>>>> +
>>>> +	spin_unlock(&ailp->ail_lock);
>>>> +	error = xfs_iri_recover(parent_tp, irip);
>>>> +	spin_lock(&ailp->ail_lock);
>>>> +
>>>> +	return error;
>>>> +}
>>>> +
>>>> +/* Release the IRI since we're cancelling everything. */
>>>> +STATIC void
>>>> +xlog_recover_cancel_iri(
>>>> +	struct xfs_mount		*mp,
>>>> +	struct xfs_ail			*ailp,
>>>> +	struct xfs_log_item		*lip)
>>>> +{
>>>> +	struct xfs_iri_log_item         *irip;
>>>> +
>>>> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
>>>> +
>>>> +	spin_unlock(&ailp->ail_lock);
>>>> +	xfs_iri_release(irip);
>>>> +	spin_lock(&ailp->ail_lock);
>>>> +}
>>>
>>> More cookie cutter code.
>>>
>>>> @@ -4856,6 +4998,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>>>>    		case XFS_LI_BUI:
>>>>    			error = xlog_recover_process_bui(parent_tp, ailp, lip);
>>>>    			break;
>>>> +		case XFS_LI_IRI:
>>>> +			error = xlog_recover_process_iri(parent_tp, ailp, lip);
>>>> +			break;
>>>>    		}
>>>>    		if (error)
>>>>    			goto out;
>>>> @@ -4912,6 +5057,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>>>>    		case XFS_LI_BUI:
>>>>    			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
>>>>    			break;
>>>> +		case XFS_LI_IRI:
>>>> +			xlog_recover_cancel_iri(log->l_mp, ailp, lip);
>>>> +			break;
>>>>    		}
>>>
>>> And the table that drives it....
>>>
>>> I guess what I'm saying is that I'd really like to see an abstract
>>> type specifically for intent log items and generic infrastructure to
>>> manipulate them before we go adding more of them...
>>>
>>> Cheers,
>>>
>>> Dave.
>>>
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
