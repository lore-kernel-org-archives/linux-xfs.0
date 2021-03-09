Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02DBC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 22:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE34650AC
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 22:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCIW06 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 17:26:58 -0500
Received: from gateway23.websitewelcome.com ([192.185.50.164]:17599 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230075AbhCIW0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 17:26:42 -0500
X-Greylist: delayed 1364 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2021 17:26:42 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id C04985B39
        for <linux-xfs@vger.kernel.org>; Tue,  9 Mar 2021 16:03:57 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id JkSLlgI6Z5rKQJkSLlxGU9; Tue, 09 Mar 2021 16:03:57 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sFVC56Nr3h3444R3x8H8hPzvSqttuM8D3wbuXBin/jo=; b=PeJdk4VRD7mV8U9CDR6MEC2yi3
        iFWD9tLrWs10yakUaZQJ/1bFEi1TcKKME+gZAKB78pwnXG8OY6UesQV4WNCBcQ9hROzZm59ZhyRiv
        uUVO4J+WLc/zJD0pRWjaQD71iDzBQTkLB0YX+m6Q14ZnUXH/ey53Lyuhdm7dHvCi7WSdDacKCFDMF
        +4anh9P8fTcBztYaeFTf5jdd3dR+e5RVy7Maw7LL7sSyRy++sv8IJVKxQ9aRgXq/sPeiGYBrkqTp7
        tkyN1HWkB85f8CA9cNSWDpE+JqvJcsE1NqLHCJ2W+QDWB42SBtXVwOV8pZQ09zdh80eEEMLI+e2Bi
        sd9K86pg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49312 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lJkSL-000zzy-E3; Tue, 09 Mar 2021 16:03:57 -0600
Subject: Re: [PATCH][next] xfs: Replace one-element arrays with flexible-array
 members
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210302150558.GA198498@embeddedor>
 <20210309174212.GV3419940@magnolia>
 <8bf7e1d2-e2d4-c56f-cd04-0045dc4c7e2f@embeddedor.com>
 <20210309212643.GZ3419940@magnolia>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <6cd7c00a-a49c-41f9-06cb-e3123bb32d6c@embeddedor.com>
Date:   Tue, 9 Mar 2021 16:03:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210309212643.GZ3419940@magnolia>
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
X-Exim-ID: 1lJkSL-000zzy-E3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49312
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/9/21 15:26, Darrick J. Wong wrote:
>>> It seems to work all right for casted NULL pointers, and then we get all
>>> the typechecking and multiplication overflow checking, e.g.:
>>>
>>> 	size_t len64 = struct_size((struct xfs_efi_log_format_32 *)NULL,
>>> 				efi_extents src_efi_fmt->efi_nextents);
>> Yeah; in that case, what do you think about casting 0, instead of NULL:
>>
>>        uint len32 = struct_size((xfs_efi_log_format_32_t *)0, efi_extents,
>>                                 src_efi_fmt->efi_nextents);
>>        uint len64 = struct_size((xfs_efi_log_format_64_t *)0, efi_extents,
>>                                 src_efi_fmt->efi_nextents);
> I don't have a preference either way, either here or for the half-dozen
> more of these scattered elsewhere in the file.

OK. I'll send v2, shortly

Thanks for the feedback!
--
Gustavo
