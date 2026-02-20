Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EFD2EDD52
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771611136; cv=none; b=eomDK7k9rOGZtOYe+MQn0Q7GbmKX1+5nsT3mfvVwaAVzZSRWlgNlfgRh9O3hy5ukW3+KA8OpbdhZjJnPjI6VkRqCA4Txr9bAQ0FkXLBRGMUKlPfkPu9iyjg/G6kt0pv2lp2w7lFHV8VltS9jL7LF/mZXGSYzHkvx3Az8BFhZafo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771611136; c=relaxed/simple;
	bh=QXiBS2u3WNPthvMcu8RHcrGjQZdLwGXaQ61hy2ceOZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLqGZvHn50T/b/WYj0SFFLv6674gU+9jJWEx8sTujYWfRSmsIKNGhzk0WpEMjomJDBv/NKXrdH8lqD8Wdf+DPSW+foZmc4YzIeQkVOChRRwQmWr0u22QyErJXXyu0yF9Kr5BFDMPDZFYjWgSJ3G25xe/sFBGdyoCxpSzNxrd6gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBlPMUKa; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBlPMUKa"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-826c49b7628so1043975b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 10:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771611133; x=1772215933; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TqtVpJyXlOSony1ZgNHaOS1RyIHwaNyTbJaxrJhP7jI=;
        b=cBlPMUKav7RpjFBvYH1HO5e884abdKIbQ4QJqS1YBmw5ozZdEZozrdvPyBPraReo9S
         kWzlHz8/Na5MnBMH+cZuFHui2hJwH3THW4Sh5pBn2eCVQXHeyUWvkNRhUsSBYKVtBQEa
         et0H8nDSdZA8NwW9biEXvF5gztD63NMrYp04zZrHIJ7dXRvYWIlJRPbLrf1AAxhsbOgQ
         ndwO3lsK/EzH2cR2Fz2aSLQSk/AJtxHSSi1X5IT8KSqsR0vH1wi4shUATHrOtYifda1w
         qmgcivaN9zVt2jGvvNd0sK0vy88a2KK5FgJ2n7jFm0nfcDpohVPKdwRoqRpq5GLphl0U
         l4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771611133; x=1772215933;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqtVpJyXlOSony1ZgNHaOS1RyIHwaNyTbJaxrJhP7jI=;
        b=EHZxGxyKY9N0sLLdAjbtsFtet586UtofHlw0GzeG/nw+xn3jqv5fhFbHxs0yDbnTMJ
         99vLvhtqUH6rbsfdsLlt1d90/lLEWMpQH5XLYSPGuWv41yTIbTv9JvKIjwAhWhBWk6Sh
         mlA2xLFYBETufi6q8Jl61hYeU8P7VpvbtClLqBr1mL9ljSbyIPw9P8G9jCytDZ5z6IOr
         Ja3tcAOLE8Bwmvn8kmwa5BqrcH+KWjUhcpluv2vjWhAibWshURylEtF/vmwfgknbpREh
         XDSM8RiqetjZ9wrgih5OqpLtniLXMvebhiYhfz9IGmNf2pcExlLBCE2Ta+KjfEdLdFDH
         OEXg==
X-Forwarded-Encrypted: i=1; AJvYcCWaZ20kPDYBO16ixhDlB86HUO8ixxDMGQRy/yQUbSKU0HPCDCC2PY85Co8mdqGajd/LlxN5jKK9GJc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSZN6R2GMQ+gnvfkTFSq7B2C2K9W+ZUy9ps1xVCAwZwIzW/p+2
	fr5Xcjt+VhFDY98o+7usOXP2B1g/tVrulsXUec7zQSQrGGPrgGx5pdOP
X-Gm-Gg: AZuq6aLJSsHU9gmnrqNY09GI+lhC9h3Zgzun41MU7BvI0VHVCaCZanKUwqhQYoeXwR4
	lXhcd7e2JVUezsTZ3Bgs30pK1yeFw9gZEwCjWlxNde3gsGawmFNJvvpq3Zc1kg59ZdK+OAk1z/m
	1T2j3tsQUlBEcsqnalgt4HPYnH/yDh6sCYiA59XKneq3yKF8xtgJ7wYCvGHQiLke90Lu9ch1xUJ
	GAhJUB1QSLoOAskF0wSBYSA8tf9hfNDSohrEFZF+5qKqfvNBaBLrUsmfKS0rsgkFc7eWZGmfPmc
	5E8hQ9ApCdzR44QaLKy81BjH4eRztM2Y2LR2md0OGSKFG7Mr65zQpg/GgdoTfG5aXD6VPz1Uokd
	hPd07N1MOHRlQSG3NsevWEWBAv05fMOeghCslShzCtUJNlo5Rwx1uEtMhQVQBCWQyjN4HzxBU8l
	IaGmItEF4Y4tPCp4AT+JW9Qy786NFlU/5H4Q==
X-Received: by 2002:a05:6a21:50e:b0:38b:e890:2f36 with SMTP id adf61e73a8af0-39545f7d1e7mr430868637.46.1771611132749;
        Fri, 20 Feb 2026 10:12:12 -0800 (PST)
Received: from [192.168.0.120] ([49.207.233.114])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b7253b43sm96706a12.25.2026.02.20.10.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 10:12:12 -0800 (PST)
Message-ID: <9f4acd07-b8dd-45ff-b40a-4d135be3155d@gmail.com>
Date: Fri, 20 Feb 2026 23:42:06 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, hch@infradead.org, david@fromorbit.com,
 zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
 <20260219154936.GF6490@frogsfrogsfrogs>
 <a3c85a2e0dff0d43ec66621c6fa530c66ec1c88e.camel@gmail.com>
 <20260220161015.GV6490@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260220161015.GV6490@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2/20/26 21:40, Darrick J. Wong wrote:
