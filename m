Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4279C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 15:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B609D61246
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 15:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhDLPhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 11:37:01 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.107]:25775 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238352AbhDLPhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 11:37:00 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 7CB09AA08
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 10:36:41 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id VycDlBHLNw11MVycDloGe1; Mon, 12 Apr 2021 10:36:41 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wo8FVePTcKy/MnYBDrOcSAgwa9NyCpnEwc+w1tZVHEk=; b=Pyp3F8zt95HjMTgMT/fYuOib1m
        PEx0LvZr7wqgu6jMWshtjI2wnuEi9WaEv+spUhDvyqy9D1MqZM13s/CWsKByq+n3cMA5Rjs9VxTUB
        ldHqOkozdW0EB16OSrMe9qb6DW9nKSE9m0ldqXOsJyoVTZR7RMuu0kZ85qN+Ty11P9CBYIX124K5t
        UCO3f3JpIe56GZ23Ia6FJpFUKmRX5uWqtrkNFKgoPo0pY5vx/Mf3nWVh3VphbvmWjm9C4CqGVlDhm
        ThJix67a8Qi/hd2aYDnQHgloYhHc5SqeuuU9nGsrh5lY0szWO58H22jaSON9m6fFbFl3x0I37E3Q2
        khuqW62w==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:60756 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lVycD-000zWQ-3V; Mon, 12 Apr 2021 10:36:41 -0500
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
To:     Christoph Hellwig <hch@infradead.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210412135611.GA183224@embeddedor>
 <20210412152906.GA1075717@infradead.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <63078523-8a57-36f4-228b-1594f0e3b025@embeddedor.com>
Date:   Mon, 12 Apr 2021 10:36:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412152906.GA1075717@infradead.org>
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
X-Exim-ID: 1lVycD-000zWQ-3V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:60756
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/12/21 10:29, Christoph Hellwig wrote:
>> Below are the results of running xfstests for "all" with the following
>> configuration in local.config:
> 
> ...
> 
>> Other tests might need to be run in order to verify everything is working
>> as expected. For such tests, the intervention of the maintainers might be
>> needed.
> 
> This is a little weird for a commit log.  If you want to show results
> this would be something that goes into a cover letter.
> 
>> +/*
>> + * Calculates the size of structure xfs_efi_log_format followed by an
>> + * array of n number of efi_extents elements.
>> + */
>> +static inline size_t
>> +sizeof_efi_log_format(size_t n)
>> +{
>> +	return struct_size((struct xfs_efi_log_format *)0, efi_extents, n);
> 
> These helpers are completely silly.  Just keep the existing open code
> version using sizeof with the one-off removed.

This was proposed by Darrick[1]. However, I'm curious, why do you think
they are "completely silly"?

> 
>> -					(sizeof(struct xfs_efd_log_item) +
>> -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
>> -					sizeof(struct xfs_extent)),
>> -					0, 0, NULL);
>> +					 struct_size((struct xfs_efd_log_item *)0,
>> +					 efd_format.efd_extents,
>> +					 XFS_EFD_MAX_FAST_EXTENTS),
>> +					 0, 0, NULL);
>>  	if (!xfs_efd_zone)
>>  		goto out_destroy_buf_item_zone;
>>  
>>  	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
>> -					 (sizeof(struct xfs_efi_log_item) +
>> -					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
>> -					 sizeof(struct xfs_extent)),
>> +					 struct_size((struct xfs_efi_log_item *)0,
>> +					 efi_format.efi_extents,
>> +					 XFS_EFI_MAX_FAST_EXTENTS),
> 
> Same here.  And this obsfucated version also adds completely pointless
> overly long lines while making the code unreadable.

This could actually use one of the inline helpers you think are silly. :)

Thanks
--
Gustavo

[1] https://lore.kernel.org/lkml/20210311031745.GT3419940@magnolia/
