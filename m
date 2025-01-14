Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2376B23242C
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 15:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736870022; cv=none; b=UndhIqMvCzD1NXei6BPOyhGyGFIMYkOrbozYMZSSRpaifa1rQ4sReD2l2IESiepknO1mvLMtAmPQ+ndtPeLgeci1D8hp9AQfZddbEubqRtnqEz2MMS6BQ2XmlqcTusLvyCy+ZBrNL+PB01UIHICPkJkz9s6BkPjKAQUsheTer7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736870022; c=relaxed/simple;
	bh=DTVNRchXJo7k78IThZM3H70cX8w9HwgQuQlTWhW13WY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XDwh1ms8K30OZvsgdgaAIdbVNCQL2Un8SV0u6iJg8ZNMbHAiCHsO4BeYLC0Uec/KU5R06t/isVQBCRua+/LBn6TEwa7RmqcAbaMebZssEjlMAM/hvH4hrMjgsAHN34u6EaVC+RpPtOCbg75+k2tGZD4zxiGAf1t4CwFdulPQHjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FifQnXY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FifQnXY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC1EC4CEDD;
	Tue, 14 Jan 2025 15:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736870021;
	bh=DTVNRchXJo7k78IThZM3H70cX8w9HwgQuQlTWhW13WY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FifQnXY1uN3v/l9T59bLkBQz1nsG7xmrefIRz1D/x3D0v10jkMcWeOK3XqZDF8Z63
	 p3gMvinROOAvveMThRfbE0ijDoJaux+hHRmfaCQYrTrHgYo+/z4jMxNryjG4uzo4h9
	 LUCkdmiYp/on4QwQLPF0c/K/2QZ+kSQkbYsSVfsZ1q/I2gHxSs4/N+gsjxHwdyrjSH
	 1xCPQtS6JKSJURiIWRNu7+yttO7B/3iscnK3a2RZEC+F2wOmbEQSQsEBIoskdXJPrc
	 WWGJgGmFoYTQ8f1Rt1E7m4TJW61ZCEQmpNbHGqDoWiTHOQnC0WDMachTl0ubr1fgWL
	 oLqhD/ngkJvzQ==
Date: Tue, 14 Jan 2025 07:53:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: lock dquot buffer before detaching dquot from
 b_li_list
Message-ID: <20250114155340.GI1306365@frogsfrogsfrogs>
References: <20250109005402.GH1387004@frogsfrogsfrogs>
 <173677158754.21511.9707589214851624907.b4-ty@kernel.org>
 <20250113162134.GD1306365@frogsfrogsfrogs>
 <bolbaetzmiqadzz4jdnz3xbugwyqnqmrskpicbvbs5ltrmfr5f@e7vvfbdb3shf>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bolbaetzmiqadzz4jdnz3xbugwyqnqmrskpicbvbs5ltrmfr5f@e7vvfbdb3shf>

On Tue, Jan 14, 2025 at 11:45:48AM +0100, Carlos Maiolino wrote:
> On Mon, Jan 13, 2025 at 08:21:34AM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 13, 2025 at 01:33:07PM +0100, Carlos Maiolino wrote:
> > > On Wed, 08 Jan 2025 16:54:02 -0800, Darrick J. Wong wrote:
> > > > We have to lock the buffer before we can delete the dquot log item from
> > > > the buffer's log item list.
> > > > 
> > > > 
> > > 
> > > Applied to next-rc, thanks!
> > > 
> > > [1/1] xfs: lock dquot buffer before detaching dquot from b_li_list
> > >       commit: 4e7dfb45fe08b2b54d7fe2499fab0eeaa42004ad
> > 
> > Um... you already pushed this to Linus, why is it queued again?
> > (albeit with the same commit id so I don't think it matters)
> 
> I rushed to push this patch to -rc7 so I didn't end up sending a TY message to
> it. It was still on my b4 stack when I sent the last TY batch.
> 
> Which reminds me I should update the message, as the TY is going after I push to
> for-next, no to next-rc :).

Ah, ok.  Carry on! :)

--D

> 
> > 
> > --D
> > 
> > > Best regards,
> > > -- 
> > > Carlos Maiolino <cem@kernel.org>
> > > 
> > > 
> > 
> 
