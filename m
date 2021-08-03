Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1C6C432BE
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 16:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B7F60187
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 16:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhHCQHV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:07:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229903AbhHCQHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Aug 2021 12:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628006828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R4hjkspymbHFGIZEEYyxwZuNJAjIUNRH9bHBkto04xU=;
        b=D18lI/QFlInEqpeTA8+QZH5gP9RWuXtdyLMrKmshJlI0YxOlOpsl78ol5ju/eqmdxkwmqo
        IqqkpVcp/LqNOoDFZuObzJNrGtXLXqXCwYrDfokvXYfDhXPaU4XIqMWae/+OFRUCG7wFZ2
        KDU1Qsk2Lo5z2fw/S+7rEtMrRUsAK/o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-LQzEgrGnM-uKvO4lhLa0vQ-1; Tue, 03 Aug 2021 12:07:07 -0400
X-MC-Unique: LQzEgrGnM-uKvO4lhLa0vQ-1
Received: by mail-wm1-f70.google.com with SMTP id u14-20020a7bcb0e0000b0290248831d46e4so822123wmj.6
        for <linux-xfs@vger.kernel.org>; Tue, 03 Aug 2021 09:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=R4hjkspymbHFGIZEEYyxwZuNJAjIUNRH9bHBkto04xU=;
        b=Isa72xEJ67m4HLbtuC3C2hAxX3dBGREI2xOZgicvtvuXftF+1zn2MKDFGe83grzadW
         RyU0Zdju+AOVsSHSXYk6UbB6JisxTC+e+PlBqRz3Ryj7AcQdu6NWuzhFzY2KNSQue4Lf
         uxZXe7vrc7HvRWU3XeLY9bkZu/m76/QcXat+Yn1czUT/lFbGMPTzLKccZSVAadwVXLfk
         Zp+8th2yBzecOs4/vf9Lza2ymAT6x76EJXB8d+tCljlHzqRG7nVSKVvTJKIO12pEqugA
         lUh7l/Fxwyrc5u2DpTz2vbbFQBK24BUk4dZIGG+qyJoxQRmdfKDo7olSjx/B+mQi4OIy
         Wh9Q==
X-Gm-Message-State: AOAM530bpVMQgWY3PYqzA+sA1hLBVgYIeAKgp4Nvxsrea4/9d3pMzEAy
        BkCdb5OsjnE0cMNl3SMdoeE3BUwDiECjxlhqWTk8j2G2ZjZUzvC2QXN6hCZdftPCBszdKmWgMOJ
        VU504jLSAtPcKex189G5eWZnYC1cq+C7DFCS46SXjabyu4AylLQ4OcQMXDiQOiv9wGXg+FlU=
X-Received: by 2002:a5d:6a0d:: with SMTP id m13mr24954059wru.33.1628006825890;
        Tue, 03 Aug 2021 09:07:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIpo2w1uUtqXXCK58FkPh5xk3cBoQL0wiXiYRdhl4HtA9GjHcX+YlkIkU0VyzW4ABbzM2+OQ==
X-Received: by 2002:a5d:6a0d:: with SMTP id m13mr24954016wru.33.1628006825632;
        Tue, 03 Aug 2021 09:07:05 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id f15sm14984317wre.66.2021.08.03.09.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 09:07:05 -0700 (PDT)
Subject: Re: [PATCH 3/8] xfsprogs: remove platform_uuid_compare()
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210802215024.949616-1-preichl@redhat.com>
 <20210802215024.949616-4-preichl@redhat.com>
 <20210802223549.GR3601443@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <c6f61457-bd19-ef0b-10e0-221e9902b727@redhat.com>
Date:   Tue, 3 Aug 2021 18:07:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802223549.GR3601443@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 8/3/21 12:35 AM, Darrick J. Wong wrote:
> On Mon, Aug 02, 2021 at 11:50:19PM +0200, Pavel Reichl wrote:
>> ---
>>   copy/xfs_copy.c      | 2 +-
>>   db/sb.c              | 2 +-
>>   include/linux.h      | 5 -----
> It's fine to change the platform_uuid_compare usages inside xfsprogs
> itself, but linux.h is shipped as part of the development headers, which
> means that you can't get rid of the wrapper functions without causing
> build problems for other userspace programs.
>
> --D
>
OK, maybe it would be best to split the effort into more steps:

1) A patchset that stops using platform_* functions and replace them 
with standard linux calls inside xfsprogs

2) A patchset that adds deprecation warnings into publicly visible 
platform_*() calls

3) Fix userspace programs now using the deprecated functions

4) Remove completely platform_*() functions from xfsprogs

Would that be a suitable path?

Thanks!