> On Fri, Feb 20, 2026 at 04:54:57PM +0530, Nirjhar Roy (IBM) wrote:
>> On Thu, 2026-02-19 at 07:49 -0800, Darrick J. Wong wrote:
>>> On Thu, Feb 19, 2026 at 03:55:02PM +0100, Carlos Maiolino wrote:
>>>> On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
>>>>> On 2/19/26 18:25, Carlos Maiolino wrote:
>>>>>> On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
>>>>>>> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>>>>>>>
>>>>>>> This series adds several tests to validate the XFS realtime fs growth and
>>>>>>> shrink functionality.
>>>>>>> It begins with the introduction of some preconditions and helper
>>>>>>> functions, then some tests that validate realtime group growth, followed
>>>>>>> by realtime group shrink/removal tests and ends with a test that
>>>>>>> validates both growth and shrink functionality together.
>>>>>>> Individual patches have the details.
>>>>>> Please don't send new versions in reply to the old one, it just make
>>>>>> hard to pull patches from the list. b4 usually doesn't handle it
>>>>>> gracefully.
>>>>> This entire series is new i.e, the kernel changes, fstests and the xfsprogs
>>>>> changes. Can you please explain as to what do you mean by the old version?
>>>>> Which old are version are you referring to?
>>>> Sure, I said 'old version' but the same applies to sending them in reply
>>>> to other series/patches.
>>>>
>>>> This series was sent:
>>>>
>>>> In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
>>>>
>>>> which is:
>>>>
>>>> Subject: xfs: Add support for multi rtgroup shrink+removal
>>>>
>>>>
>>>> In better wording, please don't nest series under other series/patches,
>>>> or things like that. It works in some point cases, but in general it
>>>> just makes my life difficult to pull them from the list.
>>> Pull requests, perhaps?
>>>
>>> Or is the problem here that you're using b4/korgalore/etc to download
>>> patchmails so that you can read them outside of a MUA?
>>>
>>> ((Again, I'll express a wish that people push their branches to
>>> git.kernel.org and send a link in the cover letter; that's much easier
>>> for me to pull and examine than reading emails or prying individual
>>> maybe-MTA-corrupted emails out of mutt into applyable form...))
>> Okay, I will keep this in mind. I was under the impression that only
>> maintainers can have their private branches in git.kernel.org. I will
> Anyone with a kernel.org account can push git repos.

https://korg.docs.kernel.org/accounts.html

It says the following:

Getting a kernel.org account
Kernel.org accounts are reserved for Linux kernel maintainers or 
high-profile developers. If you do not fall under one of these two 
categories, it’s unlikely that an account will be issued to you.


In that case, should I use GitHub?

>
> github kinda works too, though I am a Bad Microsoft Citizen(tm) so they
> arbitrarily claim on first access that I'm over a rate limit that they
> do not specify.  Granted that makes them a Bad Provider(tm) but I doubt
> they hear me above all the AI noise.
Okay.
>
>> check on how to create a branch in git.kernel.org. For now, is it okay
>> to just send the branch link as a separate email reply and you can
>> take a look - next revision onwards I will have the link in the cover
>> letter itself?
> Sounds fine to me.

Thank you.

--NR

>
> --D
>
>> --NR
>>> --D
>>>
>>>>> --NR
>>>>>
>>>>>>> Nirjhar Roy (IBM) (7):
>>>>>>>     xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
>>>>>>>     xfs: Introduce helpers to count the number of bitmap and summary
>>>>>>>       inodes
>>>>>>>     xfs: Add realtime group grow tests
>>>>>>>     xfs: Add multi rt group grow + shutdown + recovery tests
>>>>>>>     xfs: Add realtime group shrink tests
>>>>>>>     xfs: Add multi rt group shrink + shutdown + recovery tests
>>>>>>>     xfs: Add parallel back to back grow/shrink tests
>>>>>>>
>>>>>>>    common/xfs        |  65 +++++++++++++++-
>>>>>>>    tests/xfs/333     |  95 +++++++++++++++++++++++
>>>>>>>    tests/xfs/333.out |   5 ++
>>>>>>>    tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>    tests/xfs/539.out |  19 +++++
>>>>>>>    tests/xfs/611     |  97 +++++++++++++++++++++++
>>>>>>>    tests/xfs/611.out |   5 ++
>>>>>>>    tests/xfs/654     |  90 ++++++++++++++++++++++
>>>>>>>    tests/xfs/654.out |   5 ++
>>>>>>>    tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
>>>>>>>    tests/xfs/655.out |  13 ++++
>>>>>>>    11 files changed, 734 insertions(+), 1 deletion(-)
>>>>>>>    create mode 100755 tests/xfs/333
>>>>>>>    create mode 100644 tests/xfs/333.out
>>>>>>>    create mode 100755 tests/xfs/539
>>>>>>>    create mode 100644 tests/xfs/539.out
>>>>>>>    create mode 100755 tests/xfs/611
>>>>>>>    create mode 100644 tests/xfs/611.out
>>>>>>>    create mode 100755 tests/xfs/654
>>>>>>>    create mode 100644 tests/xfs/654.out
>>>>>>>    create mode 100755 tests/xfs/655
>>>>>>>    create mode 100644 tests/xfs/655.out
>>>>>>>
>>>>>>> -- 
>>>>>>> 2.34.1
>>>>>>>
>>>>>>>
>>>>> -- 
>>>>> Nirjhar Roy
>>>>> Linux Kernel Developer
>>>>> IBM, Bangalore
>>>>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

