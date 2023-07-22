Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1481C41513
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Jul 2023 02:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjGVCxP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 22:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjGVCxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 22:53:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9567135B3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 19:53:09 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bb85ed352bso56145ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 19:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689994389; x=1690599189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xiaVRG+ShF5muUmYc/onPTSWcXgRUf7boGUXUDdRaPo=;
        b=zdKxKD0gzLBA5m3r7vlbOg7noehP7VffHG9OFjAmD9o0S/rS73O/9SDOdq047T1VxQ
         Y5td8YLRsVIztlEklFnNqStI0/ls0nBAt+rqKDOSZgO3kSU/9YZO9oFRzn3VKnryn3nI
         wVAhjUt0IvpIit66zf0CBix54FyIuOWhk6vh26lM/PAuCqHBdNDsfU5cEMSWktKAcbYg
         5fntXzTrgtq0vYwWHmo1fAduvHTPhLJYDcTqHiHMKHgiZ5mA0BGQDBzkEuQM1OLVaBby
         vVK5grz3HQ7IeF+98L2EbpTYSmn00ZswFXz9iDCnBT9CaMFNZv1bgIkkScJWPOpKQwUk
         DN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689994389; x=1690599189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xiaVRG+ShF5muUmYc/onPTSWcXgRUf7boGUXUDdRaPo=;
        b=fvXBDS6E5XvfqZAX3t2Ey21gYkEHLrzxL1RmsTibEsQkX5xfgjduVc8Edf6OBZog5H
         DobR8+uopGqaQnmh2g/0Wpg7JYDhVLZvAh1FjvNjtQgK7NqwXqOp5c0jx+6oR3YQfYVe
         SHeBKF4RiK1w5Lmfkgf2uGe5NXbTjKBNfPgN2g2zFuZ4yNZXbgfFYKLRW1GW6v/d7Bwn
         pqsunRmiFFISRIOjiSnSujdaC7IK3QFjwJkj3Lt9H0tYxyVA/k2Bhk79pRQlneGwrsUI
         YzpSLdoM+K4DrFNI09VvSRb5guhHI6Z6e4puhh2pIMTSHrZTckQQa7gR+rcSIVhOiFuH
         WO4w==
X-Gm-Message-State: ABy/qLbAa+NvvKx/FTnJFMcPxYQwCXIk+PhC86zaboZWemEjtcJ1Fx1G
        7DuZ+UKaltPjrqCE5UDwnHYj0Q==
X-Google-Smtp-Source: APBJJlEBZoL6R7x3w64iwSlJzJUhvE3c8T+YG/r88OBLCJWUArVk9BBIHkc7t2QeGaZcbCW4zg41MA==
X-Received: by 2002:a17:903:24f:b0:1b8:ac61:ffcd with SMTP id j15-20020a170903024f00b001b8ac61ffcdmr4691039plh.3.1689994388909;
        Fri, 21 Jul 2023 19:53:08 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n13-20020a170902e54d00b001b9be3b94d3sm4200925plf.140.2023.07.21.19.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 19:53:07 -0700 (PDT)
Message-ID: <dcca1b15-6d3f-24a0-0317-563efa9895bf@kernel.dk>
Date:   Fri, 21 Jul 2023 20:53:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [GIT PULL] Improve iomap async dio performance
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <647e79f4-ddaa-7003-6e00-f31e11535082@kernel.dk>
 <ZLsB80ylEgs6fq13@dread.disaster.area>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZLsB80ylEgs6fq13@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/21/23 4:08?PM, Dave Chinner wrote:
> On Fri, Jul 21, 2023 at 10:54:41AM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Here's the pull request for improving async dio performance with
>> iomap. Contains a few generic cleanups as well, but the meat of it
>> is described in the tagged commit message below.
>>
>> Please pull for 6.6!
> 
> Ah, I just reviewed v4 (v5 came out while I was sleeping) and I
> think there are still problems with some of the logic...
> 
> So it might be worth holding off from pulling this until we work
> through that...

No problem, thanks for taking a look! I'll address your feedback
tomorrow and I can always just send another pull request.

-- 
Jens Axboe

