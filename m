Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE18C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 19:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324EF610A8
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 19:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhEZTKF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 15:10:05 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.4]:42079 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232982AbhEZTKC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 15:10:02 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2021 15:10:02 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 342E8CF676B
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 13:20:18 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ly8glbVoHFRe9ly8glVzXj; Wed, 26 May 2021 13:20:18 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HDHHVDIABje6bABsXVUlN331Ep4noo+DQ9eLJRToQC4=; b=fkI2TXjBxKC91M9xJGgzChXoeB
        86+oMYnOFtHXnoNMPEJp6ro4Sb3SlFFYdK7aqFoJ4nLNGt/ZNCnkhWvWTqRUWSHQmD8ZB+WIOGL/d
        p9TDzoB9NYqFYbI0d0JYEVrES5QqF4TMLpBK9V2gAFYyG2ejhtq/eEVP+9KK6yIdmYwZ7OQD1DMaT
        2xarFCv1JnpIRutt2M/Pe2Hm9dwhPKYLap31HY8qXIw9M9rvXQ3uGDjY9mSuYDGAQ8qVshe7e2caJ
        wf+2khl4bC1Q27xG57jIbRkR123ezsDrN/w/dnfKMF/PNl55J3ue537s0jluqbi6Pmwm0ODVQIBEa
        YVb9zydw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:46184 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lly8d-0049sR-OZ; Wed, 26 May 2021 13:20:15 -0500
Subject: Re: [PATCH][next] xfs: Fix fall-through warnings for Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20210420230652.GA70650@embeddedor>
 <20210420233850.GQ3122264@magnolia>
 <62895e8c-800d-fa7b-15f6-480179d552be@embeddedor.com>
Message-ID: <bcae9d46-644c-d6f6-3df5-e8f7c50a673d@embeddedor.com>
Date:   Wed, 26 May 2021 13:21:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <62895e8c-800d-fa7b-15f6-480179d552be@embeddedor.com>
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
X-Exim-ID: 1lly8d-0049sR-OZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:46184
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 18:56, Gustavo A. R. Silva wrote:
> 
> 
> On 4/20/21 18:38, Darrick J. Wong wrote:
>> On Tue, Apr 20, 2021 at 06:06:52PM -0500, Gustavo A. R. Silva wrote:
>>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
>>> the following warnings by replacing /* fall through */ comments,
>>> and its variants, with the new pseudo-keyword macro fallthrough:
>>>
>>> fs/xfs/libxfs/xfs_alloc.c:3167:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/libxfs/xfs_da_btree.c:286:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/libxfs/xfs_ag_resv.c:346:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/libxfs/xfs_ag_resv.c:388:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_bmap_util.c:246:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_export.c:88:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_export.c:96:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_file.c:867:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_ioctl.c:562:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_ioctl.c:1548:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_iomap.c:1040:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_inode.c:852:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_log.c:2627:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/xfs_trans_buf.c:298:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/scrub/bmap.c:275:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/scrub/btree.c:48:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/scrub/common.c:85:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/scrub/common.c:138:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/scrub/common.c:698:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/scrub/dabtree.c:51:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>> fs/xfs/scrub/repair.c:951:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>>>
>>> Notice that Clang doesn't recognize /* fall through */ comments as
>>> implicit fall-through markings, so in order to globally enable
>>> -Wimplicit-fallthrough for Clang, these comments need to be
>>> replaced with fallthrough; in the whole codebase.
>>>
>>> Link: https://github.com/KSPP/linux/issues/115
>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>
>> I've already NAKd this twice, so I guess I'll NAK it a third time.
> 
> Darrick,
> 
> The adoption of fallthrough; has been already accepted and in use since Linux v5.7:
> 
> https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> This change is needed, and I would really prefer if this goes upstream through your tree.
> 
> Linus has taken these patches directly for a while, now.
> 
> Could you consider taking it this time? :)
> 

Hi Darrick,

If you don't mind, I will take this in my -next[1] branch for v5.14, so we can globally enable
-Wimplicit-fallthrough for Clang in that release.

We had thousands of these warnings and now we are down to 47 in next-20210526,
22 of which are fixed with this patch.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp
