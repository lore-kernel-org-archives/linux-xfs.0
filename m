Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0DCC432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64AEC60F42
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhH0PsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 11:48:24 -0400
Received: from sandeen.net ([63.231.237.45]:41274 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234232AbhH0PsY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Aug 2021 11:48:24 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id ADC2F7BDD;
        Fri, 27 Aug 2021 10:47:11 -0500 (CDT)
Subject: Re: [PATCH] mkfs.xfs.8: clarify DAX-vs-reflink restrictions in the
 mkfs.xfs man page
To:     Bill O'Donnell <billodo@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>
References: <59ebcf23-9e32-e219-ef8b-9aa7ab2444c2@redhat.com>
 <20210827154627.ygbs6igbzavrwvyo@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d942af2d-724f-a9c6-15ac-3ee066800cea@sandeen.net>
Date:   Fri, 27 Aug 2021 10:47:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827154627.ygbs6igbzavrwvyo@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/27/21 10:46 AM, Bill O'Donnell wrote:
> On Fri, Aug 27, 2021 at 10:39:18AM -0500, Eric Sandeen wrote:


>> +and
>> +.B \-o dax=always
>> +) are incompatible with
>> +reflink-enabled XFS filesystems.  To use filesystem-wide DAX with XFS, specify the
>>   .B \-m reflink=0
>>   option to mkfs.xfs to disable the reflink feature.
>> +Alternatey, use the
> s /Alternatey/Alternately

Doh! Thanks.


-Eric
