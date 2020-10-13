Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647A2C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1606023A55
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hczToDis"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgJMNjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 09:39:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbgJMNjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 09:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602596351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HAKLqqauqS4zwdKijA+w7JOzEroZGMBbaHkwkcgcNbI=;
        b=hczToDis4JxVChjZfE3rcUrR6ddCyBEbdUKKseHgEL9mArUk/zgRQJqqHc9feQoX9HLgUL
        P+jMWA43S/FKgpatpaOWrEscXxoQlZTo2s0vpe2Z1hJ0aUrqrfDXUgtzyO48W3XGFreQBE
        Q7n0hsG9QNY8A/jk8Ebt95Hrx7Ty7ds=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-idps9ECSOmyWrWZBv_sX-A-1; Tue, 13 Oct 2020 09:39:09 -0400
X-MC-Unique: idps9ECSOmyWrWZBv_sX-A-1
Received: by mail-wm1-f69.google.com with SMTP id z7so2232611wme.8
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 06:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HAKLqqauqS4zwdKijA+w7JOzEroZGMBbaHkwkcgcNbI=;
        b=YB9MqZHLdrAT9K/Fql2qvLBh/hInvFRI3N7hFB5PfZf4+shT8Y+/O+OJJXDYRF27Io
         M4kRSIEwiX5hBWA7a0Hhxla3Xoi+yxq/zEayqLNC3QsgcntzqbtrA5ZcQ3RinxNbKjfd
         tFJJ6LwrWamnZqAY0LD9J396zy82jIflYWPAWfXdeGRZ8BgeY6+IqWuusdMz77f5Qhu9
         nEvdXK2NHilfm5IKp/FwC62uEGMSftDU9WV/f6/lbf//ajCwocYl24kz0GBSNp97VUj+
         Q6uZ1UD7+l59dLYkQz76laNFK5n5JlpilPvGRDyIGXdVL/sqJN6+gu62xV463fVYIICg
         Ai5Q==
X-Gm-Message-State: AOAM533Fk7/r6bSAVGKFsswGCf5raFlzC373VlSA6vufq9PREwMfluO3
        Y0h/awRXhRpTn0d1yQ1sleOhnYOsdC5xVdFtePgnAcZO1VoWkWLai8VGcaDGk9B6lzkMM20bzDa
        7fkvmloBz0Q3Sq8vZFCVZ
X-Received: by 2002:a1c:2905:: with SMTP id p5mr16229983wmp.187.1602596347268;
        Tue, 13 Oct 2020 06:39:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzSOocnvQ34Mmlo7bCdJCXHUOntHiINgwQ8JQXh0WzHrt58krXXsfbv5i/CDJr4AZdZfZXoA==
X-Received: by 2002:a1c:2905:: with SMTP id p5mr16229889wmp.187.1602596346051;
        Tue, 13 Oct 2020 06:39:06 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id 13sm26418050wmk.20.2020.10.13.06.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 06:39:04 -0700 (PDT)
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com> <20201012160412.GK917726@bfoster>
 <ffc87f66-759d-ac3c-5749-0972aa41924f@redhat.com>
 <20201013110427.GB966478@bfoster>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <d780c465-a305-c3d2-e583-82d70a1f964e@redhat.com>
Date:   Tue, 13 Oct 2020 15:39:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201013110427.GB966478@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/13/20 1:04 PM, Brian Foster wrote:
> On Mon, Oct 12, 2020 at 10:44:38PM +0200, Pavel Reichl wrote:
>>
>>
>> On 10/12/20 6:04 PM, Brian Foster wrote:
>>> ...
>>>> @@ -2863,8 +2875,20 @@ xfs_btree_split(
>>>>  	args.done = &done;
>>>>  	args.kswapd = current_is_kswapd();
>>>>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
>>>> +	/*
>>>> +	 * Update lockdep's ownership information to reflect that we
>>>> +	 * will be transferring the ilock from this thread to the
>>>> +	 * worker.
>>>> +	 */
>>>
>>> Can we update this comment to explain why we need to do this? E.g., I'm
>>> assuming there's a lockdep splat somewhere down in the split worker
>>> without it, but it's not immediately clear where and so it might not be
>>> obvious if we're ever able to remove this.
>>
>> Hi, would something like this work for you?
>>
>> 	/*
>> +	 * Update lockdep's ownership information to reflect that we
>> +	 * will be transferring the ilock from this thread to the
>> +	 * worker (xfs_btree_split_worker() run via queue_work()).
>> +	 * If the ownership transfer would not happen lockdep would
>> +	 * assert in the worker thread because the ilock would be owned
>> +	 * by the original thread.
>> +	 */
>>
> 
> That doesn't really answer the question. Do you have a record of the
> lockdep error message that occurs without this state transfer, by
> chance?
> 
> Brian

Hi, please see this mail from Darrick - he hit the issue first - http://mail.spinics.net/lists/linux-xfs/msg38967.html

> 
>>
> 

