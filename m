Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7061EEA23;
	Tue, 22 Apr 2025 07:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745308607; cv=none; b=M8qpaFCY5sQhFAuHoEF+bsdHPo0FnFp9o2kJeDR+DwXz6XDqgUEDgfJ7Jt+zX3yEBIuCnw6vM6YU5bnQAY46AfP8cisj2qLCwZgAdNZAe7UEMXIA0286goRbj797pQ6Sv1EuP2M0evAvuRfu37TAn8dYe++IbeVsvyrsdIBrtmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745308607; c=relaxed/simple;
	bh=Pj90EHE8r9vgVEqDG290oU8FvMy6AVbQAG7udI5RJeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7sY7acbKI2m2vz90i53IW8hdXV6gyNYdGzBKXOHbOdfnsf26zh6W7chmoqAUSINV3zQY3H4Msnn7XtrUsls1AO0sSwasVrzAKXqPtuMHH51riufA5h1FgDdJdiqFDiSRNeWbyAWeo5kbf+xjSYncXJYq9LBon/0JAc7fkz4/IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COF1Kiw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COF1Kiw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5120FC4CEE9;
	Tue, 22 Apr 2025 07:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745308607;
	bh=Pj90EHE8r9vgVEqDG290oU8FvMy6AVbQAG7udI5RJeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=COF1Kiw9v29UxuqZYFgaPhIYyS/fiMcJf+k1pwKcTITYX8+NYXZFMHQqg+ftINnfb
	 BrkP1Ym+S/8XoY9Xi8HkwI1yMFUriKqOyecBLrWgX5Me4NmST4QJjiHW2p6IFy6uWK
	 b4ejiGPAeXbas/4orgxcwVbZoMpi/ui+BRPABOr/LoZIFwxng8YwYY/zsQQgmJ6eDE
	 9+LuhsjH4lluFZMqD0/HW5hL2YRQ8hAgBfqddgPUq9DgZfa1sX1CzH+SdrbkUrI+O2
	 ShWCDmk4+wElE/qb69CzoSeWnga6s6mh64VVpRc257+2QoAFYF51ORwdptJEShvDlh
	 hFdRdHuRjcTpQ==
Date: Tue, 22 Apr 2025 09:56:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: hch <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>, 
	Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Message-ID: <5on3efybz6wr35szabvvglypmyip6nocviftpr5bke3vuvth74@rso4ha4e263o>
References: <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
 <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
 <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
 <20250421083128.GA20490@lst.de>
 <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net>
 <20250422054851.GA29297@lst.de>
 <c575ab39-f118-4459-aaea-6d3c213819cb@roeck-us.net>
 <20250422060137.GA29668@lst.de>
 <ZAeaFwRAEUsKK0hGhDYwUXtlJlY7PfLM_VWVNpab3-t5iZRi0RBfhND7vC1DwgrzRXnvTwelETC2Vl635O8MjA==@protonmail.internalid>
 <9a3cd21b-5b51-4aae-9f04-2a63f3cc68d7@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a3cd21b-5b51-4aae-9f04-2a63f3cc68d7@roeck-us.net>

On Mon, Apr 21, 2025 at 11:22:47PM -0700, Guenter Roeck wrote:
> On 4/21/25 23:01, hch wrote:
> > On Mon, Apr 21, 2025 at 10:57:31PM -0700, Guenter Roeck wrote:
> >>> free should be floored to zero, i.e.
> >>>
> >>> 	free = min(0, xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS));
> >>>
> >>
> >> Do you mean max, maybe ?
> >
> > Yes, sorry.
> >
> > Also if you want the work taken off your hands I can prepare a patch
> > as well, I just don't want to do that without approval from the
> > original author.
> 
> I didn't actually plan to write a patch myself. I thought that either
> Hans or Carlos would do that. Sorry if my replies caused a misunderstanding.

I can do that, don't worry then. I'll craft something around this week.


> 
> Guenter
> 
> 
