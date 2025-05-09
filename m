Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C168F64
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 07:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746775294; cv=none; b=d3nWj4LWWYL7jzXq6GXj0Wd6CpTN4Kr1EO4u4VzISbW2QrZYGGkhByA2vRX/jcrrI9gljEo/OPoWnW99gHiFGrwY7nFn3gu4M4hBA7ZxCD35pP0ne5cT9R0c42KSkBdOoWm0PPDmhFRLq8LE4gWfXW6nmwUEZ3ieOJvYjGvP7z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746775294; c=relaxed/simple;
	bh=KxIuv51HK8xXWjtbBmiB+EHnXDTMA/oSouWV1d5vzrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVhlOPqX/wYbgBlec+JsnCx04Xvw5dV4rWe30QfPpVM/VUv6pbGW+AmJLNQiJ+05t1uT2ma/jGNX02dM8yMCbR4Bn6meHkU0COZsUspepKAqjEkJNY2ObKhGisKXTxSc551T8ONTs9lly+Xyd482VHpTrfu5RpRy+IU6gAHbcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsgVqbe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsgVqbe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1B4C4CEE4;
	Fri,  9 May 2025 07:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746775293;
	bh=KxIuv51HK8xXWjtbBmiB+EHnXDTMA/oSouWV1d5vzrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsgVqbe40qPYiGQeEMUsdIxjwLCRHZRox5wjauh2H2omgpQTE1MihK2Ozob+NBj/3
	 oHVNiDU2xaqxgMMLproIv+oKpNdMGjDH/7Gz1aMO9Jkn83+UY/L8Zks0PiZBvVZxES
	 FMZfpZpfBlg9PhpyaMHk3BsWibuh8ZxrNNoJolYB5RYFODjBQn00pF42Ok/MB2FF7+
	 DbAe4Iyw0fkG+Qryk/JqnvBV9wKN+S/n76iICIJnvbC6fL0k6CmD1k5I3ZTPxzv99I
	 YyjD0BXbHbcG2ef9YRYaR756bWxv8oN/nuTkIFjyg+vE5t7sGDUqP0aviiABCHvpEc
	 TZp6S6+QDDakA==
Date: Fri, 9 May 2025 09:21:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] large atomic writes for xfs
Message-ID: <ym445g3xokwz24svruqtbqf5k6niqc3vamcidzmm64wm2uuo2c@voumg6yonqad>
References: <Na27AkD0pwxtDXufbKHmtlQIDLpo1dVCpyqoca91pszUTNuR1GqASOvLkmMZysL1IsA7vt-xoCFsf50SlGYzGg==@protonmail.internalid>
 <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
 <cxcr4rodmdf3m7whanyqp73eflnc5i2s5jbknbdicq7x2vjlz3@m3ya63yenfzm>
 <431a837e-b8e2-4901-96e7-9173ce9e58a3@oracle.com>
 <jJwn3DRa-8XQPRv2vekPbys38m6rn6xH8BkmCT2ytu3xReNcMTq5d5tLb21DygEXpUS0pIVnrzvMBVBbO8Rn3w==@protonmail.internalid>
 <20250507213047.GK25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507213047.GK25675@frogsfrogsfrogs>

On Wed, May 07, 2025 at 02:30:47PM -0700, Darrick J. Wong wrote:
> On Wed, May 07, 2025 at 01:23:51PM +0100, John Garry wrote:
> > On 07/05/2025 13:14, Carlos Maiolino wrote:
> > > On Wed, May 07, 2025 at 01:00:00PM +0100, John Garry wrote:
> > > > Hi Carlos,
> > > >
> > > > Please pull the large atomic writes series for xfs.
> > > >
> > > > The following changes since commit bfecc4091e07a47696ac922783216d9e9ea46c97:
> > > >
> > > >      xfs: allow ro mounts if rtdev or logdev are read-only (2025-04-30
> > > > 20:53:52 +0200)
> > > >
> > > > are available in the Git repository at:
> > > >
> > > >      https://urldefense.com/v3/__https://github.com/johnpgarry/
> > > > linux.git__;!!ACWV5N9M2RV99hQ!
> > > > IVDUFMxfAfmMgnyhV150ZyTdmIuE2vm93RuY0_z92SeHSsReFAeP5gbh3DA-
> > > > iow80_ciEVx3MhZ7gA$  tags/large-atomic-writes-xfs
> > > >
> > > > for you to fetch changes up to 2c465e8bf4fd45e913a51506d58bd8906e5de0ca:
> > > The last commit has no Reviews into it.
> >
> > I'll add it.
> 
> Not sure why John wants me to create a PR, but I'll do that, and with
> the two RVB tags received since V12 was posted.

I think it all boils down for what I spoke with John off-list. John would need
to send a PR from outside kernel.org, and while I don't think this is a big
deal, he also doesn't have a key signed by anybody on kernel.org. This would
essentially break the chain-of-trust if I'd go and pull his PR directly from
his repository with his current key.

So the possible solutions would be for him to send the final series to the list,
and/or a PR from you, until we get John's a signed key.

Carlos
