Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:35072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdFBB5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2017 21:57:15 -0400
Date: Thu, 01 Jun 2017 21:57:11 -0400 (EDT)
Message-Id: <20170601.215711.1719799806113363582.davem@davemloft.net>
Subject: Re: [sparc64] crc32c misbehave
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170601.174419.2151404855471358626.davem@davemloft.net>
References: <260a016f-0f17-e286-ceca-83b6977f2fc0@sandeen.net>
        <20170531.124916.1406665885250072302.davem@davemloft.net>
        <20170601.174419.2151404855471358626.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: matorola@gmail.com, sparclinux@vger.kernel.org, linux-xfs@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 01 Jun 2017 17:44:19 -0400 (EDT)

> Ok, I can reproduce this bug on my systems.  I'll see if I can figure out
> what is going on.

So I've done several tests to try and narrow down the cause.

First, I implemented crc32c() inside of the test module, doing
exactly the same thing that lib/libcrc32c.c is doing.  So this
make it use a separate tfm.

This never fails.

Then, I implemented a separate module "davem_crc32c.ko" that is
identical to lib/libcrc32.c except it uses it's own 'tfm' and it
exports the symbol davem_crc32c() instead of crc32c(). And finally I
adjust the test case to call davem_crc32c() instead of crc32c().

This also never fails.

So it only fails if we use the lib/libcrc32.c shared with the rest of
the kernel.

I really can't figure out yet why this sharing can even matter.  The
per-computation state is all in the on-stack 'shash':

	SHASH_DESC_ON_STACK(shash, tfm);

So invocations of crc32c() should not be able to corrupt the state of
other parallel invocations.

I'll keep digging, but that is where I am right now.
