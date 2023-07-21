Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59125EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 15:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjGUPyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 11:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjGUPyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 11:54:11 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466A4E6F
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 08:53:55 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-78706966220so20654739f.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689954834; x=1690559634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O4ARo/yeOTiBgmP0k36MZmETrc39lrjPt/j+rt2AQLs=;
        b=gBpNGmA3y3F4Ogo7q7QOWMw3ChKxkE9O805A8TeP9W7Ew9QLy6COgUj2RENTfIZ7DV
         /Ile+y3EGXiqaG4w3xesg2Lo0nFAhyuvFkTqPcMlovSlWbZLBMSfzGNZMUPc1+rsfJbb
         5rAJovP6G7gXWhTzj7J0hwqK8UbSOOMttBTtrDSkTpqp3KBgU9R4hrnrwovJ4Hh0mPj+
         Orze/7IUGL880jyuTS0FA4DSW4EUwv/Nf4n6AchUuNinYqqdVPmf7b1dqYcc6WsxmSMF
         9Vioj8+24Huati3gLd8go7DMvk6HUCi3VVs06QmTPMPBBweCeZ9IoWjHcPgMVHrWyifO
         Bvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689954834; x=1690559634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4ARo/yeOTiBgmP0k36MZmETrc39lrjPt/j+rt2AQLs=;
        b=RXdDqWYHW+LiZPd7nEAys1qQAJkHxOei8rNyqUI1u4NFZkuMZelCrQeHyt9rp9GwQf
         nlx8UXJevFNCDReYktviXdShfa4on6oIOrxnj9eL5BJ3gL0YjvCBCOI1GSeLHNaW4rrU
         IGNmynnBA9bN3bDOcraz6wYJ8XdAgy0J22M/4iikjStfHcLBdQCvHmNZAbAogBezLngp
         ECzsTm+KBaS733mPi4Xl6hL4CE8WwMZV8lzyd7h/LdX85dyF9cSmvkVvi0IavozJUdab
         QLn3WsO/hB0Uz095smggaC+on13nehyjt6Pbsiz3IkW4txUuFJioE4s1vwTFolPm+Mep
         OTmA==
X-Gm-Message-State: ABy/qLbNdw+IpuDLH4uFMoeKVjp2rTLp9flMazCR3Y6zVypDCoXa+CZx
        F4YoDVHIiCCKcvlPsBouZ5yaqFVCoWAdjuWQa9c=
X-Google-Smtp-Source: APBJJlEEmTQ/d8r7kyEOemx68DPGN+UrWLxPwqY2XR6uq4PCmBJ1Xr7E2En6E6P54FgMNfxkMqbsnA==
X-Received: by 2002:a05:6602:4809:b0:77a:ee79:652 with SMTP id ed9-20020a056602480900b0077aee790652mr2281366iob.1.1689954834704;
        Fri, 21 Jul 2023 08:53:54 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o3-20020a02cc23000000b0042b6978ccc7sm1094738jap.94.2023.07.21.08.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:53:53 -0700 (PDT)
Message-ID: <480a5dfe-dc7d-adea-9e6a-1c149a0844ab@kernel.dk>
Date:   Fri, 21 Jul 2023 09:53:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 7/8] io_uring/rw: add write support for IOCB_DIO_DEFER
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-8-axboe@kernel.dk>
 <20230721155034.GP11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721155034.GP11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/21/23 9:50?AM, Darrick J. Wong wrote:
> On Thu, Jul 20, 2023 at 12:13:09PM -0600, Jens Axboe wrote:
>> If the filesystem dio handler understands IOCB_DIO_DEFER, we'll get
>> a kiocb->ki_complete() callback with kiocb->dio_complete set. In that
>> case, rather than complete the IO directly through task_work, queue
>> up an intermediate task_work handler that first processes this
>> callback and then immediately completes the request.
>>
>> For XFS, this avoids a punt through a workqueue, which is a lot less
>> efficient and adds latency to lower queue depth (or sync) O_DIRECT
>> writes.
>>
>> Only do this for non-polled IO, as polled IO doesn't need this kind
>> of deferral as it always completes within the task itself. This then
>> avoids a check for deferral in the polled IO completion handler.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Seems pretty obvious to me, though I'm famous for not being an
> experienced io_uring user yet...
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks, keyword here is "yet" ;-)

-- 
Jens Axboe

