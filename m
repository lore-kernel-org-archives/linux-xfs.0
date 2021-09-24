Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053B3C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 22:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E112460235
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 22:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbhIXWId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:08:33 -0400
Received: from sandeen.net ([63.231.237.45]:37172 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344720AbhIXWId (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Sep 2021 18:08:33 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E3FC247753A;
        Fri, 24 Sep 2021 17:06:31 -0500 (CDT)
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        djwong@kernel.org
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-3-chandan.babu@oracle.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2 2/5] libxfs: add spinlock_t wrapper
Message-ID: <597bbcc3-2c11-16b6-897d-334d31b60c6e@sandeen.net>
Date:   Fri, 24 Sep 2021 17:06:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210924140912.201481-3-chandan.babu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/24/21 9:09 AM, Chandan Babu R wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> These provide the kernel spinlock_t interface, but are *not*
> spinlocks. Spinlocks cannot be used by general purpose userspace
> processes due to the fact they cannot control task preemption and
> scheduling reliability. Hence these are implemented as a
> pthread_mutex_t, similar to the way the kernel RT build implements
> spinlock_t as a kernel mutex.
> 
> Because the current libxfs spinlock "implementation" just makes
> spinlocks go away, we have to also add initialisation to spinlocks
> that libxfs uses that are missing from the userspace implementation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [chandan.babu@oracle.com: Initialize inode log item spin lock]
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

...

> +/*
> + * This implements kernel compatible spinlock exclusion semantics. These,
> + * however, are not spinlocks, as spinlocks cannot be reliably implemented in
> + * userspace without using realtime scheduling task contexts. Hence this
> + * interface is implemented with pthread mutexes and so can block, but this is
> + * no different to the kernel RT build which replaces spinlocks with mutexes.
> + * Hence we know it works.
> + */
> +
> +typedef pthread_mutex_t	spinlock_t;
> +
> +#define spin_lock_init(l)	pthread_mutex_init(l, NULL)
> +#define spin_lock(l)           pthread_mutex_lock(l)
> +#define spin_trylock(l)        (pthread_mutex_trylock(l) != EBUSY)
> +#define spin_unlock(l)         pthread_mutex_unlock(l)

some whitespace mess here but I'll just clean that up.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
