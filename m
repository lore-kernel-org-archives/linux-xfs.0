Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681B315AAA9
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712080561; cv=none; b=FcY2tnqh+wVeiQSNz6sN3iZz3OSt9eskYGr4fOhpZ5og8tvvs6snoBBCgRNT2sqmdaeyLqDWd17yIRKT+cTVfMrn+LrIQU2gl6jMlaoyg5CCLmIiQP74Pgir+rGU6+yb2Dpinr7OI9uwAotmRj2V5q7bSgggGEWLgSsALeWHtDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712080561; c=relaxed/simple;
	bh=+f21UHgUc6I0dn8ACpcQ/QboEyym/Vgtb/EwA4sRVtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=hhld7xoft4w6Ahk6Xp6iMpHAfl8VSl864L3vJiTFPy42xfwYkCZ0GknvuRLF+LgCw4Q1QUMVqHFdp4nsgpjk3vXKFeaULMmMG60VgBWvGF6WMwteciS5V+Zoi139OtYMzpbk/Sy028ZpmXe1fubgTFrJIEz2JALlLOmQ3ELqDF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=KWOQPT6k; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="KWOQPT6k"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 682FB3289F0;
	Tue,  2 Apr 2024 12:55:58 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 682FB3289F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1712080558;
	bh=s65TaAVtJfZ7cc7o+qZzjyI+ro9A/KZ9A0sQIYEt87w=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
	b=KWOQPT6kbRiXrX5AtgNjK7No7jsYUPCZxvwVrma58tvAfkQVgNgaK+PV3UMGW3l3P
	 yTPz2mWNRxDWvPQdc9Bhody0y04LNnv0GM15u6bMn3AhSuq25qONW4lwaJZtGOzQnx
	 qxPuMX9jhlTLhQte4WJgF/a/SQgwg+JiWtFm+IO/4wB0o+rxlb4R3y9SmxeEIwc0U5
	 8b+laciYd9MBPebykUpr45BAO/o0Vez0GQquB+x9czWcyo4lLNs6utBrVCYrBcAOac
	 pieZdH+W7Hr3R6fAYpU9Y8yCRxSbjklW3EvPBSQtlMc6l+trAbvzmNNZhL50l6B8wr
	 pxcpVK4bxAjbg==
Message-ID: <d1d4df97-307c-4c61-86bc-c83b8f10a745@sandeen.net>
Date: Tue, 2 Apr 2024 12:55:57 -0500
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
 <e5ca2146-8d39-4af5-80fb-0bd5ab9ed304@sandeen.net>
 <CAEJPjCsXGHWzek7AQ1g3byUZe1Uq7KuUxJ0GY2fac3J8y+LFZQ@mail.gmail.com>
Content-Language: en-US
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAEJPjCsXGHWzek7AQ1g3byUZe1Uq7KuUxJ0GY2fac3J8y+LFZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/2/24 10:33 AM, 刘通 wrote:
> Hi Eric:

Hi Tong -

(please keep the discussion on-list, since it started there)

> Thanks for your great efforts. Let me answer you questions one by one:
> 0. Note: I have tested the PoC under the root privileges. Did you run
> the PoC under normal user mode? So I think that's why it can through
> KASAN in my env. (I have tested on 5.15.148 and 5.15.150 and my
> teamate also tested it and confirmed with root, it can crash due to
> KASAN.) Also I have run the PoC under the normal user privilege, it
> did not crash. But, as you said, I think once we figure out the root
> cause, there may exists a syscall chain that minimize the privilege to
> reach the KASAN error.

I ran as root.

My point about analyzing the POC is that the first ioctl called,
XFS_IOC_SET_RESBLKS, requires CAP_SYS_ADMIN. So it is unsurprising
that nothing interesting happens as a normal user. This is an example
of pre-analysis that could have been done without any deep XFS
knowledge. It also greatly reduces any security concerns about the
flaw.

> 1. Does it do so for you? Please refer to Q0.

It does not.

> 2. prior to the xfs test may have corrupted memory? Well, this
> question is quite hard to answer.

It is hard to answer, but if you can run your POC from a fresh boot
and hit a KASAN error, that rules out prior corruption as the cause.

