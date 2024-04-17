Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1091487D1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367808; cv=none; b=VsAjeOuFrfpvZDC7rQ9o3c67f4SHw6uBeNrfOL3OJ+B0t3i2SjNMzXqYTNXmy40EOQ3EuAU6oRXS/smmE5C4lD9X8ujusoKvO95JCxpfZvQTECE0lFrh8bQIiDyKb+U1D6H658/gKXrLUnkI5W8OuFM5h+p4HKeKV5ybNp9AvLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367808; c=relaxed/simple;
	bh=Xu7xHAVk4kW4zdTRrYM/6MsQ5sdunfxLamunBrJ9NlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkuIj7ULH0939uwWa7jPkVxpyX8YfsZdh0rmG5Ibs2YTDwvQ/kS8/RZ5HeQ5K71uLMV1kRA/8uZUOzcYcbXeXTr9zeV8kmk1nZt5rOAGoXlSE60eX5nO2ZLeDfzQTUSleuvip6vqzUYdFN/HkSBEGcLqI6fc2ztibt9htx0sOEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGuMLeYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGuMLeYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468C5C32786;
	Wed, 17 Apr 2024 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367808;
	bh=Xu7xHAVk4kW4zdTRrYM/6MsQ5sdunfxLamunBrJ9NlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TGuMLeYJh//c+VaSqoYXbWb9gQ2wWHrwKyw5Ext928JMrS8RJdiDGYjzcviQwxw9U
	 iYZ4zHwK5kied99psYzWgDBhZtE7jdYLt6STBLyzGJuSoDhdSCVHfzfU/3UjdA+O47
	 zIgvkcoo+YzmlyFyj4Lk3V+5mrjvJolvQagV49Gzz3za2lwRuMCjkwieu6aeZY0QAm
	 iyVgl1+tvRzcRpQxUNbvNlQHohp0woG7iK6Mwg4HLcL0ZacCzqQGXT10YrHF9UsDSd
	 8JfYZl2ZNxVVNu+111lyHAvGdIYmsapKtRQjZ/jNM79DFg0TYBrpmXT3oob6GGeZHi
	 /P5g+fZAByKJw==
Date: Wed, 17 Apr 2024 08:30:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Bill O'Donnell <bodonnel@redhat.com>, Christoph Hellwig <hch@lst.de>,
	cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCHSET 1/4] xfsprogs: bug fixes for 6.8
Message-ID: <20240417153007.GY11948@frogsfrogsfrogs>
References: <20240416005120.GF11948@frogsfrogsfrogs>
 <xKvNEWiEWbanDpoNST0eV44uDLvsWDX_SkBPP3ZyelqJLqHGxCFtBonzokZzMuMUge-3CRvMu7D4c3K3gZbhnA==@protonmail.internalid>
 <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
 <ibxnfee3yfdmfthqqcpgm46373s3i57ktazwzrbbce7tjil7gn@6gx7guanmuyo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ibxnfee3yfdmfthqqcpgm46373s3i57ktazwzrbbce7tjil7gn@6gx7guanmuyo>

On Wed, Apr 17, 2024 at 09:34:41AM +0200, Carlos Maiolino wrote:
> On Mon, Apr 15, 2024 at 05:57:47PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Bug fixes for xfsprogs for 6.8.
> 
> Hey, do you plan to sent a PR for such patches or you want me to pick them up from the list?

I can send PRs.  Do you want them for just the bugfixes at the start of
my branch, or should I keep going through libxfs syncs all the way to
the end?

--D

> Carlos
> 
> > 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > This has been running on the djcloud for months with no problems.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-6.8-fixes
> > ---
> > Commits in this patchset:
> >  * xfs_repair: double-check with shortform attr verifiers
> >  * xfs_db: improve number extraction in getbitval
> >  * xfs_scrub: fix threadcount estimates for phase 6
> >  * xfs_scrub: don't fail while reporting media scan errors
> >  * xfs_io: add linux madvise advice codes
> > ---
> >  db/bit.c             |   37 ++++++++++--------------
> >  io/madvise.c         |   77 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  repair/attr_repair.c |   17 +++++++++++
> >  scrub/phase6.c       |   36 ++++++++++++++++++-----
> >  4 files changed, 137 insertions(+), 30 deletions(-)
> > 
> 
