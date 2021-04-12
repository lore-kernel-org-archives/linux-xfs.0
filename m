Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D07AC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9EA860FED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbhDLQwQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:52:16 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.164]:11601 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345233AbhDLQqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 12:46:46 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2021 12:46:46 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 2DD891625B8
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 10:56:57 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Vyvolfq70b8LyVyvolpzUb; Mon, 12 Apr 2021 10:56:57 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fQXHp6pOiHKtfsUAenCa0CmRnzZ4eEUllKHNfdQL05A=; b=DyZxCYbPIyZnLF0Ap9hMbfsgeq
        3wBE5tB0qoJPZObyNQyV34G93OqD0hwCalmttT7nrkPvpBs1nCmDsgcUHQcddDJtpj/l9xRUOE0/s
        Ib58+e0AMvL8nEmtP/5xqEUHVF7Lfyruc1oXR4vXRfimTVorLquADyJREVuJiOaDz6UCRgUx36LUn
        36UvrYw/xjceglE8E2gHOd1f6WZk8W3+O4RsD1YIt25AYI7booRk5fq0DAxen/xgSs99UnbKxRiOo
        C0tI62X8k8DOYCSNp6OjD6S+fsvHuQHMs18C+nl36kHD7OwaxmtlMaETE7q3qPEZSDmDh93XgLEnz
        Hwt3hRZg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:33150 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lVyvo-001NsM-Lt; Mon, 12 Apr 2021 10:56:56 -0500
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210412135611.GA183224@embeddedor>
 <20210412152906.GA1075717@infradead.org> <20210412154808.GA1670408@magnolia>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <fac30774-faa6-7e21-9701-aaf92feb097a@embeddedor.com>
Date:   Mon, 12 Apr 2021 10:57:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412154808.GA1670408@magnolia>
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
X-Exim-ID: 1lVyvo-001NsM-Lt
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:33150
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/12/21 10:48, Darrick J. Wong wrote:
> On Mon, Apr 12, 2021 at 04:29:06PM +0100, Christoph Hellwig wrote:
>>> Below are the results of running xfstests for "all" with the following
>>> configuration in local.config:
>>
>> ...
>>
>>> Other tests might need to be run in order to verify everything is working
>>> as expected. For such tests, the intervention of the maintainers might be
>>> needed.
>>
>> This is a little weird for a commit log.  If you want to show results
>> this would be something that goes into a cover letter.
> 
> Agreed, please don't post fstests output in the commit message.

OK. I've got it.

> 
>>> +/*
>>> + * Calculates the size of structure xfs_efi_log_format followed by an
>>> + * array of n number of efi_extents elements.
>>> + */
>>> +static inline size_t
>>> +sizeof_efi_log_format(size_t n)
>>> +{
>>> +	return struct_size((struct xfs_efi_log_format *)0, efi_extents, n);
>>
>> These helpers are completely silly.  Just keep the existing open code
>> version using sizeof with the one-off removed.
> 
> A couple of revisions ago I specifically asked Gustavo to create these
> 'silly' sizeof helpers to clean up...
> 
>>> -					(sizeof(struct xfs_efd_log_item) +
>>> -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
>>> -					sizeof(struct xfs_extent)),
>>> -					0, 0, NULL);
>>> +					 struct_size((struct xfs_efd_log_item *)0,
>>> +					 efd_format.efd_extents,
>>> +					 XFS_EFD_MAX_FAST_EXTENTS),
> 
> ...these even uglier multiline statements.  I was also going to ask for
> these kmem cache users to get cleaned up.  I'd much rather look at:
> 
> 	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
> 				sizeof_xfs_efi(XFS_EFI_MAX_FAST_EXTENTS), 0);
> 	if (!xfs_efi_zone)
> 		goto the_drop_zone;
> 
> even if it means another static inline.

Yep; I agree[1].

Thanks
--
Gustavo

[1] https://lore.kernel.org/lkml/63078523-8a57-36f4-228b-1594f0e3b025@embeddedor.com/
