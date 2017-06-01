Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdFAVoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2017 17:44:21 -0400
Date: Thu, 01 Jun 2017 17:44:19 -0400 (EDT)
Message-Id: <20170601.174419.2151404855471358626.davem@davemloft.net>
Subject: Re: [sparc64] crc32c misbehave
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170531.124916.1406665885250072302.davem@davemloft.net>
References: <ccdf645b-e22f-ef71-53df-993cc45869c0@sandeen.net>
        <260a016f-0f17-e286-ceca-83b6977f2fc0@sandeen.net>
        <20170531.124916.1406665885250072302.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: matorola@gmail.com, sparclinux@vger.kernel.org, linux-xfs@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 31 May 2017 12:49:16 -0400 (EDT)

> From: Eric Sandeen <sandeen@sandeen.net>
> Date: Wed, 31 May 2017 11:31:10 -0500
> 
>> On 5/31/17 11:19 AM, Eric Sandeen wrote:
>>> On 5/31/17 10:53 AM, David Miller wrote:
>>>> From: Anatoly Pugachev <matorola@gmail.com>
>>>> Date: Wed, 31 May 2017 14:56:52 +0300
>>>>
>>>>> While debugging occasional crc32c checksum errors with xfs disk reads on
>>>>> sparc64 (T5 [sun4v] 3.6 GHz CPU ldom, debian unstable/sid), Eric have found
>>>>> that crc32c sometimes returns wrong checksum for data. Eric made a simple
>>>>> test kernel module (included), which produce the following results on my
>>>>> sparc64 machines:
>>> 
>>> cc: linux-xfs, because this problem cropped up on xfs/sparc.
>> 
>> FWIW, the testcase (module which does
>> 
>> 	crc = crc32c(CRC_SEED, data, 512);
>> 
>> 1 million times in a loop on the same data, and printk's if
>> the result ever changes) does not fail on x86_64 or ARM
>> (well, not after a gcc bug was fixed on ARM ...)
> 
> Is the machine doing things that would cause crc32c() operations in
> interrupts (SCTP protocol traffic) or on other cpus?
> 
> That's the danger in comparing other machines, the context and what's
> running on them is different.

Ok, I can reproduce this bug on my systems.  I'll see if I can figure out
what is going on.
