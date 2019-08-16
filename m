Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB17C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 08:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAE35206C2
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 08:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ANUE1VCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHPIKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 04:10:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41084 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHPIKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 04:10:13 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so2140956pls.8
        for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2019 01:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jonMliFIIvZroPOVA2g+LcxF8Aa0o4fnN2u0J1fVyJ8=;
        b=ANUE1VCNy23Eo87OAGWVkdUOSLMPcm7KGBH6vFpzOuWzfj8IOe7+sCUGxanucdk3Ym
         nYQruCIJZbKuxSBt8xdTr2dhLRm/0eJ5bf8ioemwIcTKjQAD8t5b+DVCKHfoa1MYcxso
         bZXQvxSQfmlDQbcr/hXnAaX/xkrsM97XCHZO0JYFv71s807ZJoptoeySIFAFu35VAtiU
         8Ri3bRoPxQaMj/ELB4cMc1FLSsFDq9rEqAvahIf+y4CplQ+921OvO/+gGCatYrD33uGQ
         rzxf2eWIiG3+MDiEAPbf+6uZYfp6w7WbpC4ANOnwo5vxXbw1/dYgmWcBf9iG7edqDPvj
         PfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jonMliFIIvZroPOVA2g+LcxF8Aa0o4fnN2u0J1fVyJ8=;
        b=JWkwLrpzHlKBx6d9sLxk8/CJdVfuOLdmyiYq1DwYVmwNA+/kXxAOBookM8OsUC9eY4
         yz1480l4Hr3cuGfn/0o89BC7+gwQAhY9LMT7jEsibJvrlK/mFilNjrhKPVryZvC9m2W8
         tvzfFPki58wtLSTEGWcUPLhQqHIc98xRCthdGJTG7xDnxaKmEmp/cF6K4kaSXQBtlw80
         L1onrVvPKa737EakYZ74rjX1anMDnjMywIT+yAV+b3sNL5TgkwALquwHXFDTRjwocSJ9
         KaxBjwxpdz+0HXO0dKlIGVCXsq/Yh6y5ff4k//ljWZu8pIRKl7CrFJu7k4IEjirnP140
         fU/Q==
X-Gm-Message-State: APjAAAVdTEuv/ySBDxyDIYlgY7hSRUsA3vhAOl8Kz8l4CUZmxMLs2SLB
        DZ3uhQuosPx1XhTTn1aw2A==
X-Google-Smtp-Source: APXvYqyJK+51NUxrOqTdNKygvAq2kbeOXHMubbb+Us+GroYpfl4l9XLq3oNAVxg4v7lP5KA5F1uM3w==
X-Received: by 2002:a17:902:e002:: with SMTP id ca2mr8199512plb.326.1565943012346;
        Fri, 16 Aug 2019 01:10:12 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id s11sm4274399pgv.13.2019.08.16.01.10.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 01:10:11 -0700 (PDT)
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        newtongao@tencent.com, jasperwang@tencent.com
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190815233630.GU6129@dread.disaster.area>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
Date:   Fri, 16 Aug 2019 16:09:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815233630.GU6129@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/8/16 7:36, Dave Chinner wrote:
> On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
>> In this patch we make the unlinked list removal a deferred operation,
>> i.e. log an iunlink remove intent and then do it after the RENAME_WHITEOUT
>> transaction has committed, and the iunlink remove intention and done
>> log items are provided.
> 
> I really like the idea of doing this, not just for the inode unlink
> list removal, but for all the high level complex metadata
> modifications such as create, unlink, etc.
> 
> The reason I like this is that it moves use closer to being able to
> do operations almost completely asynchronously once the first intent
> has been logged.
> 

Thanks a lot for your comments.
Yeah, sometimes the complex metadata modifications correspond to the
long and complex transactions that hold more locks or other common
resources, so the deferred options may be better choices than just
changing the order in one transaction.

> Once we have committed the intent, we can treat the rest of the
> operation like recovery - all the information needed to perform the
> operation is in the intenti and all the objects that need to be
> locked across the entire operation are locked and joined to the
> defer structure. If the intent hits the log the we guarantee that it
> will be completed atomically and in the correct sequence order.
> Hence it doesn't matter once the intent is built and committed what
> context actually completes the rest of the transaction.
> 
> If we have to do a sync transaction, because XFS_MOUNT_SYNC,
> XFS_MOUNT_DIRSYNC, or there's a sync flag on the inode(s), we can
> add a waitqueue_head to the struct xfs_defer and have the context
> issuing the transaction attach itself and wait for the defer ops to
> complete and wake it....
> 
> 
> .....
> 
>> @@ -3752,6 +3755,96 @@ struct xfs_buf_cancel {
>>   }
>>
>>   /*
>> + * This routine is called to create an in-core iunlink remove intent
>> + * item from the iri format structure which was logged on disk.
>> + * It allocates an in-core iri, copies the inode from the format
>> + * structure into it, and adds the iri to the AIL with the given
>> + * LSN.
>> + */
>> +STATIC int
>> +xlog_recover_iri_pass2(
>> +	struct xlog			*log,
>> +	struct xlog_recover_item	*item,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	xfs_mount_t		*mp = log->l_mp;
>> +	xfs_iri_log_item_t	*irip;
>> +	xfs_iri_log_format_t	*iri_formatp;
>> +
>> +	iri_formatp = item->ri_buf[0].i_addr;
>> +
>> +	irip = xfs_iri_init(mp, 1);
>> +	irip->iri_format = *iri_formatp;
>> +	if (item->ri_buf[0].i_len != sizeof(xfs_iri_log_format_t)) {
>> +		xfs_iri_item_free(irip);
>> +		return EFSCORRUPTED;
>> +	}
>> +
>> +	spin_lock(&log->l_ailp->ail_lock);
>> +	/*
>> +	 * The IRI has two references. One for the IRD and one for IRI to ensure
>> +	 * it makes it into the AIL. Insert the IRI into the AIL directly and
>> +	 * drop the IRI reference. Note that xfs_trans_ail_update() drops the
>> +	 * AIL lock.
>> +	 */
>> +	xfs_trans_ail_update(log->l_ailp, &irip->iri_item, lsn);
>> +	xfs_iri_release(irip);
>> +	return 0;
>> +}
> 
> These intent recovery functions all do very, very similar things.
> We already have 4 copies of this almost identical code - I think
> there needs to be some factoring/abstrcting done here rather than
> continuing to copy/paste this code...

