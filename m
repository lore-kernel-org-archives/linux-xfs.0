Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DA615B562
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721835682; cv=none; b=KtzV7KZLSC+lHXkujVfvmsDLz5/1HiZovgS/gDx1/l3oR6aUyLpOrAKq91Ktop/si+9DYg+kazvbW/e/YXtBXkvPBFfzoMhVczRSzj7k1zzhtoentvqhUjccgAi5SiAZyvABY3GJZmp8CTlSswlHixMX+Dm+E94PEJp0qX9hb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721835682; c=relaxed/simple;
	bh=UKuJAJCjgJuoqVQ/g4EzxlOxMpuSggpwMJposD5Yydo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fygw34x0PKStzd2EFeC0V4/lFKHq/Jzyd2WudfwsmhijmszRPrxdqLepIKMopXXkRH36dSzPp/ZFcWcboVUzYlF8/v7vz//IJQa18Upu+v3VdqwXI386d8mMWX1TRvfKu3Q9/U3kUsl94JhpYvGe8JH2AWl9cAwko0IMYnuTcME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=DG4gbjw4; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="DG4gbjw4"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 983A35CC2E1;
	Wed, 24 Jul 2024 10:41:13 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 983A35CC2E1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1721835673;
	bh=xSYMppAcBIth4BA01R0gtHPTkqTmfabiFuszD8eq0xg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DG4gbjw4PAxKGShT8tk/8BFULH50dq2uSq0NLagomyc/7YZnB5UmuBqq5bDzb883a
	 RC/eXkehrCUuU9P7lnQZiktd72GeneZZ8C2H1pSXUadJQmHcG57nMiSr8Pw14LyfWI
	 c/NeH3DZPkBNlvIv9u3eL70J7H4OVIDuaZ4peR0dZ5uVYtJ8Ure8iz/OEZAbjNw6WI
	 GFlRNHjML1CS9Eg0mi/rnmVVA9tKJqLluCmYc6i4edCjphpPiB08To64PslJj7COne
	 KbY7qLXn8YwbHfGQ/KfJ1IzK/081R4psltCyLEWv+18BfH9Z2t2c1Hw21tPMvO93lU
	 NWYe3J7XCq+VA==
Message-ID: <f7bbde19-80b8-4118-b8ab-654df9784e13@sandeen.net>
Date: Wed, 24 Jul 2024 10:41:13 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ZqBO177pPLbovguo@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/23/24 7:46 PM, Dave Chinner wrote:
>> What about the log?  If sb_agblocks increases, that can cause
>> transaction reservations to increase, which also increases the minimum
>> log size.
> Not caring, because the current default minimum of 64MB is big enough for
> any physical filesystem size. Further, 64MB is big enough for decent
> metadata performance even on large filesystem, so we really don't
> need to touch the journal here.

Seems fair, but just to stir the pot, "growing the log" offline, when
you've just added potentially gigabytes of free space to an AG, should
be trivial, right?

-Eric