However, I have run the POC with your kernel version and your exact config
in a loop 2000x in my VM (after disabling panic on warn), with and without
other system load, and I hit no KASAN errors.

-Eric

> I've trying to debug the PoC using
> gdb but the poc calls xfs_allocbt_init_key_from_rec soooo much times
> so I can hardly locate the root cause. That's why I did not figure out
> this issue clearly... If I can do this, I definitely will show them in
> the report. So I feel sorry that the report is somehow unclear and
> rushed. But I just submit it promptly after I tried my best to
> analyzing to ensure the kernel security.

> Thanks for your time again.
> 
> Best,
> Tong
> 
> Eric Sandeen <sandeen@sandeen.net> 于2024年4月2日周二 23:09写道：
>>
>> On 4/2/24 5:08 AM, 刘通 wrote:
>>> Hi Eric.
>>>
>>> I've actually always followed this principle of vulnerability analysis
>>> that you mentioned, but in this case, due to my lack of familiarity
>>> with xfs, I wasn't able to construct a sensible PoC. I try to do my
>>> best to analyze the root cause when it's in my power to do so, but I
>>> couldn't do it in this case.
>>
>> Ok, but the things I suggested below don't require deep knowledge
>> of xfs - just looking at the POC and understanding/describing what
>> it is doing, simplifying it to the fewest syscalls to provoke the
>> problem, what privileges are required to form a general assessment
>> of a possible threat, etc.
>>
>>> I'm sorry for adding to your workload,
>>> but I don't think that this is an indication that it's a false
>>> positive, KASAN's memory detection is justified, so are you 100% sure
>>> that the program you constructed is completely correct? I mean, KASAN
>>> reported a uaf vulnerability, which is not unfounded. If you are able
>>> to reproduce the crash as I said before, then it is a fact that it
>>> exists with a high probability, but if when you constructed the
>>> simplified program, is it completely consistent with the original
>>> repro.c?
>>
>> I did not construct a new reproducer, I ran your exact set of steps
>> using your kernel version, your config, and your repro.c, and while
>> it triggered a bug in XFS, it did not trigger any KASAN errors.
>>
>> As I originally asked - does it do so for you? Looking at the logs,
>> it seems very possible that tests that ran prior to the xfs test
>> may have corrupted memory, which the xfs repro.c stumbled into during
>> your run, and won't be reproduced on a fresh run of that reproducer.
>>
>> Thanks,
>> -Eric
>>
>>> Best,
>>> Tong
>>>
>>> Eric Sandeen <sandeen@sandeen.net> 于2024年4月2日周二 13:54写道：
>>>>
>>>> On 3/7/24 1:23 AM, 刘通 wrote:
>>>>> Hi upstream community,
>>>>>
>>>>> I was fuzzing a LTS version of Linux kernel 5.15.148 with my modified
>>>>> syzkaller and I found a bug named "KASAN: use-after-free in
>>>>> xfs_allocbt_init_key_from_rec".
>>>>>
>>>>> I tested the PoC on 5.15.148, 5.15.149 and 5.15.150 with sanitizer on
>>>>> and found sanitizer through a panic as "KASAN: use-after-free in
>>>>> xfs_allocbt_init_key_from_rec" on 5.15.148 and 5.15.150, but there was
>>>>> no panic and sanitizer error in 5.15.149.
>>>>>
>>>>> The syzkaller log, report, kernel config, PoC can be found here:
>>>>> https://drive.google.com/file/d/1w6VKKewt4VQzb9FzcGtkELJUOwd1wMcC/view?usp=sharing
>>>>>
>>>>> # Analysis (rough):
>>>>> Because that I cannot understand the report0 clearly in the zip file
>>>>> above, so I rerun the PoC on my vm (5.15.148) and I get another report
>>>>> named as the same but it looks much clearer than the report0. The new
>>>>> report can be found in:
>>>>> https://drive.google.com/file/d/1Vg_4Qwueow6VgjLrijnUB8QbZVx902sv/view?usp=sharing
>>>>> In this report, we can easily see that the memory allocation and free:
>>>>> Allocation:
>>>>
>>>> As a PhD student interested in security analysis, you could do much more
>>>> here.
>>>>
>>>> For starters, test this on an upstream/mainline kernel to see if it
>>>> reproduces.
>>>>
>>>> Provide the filesystem image that seems to reproduce it, rather than
>>>> an array in a C file.
>>>>
>>>> Look at your reproducer, and identify the ioctls and syscalls that you
>>>> believe provoked the error. See what privileges are needed to invoke them,
>>>> if you believe this may be a security flaw.
>>>>
>>>> Test your reproducer in isolation, and see if it actually reproduces your
>>>> use after free (I don't think that it does.)
>>>>
>>>> If it doesn't, look back at the tests that ran before it, and see if
>>>> something is corrupting memory, etc.
>>>>
>>>> It's far too easy for someone to turn a syzkaller crank, throw it over
>>>> the wall, and move on. If you want to help, dig in, don't just pawn off
>>>> the problem with no effort to investigate what you believe you've found.
>>>>
>>>>> ```
>>>>> [   62.995194][ T6349] Allocated by task 6343:
>>>>> [   62.995610][ T6349]  kasan_save_stack+0x1b/0x40
>>>>> [   62.996044][ T6349]  __kasan_slab_alloc+0x61/0x80
>>>>> [   62.996475][ T6349]  kmem_cache_alloc+0x18e/0x6b0
>>>>> [   62.996918][ T6349]  getname_flags+0xd2/0x5b0
>>>>> [   62.997335][ T6349]  user_path_at_empty+0x2b/0x60
>>>>> [   62.997782][ T6349]  vfs_statx+0x13c/0x370
>>>>> [   62.998193][ T6349]  __do_sys_newlstat+0x91/0x110
>>>>> [   62.998634][ T6349]  do_syscall_64+0x35/0xb0
>>>>> [   62.999033][ T6349]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
>>>>> ```
>>>>> Free:
>>>>> ```
>>>>> [   62.999776][ T6349] Freed by task 6343:
>>>>> [   63.000135][ T6349]  kasan_save_stack+0x1b/0x40
>>>>> [   63.000555][ T6349]  kasan_set_track+0x1c/0x30
>>>>> [   63.001053][ T6349]  kasan_set_free_info+0x20/0x30
>>>>> [   63.001638][ T6349]  __kasan_slab_free+0xe1/0x110
>>>>> [   63.002206][ T6349]  kmem_cache_free+0x82/0x5b0
>>>>> [   63.002742][ T6349]  putname+0xfe/0x140
>>>>> [   63.003103][ T6349]  user_path_at_empty+0x4d/0x60
>>>>> [   63.003551][ T6349]  vfs_statx+0x13c/0x370
>>>>> [   63.003943][ T6349]  __do_sys_newlstat+0x91/0x110
>>>>> [   63.004378][ T6349]  do_syscall_64+0x35/0xb0
>>>>> [   63.004841][ T6349]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
>>>>> ```
>>>>> So this is a use-after-free bug: allocated by `kmem_cache_alloc` and
>>>>> freed by `kmem_cache_free`.
>>>>> And according to the report, the UAF occurs in
>>>>> `xfs_allocbt_init_key_from_rec`, `key->alloc.ar_startblock =
>>>>> rec->alloc.ar_startblock;` which indicates that maybe
>>>>> `rec->alloc.ar_startblock` was freed before.
>>>>>
>>>>> # Step to reproduce:
>>>>> 1. download the zip file
>>>>> 2. unzip it
>>>>> 3. compile the kernel (5.15.148, 5.15.150) with kernel_config
>>>>> 4. start the kernel with qemu vm
>>>>> 5. scp repro.c to the vm
>>>>> 6. compile the repro.c and run it: gcc repro.c -o exp && ./exp
>>>>> 7. you will see the KASAN error
>>>>
>>>> AFAICT you won't. I did exactly this, and got no KASAN error.
>>>> Did you, after following these steps on a fresh boot of the kernel?
>>>>
>>>> -Eric
>>>>
>>>>> # Note:
>>>>> I didn't find any related reports on the internet, which indicates
>>>>> that it may be a 0day. Hope the upstream can help check and fix it.
>>>>> And I'll be happy to provide more information if needed.
>>>>>
>>>>> Best,
>>>>> Tong
>>>>>
>>>>
>>>
>>
> 

