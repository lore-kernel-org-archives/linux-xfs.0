Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7984C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 18:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B72EF60E09
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 18:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhI0Sug (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 14:50:36 -0400
Received: from sandeen.net ([63.231.237.45]:40792 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234211AbhI0Sub (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Sep 2021 14:50:31 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D5C3A46C7C2;
        Mon, 27 Sep 2021 13:48:17 -0500 (CDT)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        djwong@kernel.org
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-2-chandan.babu@oracle.com>
 <41a4a5e6-c58e-97e7-666b-d1205ed0604f@sandeen.net>
 <20210925230551.GY1756565@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2 1/5] xfsprogs: introduce liburcu support
Message-ID: <b01c99b7-5d8e-d772-a4ff-3d54caff8f6a@sandeen.net>
Date:   Mon, 27 Sep 2021 13:48:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210925230551.GY1756565@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/25/21 6:05 PM, Dave Chinner wrote:
> On Fri, Sep 24, 2021 at 04:51:32PM -0500, Eric Sandeen wrote:
>> On 9/24/21 9:09 AM, Chandan Babu R wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> The upcoming buffer cache rework/kerenl sync-up requires atomic
>>> variables. I could use C++11 atomics build into GCC, but they are a
>>> pain to work with and shoe-horn into the kernel atomic variable API.
>>>
>>> Much easier is to introduce a dependency on liburcu - the userspace
>>> RCU library. This provides atomic variables that very closely match
>>> the kernel atomic variable API, and it provides a very similar
>>> memory model and memory barrier support to the kernel. And we get
>>> RCU support that has an identical interface to the kernel and works
>>> the same way.
>>>
>>> Hence kernel code written with RCU algorithms and atomic variables
>>> will just slot straight into the userspace xfsprogs code without us
>>> having to think about whether the lockless algorithms will work in
>>> userspace or not. This reduces glue and hoop jumping, and gets us
>>> a step closer to having the entire userspace libxfs code MT safe.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> [chandan.babu@oracle.com: Add m4 macros to detect availability of liburcu]
>>
>> Thanks for fixing that up. I had tried to use rcu_init like Dave originally
>> had, and I like that better in general, but I had trouble with it - I guess
>> maybe it gets redefined based on memory model magic and the actual symbol
>> "rcu_init" maybe isn't available? I didn't dig very much.
> 
> Ah, so I just checked where the m4/package_urcu.m4 file went -
> forgot to re-add it after it rejected on apply. The diff is this:
> 
> diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> new file mode 100644
> index 000000000000..9b0dee35d9a1
> --- /dev/null
> +++ b/m4/package_urcu.m4
> @@ -0,0 +1,22 @@
> +AC_DEFUN([AC_PACKAGE_NEED_URCU_H],
> +  [ AC_CHECK_HEADERS(urcu.h)
> +    if test $ac_cv_header_urcu_h = no; then
> +       AC_CHECK_HEADERS(urcu.h,, [
> +       echo
> +       echo 'FATAL ERROR: could not find a valid urcu header.'
> +       exit 1])
> +    fi
> +  ])
> +
> +AC_DEFUN([AC_PACKAGE_NEED_RCU_INIT],
> +  [ AC_MSG_CHECKING([for liburcu])
> +    AC_TRY_COMPILE([
> +#define _GNU_SOURCE
> +#include <urcu.h>
> +    ], [
> +       rcu_init();
> +    ], liburcu=-lurcu
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(liburcu)
> +  ])

Works great here too. My error was not including urcu.h in the test I think,
and looking for the symbol directly. I will merge this version rather
than Chandan's.

Thanks,
-Eric

