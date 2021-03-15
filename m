Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975CAC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 518B364EF9
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhCOTyB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:54:01 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.108]:37077 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232666AbhCOTxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 15:53:48 -0400
X-Greylist: delayed 1334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2021 15:53:47 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 7E618112D7A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 14:31:30 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Lsw6l7lVXMGeELsw6lzUt3; Mon, 15 Mar 2021 14:31:30 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/H0ligbcxPpdDZScnFVEzZTS5RK+PXk5CzzXsw7JzbA=; b=ktrIMr/qHov2/xwdpYQbGI/u6A
        +Oe/YcFuhW6ut7NfPsD3AwKnpdjpQCSB2kDvbYe+O14x+a8sWgkhvsBLwt8Fup7Nca6W64Ou+y5LM
        2JDuPI7gqgNeHw/RtaH7I4bxB7R7QQRRAvUwzXuBEseF4w6RlgtelgvWOnVu5/VmcVN1F9yLz73zI
        xurIUVrLsOw+ytisHO4+sNG/8nyfMWJjqHvi4dc5ppWLAaQsAlQCT7iTHNQi+1lDNVXIarnQ9IPrs
        BpItnUSmPcB/bXilXHoqKoUxFw/n1uC/50vOFHuy4BlP7ikGaCDppDYui3AjD1vwNonFLiEJELQOd
        TNtcFdAQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:34340 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lLsw6-002lVA-5d; Mon, 15 Mar 2021 14:31:30 -0500
Subject: Re: [PATCH v3][next] xfs: Replace one-element arrays with
 flexible-array members
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210311042302.GA137676@embeddedor>
 <20210311044700.GU3419940@magnolia>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <96be7032-a95c-e8d2-a7f8-64b96686ea42@embeddedor.com>
Date:   Mon, 15 Mar 2021 13:31:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311044700.GU3419940@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lLsw6-002lVA-5d
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:34340
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/10/21 22:47, Darrick J. Wong wrote:
> On Wed, Mar 10, 2021 at 10:23:02PM -0600, Gustavo A. R. Silva wrote:
>> There is a regular need in the kernel to provide a way to declare having
>> a dynamically sized set of trailing elements in a structure. Kernel code
>> should always use “flexible array members”[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
>>
>> Refactor the code according to the use of flexible-array members in
>> multiple structures, instead of one-element arrays. Also, make use of
>> the new struct_size() helper to properly calculate the size of multiple
>> structures that contain flexible-array members. Additionally, wrap
>> some calls to the struct_size() helper in multiple inline functions.
>>
>> Below are the results of running xfstests for groups shutdown and log
>> with the following configuration in local.config:
>>
>> export TEST_DEV=/dev/sda3
>> export TEST_DIR=/mnt/test
>> export SCRATCH_DEV=/dev/sda4
>> export SCRATCH_MNT=/mnt/scratch
>>
>> The size for both partitions /dev/sda3 and /dev/sda4 is 25GB.
> 
> Looks good to me, will toss it at my fstests cloud and see if anything
> shakes out.  Thanks for cleaning up this goofy thorn-pile!

Great. It's been fun to work on this. :p

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!
--
Gustavo
