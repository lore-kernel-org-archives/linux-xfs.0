Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25579C00528
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 23:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjGZXIB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 19:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjGZXIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 19:08:00 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FC11737
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 16:07:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-686f6231bdeso335b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 16:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690412879; x=1691017679;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p7/oP7WoNWR+PINLXplV3oHqqLL4+fszPcNGIJhuEWk=;
        b=ViPNVRYFQndVCfDDCO2WY1Xa/4+syxVzQc2rXiDbFlNk4A6czSB3atXb3iPQy7ecEz
         1tXLWyO68zep2iAOs4A9PVnSS104OtFplD2OA1T/uhf9LeEcz+qVaauqWWwqCeUao8mH
         9qTo9FZGnS+oVLe7dFSNvQ9DnHss5V0+H17NucvSTl92mpaihqOe0vVptSU6tI3spr40
         pTKT5WA1079BYj//OmngM+UpAtsrGqunTm38EpaGdksppOcxLJcVQHGIKZDEdiDe7WLL
         OsXaMx3mE9PKIV91crcEeYClE3BP+y5iejYocmMhZua/mqx9PefkacWDNV0PWeZMY1ki
         0Vzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690412879; x=1691017679;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p7/oP7WoNWR+PINLXplV3oHqqLL4+fszPcNGIJhuEWk=;
        b=Kja6pqOFy3NOlixLCn4ZC4BTvbs6c1h12nqZQfwA6ugIGDQmcTXB2UtEvN80CjJmsQ
         Hgr98GMBA2dy5S4XZo7kpYsaWWJEq5WwIKVXUq8N+v1xixU8KBZouKVfTzCAgHwSd8zC
         uXxIQ7GtGhai8hFJPxTs0lw/DY7nR2z96Fiu1ELE9Sv7vwojT+0iN9R7XvOz5UhIbr0A
         kXsDodogWs+vHAYDBu2nMjl24BYXj0faqttuCFMiQGBAj+WTJiVwr1W30CwslPH3nfXp
         K9ifnEU914zJsPuZvIdpmSv+H8ZtSw2UoAnY0L2FMeNNjwqHCgrbIMwKY4KG0wiA0EUo
         7LFA==
X-Gm-Message-State: ABy/qLbTwiPmAyG9VgXVTLaPHQUzndTInaMiNmv2Pe4Cf6RlLXfN9CXX
        29TupLXmqaWPpkZTnkSVxTorLA==
X-Google-Smtp-Source: APBJJlHXKScTmXEgilon30N8c3qbXnKPqUp0hZOJIl/faT7MRn4jaUH13Oir3gHFy6jkpcyqnYXaFg==
X-Received: by 2002:a17:902:e809:b0:1b8:35fa:cdcc with SMTP id u9-20020a170902e80900b001b835facdccmr4193440plg.5.1690412878728;
        Wed, 26 Jul 2023 16:07:58 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a14-20020a17090abe0e00b0025dc5749b4csm1704311pjs.21.2023.07.26.16.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 16:07:58 -0700 (PDT)
Message-ID: <786a1eda-4592-789b-aaea-e70efbabeaa5@kernel.dk>
Date:   Wed, 26 Jul 2023 17:07:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCHSET v6 0/8] Improve async iomap DIO performance
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org
References: <20230724225511.599870-1-axboe@kernel.dk>
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/24/23 4:55?PM, Jens Axboe wrote:
> Hi,
> 
> Hi,
> 
> This patchset improves async iomap DIO performance, for XFS and ext4.
> For full details on this patchset, see the v4 posting:
> 
> https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/
> 
>  fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++-----------
>  include/linux/fs.h   |  35 +++++++++-
>  io_uring/rw.c        |  26 ++++++-
>  3 files changed, 179 insertions(+), 45 deletions(-)
> 
> Can also be found here:
> 
> https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.6
> 
> No change in performance since last time, and passes my testing without
> complaints.
> 
> Changes in v6:
> - Drop the polled patch, it's not needed anymore
> - Change the "inline is safe" logic based on Dave's suggestions
> - Gate HIPRI on INLINE_COMP|CALLER_COMP, so polled IO follows the
>   same rules as inline/deferred completions.
> - INLINE_COMP is purely for reads, writes can user CALLER_COMP to
>   avoid a workqueue punt. This is necessary as we need to invalidate
>   pages on write completions, and if we race with a buffered reader
>   or writer on the file.

Dave, are you happy with this one?

-- 
Jens Axboe

