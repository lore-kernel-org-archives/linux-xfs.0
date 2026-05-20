Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7526D346E70
	for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 07:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779261452; cv=none; b=aDTylzlv8n4yy/Yt6RLOM7I47RmWjyelP9sDLb/ZjugLoVwtFenuRtl8DiUZJZkrSh4A043s/z2J2b/y0Azzri5F/KT57qvmBgeVKGeAC88DB0kk3/R0o2KP05lytXjme0gzU5gCB3+0FsWKtc3wT3J0A85m/43oDJ6qjpxwRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779261452; c=relaxed/simple;
	bh=olwb/z86ckyhfF+FdM1S0WI7K5bZ37CoRoRiUfRjqOY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=kfQMS0FiD2Do7G5rRPT9hWDNBK9xVzd8EE7iNQt07BxAIwb4XJfidac3Txtm7PYWznoP4wYqELsD89ot45R3/YCbbYkqljZLXPRPyzZ5Yy+CkO9EbwhcyizXW+nbcICa7iIz+dOapzMtn6ulq/AYVjH+5x6TUt3K2YZJRQBzI54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 53099180F2E9;
	Wed, 20 May 2026 09:17:16 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id HdEeDvxfDWoBnDEAKEJqOA
	(envelope-from <lukas@herbolt.com>); Wed, 20 May 2026 09:17:16 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 20 May 2026 09:17:16 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cem@kernel.org>, djwong@kernel.org,
 aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] xfsprogs: mkfs.xfs add default configuration
 file.
In-Reply-To: <fddc8573-8461-475f-9826-ee465c48c969@sandeen.net>
References: <20260514143716.893814-2-lukas@herbolt.com>
 <20260514143716.893814-3-lukas@herbolt.com>
 <agXnLdc5kzfyOI3P@nidhogg.toxiclabs.cc>
 <fddc8573-8461-475f-9826-ee465c48c969@sandeen.net>
Message-ID: <ab057e365f5d2a50fd4ef1385c7f7e11@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-05-14 18:05, Eric Sandeen wrote:
> On 5/14/26 10:21 AM, Carlos Maiolino wrote:
>> On Thu, May 14, 2026 at 04:37:17PM +0200, Lukas Herbolt wrote:
>>> Various users may prefer different default values. Having a default 
>>> config
>>> file will allow them to utilize it without the need specifying 
>>> configuration
>>> file on command line.
>>> 
>> The idea seems reasonable, to have a default file to load if it's 
>> found.
>> I just particularly don't like the idea of shipping/installing a 
>> 'default'
>> config file.
>> I think we could ship an "example" one, but leave to distributions to 
>> decide
>> what to do. If they would install a default config or not. And 
>> maintain
>> the default config file.
>> LTS configs are easy to maintain because we know no new features will 
>> be
>> ported to LTS. Providing a default config file from the mainline risks
>> getting a lot of user complains if we in the future decide to change 
>> the
>> 'defaults' of the default config file.
> 
> Thanks for starting this discussion Lukas.
> 
> I'm sure others will have Deeper Thoughts but I more or less agree with
> Carlos here - a default config file to be loaded /if it exists/ but 
> maybe
> not existing by default - because we already have defaults hardcoded 
> into
> the binary itself - might be a more maintainable path for upstream.
> Otherwise I see new tests appearing which are like "make sure the 
> dfault
> config we ship matches the defaults built into the binary itself" which
> seems like unneeded complexity.
> 
> (i.e. the os-specific config files could be renamed or symlinked to
> that special default config file path, for example?)
> 
> I could maybe see generating an example defaults config file which 
> matches
> the built-in defaults at build time? Not sure if that would be useful
> or helpful (or complex).
> 
> Thanks,
> -Eric

Noted, I think we can be shipping mkfs.xfs.conf.example with some of the
defaults options set and keep it with the lts configs
-- 
-lhe
