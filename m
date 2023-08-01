Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE2BC001DF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 00:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjHAAU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jul 2023 20:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjHAAUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2023 20:20:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4254133
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 17:20:22 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bbb7c3d0f5so7705545ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 17:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690849222; x=1691454022;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xpuXujTyx0yZXJLxkaZyBE8qOTBt6WGwswqx/Q7zDcg=;
        b=2K+McX52TGTdP9NKCPdI+kPoCVzcRTatAC2vD3e8W1nzmd2FHQ8Fm865VdEFxugdtF
         TgotY/hRJV5IPAP97tZ66IeRpCnGWdC05csbGNLtV/13RyrR6BQU1vlN9KDXJtWGnm1I
         4WLb0i98VZcSowyEAicZTbpqNxtJ/RUIuDm+fdwYTkgA3rOHafFYfqm7ny79fjRV71k2
         Gtpg8RpyPeBsYeh/ZXrH9eLoxxHROXmXOFzvZAQzKOyYArTn/VtpeX1Q86TUZv8PfV0r
         KUP0w2ZV3gTwTkj5n8HeIOKcQ3pGdC+bBUk3ml9zwluFc1y9lolDwq9jvWL2HdK6f3Is
         Hs7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849222; x=1691454022;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xpuXujTyx0yZXJLxkaZyBE8qOTBt6WGwswqx/Q7zDcg=;
        b=L7sf+PWUT0aAmvG5ZPl8F6ugiFB9Ued+8jml2xh1zPNSkSdZeqLkaQl0QDHmLWXQmv
         neCfy2eeItyWIUhCNNxKQwO0nAFxdXDD/bRy/ukTQsxW7iq+QgXMt/AKqQRpZz2ymdUq
         RQQwvc64rKvwv9vbGFzUN6Z+V55+J5KHYKv264MdypxjnGtY+fATfX0q7ASdFk6ZOWdl
         5GPgTftRLJ7gkYdM1uauaJWsco0XDHWrKVZOzmEFah1P9QX8g2Vz+vZoWK3AzhQk0HJF
         MJfN5VxJ7jXY1jQQwJEl6Yp9JXmt2eoo8Pzsyzy160L3WRAcd20XPLQwVRzxeYkZU9+w
         2gBw==
X-Gm-Message-State: ABy/qLawPbfqiGhtG11GK5zYVqsukvVlvcdsqTbckQAY9U1xPkDSJY17
        +et2a42hmoKaKZfaM4JsC1XS4g==
X-Google-Smtp-Source: APBJJlGXrIl+5ZhGuHS3Olt+JwOomXC8Qds7H56BlPm2j/y2NVMdSqx4UwV1cUEkAlTk7nM5o/S3dg==
X-Received: by 2002:a17:902:e803:b0:1bb:c2b1:9c19 with SMTP id u3-20020a170902e80300b001bbc2b19c19mr10289968plg.6.1690849222243;
        Mon, 31 Jul 2023 17:20:22 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c10600b001b8a00d4f7asm9133204pli.9.2023.07.31.17.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 17:20:21 -0700 (PDT)
Message-ID: <93335793-81b5-3c44-81d1-aa74e29893f9@kernel.dk>
Date:   Mon, 31 Jul 2023 18:20:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCHSET v6 0/8] Improve async iomap DIO performance
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, djwong@kernel.org
References: <20230724225511.599870-1-axboe@kernel.dk>
 <786a1eda-4592-789b-aaea-e70efbabeaa5@kernel.dk>
 <ZMQ2SEVlqZ59NmSL@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZMQ2SEVlqZ59NmSL@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/28/23 3:42 PM, Dave Chinner wrote:
> On Wed, Jul 26, 2023 at 05:07:57PM -0600, Jens Axboe wrote:
>> On 7/24/23 4:55?PM, Jens Axboe wrote:
>>> Hi,
>>>
>>> Hi,
>>>
>>> This patchset improves async iomap DIO performance, for XFS and ext4.
>>> For full details on this patchset, see the v4 posting:
>>>
>>> https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/
>>>
>>>  fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++-----------
>>>  include/linux/fs.h   |  35 +++++++++-
>>>  io_uring/rw.c        |  26 ++++++-
>>>  3 files changed, 179 insertions(+), 45 deletions(-)
>>>
>>> Can also be found here:
>>>
>>> https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.6
>>>
>>> No change in performance since last time, and passes my testing without
>>> complaints.
>>>
>>> Changes in v6:
>>> - Drop the polled patch, it's not needed anymore
>>> - Change the "inline is safe" logic based on Dave's suggestions
>>> - Gate HIPRI on INLINE_COMP|CALLER_COMP, so polled IO follows the
>>>   same rules as inline/deferred completions.
>>> - INLINE_COMP is purely for reads, writes can user CALLER_COMP to
>>>   avoid a workqueue punt. This is necessary as we need to invalidate
>>>   pages on write completions, and if we race with a buffered reader
>>>   or writer on the file.
>>
>> Dave, are you happy with this one?
> 
> I haven't had a chance to look at it yet. Had my head in log hang
> bug reports these last few days...

Is it going to happen anytime soon? Would be nice to get this
flushed out for 6.6.

-- 
Jens Axboe


