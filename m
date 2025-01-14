Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9558D22961D
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736851552; cv=none; b=E5Yl9ZH/WfNWuVCviYgTPfuAi4345KMSKEQZLngVedqHoYCAozM5+wACSUzAMyAITk09jdVuVxNQf5a/8XxhJFdIawS+6Fvrp99KgPYwOZZ7TICosUAWj+oUZQ+Q4m/NWNegwisH3z84c69pRTfA5ajTBwLmATf7n/gYMMaraqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736851552; c=relaxed/simple;
	bh=dYsP0sVZWPBekkMGDIXlyZi+TLFVuXD+v/qKh6I6NG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R7Nq96y5/NIQ3ovJENgXC+StwR5va5sdTszb2KrBiiLWSPHF9yEpK2k/1n6+7gfXzzupZ+JZwjyk5mmD2Jw2F36i4E6GVn6Hk0BKVKYUEZ3LoqhKNlLgNuafkhAa16LTAU+52eOntVepm+ZFXZTxJi5g48oAUA3/SkqXwk6t0jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twQv5+Pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twQv5+Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418EBC4CEDD;
	Tue, 14 Jan 2025 10:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736851552;
	bh=dYsP0sVZWPBekkMGDIXlyZi+TLFVuXD+v/qKh6I6NG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=twQv5+PelHi5qno8J5iACvKdZbw0+M2LnEhSklqqpBdEJ0/tlcy4uI7Puwiw5uUjv
	 JcpI2BgeJZ7OY/OZlopGJrDSmqNtUIwrO0lvSNnv5pKRFIvOdZO8hKv04TyUfguUuO
	 wq6kI63kmEBQd7Gerylfx7AcDAsvy08KsP9xCBYx6nkBcqlPzf9jmOGMe8v4eD4Y3F
	 RXzLvOCPM5aCvx0lsxIZJnMR0qywOo+HwylROEIl/7pUeaoZXdC9BhhKEjX3RlCoGp
	 lbhx7jUYCCZaL2QSPZPvGT7PlIh2NBCxXEfRWu1NOXM4KwfLc6UC1cephP7eX+j2ix
	 3ddkHeG+tH+gQ==
Date: Tue, 14 Jan 2025 11:45:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: lock dquot buffer before detaching dquot from
 b_li_list
Message-ID: <bolbaetzmiqadzz4jdnz3xbugwyqnqmrskpicbvbs5ltrmfr5f@e7vvfbdb3shf>
References: <20250109005402.GH1387004@frogsfrogsfrogs>
 <173677158754.21511.9707589214851624907.b4-ty@kernel.org>
 <20250113162134.GD1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113162134.GD1306365@frogsfrogsfrogs>

On Mon, Jan 13, 2025 at 08:21:34AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 13, 2025 at 01:33:07PM +0100, Carlos Maiolino wrote:
> > On Wed, 08 Jan 2025 16:54:02 -0800, Darrick J. Wong wrote:
> > > We have to lock the buffer before we can delete the dquot log item from
> > > the buffer's log item list.
> > > 
> > > 
> > 
> > Applied to next-rc, thanks!
> > 
> > [1/1] xfs: lock dquot buffer before detaching dquot from b_li_list
> >       commit: 4e7dfb45fe08b2b54d7fe2499fab0eeaa42004ad
> 
> Um... you already pushed this to Linus, why is it queued again?
> (albeit with the same commit id so I don't think it matters)

I rushed to push this patch to -rc7 so I didn't end up sending a TY message to
it. It was still on my b4 stack when I sent the last TY batch.

Which reminds me I should update the message, as the TY is going after I push to
for-next, no to next-rc :).


> 
> --D
> 
> > Best regards,
> > -- 
> > Carlos Maiolino <cem@kernel.org>
> > 
> > 
> 
