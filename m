Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291D0C43457
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 20:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5319208D5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 20:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bAh1deqe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgJLUo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:44:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728944AbgJLUo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 16:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602535495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HjyVvdRwN+ecS97SL5UTDwfoc0Uw9c+6U07agPU6ss=;
        b=bAh1deqelBtiSrME9EQH37TrOpVbyp43Sddag9n6VjNpOphdmWf3fcz24Z/YQf/+IW93dN
        iL1ua6fVoB5bV/2mxstRxaFXOGAd+nOGnHJ2L8zJp+9et/kJGtjeHHeDuk1eT1L6deDqQj
        wgaj3JXqi3sH5RxvnSwyzs8KKIRYz2E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-0kN-P3FxOMSEvNh2S34o4A-1; Mon, 12 Oct 2020 16:44:41 -0400
X-MC-Unique: 0kN-P3FxOMSEvNh2S34o4A-1
Received: by mail-wr1-f71.google.com with SMTP id 47so9794248wrc.19
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 13:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HjyVvdRwN+ecS97SL5UTDwfoc0Uw9c+6U07agPU6ss=;
        b=AFjlH4pOxOpHtCy+fxceRxAw7K2ywxB7cAReqDDF8Mxo6tSN6pBgF6Ld89dzzdvA0r
         /uPGIeWSOAktDrVwDzekpj6DYPUoQBb4Z4jZVuFvFeYjjRGvWojYVFkbylCoveVpkwD/
         WLQplJN1BsKuiPOz5patSKmyAh1SYseHjkdMIXv5HbZfEENysHXfQPOclWzcjq9iTe7O
         Y3Pj+aFMQO1IRELCb4dj/wIesgxlkOVDnMnyiGgo5EdqXTwELvipK8yJ17dpl/BBRWCg
         8a7FCcss00PO5Bjvuvgceg9ekzksAhaDys6yKaURCOfLzUyyBoQiet568S3ehU40WluG
         wsUw==
X-Gm-Message-State: AOAM533nUnfK1YdkBFYMyby3YFgEdrag/UqBkfQM4CAxVBTeckFBxJH8
        SMNkDS8nzaevHIeuvFbfGDNLI15UhYdymN8xca5bxz4g/60oMLWwQR8/equmiJ91pMCq2rP44HX
        kfxk30+sQfc7s9ISCHVY9
X-Received: by 2002:a1c:6488:: with SMTP id y130mr12070706wmb.94.1602535480355;
        Mon, 12 Oct 2020 13:44:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmohSxwUn+w6JbYNFEyTRhJxTlWmi3bAJhY1fwlQTZvKcNoN1vNDEhKcZyazDXN6IyWY1phA==
X-Received: by 2002:a1c:6488:: with SMTP id y130mr12070700wmb.94.1602535480103;
        Mon, 12 Oct 2020 13:44:40 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id d20sm12427238wra.38.2020.10.12.13.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 13:44:39 -0700 (PDT)
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com> <20201012160412.GK917726@bfoster>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <ffc87f66-759d-ac3c-5749-0972aa41924f@redhat.com>
Date:   Mon, 12 Oct 2020 22:44:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201012160412.GK917726@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/12/20 6:04 PM, Brian Foster wrote:
> ...
>> @@ -2863,8 +2875,20 @@ xfs_btree_split(
>>  	args.done = &done;
>>  	args.kswapd = current_is_kswapd();
>>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
>> +	/*
>> +	 * Update lockdep's ownership information to reflect that we
>> +	 * will be transferring the ilock from this thread to the
>> +	 * worker.
>> +	 */
> 
> Can we update this comment to explain why we need to do this? E.g., I'm
> assuming there's a lockdep splat somewhere down in the split worker
> without it, but it's not immediately clear where and so it might not be
> obvious if we're ever able to remove this.

Hi, would something like this work for you?

	/*
+	 * Update lockdep's ownership information to reflect that we
+	 * will be transferring the ilock from this thread to the
+	 * worker (xfs_btree_split_worker() run via queue_work()).
+	 * If the ownership transfer would not happen lockdep would
+	 * assert in the worker thread because the ilock would be owned
+	 * by the original thread.
+	 */


