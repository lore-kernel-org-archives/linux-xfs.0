Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEACC2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 19:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4627B2076A
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 19:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZJYWx1N9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgI1Tla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 15:41:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgI1Tla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 15:41:30 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601322089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MIhIoPGSjjLbx8kEuJt7lHnFMJSFOBgQki6xxIVKmmA=;
        b=ZJYWx1N9Fvxwt1Nz98n9zRHHNBcH4fg4oz45KLg1v2ICJXCYkEd0xBbHKrgWAXwaHLBRjI
        7pWE1hT4K4vQETcfL+DQOIOq8sPQ/gpKcG9PBPDyC/WlW6hYjF6eD2oRUQoRVHliE39nIv
        8LIyCykzvZFc/SSvStrUl/qU7Iz/dvs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-vLCkZbE-Pf6F2A3KLRtZEA-1; Mon, 28 Sep 2020 15:41:27 -0400
X-MC-Unique: vLCkZbE-Pf6F2A3KLRtZEA-1
Received: by mail-wm1-f72.google.com with SMTP id y18so665412wma.4
        for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2020 12:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIhIoPGSjjLbx8kEuJt7lHnFMJSFOBgQki6xxIVKmmA=;
        b=O6JA6z1nwn7iZdbjhp4v5Dn3z/FfVmplOTP8k68/u4HoKJKfGXA0Q2EkxxNODFE5K4
         v+N3LC52TeRLC3LluTGwJ/KKFqqYSdbPr1sJ+TT7nptMwQ+ISt260R/oV5knRsAHeXfW
         cbO06xq6WURcupZwPEoAsjHN7S4ZHBlf/+Xdyg9unBywXB+b/Y0ZZSRrMX/83s2zxDX9
         /S3mdAtJEfHpmmr8CtJ5qQUjkoMES8BZFOI+MZ0JpTqjehrgdLfbfwqKYPXo05X7p2xQ
         TWDjrrRzv1S26qaNMZOP8wpEk9dl6U8gaAxqBFJNABSDbg4OTcS+uMWSnQzhBQpiSjWk
         r/+w==
X-Gm-Message-State: AOAM530cUyaQyIoF9WG82TrwZUWNqeq2UY/vRpmo8DKrxnloJ3UjqY4P
        UGkNi7s4PN2xaXl++hFTtonhay51uWKavG9NcJZR+BKHaMT+fEYI5GfGibL/VJXZiepWasrnwgq
        2I7otr7vipeiK7O3QJqrq
X-Received: by 2002:adf:93e5:: with SMTP id 92mr73536wrp.31.1601322085782;
        Mon, 28 Sep 2020 12:41:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKkIcPUOQ9ubv8TN0RGKId6Y7G6N8KEhd6sLZPfW0I7TkBDwiVU9nkp3R+nOGx3hSK/ZzloQ==
X-Received: by 2002:adf:93e5:: with SMTP id 92mr73526wrp.31.1601322085634;
        Mon, 28 Sep 2020 12:41:25 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id k12sm2670941wrn.39.2020.09.28.12.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 12:41:24 -0700 (PDT)
Subject: Re: [PATCH] xfsdump: rename worker threads
To:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
References: <144faa13-75be-4742-11cf-81cf30ae71b8@redhat.com>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <13fecca0-4391-d6b0-7ae4-7260a4386eb8@redhat.com>
Date:   Mon, 28 Sep 2020 21:41:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <144faa13-75be-4742-11cf-81cf30ae71b8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

patch looks good to me, it applies and xfsdump builds fine.

However, could I ask about the directory change below?

>  	immediate mode rewind, etc. is enabled.  Setting this bit
>  	will disable immediate mode rewind on the drive, independent
> -	of the setting of tpsc_immediate_rewind (in master.d/tpsc) */
> +	of the setting of tpsc_immediate_rewind (in the tpsc sysgen file) */

Who makes and removes the master.d directory, that was not part of the patch, right?

Thanks.

Reviewed-by: Pavel Reichl <preichl@redhat.com>

