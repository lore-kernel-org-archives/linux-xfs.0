Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6FEC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 15:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbiFXP1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 11:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiFXP1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 11:27:17 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9075151317;
        Fri, 24 Jun 2022 08:27:16 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.254.122.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 43B4E7F8F8;
        Fri, 24 Jun 2022 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656084435;
        bh=dqXxhETwvokQiIm5x80WTIJgvrFxIMsjKY1qs1QtCjY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Oi+vpIn21Bl+oYJQyqia2C8uWeF8Cylu3GekctbMfvwb9ieeoe98/wQiUHUSx6XyS
         MsmD6OEvKYfakQ7YJzlzVKiDtiopVMsWTN8AuY2mBjcoGvFvVrSz2LvNWpj8hg2flc
         pvpq9Peu43cpVud9PHqKDNOrnDBXIfDW5wXLaOX5vUrLQnuTddLanJZxEnOfRphVCE
         ZRf/h6kAGQqWFl295wcVrWPvbCWFn8KFTGXvcCcjyJ4W4nUXnEfNoPfd29LAJMcj46
         CRFCmx7gOprMllZLPZ+KtOyvBXN1NioyHlYX8muVIhrcRxeX9tWRPKZXdj7gIzWCmG
         sjuq7+W8V5vBQ==
Message-ID: <4ce26ef8-b70f-9213-3210-41f32867df63@gnuweeb.org>
Date:   Fri, 24 Jun 2022 22:27:09 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RESEND PATCH v9 00/14] io-uring/xfs: support async buffered
 writes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        willy@infradead.org
References: <20220623175157.1715274-1-shr@fb.com> <YrTNku0AC80eheSP@magnolia>
 <YrVINrRNy9cI+dg7@infradead.org>
 <2189b2ff-e894-a85c-2d1b-5834c22363d5@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <2189b2ff-e894-a85c-2d1b-5834c22363d5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/24/22 9:49 PM, Jens Axboe wrote:
> On 6/23/22 11:14 PM, Christoph Hellwig wrote:
>> On Thu, Jun 23, 2022 at 01:31:14PM -0700, Darrick J. Wong wrote:
>>> Hmm, well, vger and lore are still having stomach problems, so even the
>>> resend didn't result in #5 ending up in my mailbox. :(
>>
>> I can see a all here.  Sometimes it helps to just wait a bit.
> 
> on lore? I'm still seeing some missing. Which is a bit odd, since eg b4
> can pull the series down just fine.

I'm still seeing some missing on the io-uring lore too:

    https://lore.kernel.org/io-uring/20220623175157.1715274-1-shr@fb.com/ (missing)

But changing the path to `/all/` shows the complete series:

    https://lore.kernel.org/all/20220623175157.1715274-1-shr@fb.com/ (complete)

b4 seems to be fetching from `/all/`.

-- 
Ammar Faizi
