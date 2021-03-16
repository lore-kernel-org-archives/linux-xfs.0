Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DA8C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 16:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA39D65086
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 16:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhCPQLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:11:33 -0400
Received: from sandeen.net ([63.231.237.45]:58456 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238506AbhCPQLK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Mar 2021 12:11:10 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3F5AC2AD3;
        Tue, 16 Mar 2021 11:10:33 -0500 (CDT)
Subject: Re: [PATCH] xfs_logprint: Fix buffer overflow printing quotaoff
To:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20210316090400.35180-1-cmaiolino@redhat.com>
 <0a4f390e-53d2-7be9-fc6b-6064f4f8249b@sandeen.net>
 <20210316141044.4myelroxkotnq57h@andromeda.lan>
 <20210316153604.GH22100@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6f63215f-7ae5-b000-723c-92f54dd17ace@sandeen.net>
Date:   Tue, 16 Mar 2021 11:11:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210316153604.GH22100@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/16/21 10:36 AM, Darrick J. Wong wrote:
> On Tue, Mar 16, 2021 at 03:10:44PM +0100, Carlos Maiolino wrote:
>> On Tue, Mar 16, 2021 at 08:45:20AM -0500, Eric Sandeen wrote:
>>> On 3/16/21 4:04 AM, Carlos Maiolino wrote:
>>>> xlog_recover_print_quotaoff() was using a static buffer to aggregate
>>>> quota option strings to be printed at the end. The buffer size was
>>>> miscalculated and when printing all 3 flags, a buffer overflow occurs
>>>> crashing xfs_logprint, like:
>>>>
>>>> QOFF: cnt:1 total:1 a:0x560530ff3bb0 len:160
>>>> *** buffer overflow detected ***: terminated
>>>> Aborted (core dumped)
>>>>
>>>> Fix this by removing the static buffer and using printf() directly to
>>>> print each flag. 
>>>
>>> Yeah, that makes sense. Not sure why it was using a static buffer,
>>> unless I was missing something?
>>>
>>>> Also add a trailling space before each flag, so they
>>>
>>> "trailing space before?" :) I can fix that up on commit.
>>
>> Maybe I slipped into my words here... The current printed format, did something
>> like this:
>>
>> type: USER QUOTAGROUP QUOTAPROJECT QUOTA
>>
>> I just added a space before each flag string, to print like this:
>>
>> type: USER QUOTA GROUP QUOTA PROJECT QUOTA
> 
> Any reason we can't just shorten this to "type: USER GROUP PUOTA" ?

oh yeah, that's a good idea, but: "USER GROUP PROJECT"

-Eric
