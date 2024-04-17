Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E329C146D59
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367994; cv=none; b=IGMbgYdF8i2VaE5IUesdBwdqUiJebJ/aOMeiOlhY4uyzLdNkbDvc0uwtYOkvZq2mHKKNizD+5z3vtoIo0eDOLI9GJ+8BknrmEoguTvICLuye/29Uu1/+kwbIt+5kJiGws81cnp2oDq008GOdxwkLCRtbm9HjCN2HOGD+wIsb0EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367994; c=relaxed/simple;
	bh=8L8UD1WezWVddbuOG1zR2U8xrK48XakTgfFm9gSNfJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i34WyqUgZHR7WNjmmsvVzBO/UoFaoHXheMbTnKCerjxnjdHhiUf3MOFNjThpQnzt1crpcBa9mAa1ICpOhVxtGR8O3aNpMgsszqWil7fOph8FwPnKDtbaMgBXbp3VhBTZ7vZGMFUO7QKWLJhDuvizf6nOfCifLeIAbWTSjHPuIYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5T/uCg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5T/uCg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F9AC3277B;
	Wed, 17 Apr 2024 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367993;
	bh=8L8UD1WezWVddbuOG1zR2U8xrK48XakTgfFm9gSNfJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5T/uCg32e68k85MCOh3zni70sc1yyroL036ICuqh0lS18f/haeHYmPm0uC83hwAz
	 CxZElBJot2dc5BL1FB4+TrZggyqR1FrQlGh1BdF5JwKhXXa4QnM1Az67udHusRaYN1
	 1laLOMrh8Tomth8wOgPxezPatw9nFuSHMQwshHAPq50E2S5DG54L7nPNKq2rTco20b
	 q4QTnwg6P+s74JBjewBtYORAINHoe4M3FNqnjHCWUIPSCoSpIYuFRVq3AiV1yarO5+
	 a+iUJOQCxpLPpFDNnjXJIzuBEwYyw5GS0UXCOJfjRcRgBJc1YfjfJ/zgC5tTkK5gwo
	 /tl+FI/pj+q/w==
Date: Wed, 17 Apr 2024 17:33:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <lwzfrwkgjubhy7oetg4ecgzuch2rpk6xvmxaoadta67zkgt634@x5iho7wtgosi>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
 <20240417151834.GR11948@frogsfrogsfrogs>
 <q3_t-72x9zwHVZz9HCqmeGL16L4bea_YbMWpf0aWjLJR_9Kw5r2sTiWFaugZi3BPdXKVLuZglLofXUWSPyJ-uQ==@protonmail.internalid>
 <Zh_ok7hsmUTpiihC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh_ok7hsmUTpiihC@infradead.org>

On Wed, Apr 17, 2024 at 08:19:47AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 17, 2024 at 08:18:34AM -0700, Darrick J. Wong wrote:
> > > on the list and not included in this update, please let me know.
> >
> > Ah well, I was hoping to get
> > https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
> > and
> > https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
> > in for 6.7.
> 
> Shouldn't we have a 6.8 follow pretty quickly anyway?

That's my idea indeed, I'm almost finished with libxfs-sync and should submit it to the list soon.

I'm not planning to hold 6.8 for too long.

> 
> 