Factoring/abstrcting is better than just copy/paste...
The log incompat feature bit is also needed because adding new
log item types(IRI&IRD)...
Any way, I will send the V2 patch for all the review comments.

> 
>> @@ -3981,6 +4074,8 @@ struct xfs_buf_cancel {
>>   	case XFS_LI_CUD:
>>   	case XFS_LI_BUI:
>>   	case XFS_LI_BUD:
>> +	case XFS_LI_IRI:
>> +	case XFS_LI_IRD:
>>   	default:
>>   		break;
>>   	}
>> @@ -4010,6 +4105,8 @@ struct xfs_buf_cancel {
>>   	case XFS_LI_CUD:
>>   	case XFS_LI_BUI:
>>   	case XFS_LI_BUD:
>> +	case XFS_LI_IRI:
>> +	case XFS_LI_IRD:
>>   		/* nothing to do in pass 1 */
>>   		return 0;
>>   	default:
>> @@ -4052,6 +4149,10 @@ struct xfs_buf_cancel {
>>   		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>>   	case XFS_LI_BUD:
>>   		return xlog_recover_bud_pass2(log, item);
>> +	case XFS_LI_IRI:
>> +		return xlog_recover_iri_pass2(log, item, trans->r_lsn);
>> +	case XFS_LI_IRD:
>> +		return xlog_recover_ird_pass2(log, item);
>>   	case XFS_LI_DQUOT:
>>   		return xlog_recover_dquot_pass2(log, buffer_list, item,
>>   						trans->r_lsn);
> 
> As can be seen by the increasing size of this table....
> 
>> @@ -4721,6 +4822,46 @@ struct xfs_buf_cancel {
>>   	spin_lock(&ailp->ail_lock);
>>   }
>>
>> +/* Recover the IRI if necessary. */
>> +STATIC int
>> +xlog_recover_process_iri(
>> +	struct xfs_trans		*parent_tp,
>> +	struct xfs_ail			*ailp,
>> +	struct xfs_log_item		*lip)
>> +{
>> +	struct xfs_iri_log_item		*irip;
>> +	int				error;
>> +
>> +	/*
>> +	 * Skip IRIs that we've already processed.
>> +	 */
>> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
>> +	if (test_bit(XFS_IRI_RECOVERED, &irip->iri_flags))
>> +		return 0;
>> +
>> +	spin_unlock(&ailp->ail_lock);
>> +	error = xfs_iri_recover(parent_tp, irip);
>> +	spin_lock(&ailp->ail_lock);
>> +
>> +	return error;
>> +}
>> +
>> +/* Release the IRI since we're cancelling everything. */
>> +STATIC void
>> +xlog_recover_cancel_iri(
>> +	struct xfs_mount		*mp,
>> +	struct xfs_ail			*ailp,
>> +	struct xfs_log_item		*lip)
>> +{
>> +	struct xfs_iri_log_item         *irip;
>> +
>> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
>> +
>> +	spin_unlock(&ailp->ail_lock);
>> +	xfs_iri_release(irip);
>> +	spin_lock(&ailp->ail_lock);
>> +}
> 
> More cookie cutter code.
> 
>> @@ -4856,6 +4998,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>>   		case XFS_LI_BUI:
>>   			error = xlog_recover_process_bui(parent_tp, ailp, lip);
>>   			break;
>> +		case XFS_LI_IRI:
>> +			error = xlog_recover_process_iri(parent_tp, ailp, lip);
>> +			break;
>>   		}
>>   		if (error)
>>   			goto out;
>> @@ -4912,6 +5057,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>>   		case XFS_LI_BUI:
>>   			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
>>   			break;
>> +		case XFS_LI_IRI:
>> +			xlog_recover_cancel_iri(log->l_mp, ailp, lip);
>> +			break;
>>   		}
> 
> And the table that drives it....
> 
> I guess what I'm saying is that I'd really like to see an abstract
> type specifically for intent log items and generic infrastructure to
> manipulate them before we go adding more of them...
> 
> Cheers,
> 
> Dave.
> 

-- 
kaixuxia
