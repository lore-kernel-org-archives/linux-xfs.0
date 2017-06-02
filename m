Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34500 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751136AbdFBCK4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 22:10:56 -0400
Subject: Re: [sparc64] crc32c misbehave
References: <260a016f-0f17-e286-ceca-83b6977f2fc0@sandeen.net>
 <20170531.124916.1406665885250072302.davem@davemloft.net>
 <20170601.174419.2151404855471358626.davem@davemloft.net>
 <20170601.215711.1719799806113363582.davem@davemloft.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9902b59c-0f73-f306-28e0-fea7ee4a1169@sandeen.net>
Date: Thu, 1 Jun 2017 21:10:50 -0500
MIME-Version: 1.0
In-Reply-To: <20170601.215711.1719799806113363582.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Miller <davem@davemloft.net>
Cc: matorola@gmail.com, sparclinux@vger.kernel.org, linux-xfs@vger.kernel.org

On 6/1/17 8:57 PM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 01 Jun 2017 17:44:19 -0400 (EDT)
> 
>> Ok, I can reproduce this bug on my systems.  I'll see if I can figure out
>> what is going on.
> 
> So I've done several tests to try and narrow down the cause.
> 
> First, I implemented crc32c() inside of the test module, doing
> exactly the same thing that lib/libcrc32c.c is doing.  So this
> make it use a separate tfm.
> 
> This never fails.
> 
> Then, I implemented a separate module "davem_crc32c.ko" that is
> identical to lib/libcrc32.c except it uses it's own 'tfm' and it
> exports the symbol davem_crc32c() instead of crc32c(). And finally I
> adjust the test case to call davem_crc32c() instead of crc32c().
> 
> This also never fails.
> 
> So it only fails if we use the lib/libcrc32.c shared with the rest of
> the kernel.
> 
> I really can't figure out yet why this sharing can even matter.  The
> per-computation state is all in the on-stack 'shash':
> 
> 	SHASH_DESC_ON_STACK(shash, tfm);
> 
> So invocations of crc32c() should not be able to corrupt the state of
> other parallel invocations.
> 
> I'll keep digging, but that is where I am right now.

Thanks for digging.

On ARM, there was a gcc bug causing similar results - I /think/
it was https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293

"programs could fail sporadically with this if an interrupt happens at
the wrong instant in time and data was written onto the current stack."

https://gcc.gnu.org/ml/gcc-patches/2014-09/msg02292.html

Maybe totally unrelated; if not, hope it helps.  :)

-Eric
