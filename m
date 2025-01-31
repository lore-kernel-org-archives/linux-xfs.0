Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F231CD215;
	Fri, 31 Jan 2025 17:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738346391; cv=none; b=bg5Vydx/PTNDD9sWSHGgVOMwPoG7gqDEM/hIABUbBqr9JPmuuwYkbV83QwcS13ThMcap48CHdgnjbDO+EVov55Axsd4ZQAJf/TFNMsQzdTVOUOLoCGftnHobysV7Lg2TQephBGDtI2q/vlFnU13CvF2kPqdfqbzf0CyssrrnFOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738346391; c=relaxed/simple;
	bh=nXWT8j2G/uzLN64vLb7vwc1laXXA983XpXlI9rAJRa0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hNaHd8h3x29MzTxcZOLrfL4SAk+AT7CUcfVGUV39cYv2koPJzpzjTOALUIy3BAM5e/M/VaOrkWDY0dqYYmBxnuJ90nEY7KNQy7EdlrAtHQNHE6zBzEYTFRJf2AGIcxuGarx+V2J/TIGBpLxcBmE/FFAfnDsgFvBl5Futst+PDf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=a6dw5Bmq; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="a6dw5Bmq"
Received: from [100.65.234.206] (unknown [20.236.10.66])
	by linux.microsoft.com (Postfix) with ESMTPSA id 24E8E210C322;
	Fri, 31 Jan 2025 09:59:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 24E8E210C322
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738346389;
	bh=XPbYcf6qzF2DMTTNx2lFPYl4W5TcffizNhSxUduMC2A=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=a6dw5BmqI18cQBFdJlYBMKyx5kbRldsQWBROTSkbGpDQ1utLrBFCv8LtYHmT3tuk6
	 48NhnQjeEmR83rgegD+5CWd2uoJDbmYi26BZVc4lubYeduw5r0ipF7IkGiDRUIMUji
	 Vo+/gmn0Nz6YZlI7SOf3Cp1KOiFDrRed7ezz+VdQ=
Message-ID: <3bdffe1d-9355-4fad-8d4e-6526c094e3a3@linux.microsoft.com>
Date: Fri, 31 Jan 2025 09:59:50 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: eahariha@linux.microsoft.com, Jiri Slaby <jirislaby@kernel.org>,
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
 <47098c16-2cf3-44bc-985a-07eb2a225698@linux.microsoft.com>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <47098c16-2cf3-44bc-985a-07eb2a225698@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/2025 9:55 AM, Easwar Hariharan wrote:
> On 1/31/2025 12:10 AM, Geert Uytterhoeven wrote:
>> Hi Jiri,
>>
>> CC linux-xfs
>>
>> On Fri, 31 Jan 2025 at 08:05, Jiri Slaby <jirislaby@kernel.org> wrote:
>>> On 30. 01. 25, 21:14, David Laight wrote:
>>>> On Thu, 30 Jan 2025 18:43:17 +0000
>>>> Easwar Hariharan <eahariha@linux.microsoft.com> wrote:
>>>>
>>>>> While converting users of msecs_to_jiffies(), lkp reported that some
>>>>> range checks would always be true because of the mismatch between the
>>>>> implied int value of secs_to_jiffies() vs the unsigned long
>>>>> return value of the msecs_to_jiffies() calls it was replacing. Fix this
>>>>> by casting secs_to_jiffies() values as unsigned long.
>>>>
>>>> Surely 'unsigned long' can't be the right type ?
>>>> It changes between 32bit and 64bit systems.
>>>> Either it is allowed to wrap - so should be 32bit on both,
>>>> or wrapping is unexpected and it needs to be 64bit on both.
>>>
>>> But jiffies are really ulong.
>>
>> That's a good reason to make the change.
>> E.g. msecs_to_jiffies() does return unsigned long.
>>
>> Note that this change may cause fall-out, e.g.
>>
>>     int val = 5.
>>
>>     pr_debug("timeout = %u jiffies\n", secs_to_jiffies(val));
>>                         ^^
>>                         must be changed to %lu

That was wrong even before the conversion to secs_to_jiffies() (or this
patch) because as Jiri says, jiffies are ulong.

<snip>

- Easwar (he/him)
