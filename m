Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AD91591F3
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721835890; cv=none; b=MaiDH1h9myDHKZjld0ajMU2wJqn8JGNmB5F1dvgVuwgqdapWCMd68Ik1XSQVTdGhe2eSd7AJlXN+jQQB4COoenZzuZmS5hikq1wkELHcWq6K/XhfDfqK5gKtDjV3Adz36MQU6sHGdOqq8Dyxv123oZngyhl19hGR7qlLM8+mHgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721835890; c=relaxed/simple;
	bh=kbDWsZTKegIMsO/qk2BHihs1hBEFxduQkISfbI7sKz4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Hr/q/uPzdLjc0uW7p3HObmT+BnoROo/mu72iAr49XyKrIkMxB372N312AYiEYdjHleMHrjXXbcZZ8hvBgdWKejdhc5JQIuYHcagGIZKQ9ITXKlO5rQvF1l9Q62ilpcH/wDRdyAjWHK2daZT5Q9GrakKeF/U2YDa6KomwkZF2EdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=by0q99Gx; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="by0q99Gx"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EC2B25CC2E1;
	Wed, 24 Jul 2024 10:44:47 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net EC2B25CC2E1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1721835888;
	bh=gys8VMqMbEwlRlezX9Su2sPpBdkHtkz2M5BEi43E3kE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=by0q99GxeGgRxUuVY3MB5hXxfs2wLJp4nMS+NiOGeWlj1Edz6lPSrwnOcm8vMAozC
	 jA64bKG9vSxpMkY+8PTqay5ES6aWP5QoWWTEOxoWW940+xdTcGM65K5JRIKHzIn+I3
	 q65L6kQfI93QkhZLAPy99kNgNCKQGkTTY9jEOdbwDUBk13byq5uCIntNqx1YPJhPsT
	 kC/crR38OIg5PIitfc9ip68TmzFHlitqNKLp+bvoUd72SthtJOOXAEWTRYI2PTWHKx
	 sYd2V7vfPZ6XJDxqNr84QCqB97b76PKIJMaGa2vEVeKZqTKyxAHPmnW1SyaQ610NWN
	 NfzPdFSLhBrTg==
Message-ID: <73173356-6914-42d4-8020-ea2f32661393@sandeen.net>
Date: Wed, 24 Jul 2024 10:44:47 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
From: Eric Sandeen <sandeen@sandeen.net>
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <f7bbde19-80b8-4118-b8ab-654df9784e13@sandeen.net>
Content-Language: en-US
In-Reply-To: <f7bbde19-80b8-4118-b8ab-654df9784e13@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 10:41 AM, Eric Sandeen wrote:
> On 7/23/24 7:46 PM, Dave Chinner wrote:
>>> What about the log?  If sb_agblocks increases, that can cause
>>> transaction reservations to increase, which also increases the minimum
>>> log size.
>> Not caring, because the current default minimum of 64MB is big enough for
>> any physical filesystem size. Further, 64MB is big enough for decent
>> metadata performance even on large filesystem, so we really don't
>> need to touch the journal here.
> 
> Seems fair, but just to stir the pot, "growing the log" offline, when
> you've just added potentially gigabytes of free space to an AG, should
> be trivial, right?

Ugh I'm sorry, read to the end before responding, Eric.

(I had assumed that an expand operation would require a clean log, but I
suppose it doesn't have to.)

-Eric

