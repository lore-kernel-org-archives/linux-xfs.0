Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28E6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 20:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2DE76128E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 20:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346775AbhI2Us1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 16:48:27 -0400
Received: from sandeen.net ([63.231.237.45]:49966 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346011AbhI2Us0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Sep 2021 16:48:26 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4D55B116E1;
        Wed, 29 Sep 2021 15:46:08 -0500 (CDT)
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        djwong@kernel.org
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-2-chandan.babu@oracle.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2 1/5] xfsprogs: introduce liburcu support
Message-ID: <3bd3b2b8-cdd9-1dfc-6f89-a3adc44f93e9@sandeen.net>
Date:   Wed, 29 Sep 2021 15:46:43 -0500
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
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

I've added Dave's m4 macros in place of yours, and with that circuitous
route I think we have a good set of changes, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

for the combined set of this-plus-dave's-m4's (elsewhere in replies
on this thread)

Thanks,
-Eric
