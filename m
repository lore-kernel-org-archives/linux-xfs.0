Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85C3EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 16:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjGTQZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 12:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjGTQZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 12:25:26 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CF2114
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 09:25:23 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so12507539f.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 09:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689870322; x=1690475122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y3I414zv04A9+qU7TbrTnDxY7ym9eW8t+F+laAPoK60=;
        b=ZTO5xKXE/6EzkT43ORkecNoB7OoogXCDr82I61frQNQtjCS4G6f0b+KuhWxRJsZ+kf
         NkD8jJ7252vLxaqhGgRS10KjwoUya34xFIDzuwjvbaoiC74/EnghWlj4WdP9VdpMfkZq
         yZ+fZ3FHadDw05UUS9VYgZaWeq77++RU2ewSKVV0xp3prjt9h894QUPK0+XkBKkOwJDx
         OoxG4KO6SttLY5vjZRRh3NxEEGHnSUWP22vWsI8q9xXOBcDiUtUE97M00sFC96W0SBtr
         uOmPiSq7S9nicNQk0Wcwl93lZ6jwsYm1D/A01ytKpaNnPCl0sC6CulyH61b+az8dBfBe
         TpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689870322; x=1690475122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3I414zv04A9+qU7TbrTnDxY7ym9eW8t+F+laAPoK60=;
        b=dFp1xVNc+OA/VfiEc3Z1PSejpGbXkdO9H2kvlVshUjygNnKaGjaaAMCE+5npLP269C
         e83q08IKq/ff1eI/t3d/wQfuJFk76Lza7E9bFEkZiVVehL1Ht4PZdXgxvXDtlG6lSOxT
         3DLSFHC9NWxHaI49pRH2h/aCV5I4lMFNlhWodVYHmYv/3cfX6SQcmVuqlQdcn8k7FPc4
         7OygGb9IYrIeilWaWVigi2uhHNFjOioJQROkwTXf56nkO+/wTfQfEoK2ACU83kwFNOMj
         eh+6QgL8Bya0eO62xH4TppgssJXOOLKqTy99BmCo3x1AxKF8EMXgcvN9c92BqFw8zHUx
         dAhA==
X-Gm-Message-State: ABy/qLYnUO9OwF+60IolEa9/BU2/KLMGx87w/UQkeegcx8LggEydThMy
        +XtlG6ejx4SU0eLjR/OHnuXMfg==
X-Google-Smtp-Source: APBJJlHFMD/YbKKO5bXaEK/SFXhIhNXwjIPOF+YiZ5pvUESvBP5Ig0VZNfnGEWZYGnr1MU2/MVADoQ==
X-Received: by 2002:a05:6602:3d3:b0:788:479f:171b with SMTP id g19-20020a05660203d300b00788479f171bmr5176636iov.0.1689870322591;
        Thu, 20 Jul 2023 09:25:22 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b26-20020a029a1a000000b0042b69cca627sm408515jal.137.2023.07.20.09.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 09:25:21 -0700 (PDT)
Message-ID: <31a3a786-9781-6a67-08a6-17190897adab@kernel.dk>
Date:   Thu, 20 Jul 2023 10:25:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/6] fs: add IOCB flags related to passing back dio
 completions
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230719195417.1704513-1-axboe@kernel.dk>
 <20230719195417.1704513-5-axboe@kernel.dk> <20230720050114.GE1811@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720050114.GE1811@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/19/23 11:01?PM, Christoph Hellwig wrote:
>>  /* can use bio alloc cache */
>>  #define IOCB_ALLOC_CACHE	(1 << 21)
>> +/*
>> + * IOCB_DIO_DEFER can be set by the iocb owner, to indicate that the
>> + * iocb completion can be passed back to the owner for execution from a safe
>> + * context rather than needing to be punted through a workqueue. If this
>> + * flag is set, the completion handling may set iocb->dio_complete to a
>> + * handler, which the issuer will then call from task context to complete
>> + * the processing of the iocb. iocb->private should then also be set to
>> + * the argument being passed to this handler.
> 
> Can you add an explanation when it is safe/destirable to do the deferred
> completion?  As of the last patch we seem to avoid anything that does
> I/O or transaction commits, but we'd still allow blocking operations
> like mutexes used in the zonefs completion handler.  We need to catch
> this so future usuers know what to do.

Sure can do - generally it's exactly as you write, anything that does
extra IO should still be done in a workqueue to avoid stalling this
particular IO completion on further IO.

> Similarly on the iomap side I think we need clear documentation for
> what context ->end_io can be called in now.

Honestly that was needed before as well, not really related to this
change (or the next two patches) as they don't change the context of how
it is called.

-- 
Jens Axboe

