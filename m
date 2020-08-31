Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A90C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 14:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D0612083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 14:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHaOy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 10:54:59 -0400
Received: from sandeen.net ([63.231.237.45]:36982 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgHaOy6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Aug 2020 10:54:58 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 59D617BAD;
        Mon, 31 Aug 2020 09:54:39 -0500 (CDT)
Subject: Re: [PATCH 1/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-2-cmaiolino@redhat.com>
 <029949dc-6f6b-7083-0dc7-85961f728776@sandeen.net>
Message-ID: <319c7184-7a58-61b1-3f5d-c73d7cd0e116@sandeen.net>
Date:   Mon, 31 Aug 2020 09:54:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <029949dc-6f6b-7083-0dc7-85961f728776@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/31/20 9:53 AM, Eric Sandeen wrote:
> On 8/31/20 8:04 AM, Carlos Maiolino wrote:
>>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
>> -	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
>> +	(1 << (NBBY*(int)sizeof(uint8_t)))
> 
> This probably is not correct.  :)
> 
> This would cut the max size of attr (name+value) in half.

Whoops other way around.  ;)  this would double XFS_ATTR_SF_ENTSIZE_MAX.

In any case, just drop that change.

-Eric
