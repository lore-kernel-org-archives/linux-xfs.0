Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA5717C9F1;
	Mon,  3 Feb 2025 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738615353; cv=none; b=ISB3sM9xdT4mfXljl7grzd3FusWM7jzE7So/2iPlOnnMTcK22P+9TCn09uKqXfFJEFdCa8PRxX+Ok15HZNfeSDY8xDG0Mwm8mnRHBOpawnvJ3eWRbPDk0kacsBF/Ar+ElAyr2tdvYpi5RA7Bwsx4Bo5/NX9vJ+RYmK6YDb79PtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738615353; c=relaxed/simple;
	bh=Iu6wnHsyLCNQdkmLTXy/FM4BG/7x+N4mvMN1Zrvhxrc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=XqmWIsqHXWJns3nwfBlITpgseVsBhPJ5KS2vNdMlFacZTDQVI3OrLclbQfW0wywoAPDhjFzWD2CPXtvFbfEAxauMyw2Kq4ZdxfMvd2VDsQpz5ILG652fTF/+r+V8ImJJ3I3JSfwXx464/Fb/645KSCcxdnkKTmb3H3Tf7+gmXxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=AnduH1Wg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="AnduH1Wg"
Received: from [100.65.3.132] (unknown [20.236.10.163])
	by linux.microsoft.com (Postfix) with ESMTPSA id ACFFA20BCAF2;
	Mon,  3 Feb 2025 12:42:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ACFFA20BCAF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738615351;
	bh=uCnmbS+l4SVliYD61OoKU2p2xCGadch80XW9/XVbniQ=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=AnduH1WgJdvR4wX5269FS/zbXk5FZRl9BGFfUkGrPiiZofWBwRYQI6QpswAJf4SFR
	 /byZ9O61zA6+iVC7lKeNe1J0NxEjzBd/KdVGg/8/fRQYTOPdGSSpK/QvBt/BqoSdmW
	 Ji5+zneX3m1tPKj8iG9X2HU2Pys/jQmT6o6h/fp0=
Message-ID: <34a36725-6efd-43fe-9e23-19b14814b6af@linux.microsoft.com>
Date: Mon, 3 Feb 2025 12:42:36 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: Re: [PATCH] jiffies: Cast to unsigned long for secs_to_jiffies()
 conversion
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: eahariha@linux.microsoft.com, Jiri Slaby <jirislaby@kernel.org>,
 David Laight <david.laight.linux@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
 Miguel Ojeda <ojeda@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 kernel test robot <lkp@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>
References: <20250130184320.69553-1-eahariha@linux.microsoft.com>
 <20250130201417.32b0a86f@pumpkin>
 <9ae171e2-1a36-4fe1-8a9f-b2b776e427a0@kernel.org>
 <CAMuHMdUNjKJ0CFw+i1qgVsHO2LU6uOqkAq5iGL0EZyCtrfzM=A@mail.gmail.com>
 <47098c16-2cf3-44bc-985a-07eb2a225698@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <47098c16-2cf3-44bc-985a-07eb2a225698@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/2025 9:55 AM, Easwar Hariharan wrote:
> On 1/31/2025 12:10 AM, Geert Uytterhoeven wrote:

<snip>

>>
>> More importantly, I doubt this change is guaranteed to fix the
>> reported issue.  The code[*] in retry_timeout_seconds_store() does:
>>
>>     int val;
>>     ...
>>     if (val < -1 || val > 86400)
>>             return -EINVAL;
>>     ...
>>     if (val != -1)
>>             ASSERT(secs_to_jiffies(val) < LONG_MAX);
>>
>> As HZ is a known (rather small) constant, and val is range-checked
>> before, the compiler can still devise that the condition is always true.
>> So I think that assertion should just be removed.
>>

Following the lkp instructions to repro the issue, with this patch, the
compiler does not continue reporting that the condition is always true.
This patch is sufficient IMHO, without needing to remove the assert.

- Easwar (he/him)
