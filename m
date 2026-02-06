Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C43644B3;
	Fri,  6 Feb 2026 11:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375856; cv=none; b=VyflSN6GZfVx+20TzG1wgdVFPBIoYt2JeliKB5cGqHNPM99vGjVXidAgP5+3QfezU3GbLVgxZI++CcFKEiQXl8wEz5/zt73ROQiafP/oOAkJ0xGtD2KAqFwionIvXw2jjRebC5i/Ujy+YisIgCQjclw7W5K82UiyOTGUoFPXoZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375856; c=relaxed/simple;
	bh=aP2cAl4iCsBuJJewGR8MWGWEHKomvwnjEoBfMeCAsEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VN0JWFrXJBhNfQH5vFH9B9Wet5wNR5tuRUFqIe08a4K2buJH55sx1U0dpzf0ISUBnsVBQNjqeZ5mB74mzu4huDgSNzNl0jR27waguPzW4Vah63wTFjMNVVkIB3HhPJFGUOSwxAqiRdQ1p48uQga6l8nnqaFOp+3KMG9A8M9MpPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9Csoivz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9Csoivz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B8AC116C6;
	Fri,  6 Feb 2026 11:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770375855;
	bh=aP2cAl4iCsBuJJewGR8MWGWEHKomvwnjEoBfMeCAsEk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b9Csoivz5Ugu3GygjOtclhmxIdxcZmE4MXKR1Cx1zKQZeMnv/AeDrOZTrHiMitqkw
	 /+5HfpQRuKV3+OkuPhF4/PSHcvTC12bjF/xIglRQKiju1G8vBNv1bT6Num5+dQmD0l
	 DlsJ0zb2+Rgo2sBfGUcAvXcwzjZRTpatk3YmMMoMVK8NIxPtm0FErSAQHXfiP4fhEH
	 JSPSlaB1QSVMcmCFp7kjkXUHXKJABAWOt3JfN7NOG8eWdVj0KiKiQie5WsjCPP3vYL
	 DOG7sfLEhIRmc0PAqts6SRaskhoToykKA86OOs18TyRm+GlQEoPwEomnZOUg2vksk0
	 ES6ifgj+ZE79A==
Message-ID: <658ce2e9-769b-45b4-9cbb-c340059c5a6e@kernel.org>
Date: Fri, 6 Feb 2026 12:04:11 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: rcu stalls during fstests runs for xfs
Content-Language: en-GB, fr-BE
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Kunwu Chan <kunwu.chan@hotmail.com>,
 "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, hch <hch@lst.de>,
 "Paul E. McKenney" <paulmck@kernel.org>, MPTCP Linux <mptcp@lists.linux.dev>
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
 <aXrl46PxeHQSpYbX@shinmob>
 <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>
 <c33c3d3e-a59c-4f5a-a562-13e2cabc2faf@paulmck-laptop>
 <aXyRRaOBkvENTlBE@shinmob> <144e31a9-e29c-4809-af2e-5ac45150d3f7@kernel.org>
 <aYW6GCmmCFeivAxo@shinmob>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <aYW6GCmmCFeivAxo@shinmob>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/02/2026 11:02, Shinichiro Kawasaki wrote:
> On Feb 06, 2026 / 10:33, Matthieu Baerts wrote:
>> Hi Shinichiro,
>>
>> Sorry to jump in, but I *think* our CI for the MPTCP subsystem is
>> hitting the same issue.
> 
> Hi Matthieu,
> 
>> On 30/01/2026 12:16, Shinichiro Kawasaki wrote:
>>> On Jan 29, 2026 / 15:19, Paul E. McKenney wrote:
>>> [...]
>>>>>>> I have seen the static-key pattern called out by Dave Chinner when running
>>>>>>> KASAN on large systems.  We worked around this by disabling KASAN's use
>>>>>>> of static keys.  In case you were running KASAN in these tests.
>>>>>>
>>>>>> As to KASAN, yes, I enable it in my test runs. I find three static-keys under
>>>>>> mm/kasan/*. I will think if they can be disabled in my test runs. Thanks.
>>>>>
>>>>> There is a set of Kconfig options that disables static branches.  If you
>>>>> cannot find them quickly, please let me know and I can look them up.
>>>
>>> Thank you. But now I know the fix series by Thomas is available. I prioritize
>>> the evaluation of the fix series. Later on, I will try disabling the static-keys
>>> if it is required.
>>>
>>>>
>>>> And Thomas Gleixner posted an alleged fix to the CID issue here:
>>>>
>>>> https://lore.kernel.org/lkml/20260129210219.452851594@kernel.org/
>>>>
>>>> Please let him know whether or not it helps.
>>>
>>> Good to see this fix candidate series, thanks :) I have set up the patches and
>>> started my regular test runs. So far, the hangs have been observed once or twice
>>> a week. To confirm the effect of the fix series, I think two weeks runs will be
>>> required. Once I get the result, will share it on this thread and with Thomas.
>>
>> I know it is only one week now, but did you see any effects so far?
> 
> No, I do not see any hang so far. And I hope there will be no hang in the
> next week either. Fingers crossed...

Thank you for your reply!

>> On
>> my side, I applied the v2 series -- which has been applied i
>> tip/sched/urgent -- but I still have issues, and it looks like it is
>> even more frequent. Maybe what I see is different. If you no longer see
>> the issues on your side after one week, I'm going to start a new thread
>> with my issues not to mix them.
>>
>> Note that in my case, the issue is visible on a system where nested VMs
>> are used, with and without KASAN (enabled via debug.config), just after
>> having started a VSOCK listening socket via socat.
> 
> I applied the v1 series on top of my test target xfs kernel branches enabling
> KASAN.

Sorry for the noise, I guess I have a different issue, even if the
traces look similar [1]. Hopefully someone can help me find the root
cause :)

[1]
https://github.com/multipath-tcp/mptcp_net-next/actions/runs/21723325004/job/62658752123#step:7:7288

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

