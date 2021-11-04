Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FE4C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 03:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E6B61106
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 03:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhKDDgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 23:36:37 -0400
Received: from sandeen.net ([63.231.237.45]:58490 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhKDDgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 23:36:37 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 03E41FB436;
        Wed,  3 Nov 2021 22:32:20 -0500 (CDT)
Message-ID: <d5bf39e3-c1d0-192b-89bc-bc74f1c43460@sandeen.net>
Date:   Wed, 3 Nov 2021 22:33:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
 <7fe17d89-749d-7114-1f4f-294aba1e3f1d@redhat.com>
 <20211104031411.GS24307@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2] xfsprogs: move stubbed-out kernel functions out of
 xfs_shared.h
In-Reply-To: <20211104031411.GS24307@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/3/21 10:14 PM, Darrick J. Wong wrote:
> On Wed, Nov 03, 2021 at 09:59:57PM -0500, Eric Sandeen wrote:
>> Move kernel stubs out of libxfs/xfs_shared.h, which is kernel
>> libxfs code and should not have userspace shims in it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: fix spdx and copyright
>>
>> diff --git a/include/libxfs.h b/include/libxfs.h
>> index 24424d0e..64b44af8 100644
>> --- a/include/libxfs.h
>> +++ b/include/libxfs.h
>> @@ -11,6 +11,7 @@
>>   #include "platform_defs.h"
>>   #include "xfs.h"
>> +#include "stubs.h"
>>   #include "list.h"
>>   #include "hlist.h"
>>   #include "cache.h"
>> diff --git a/include/stubs.h b/include/stubs.h
>> new file mode 100644
>> index 00000000..d80e8de0
>> --- /dev/null
>> +++ b/include/stubs.h
>> @@ -0,0 +1,29 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2021 Red Hat, Inc.
>> + * All Rights Reserved.
>> + */
>> +#ifndef STUBS_H
>> +#define STUBS_H
>> +
>> +/* Stub out unimplemented and unneeded kernel functions */
>> +struct rb_root {
>> +};
>> +
>> +#define RB_ROOT 		(struct rb_root) { }
> 
> Please to remove  ^ this unnecessary space.
> 
>> +
>> +typedef struct wait_queue_head {
>> +} wait_queue_head_t;
>> +
>> +#define init_waitqueue_head(wqh)	do { } while(0)
>> +
>> +struct rhashtable {
>> +};
>> +
>> +struct delayed_work {
>> +};
>> +
>> +#define INIT_DELAYED_WORK(work, func)	do { } while(0)
>> +#define cancel_delayed_work_sync(work)	do { } while(0)
>> +
>> +#endif
> 
> This probably ought to be '#endif /* STUBS_H */' just to keep it clear
> which #ifdef it goes with.

Yup I spotted and added that already. I'm so rusty.

> With those two things fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks,
-Eric
