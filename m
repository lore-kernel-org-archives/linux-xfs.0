Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE8412CD8A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712070576; cv=none; b=Ppe/xKErx7Iv32xByZChkn8tC+uqJjyEhSPVL75zod/5irx8fq+EEjKD3J513Z66FQkjAjNx8A1sR7/7SL/5W+RgN2RcTQAHjGqeqOCZbv03OMkxl/qRXPRiJ7SjMRnyRR6BekXMM6hKyAi4+nw8+UWiKy38J+TYntnyPEj8Yvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712070576; c=relaxed/simple;
	bh=sutPQ/58yiSUNXs+JiFodVsv9rLEFF7TOkOQ15mkyLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=M8DbEInIOmGhRXKaps62t3/FyATh5oSM/RAQYjqr5jz58/LIIeWZjhBB1tYNnQfK1xNyXAL907srQ9SzEE0kVyc5C4A2FkwcBmxDpH85KZ6VnSJlELPzzITO5LuHqlGFHMcA4Rlu/dubf0Zkc9QQ2WetDfEYjEKCgDxG+boMT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=aP+xmaIr; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="aP+xmaIr"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id BB57D3289F0;
	Tue,  2 Apr 2024 10:09:32 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net BB57D3289F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1712070572;
	bh=QKwPi/RnmBUs2NbTBEfnglR/l592ohuG6n2rdcGZ5F8=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
	b=aP+xmaIrYPnrOMFqihr3bMHoDd9dxuPr39+iNCx/rjdQro82dpUKv7Yhi1e8frdSH
	 NEcuY9NgeSjfuRqSTw4l4t47gmTDy9A2ZxyllY7qESWdu7j15i1VnIc2FHnEKJiJER
	 a3vA4b1GCkkvHp97PLUKFbNYB5zISnH69mdlivEAW6LiZ8vl+OjIbu9N9mqI00N8mx
	 Q1X23KVyAY4r+/FB1SItzKW9g6A8e+BAhLGkr1i2ZC+eY4bKx/clyWQocDRPP185wo
	 8OgJPcwwvXOi3B4+054Yrl9yTlcg2APIALspWwQ18nk2dLK4YJhEkpc+BGSNnCqAbd
	 hHtxOljwDM0hw==
Message-ID: <e5ca2146-8d39-4af5-80fb-0bd5ab9ed304@sandeen.net>
Date: Tue, 2 Apr 2024 10:09:31 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: A bug was found in Linux Kernel 5.15.148 and 5.15.150: KASAN:
 use-after-free in xfs_allocbt_init_key_from_rec (with POC)
To: =?UTF-8?B?5YiY6YCa?= <lyutoon@gmail.com>
References: <CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com>
 <32f02757-70e0-41ed-a0d0-23190a28dad3@sandeen.net>
 <CAEJPjCvK-LATJ5B9-=KXa3oMZwT-zQyFqMNU9EgcfsRD12AWWA@mail.gmail.com>
Content-Language: en-US
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAEJPjCvK-LATJ5B9-=KXa3oMZwT-zQyFqMNU9EgcfsRD12AWWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/2/24 5:08 AM, 刘通 wrote:
> Hi Eric.
> 
> I've actually always followed this principle of vulnerability analysis
> that you mentioned, but in this case, due to my lack of familiarity
> with xfs, I wasn't able to construct a sensible PoC. I try to do my
> best to analyze the root cause when it's in my power to do so, but I
> couldn't do it in this case.

Ok, but the things I suggested below don't require deep knowledge
of xfs - just looking at the POC and understanding/describing what
it is doing, simplifying it to the fewest syscalls to provoke the
problem, what privileges are required to form a general assessment
of a possible threat, etc.

> I'm sorry for adding to your workload,
> but I don't think that this is an indication that it's a false
> positive, KASAN's memory detection is justified, so are you 100% sure
> that the program you constructed is completely correct? I mean, KASAN
> reported a uaf vulnerability, which is not unfounded. If you are able
> to reproduce the crash as I said before, then it is a fact that it
> exists with a high probability, but if when you constructed the
> simplified program, is it completely consistent with the original
> repro.c?

I did not construct a new reproducer, I ran your exact set of steps
using your kernel version, your config, and your repro.c, and while
it triggered a bug in XFS, it did not trigger any KASAN errors.

As I originally asked - does it do so for you? Looking at the logs,
it seems very possible that tests that ran prior to the xfs test
may have corrupted memory, which the xfs repro.c stumbled into during
your run, and won't be reproduced on a fresh run of that reproducer.

Thanks,
-Eric
 
