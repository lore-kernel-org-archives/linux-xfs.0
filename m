Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E24FC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 22:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DB2361212
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 22:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhIXWPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:15:05 -0400
Received: from sandeen.net ([63.231.237.45]:37498 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhIXWPF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Sep 2021 18:15:05 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BB7B847753B;
        Fri, 24 Sep 2021 17:13:03 -0500 (CDT)
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        djwong@kernel.org
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-4-chandan.babu@oracle.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2 3/5] atomic: convert to uatomic
Message-ID: <80546d48-9018-e374-2a0b-caf84e521ebd@sandeen.net>
Date:   Fri, 24 Sep 2021 17:13:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210924140912.201481-4-chandan.babu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/24/21 9:09 AM, Chandan Babu R wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have liburcu, we can make use of it's atomic variable
> implementation. It is almost identical to the kernel API - it's just
> got a "uatomic" prefix. liburcu also provides all the same aomtic
> variable memory barriers as the kernel, so if we pull memory barrier
> dependent kernel code across, it will just work with the right
> barrier wrappers.
> 
> This is preparation the addition of more extensive atomic operations
> the that kernel buffer cache requires to function correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [chandan.babu@oracle.com: Swap order of arguments provided to atomic[64]_[add|sub]()]
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>   include/atomic.h | 65 ++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 54 insertions(+), 11 deletions(-)
> 
> diff --git a/include/atomic.h b/include/atomic.h
> index e0e1ba84..99cb85d3 100644
> --- a/include/atomic.h
> +++ b/include/atomic.h
> @@ -7,21 +7,64 @@
>   #define __ATOMIC_H__
>   
>   /*
> - * Warning: These are not really atomic at all. They are wrappers around the
> - * kernel atomic variable interface. If we do need these variables to be atomic
> - * (due to multithreading of the code that uses them) we need to add some
> - * pthreads magic here.
> + * Atomics are provided by liburcu.
> + *
> + * API and guidelines for which operations provide memory barriers is here:
> + *
> + * https://github.com/urcu/userspace-rcu/blob/master/doc/uatomic-api.md
> + *
> + * Unlike the kernel, the same interface supports 32 and 64 bit atomic integers.

Given this, anyone have any objection to putting the #defines together at the
top, rather than hiding the 64 variants at the end of the file?

>    */
> +#include <urcu/uatomic.h>
> +#include "spinlock.h"
> +
>   typedef	int32_t	atomic_t;
>   typedef	int64_t	atomic64_t;
>   
> -#define atomic_inc_return(x)	(++(*(x)))
> -#define atomic_dec_return(x)	(--(*(x)))
> +#define atomic_read(a)		uatomic_read(a)
> +#define atomic_set(a, v)	uatomic_set(a, v)
> +#define atomic_add(v, a)	uatomic_add(a, v)
> +#define atomic_sub(v, a)	uatomic_sub(a, v)
> +#define atomic_inc(a)		uatomic_inc(a)
> +#define atomic_dec(a)		uatomic_dec(a)
> +#define atomic_inc_return(a)	uatomic_add_return(a, 1)
> +#define atomic_dec_return(a)	uatomic_sub_return(a, 1)
> +#define atomic_dec_and_test(a)	(atomic_dec_return(a) == 0)
> +#define cmpxchg(a, o, n)        uatomic_cmpxchg(a, o, n);

and I'll fix this whitespace.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
