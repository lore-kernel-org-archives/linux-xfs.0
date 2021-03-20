Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF7FC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 21:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5AD96148E
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 21:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCTVnh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Mar 2021 17:43:37 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.36]:43904 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229886AbhCTVnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Mar 2021 17:43:04 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Mar 2021 17:43:04 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 4F5565CBD
        for <linux-xfs@vger.kernel.org>; Sat, 20 Mar 2021 16:21:04 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Nj1slsBp2L7DmNj1slQali; Sat, 20 Mar 2021 16:21:04 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wvk/qSZI6Fzn1oUDvqP0MKw745b0VRkjkJqWjBqnIpM=; b=keKyp3vZxo972ZfNGZJSlB9/DH
        /iJVv8r1TyxmdclN34lQ8NDDkOanuelOpAztihwESJPgBUeofUX9cNrDxONHZPMSbz/GeWPJm2Ktg
        vhZ4PNX7N/YthiQ7KOwpSkKRTgLQrA9wcSZSDadnrfRpJTsxbwJfvcxUGW15pyiYaUS6xv+gNUqbs
        aB6PNWLlYg97kUZgAgOhnyfVLhOEBt+4TBfuXfmnYJHywwXwcoH7zgmejMOdhmBJs0n7ZjPfzX3OF
        ZjMM7SYB6/XureWJY2Xj3nKDEU3bEVGBQnt3RfeaB5c5CJSh7zRhWhQ++bgia0DItlT0D2gzk5TDl
        imB4Bjew==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:60306 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lNj1s-00413S-0O; Sat, 20 Mar 2021 16:21:04 -0500
Subject: Re: [PATCH v3][next] xfs: Replace one-element arrays with
 flexible-array members
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210311042302.GA137676@embeddedor>
 <20210311044700.GU3419940@magnolia>
 <96be7032-a95c-e8d2-a7f8-64b96686ea42@embeddedor.com>
 <20210320201711.GY22100@magnolia>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <d5a9046e-e204-c854-34fe-2a39e58faea4@embeddedor.com>
Date:   Sat, 20 Mar 2021 15:20:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210320201711.GY22100@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lNj1s-00413S-0O
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:60306
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/20/21 15:17, Darrick J. Wong wrote:
>>>> Below are the results of running xfstests for groups shutdown and log
>>>> with the following configuration in local.config:
>>>>
>>>> export TEST_DEV=/dev/sda3
>>>> export TEST_DIR=/mnt/test
>>>> export SCRATCH_DEV=/dev/sda4
>>>> export SCRATCH_MNT=/mnt/scratch
>>>>
>>>> The size for both partitions /dev/sda3 and /dev/sda4 is 25GB.
>>>
>>> Looks good to me, will toss it at my fstests cloud and see if anything
>>> shakes out.  Thanks for cleaning up this goofy thorn-pile!
>>
>> Great. It's been fun to work on this. :p
> 
> Did you run the /entire/ fstests suite?  With this patch applied to
> 5.12-rc2, I keep seeing list corruption assertions about an hour into

Nope; I run xfstests 'shutdown' and 'log' groups on 5.11.0, only.

How do you run the entire fstests?
Could you give me some pointers?

> the test run, and usually on some test that heavily exercises allocating
> and deleting file extents.  I'll try to look at this patch more closely
> next week, but I figured I should let you know early, on the off chance
> something sticks out to you.

OK. I'll go run my tests on 5.12-rc2.

Should I run the entire xfstests, too?

Thanks
--
Gustavo
