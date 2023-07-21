Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219E2EB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 14:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjGUOEX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 10:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjGUOEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 10:04:22 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F5ECE
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 07:04:21 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-78706966220so18861039f.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 07:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689948260; x=1690553060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hd+3Du2K9dSrzjpH/WaoagexKKiDZ1jhyAjWgONy/SM=;
        b=O+xzZQcfECwCo7dj8d2XQwOmWjwAYSTfqBX+tWLSqF4Fa/OYxDXKfRJAQDEgaMfF8O
         OSy2ja5rQPoz+Eau6M7XMYe9nTODuBWaqhIPi5ZZiLj6ZLdCr4A2XETtBGzNPBdL+OBf
         OhL8E8Ucbu/NPy01gcL7aGM0xNUR6QjIkHfERuY1woRsLu7uipWldr+tWkcWJ7s6fZW3
         ojRfhAQLq4GYd4pOknbZ56CijpaQoUl8f/5GBeXC9M50REQ4hiZg2rY2Tib+92jF/eqX
         qwFjONOwPZdWHs2/X+k3H7yJOGpvl9qL7Fi5f1iGqPKG2qS2mE18J6RXgSHoPo+7qFVm
         n/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689948260; x=1690553060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hd+3Du2K9dSrzjpH/WaoagexKKiDZ1jhyAjWgONy/SM=;
        b=LWYtuZmUAzPzFxrMKL12nq3AX/ZfAAtFxFBKCMYVSjuWKdEJilTvNahtgcSDjg+oWH
         w++RVJFb6X8EfQrB5emsXonESF19IfM2OQR5QQMVzkjI4NetUYOtKyw5rsGJs8zK+Do+
         lDFh9y7eURGynP8LIZO4Sr4JMwhVbPLNRQ+8fUsxVwwRAhNFtrz7bKWBJ8mBfvY+X5vO
         Wl/lwL2RvHo6US5PVDtykSQ9TGSOmG6f/oYb1k2nAWbZu/rhsT8VSLSBitM10IFycBUT
         rEWIkfDd6VNpMGQ78PMph3E4fe+ckhYE56oRD4eunzFVVoLO4ctG0sxDyEtT598HaISt
         AYew==
X-Gm-Message-State: ABy/qLZuqhFeZvdoZwmnh35H6zE1iI25hxLARmdd9kZI+UYn3aSnNGEG
        0c79iVdrL9+kYoPuAnN7m32kGg==
X-Google-Smtp-Source: APBJJlE6jLWBotJ7f2uz+sxTTQ8vydHCa8L0AWolLZQNBVR3bY/PP5K7si0YOiHp+EBcYkga9vPoMQ==
X-Received: by 2002:a05:6602:8c9:b0:787:16ec:2699 with SMTP id h9-20020a05660208c900b0078716ec2699mr1675361ioz.2.1689948260668;
        Fri, 21 Jul 2023 07:04:20 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dp21-20020a0566381c9500b0042b1061c6a8sm1063459jab.84.2023.07.21.07.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 07:04:19 -0700 (PDT)
Message-ID: <5b14e30b-1a22-b5fe-1a21-531397b94b16@kernel.dk>
Date:   Fri, 21 Jul 2023 08:04:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/8] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-4-axboe@kernel.dk> <20230721061554.GC20600@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721061554.GC20600@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/21/23 12:15?AM, Christoph Hellwig wrote:
> On Thu, Jul 20, 2023 at 12:13:05PM -0600, Jens Axboe wrote:
>> Whether we have a write back cache and are using FUA or don't have
>> a write back cache at all is the same situation. Treat them the same.
>>
>> This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
>> two cases that provide stable writes:
>>
>> 1) Volatile write cache with FUA writes
>> 2) Normal write without a volatile write cache
>>
>> Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
>> update some of the FUA comments as well.
> 
> I would have preferred IOMAP_DIO_WRITE_THROUGH, STABLE_WRITES is a flag
> we use in file systems and the page cache for cases where the page
> can't be touched before writeback has completed, e.g.
> QUEUE_FLAG_STABLE_WRITES and SB_I_STABLE_WRITES.

Good point, it does confuse terminology with stable pages for writes.
I'll change it to WRITE_THROUGH, that is more descriptive for this case.

-- 
Jens Axboe

