Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D651DFF0;
	Fri, 31 Jan 2025 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738346128; cv=none; b=XmR7bu1uM6qkqvXDcJxUwZASIF+zgcXLwbFVtbFs6lVKoRmn26pPbZEB9l3Tln4pJuo2V+JGHbrHyFfvnkKpdOj6pgp8GZWKsSCpdwWeU0pFmhAWOvM1ZT4pYLSUjCoS6cnLoadkg6R6Dw9OQzkUPw0RQ4M73s5Vre7QgMs5b8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738346128; c=relaxed/simple;
	bh=OAXghzXbEXET05k4T0EdsDjBHj6a0D0fu4r8hsebT5M=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CxUe6LlQokkLlzP5pyk0aR0isy5bC5m4sSR8F/jFlgtgzeBbjqQbN3QwyLXOpyv2+X+6/cV1cn+BnEVZ1ezNcITViAsuDeGOUrtbUvywmPTITjpjoR6w4fpWL+77Qoi/X4yqsAKONXeQ/ft7rqP174BFPdQHyPaj0q+Xg/1Rm98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=r6Dkc7Tm; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="r6Dkc7Tm"
Received: from [100.65.234.206] (unknown [20.236.10.206])
	by linux.microsoft.com (Postfix) with ESMTPSA id D3EC6210C322;
	Fri, 31 Jan 2025 09:55:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D3EC6210C322
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738346126;
	bh=iV+UaXEvpkR3ax+7gZ8yaJMQbFN1wL9ZD6rO+ROaaek=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=r6Dkc7TmZNztbxSpCn/dVMBV8kFt6An/UvQUukvfSTcNgLQJWbQH9K5Mvm6zT+Pbr
	 lyJOQ+0yGd4Dyl/Xc2VqWK4YCOYlI21SCChF6QTjo2qfCt02lcoXpq7Oglzy1v0G/U
	 hw0sy/mk3vzKODnBiXLo22iX0+0b3A9ppSMh+mnw=
Message-ID: <47098c16-2cf3-44bc-985a-07eb2a225698@linux.microsoft.com>
Date: Fri, 31 Jan 2025 09:55:27 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Jiri Slaby <jirislaby@kernel.org>, eahariha@linux.microsoft.com,
 David Laight <david.laight.linux@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
 Miguel Ojeda <ojeda@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 kernel test robot <lkp@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] jiffies: Cast to unsigned long for secs_to_jiffies()
 conversion
To: Geert Uytterhoeven <geert@linux-m68k.org>
References: <20250130184320.69553-1-eahariha@linux.microsoft.com>
 <20250130201417.32b0a86f@pumpkin>
 <9ae171e2-1a36-4fe1-8a9f-b2b776e427a0@kernel.org>
 <CAMuHMdUNjKJ0CFw+i1qgVsHO2LU6uOqkAq5iGL0EZyCtrfzM=A@mail.gmail.com>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <CAMuHMdUNjKJ0CFw+i1qgVsHO2LU6uOqkAq5iGL0EZyCtrfzM=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/2025 12:10 AM, Geert Uytterhoeven wrote:
> Hi Jiri,
> 
> CC linux-xfs
> 
> On Fri, 31 Jan 2025 at 08:05, Jiri Slaby <jirislaby@kernel.org> wrote:
>> On 30. 01. 25, 21:14, David Laight wrote:
>>> On Thu, 30 Jan 2025 18:43:17 +0000
>>> Easwar Hariharan <eahariha@linux.microsoft.com> wrote:
>>>
>>>> While converting users of msecs_to_jiffies(), lkp reported that some
>>>> range checks would always be true because of the mismatch between the
>>>> implied int value of secs_to_jiffies() vs the unsigned long
>>>> return value of the msecs_to_jiffies() calls it was replacing. Fix this
>>>> by casting secs_to_jiffies() values as unsigned long.
>>>
>>> Surely 'unsigned long' can't be the right type ?
>>> It changes between 32bit and 64bit systems.
>>> Either it is allowed to wrap - so should be 32bit on both,
>>> or wrapping is unexpected and it needs to be 64bit on both.
>>
>> But jiffies are really ulong.
> 
> That's a good reason to make the change.
> E.g. msecs_to_jiffies() does return unsigned long.
> 
> Note that this change may cause fall-out, e.g.
> 
>     int val = 5.
> 
>     pr_debug("timeout = %u jiffies\n", secs_to_jiffies(val));
>                         ^^
>                         must be changed to %lu
> 
> More importantly, I doubt this change is guaranteed to fix the
> reported issue.  The code[*] in retry_timeout_seconds_store() does:
> 
>     int val;
>     ...
>     if (val < -1 || val > 86400)
>             return -EINVAL;
>     ...
>     if (val != -1)
>             ASSERT(secs_to_jiffies(val) < LONG_MAX);
> 
> As HZ is a known (rather small) constant, and val is range-checked
> before, the compiler can still devise that the condition is always true.
> So I think that assertion should just be removed.
> 
> [*] Before commit b524e0335da22473 ("xfs: convert timeouts to
>     secs_to_jiffies()"), which was applied to the MM tree only 3
>     days ago, the code used msecs_to_jiffies() * MSEC_PER_SEC,
>     which is more complex than a simple multiplication, and harder for
>     the compiler to analyze statically, thus not triggering the warning
>     that easily...
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 

Thanks, Jiri and Geert. Geert, am I correct in understanding you that
you're suggesting v2 of the series[1] to convert msecs_to_jiffies()
calls to secs_to_jiffies() remove the ASSERT as redundant, while also
keeping this patch because ulong is the right type for jiffies?

[1]
https://lore.kernel.org/all/20250128-converge-secs-to-jiffies-part-two-v1-0-9a6ecf0b2308@linux.microsoft.com/

Thanks,
Easwar
