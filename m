Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5598BC76196
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 02:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCQCxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 22:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCQCxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 22:53:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB793E081
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:53:09 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x11so1703110pja.5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679021589; x=1681613589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E+eXRdP9Oh06pkJEQfCkDaUqO1qE+/y/kM5YhZ0CyF8=;
        b=66N2L5uy/PSyfUNkUPj5rCSWt0gJZJ31p4S2CMQEiXYLF146Zki/X97oGU+s9I2u6Y
         xCcS2stF6nU6bP3In4pcLJn10+1/WsT0s1vL4TcrkJyxXxpCofxhWCLOo+J6nk45kxyG
         7uy1/q1FsA79toXpAgRT3uwxANG544bdY44I21fDzaGoItRK9zOfjuwH6uro56aguizm
         9dBTuY+BXEjweMC/1q+F/DPd8J74gZrvf7SsgGhr5b/V9CZhBVawneYzTWhzm7MLa6a+
         NyF6sNC34a0/M/XCegFzKCWBlNvZgPTZ3KdPyfROtUh45kY/igru5nZcORVh6WFkUV0j
         Sv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679021589; x=1681613589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+eXRdP9Oh06pkJEQfCkDaUqO1qE+/y/kM5YhZ0CyF8=;
        b=ZV5zKqezMvUd3GEcv5CRh9XY5Osn53u+wPPIuHSZ+gKFAVxDxbH2aMrnDKkx+sk6JS
         cvfb1vQsE0/GyT0Leg+wzZCILP+TBoA1OQ0SVJ4ZF6p593Be4vG6lQrRJBLOgkqycTsz
         k9JZukiS7vFxUTzf9Ddov5tie3pZiXOxJUvG8lqo+n0cEhGbC00BYIuTfheHM7SlIkww
         ZbA6hjNsdil8zyemWEfgbMWca9Qpe2GIdm79nE5nhcquV7P2VRks62xl7/MrxIvDqbKQ
         pc2+1RWd2MkXvYjA56KTUmNQrbwjub/PUgzQoqvB9QtAPtMSlw0IWgjNhHp7RCuxDgX1
         vOsQ==
X-Gm-Message-State: AO0yUKXOGX2CpUUQ1eFXiaobJRua76HMvsfw1tmhrxAnkgzDFJTsgBV5
        0GwEZUI0ZMT0Katgm4cPRH/luQ==
X-Google-Smtp-Source: AK7set+lrtaNiEv6+zEyWS9cYD4p972SFQ5dYlgq6B5kZ0CNj58XZrBm9watTWVPNI590v7FWOwzmA==
X-Received: by 2002:a05:6a20:6914:b0:cd:fc47:dd73 with SMTP id q20-20020a056a20691400b000cdfc47dd73mr10145784pzj.2.1679021588750;
        Thu, 16 Mar 2023 19:53:08 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y127-20020a633285000000b00502ea8014f3sm340501pgy.42.2023.03.16.19.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 19:53:08 -0700 (PDT)
Message-ID: <c9c2c53e-ca65-2122-84fd-05cb4da99aa6@kernel.dk>
Date:   Thu, 16 Mar 2023 20:53:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET for-next 0/2] Flag file systems as supporting parallel
 dio writes
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20230307172015.54911-1-axboe@kernel.dk>
 <b11d27d5-8e83-7144-cdc8-3966abf42db5@kernel.dk>
 <20230316042912.GI11376@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230316042912.GI11376@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/15/23 10:29 PM, Darrick J. Wong wrote:
> On Wed, Mar 15, 2023 at 11:40:02AM -0600, Jens Axboe wrote:
>> On 3/7/23 10:20 AM, Jens Axboe wrote:
>>> Hi,
>>>
>>> This has been on my TODO list for a while, and now that ext4 supports
>>> parallel dio writes as well, time to dust it off and send it out... This
>>> adds an FMODE flag to inform users that a given file supports parallel
>>> dio writes. io_uring can use this to avoid serializing dio writes
>>> upfront, in case it isn't needed. A few details in patch #2, patch 1 does
>>> nothing by itself.
>>
>> I'm assuming silence is consent here and folks are fine with this
>> change?
> 
> Oh, yeah, this one fell off my radar.
> 
> LGTM,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks Darrick.

-- 
Jens Axboe


