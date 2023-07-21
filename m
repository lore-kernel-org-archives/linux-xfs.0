Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2AFEB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 16:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjGUQwm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjGUQwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 12:52:41 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7AB2726
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:52:39 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-34770dd0b4eso2641435ab.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689958358; x=1690563158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OnupsbExh4NM9Tn6/gpUNLLTgNhKms1bpTeWjm068wg=;
        b=inoaNIPOECQy4pA3qZTlkqjBrWntS+Q8OSQVxMLo0NjeWorYEEyD70BXwKDfyp8JJ4
         kZdBXWNvJwc/nMyXNpNeGHoXaeLxWzIpjY/BEUfXPJzj088Xq1OiD+XWuOKZlnKvqrLg
         4bjEmGagmAtA0wmlfV3E0QTdFbatKXymkReTMzS+Dh2ZOjsIhRpswgmfxuYdL1tUDogJ
         Tph5b4Kw7gmK8BbOjQkVU9bZaFxCIiPTiVt6wd9jQzqLLJ+VKXFnmHqZIqqy7YubcqVG
         by768eJF/4jyKw6tDWDOvy9yU82azp8O9P0Ak027xqipgoLRzcRRMF28w2WoKhqbyVEH
         O/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689958358; x=1690563158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OnupsbExh4NM9Tn6/gpUNLLTgNhKms1bpTeWjm068wg=;
        b=hMZjlYWIscqw9tnduPEnHsNVyugKf4PbZ+fUTzwk1Ao2qkNHivgVKbbpRtf4aac1sY
         VV7N0JHcwMbxrJZmfIDOtpjzj6hpPVsKouPKxrBS43P4fPsz5gHDg8YyLMO2wubCXZm+
         f8mRTQnN9BQI4Oy72/pophXo5a+ltB+tbGpUPKZsQDsLEYQIu3uKU9Xyz8fEpEUMe35z
         4lLqDRFMNGxgRDiHanlgNCj0Qg9xUUr0mojwdzUd77dXkOAd0LeYzEpOMmteVV1i07qC
         VUozJHWif5XLlMVpDYdeQ7NJ1/NMoyCKtH01fRoTYwjQub5OEoL89jR9p01VYUpbH57M
         Z5aQ==
X-Gm-Message-State: ABy/qLY19TcSxLavoEpSwb7rzN6ZW+ma0pGsbMYQcRwvBBU5Wk6exeny
        6y4nxgTdxkA6bgurNArgGdFJCA==
X-Google-Smtp-Source: APBJJlGiswFLAOQvljGsoE8hQKUkJW9EMS21QiLhqeQWKvrNgerOvL3EbZw73YgWKOecj9z49gL04w==
X-Received: by 2002:a92:ad0f:0:b0:346:10c5:2949 with SMTP id w15-20020a92ad0f000000b0034610c52949mr2092903ilh.1.1689958358423;
        Fri, 21 Jul 2023 09:52:38 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b13-20020a92c14d000000b00348730b48a1sm1069686ilh.43.2023.07.21.09.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:52:37 -0700 (PDT)
Message-ID: <7c980a66-0e74-06df-dae5-6d7887dd3544@kernel.dk>
Date:   Fri, 21 Jul 2023 10:52:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/9] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-4-axboe@kernel.dk>
 <20230721162553.GS11352@frogsfrogsfrogs>
 <4fcc44be-f2da-9a7c-03ca-f7e38ac147cb@kernel.dk>
 <20230721164744.GW11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721164744.GW11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/21/23 10:47 AM, Darrick J. Wong wrote:
> On Fri, Jul 21, 2023 at 10:27:16AM -0600, Jens Axboe wrote:
>> On 7/21/23 10:25?AM, Darrick J. Wong wrote:
>>>> @@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>>>  
>>>>  		       /*
>>>>  			* For datasync only writes, we optimistically try
>>>> -			* using FUA for this IO.  Any non-FUA write that
>>>> -			* occurs will clear this flag, hence we know before
>>>> -			* completion whether a cache flush is necessary.
>>>> +			* using WRITE_THROUGH for this IO. Stable writes are
>>>
>>> "...using WRITE_THROUGH for this IO.  This flag requires either FUA
>>> writes through the device's write cache, or a normal write..."
>>>
>>>> @@ -627,10 +632,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>>>  		iomap_dio_set_error(dio, ret);
>>>>  
>>>>  	/*
>>>> -	 * If all the writes we issued were FUA, we don't need to flush the
>>>> +	 * If all the writes we issued were stable, we don't need to flush the
>>>
>>> "If all the writes we issued were already written through to the media,
>>> we don't need to flush..."
>>>
>>> With those fixes,
>>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>> If you're queueing up this series, could you just make those two edits
>> while applying? I don't want to spam resend with just a comment change,
>> at least if I can avoid it...
> 
> How about pushing the updated branch, tagging it with the cover letter
> as the message, and sending me a pull request?  Linus has been very
> receptive to preserving cover letters this way.

OK, will do.

-- 
Jens Axboe


