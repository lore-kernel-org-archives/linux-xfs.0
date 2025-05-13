Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D752BF96B
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747162256; cv=none; b=TF4VCTP/OOuiO3jYdayulZlAQbQLrSacHl8FWuwmH7DUdfTftf7LlnJ1ADhLFEMnrE6tHu4SB7TuL3zbdi96zGeYQ1UW0ZI8iATdXjBe9GwVhLwNogcBPoxq73Z1SBDa7upCQgTYn0bQ+ty/MDNbGQfoOT4385+iVVibeHpxWi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747162256; c=relaxed/simple;
	bh=HvPqrC1DHxS5/bJOHcE1jwzcAkMbES86sfu9SdJwLxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDb58oCSQ1+rJ3vVNvtUSqpdh2LFV80aGfror23mHmXDbiz+yyRpMRv+T46fAJqD2O5/7TZVvK5oc0LMdnw7YN8oMKYxcOZHOROTAbXqiAMsehl20P576as2pu1YfoKn1wZGKyjCWUqj+3C6IQhbmKMBc+2hcaYsbkR805L4XUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7otX9U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7otX9U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29964C4CEE4;
	Tue, 13 May 2025 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747162256;
	bh=HvPqrC1DHxS5/bJOHcE1jwzcAkMbES86sfu9SdJwLxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b7otX9U8KXunauw2biI1e6d7vnXqpO7lPdYNmg9v3iIUtY6c/oFLHSQwwpWH8Lfpa
	 Ghjf42WzBN7ToEdQWYaohPW0NoJfi6kSpJg1n4m62yE8KaEs/M1d7FiYo5eracOMpI
	 K265R2ukIGQRtpwvV92FzCh9bpluqLQYyxQMetXAObuvj4NSfjWBt+paIPFw0TN8K9
	 ZE9Q9hTjsSfGS0rE+dC2dkYn4gdVH1g1/8Po3dFhfHil/mWdf1flwwWNhcC5/TO2RK
	 GUxn33uptsLE/I/hrTsh3t7VFE57EQF2jt23PfVhZyRy+bPgakUcHAHaghxmZTcoJH
	 OHuTYtheZtzwg==
Date: Tue, 13 May 2025 11:50:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <20250513185055.GH25700@frogsfrogsfrogs>
References: <20250510155301.GC2701446@frogsfrogsfrogs>
 <174715788805.709704.13710865404538859491.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174715788805.709704.13710865404538859491.b4-ty@kernel.org>

On Tue, May 13, 2025 at 07:38:08PM +0200, Carlos Maiolino wrote:
> On Sat, 10 May 2025 08:53:01 -0700, Darrick J. Wong wrote:
> > Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> > syscall and parent pointers were merged in the same cycle.  None of
> > these have encountered any serious errors in the year that they've been
> > in the kernel (or the many many years they've been under development) so
> > let's drop the shouty warnings.
> > 
> > 
> > [...]
> 
> Applied to for-next, thanks!
> 
> [1/1] xfs: remove some EXPERIMENTAL warnings
>       (no commit info)

Er... there's a V2 out with slightly more aggressive cleanups of
now-defunct OPSTATE bits.

--D

> Best regards,
> -- 
> Carlos Maiolino <cem@kernel.org>
> 