> Best,
> Tong
> 
> Eric Sandeen <sandeen@sandeen.net> 于2024年4月2日周二 13:54写道：
>>
>> On 3/7/24 1:23 AM, 刘通 wrote:
>>> Hi upstream community,
>>>
>>> I was fuzzing a LTS version of Linux kernel 5.15.148 with my modified
>>> syzkaller and I found a bug named "KASAN: use-after-free in
>>> xfs_allocbt_init_key_from_rec".
>>>
>>> I tested the PoC on 5.15.148, 5.15.149 and 5.15.150 with sanitizer on
>>> and found sanitizer through a panic as "KASAN: use-after-free in
>>> xfs_allocbt_init_key_from_rec" on 5.15.148 and 5.15.150, but there was
>>> no panic and sanitizer error in 5.15.149.
>>>
>>> The syzkaller log, report, kernel config, PoC can be found here:
>>> https://drive.google.com/file/d/1w6VKKewt4VQzb9FzcGtkELJUOwd1wMcC/view?usp=sharing
>>>
>>> # Analysis (rough):
>>> Because that I cannot understand the report0 clearly in the zip file
>>> above, so I rerun the PoC on my vm (5.15.148) and I get another report
>>> named as the same but it looks much clearer than the report0. The new
>>> report can be found in:
>>> https://drive.google.com/file/d/1Vg_4Qwueow6VgjLrijnUB8QbZVx902sv/view?usp=sharing
>>> In this report, we can easily see that the memory allocation and free:
>>> Allocation:
>>
>> As a PhD student interested in security analysis, you could do much more
>> here.
>>
>> For starters, test this on an upstream/mainline kernel to see if it
>> reproduces.
>>
>> Provide the filesystem image that seems to reproduce it, rather than
>> an array in a C file.
>>
>> Look at your reproducer, and identify the ioctls and syscalls that you
>> believe provoked the error. See what privileges are needed to invoke them,
>> if you believe this may be a security flaw.
>>
>> Test your reproducer in isolation, and see if it actually reproduces your
>> use after free (I don't think that it does.)
>>
>> If it doesn't, look back at the tests that ran before it, and see if
>> something is corrupting memory, etc.
>>
>> It's far too easy for someone to turn a syzkaller crank, throw it over
>> the wall, and move on. If you want to help, dig in, don't just pawn off
>> the problem with no effort to investigate what you believe you've found.
>>
>>> ```
>>> [   62.995194][ T6349] Allocated by task 6343:
>>> [   62.995610][ T6349]  kasan_save_stack+0x1b/0x40
>>> [   62.996044][ T6349]  __kasan_slab_alloc+0x61/0x80
>>> [   62.996475][ T6349]  kmem_cache_alloc+0x18e/0x6b0
>>> [   62.996918][ T6349]  getname_flags+0xd2/0x5b0
>>> [   62.997335][ T6349]  user_path_at_empty+0x2b/0x60
>>> [   62.997782][ T6349]  vfs_statx+0x13c/0x370
>>> [   62.998193][ T6349]  __do_sys_newlstat+0x91/0x110
>>> [   62.998634][ T6349]  do_syscall_64+0x35/0xb0
>>> [   62.999033][ T6349]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
>>> ```
>>> Free:
>>> ```
>>> [   62.999776][ T6349] Freed by task 6343:
>>> [   63.000135][ T6349]  kasan_save_stack+0x1b/0x40
>>> [   63.000555][ T6349]  kasan_set_track+0x1c/0x30
>>> [   63.001053][ T6349]  kasan_set_free_info+0x20/0x30
>>> [   63.001638][ T6349]  __kasan_slab_free+0xe1/0x110
>>> [   63.002206][ T6349]  kmem_cache_free+0x82/0x5b0
>>> [   63.002742][ T6349]  putname+0xfe/0x140
>>> [   63.003103][ T6349]  user_path_at_empty+0x4d/0x60
>>> [   63.003551][ T6349]  vfs_statx+0x13c/0x370
>>> [   63.003943][ T6349]  __do_sys_newlstat+0x91/0x110
>>> [   63.004378][ T6349]  do_syscall_64+0x35/0xb0
>>> [   63.004841][ T6349]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
>>> ```
>>> So this is a use-after-free bug: allocated by `kmem_cache_alloc` and
>>> freed by `kmem_cache_free`.
>>> And according to the report, the UAF occurs in
>>> `xfs_allocbt_init_key_from_rec`, `key->alloc.ar_startblock =
>>> rec->alloc.ar_startblock;` which indicates that maybe
>>> `rec->alloc.ar_startblock` was freed before.
>>>
>>> # Step to reproduce:
>>> 1. download the zip file
>>> 2. unzip it
>>> 3. compile the kernel (5.15.148, 5.15.150) with kernel_config
>>> 4. start the kernel with qemu vm
>>> 5. scp repro.c to the vm
>>> 6. compile the repro.c and run it: gcc repro.c -o exp && ./exp
>>> 7. you will see the KASAN error
>>
>> AFAICT you won't. I did exactly this, and got no KASAN error.
>> Did you, after following these steps on a fresh boot of the kernel?
>>
>> -Eric
>>
>>> # Note:
>>> I didn't find any related reports on the internet, which indicates
>>> that it may be a 0day. Hope the upstream can help check and fix it.
>>> And I'll be happy to provide more information if needed.
>>>
>>> Best,
>>> Tong
>>>
>>
> 

