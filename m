Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47FE2E639
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721842439; cv=none; b=BeticyJaAi9mrAkvzPwN7D0AEVD/LUtNY/5OtK/J+RC8ElNK3abF5D18MJ3hmehDRygspqTN0mt69E1icE+0IbpNKqeRO9jfRi9hxqgUGpKFGuG+XUNLqqIZEsZrOUMT7dxvXuy7xS5L0WMvvVWYDinA9KfLG8jekwVoHjWwa34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721842439; c=relaxed/simple;
	bh=0sBQuT+WP2ssfjPBzvD741TAXsRRsQH9w3HeRcdnD4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QTg2BMMOLbRSkOAskcrKbxh9CXEKltPv6mNv/BkFQZgfDlZjRpye2X7GVvMd81lHhfT3wSaMQBmSZCRVKaBCVcBLFA4k0TKJoXflJevEkt83g/KtH7V4yVmTeL/trmwoBOqyI+LbY3uqpxKCr4lUeoiOwcWTlV6SFJNXhF17/Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=AQ24Qozk; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="AQ24Qozk"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B7E095CC2E1;
	Wed, 24 Jul 2024 12:33:56 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net B7E095CC2E1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1721842436;
	bh=vbPR/UhJT03o3JpQLyfIjR8J0OczJDOAvuVVDWTpZus=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AQ24QozkXVMHadg/lJLk4yP/XDNVYm+88o/2qIAOova3I6HaoWXjhF6dMxbEItHX9
	 AZYIdHsq0i7X5NxE8jq3trnYsH52t3G/tWUco6XNH6gLZYaBwTfChdqEdJwADl8P+x
	 687IybuH5Wqm1tWZP1tSlAxeaTvbIANuE+PkR8wOpf4mgfXvyZFHG49qn6/7ijUW/W
	 0QFRbxldKPqDdyL5jgmcttVdP+sCwmg7RVJg05r3Sm0Jw6EG0Ok6EQEKB9TutWgaiu
	 a68pv6OwY3R3naC9E9pg+viskCTi8CrARE9xwegYZSQlrzvkBfGR6hiERmHzQb3eIg
	 7ZXOAXDvfgwvw==
Message-ID: <adf6e172-a8cc-4223-a790-9a9dcc1b28ca@sandeen.net>
Date: Wed, 24 Jul 2024 12:33:56 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <f7bbde19-80b8-4118-b8ab-654df9784e13@sandeen.net>
 <73173356-6914-42d4-8020-ea2f32661393@sandeen.net>
 <20240724172334.GY612460@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240724172334.GY612460@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 12:23 PM, Darrick J. Wong wrote:
> On Wed, Jul 24, 2024 at 10:44:47AM -0500, Eric Sandeen wrote:
>> On 7/24/24 10:41 AM, Eric Sandeen wrote:
>>> On 7/23/24 7:46 PM, Dave Chinner wrote:
>>>>> What about the log?  If sb_agblocks increases, that can cause
>>>>> transaction reservations to increase, which also increases the minimum
>>>>> log size.
>>>> Not caring, because the current default minimum of 64MB is big enough for
>>>> any physical filesystem size. Further, 64MB is big enough for decent
>>>> metadata performance even on large filesystem, so we really don't
>>>> need to touch the journal here.
> 
> <shrug> I think our support staff might disagree about that for the
> large machines they have to support, but log expansion doesn't need to
> be implemented in the initial proposal or programming effort.

+1

Yeah I'd prefer to not get bogged down in that, it can be done later,
or not. Let's focus on the core of the proposal, even though I'm
academically intrigued by log growth possibilities.

(he says, then comments more)

>>> Seems fair, but just to stir the pot, "growing the log" offline, when
>>> you've just added potentially gigabytes of free space to an AG, should
>>> be trivial, right?
> 
> Possibly -- if there's free space after the end and the log is clean.
> Maybe mkfs should try to allocate the log at the /end/ of the AG to
> make this easier?

It can be any sufficiently large free space, right, doesn't have to
be adjacent to the log. So as long as you've expanded more than 64MB
there's a chance to move to a bigger log region, I think.

>> Ugh I'm sorry, read to the end before responding, Eric.
>>
>> (I had assumed that an expand operation would require a clean log, but I
>> suppose it doesn't have to.)
> 
> ...why not require a clean filesystem?  Most of these 10000x XFS
> expansions are gold master cloud images coming from a vendor, which
> implies that we could hold them to slightly higher cleanliness levels.

Yeah I mean it only matters if you want to change the log size, right.
So could even do

# xfs_expand --grow-data=4T --grow-log=2G fs-image.img
Error: Cannot grow a dirty log, please mount ...
# 

But I think we're getting ahead of ourselves a little, let's see if
the basic proposal makes sense before debating extra bells and
whistles too much? It's probably enough at this point to say
"yeah, it's possible if we decide we want it, the design does not
preclude it."

-Eric

> --D
> 
>> -Eric
>>
>>
> 

