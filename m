Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCD1C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 04:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9658964FC9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 04:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhCKEtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 23:49:01 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.187]:26403 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhCKEsc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 23:48:32 -0500
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2021 23:48:32 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id E4B693CDE
        for <linux-xfs@vger.kernel.org>; Wed, 10 Mar 2021 22:28:22 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id KCvulXhKHiQiZKCvulbK2F; Wed, 10 Mar 2021 22:28:22 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hGlSvfVilRdyjcxlHigRVXBapy983SK4zTZ5DVkCG4s=; b=pft6ycncLKFmg0KMj3fsFIn7rW
        bWnd+RboW3SxSz09J5brSDZRt3ED+qM0oso0DQ2dT8nqUI/LmGxYCYr7vf0ytPLWVNkQXGumc6+7K
        zanca0/r5zIWmxLbGDiBRvExFoHO57tEO73lQ49e7aah/gQOIOmFjm/YKFkBLh/G/9V88VAByyizW
        bsuVLvs99FDjzGGCeWho3U2j4qdYc5lQahuowwRAenezYBTHfvnYNdb5eKhJpSukrbOugrAQ8kngE
        8P1NjGReJTpPCwbTVs8bzs7OaS/Q85OyKsWFkEGjBewCnheiNAwAF8Eb0MfHgWcygXU8/uzIPBrh9
        gIIDHWhQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:44512 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lKCvu-003P6f-Ka; Wed, 10 Mar 2021 22:28:22 -0600
Subject: Re: [PATCH v2][next] xfs: Replace one-element arrays with
 flexible-array members
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210310020108.GA279881@embeddedor>
 <20210311031745.GT3419940@magnolia>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b9e2c900-0852-fc5d-9696-835636b4219f@embeddedor.com>
Date:   Wed, 10 Mar 2021 22:28:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311031745.GT3419940@magnolia>
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
X-Exim-ID: 1lKCvu-003P6f-Ka
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:44512
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/10/21 21:17, Darrick J. Wong wrote:

> Why not use size_t instead of uint?  You converted the @len declaration
> above.
> 
>> +				 src_efi_fmt->efi_nextents);
>> +	uint len64 = struct_size((xfs_efi_log_format_64_t *)0, efi_extents,
> 
> Also, please don't use the struct typedefs, we're trying to get rid of
> those slowly.
> 
> TBH I wonder if these could just be turned into static inline helpers to
> decrapify the code:
> 
> static inline size_t
> sizeof_efi_log_format32(unsigned int nr)
> {
> 	return struct_size((xfs_efi_log_format_32_t *)0, efi_extents, nr);
> }
> 
> Then you only need:
> 
> 	size_t len = sizeof_efi_log_format(src_efi_fmt->efi_nextents);
> 	size_t len32 = sizeof_efi_log_format32(src_efi_fmt->efi_nextents);
> 	size_t len64 = sizeof_efi_log_format64(src_efi_fmt->efi_nextents);
> 
> 	if (len == len32) ...
> 	else if (len == len64) ...
> 
> And down below you can clean up the asserts a bit:
> 
> 	ASSERT(item->ri_buf[0].i_len ==
> 			sizeof_efi_log_format32(efd_formatp->efd_nextents) ||
> 	       item->ri_buf[0].i_len ==
> 			sizeof_efi_log_format64(efd_formatp->efd_nextents));
> 

Done: https://lore.kernel.org/lkml/20210311042302.GA137676@embeddedor/

Thanks for the feedback!
--
Gustavo
