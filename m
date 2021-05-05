Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A37CC433ED
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 15:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3D461155
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 15:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhEEPrl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 May 2021 11:47:41 -0400
Received: from mail.worldserver.net ([217.13.200.37]:46487 "EHLO
        mail.worldserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhEEPrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 May 2021 11:47:40 -0400
Received: from postpony.nebelschwaden.de (v22018114346177759.hotsrv.de [194.55.14.20])
        (Authenticated sender: postmaster@nebelschwaden.de)
        by mail.worldserver.net (Postfix) with ESMTPA id E845926CF7
        for <linux-xfs@vger.kernel.org>; Wed,  5 May 2021 17:46:29 +0200 (CEST)
Received: from [172.16.37.5] (kaperfahrt.nebelschwaden.de [172.16.37.5])
        by postpony.nebelschwaden.de (Postfix) with ESMTP id 76CBEEB8B1
        for <linux-xfs@vger.kernel.org>; Wed,  5 May 2021 17:46:29 +0200 (CEST)
Reply-To: listac@nebelschwaden.de
Subject: Re: current maximum stripe unit size?
To:     xfs <linux-xfs@vger.kernel.org>
References: <993c93fc-56e7-8c81-8f92-4e203b6e68dd@nebelschwaden.de>
 <43d4d941-e07a-9a75-daad-a9dbcae8da0e@sandeen.net>
From:   Ede Wolf <listac@nebelschwaden.de>
Message-ID: <16433d78-c04b-e8a2-52da-538b83ec3a23@nebelschwaden.de>
Date:   Wed, 5 May 2021 17:46:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <43d4d941-e07a-9a75-daad-a9dbcae8da0e@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

thanks for replying. Indeed I did not distinguish between log and data 
stripe set - as I did not know, those can be treated independendly.

The docs I have all talking about log stripe size, I was just under the 
impression, those set the overall limit.

Thanks again

Ede

Am 03.05.21 um 15:22 schrieb Eric Sandeen:
> 
> 
> On 4/29/21 9:10 AM, Ede Wolf wrote:
>> Hello,
>>
>> having found different values, as of Kernel 5.10, what is the maximum allowed size in K for stripe units?
>>
>> I came across limits from 64k - 256k
> 
> Where did you read that?
> 
>> , but the documentation  always seemed quite aged.
> 
> Current mkfs limits are UINT_MAX for stripe unit and stripe width (so width is the effective limiter in most cases)
> 
> Interestingly, in the kernel the limit on swidth is INT_MAX. In any case, quite large.
> 
> (However, the /log/ stripe unit has a limit of 256; if the data stripe unit is larger, the log stripe unit will automatically be reduced.)
> 
> -Eric
> 
>> Thanks
> 

