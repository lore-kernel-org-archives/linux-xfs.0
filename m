Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB35C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 21:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637AB60E9C
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 21:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbhIXVxI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 17:53:08 -0400
Received: from sandeen.net ([63.231.237.45]:36284 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234673AbhIXVxH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Sep 2021 17:53:07 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1DD1347753A;
        Fri, 24 Sep 2021 16:51:06 -0500 (CDT)
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        djwong@kernel.org
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-2-chandan.babu@oracle.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2 1/5] xfsprogs: introduce liburcu support
Message-ID: <41a4a5e6-c58e-97e7-666b-d1205ed0604f@sandeen.net>
Date:   Fri, 24 Sep 2021 16:51:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210924140912.201481-2-chandan.babu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/24/21 9:09 AM, Chandan Babu R wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The upcoming buffer cache rework/kerenl sync-up requires atomic
> variables. I could use C++11 atomics build into GCC, but they are a
> pain to work with and shoe-horn into the kernel atomic variable API.
> 
> Much easier is to introduce a dependency on liburcu - the userspace
> RCU library. This provides atomic variables that very closely match
> the kernel atomic variable API, and it provides a very similar
> memory model and memory barrier support to the kernel. And we get
> RCU support that has an identical interface to the kernel and works
> the same way.
> 
> Hence kernel code written with RCU algorithms and atomic variables
> will just slot straight into the userspace xfsprogs code without us
> having to think about whether the lockless algorithms will work in
> userspace or not. This reduces glue and hoop jumping, and gets us
> a step closer to having the entire userspace libxfs code MT safe.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [chandan.babu@oracle.com: Add m4 macros to detect availability of liburcu]

Thanks for fixing that up. I had tried to use rcu_init like Dave originally
had, and I like that better in general, but I had trouble with it - I guess
maybe it gets redefined based on memory model magic and the actual symbol
"rcu_init" maybe isn't available? I didn't dig very much.

Also, dumb question from me - how do we know where we need the
rcu_[un]register_thread() calls? Will it be obvious if we miss it
in the future?  "each thread must invoke this function before its
first call to rcu_read_lock() or call_rcu()."

Thanks,
-Eric
