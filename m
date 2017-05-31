Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34946 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751188AbdEaQ01 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 12:26:27 -0400
Subject: Re: [sparc64] crc32c misbehave
References: <CADxRZqzgaL4ew6PVek3WBsdwo6GcT0ORx=7h+6p0V3NAr8qF+w@mail.gmail.com>
 <CADxRZqzNTB1n0g1r_2rLsjifHpJ+_x1WPxNOSqEcHbi74jHi5w@mail.gmail.com>
 <20170531.115335.213691069712156732.davem@davemloft.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ccdf645b-e22f-ef71-53df-993cc45869c0@sandeen.net>
Date: Wed, 31 May 2017 11:19:20 -0500
MIME-Version: 1.0
In-Reply-To: <20170531.115335.213691069712156732.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Miller <davem@davemloft.net>, matorola@gmail.com
Cc: sparclinux@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>

On 5/31/17 10:53 AM, David Miller wrote:
> From: Anatoly Pugachev <matorola@gmail.com>
> Date: Wed, 31 May 2017 14:56:52 +0300
> 
>> While debugging occasional crc32c checksum errors with xfs disk reads on
>> sparc64 (T5 [sun4v] 3.6 GHz CPU ldom, debian unstable/sid), Eric have found
>> that crc32c sometimes returns wrong checksum for data. Eric made a simple
>> test kernel module (included), which produce the following results on my
>> sparc64 machines:

cc: linux-xfs, because this problem cropped up on xfs/sparc.

-Eric

> I don't think that crc32c() is thread safe because of the way it is
> implemented with a shared TFM crypto object allocated once at boot
> time.
> 
> I think you are seeing the corruption any time an interrupt comes in
> on the same cpu as your test module is running on and does a crc32c()
> calculation, corrupting the context key value being used by your
> invocation.
> 
> At least that's my guess, I could have misread how the key is stored
> and managed around operations.
> 
> Can you try something like disabling cpu IRQs around the crc32c() function
> in lib/libcrc32c.c?  Something like:
> 
> 	u32 retval;
> 
> 	local_irq_disable();
> 
> 	shash->tfm = tfm;
> 	shash->flags = 0;
> 	*ctx = crc;
> 
> 	err = crypto_shash_update(shash, address, length);
> 	BUG_ON(err);
> 
> 	retval = *ctx;
> 
> 	local_irq_enable();
> 
> 	return retval;
> 
> Thanks.
> 
