Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DD9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8F3611CA
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhKDC6F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:58:05 -0400
Received: from sandeen.net ([63.231.237.45]:56504 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhKDC6F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 22:58:05 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 595EC78EA;
        Wed,  3 Nov 2021 21:53:48 -0500 (CDT)
Message-ID: <32609223-647d-db97-2f1b-0c42fd3b7ef8@sandeen.net>
Date:   Wed, 3 Nov 2021 21:55:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] xfsprogs: move stubbed-out kernel functions out of
 xfs_shared.h
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
 <20211104022826.GR24307@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20211104022826.GR24307@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/3/21 9:28 PM, Darrick J. Wong wrote:
> On Wed, Nov 03, 2021 at 09:21:35PM -0500, Eric Sandeen wrote:
>> Move kernel stubs out of libxfs/xfs_shared.h, which is kernel
>> libxfs code and should not have userspace shims in it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
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
>> index 00000000..41eaa0c4
>> --- /dev/null
>> +++ b/include/stubs.h
>> @@ -0,0 +1,28 @@
>> +// SPDX-License-Identifier: GPL-2.0
> 
> This needs a C-style (not C++-style) comment for SPDX compliance.
> 
> (I still don't get why the committee who came up with SPDX required C++
> style comments for C code...)
> 
>> +
> 
> Needs a copyright statement too.

well that's what I get for cargo-culting bitops.h.  :/

