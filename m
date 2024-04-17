Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B356E616
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 07:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713339287; cv=none; b=JaWxXFyXe8W7fLsc1Yuf6/HVx+8n17MYIXQD9cSJWgWB7zRRxrnLP8PfjggUqoP8eeD2BUVgUSqTSOu2kStgRbRwmomWLVHnm1hzvywNezSwzefOuL/kDSPF8cFOS0fumahmOn7eTEYEy3eiqrEEjc/Svj7OkR9YFmsxZzcQ5G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713339287; c=relaxed/simple;
	bh=H8D9bp7vCCWtIenrzvMMzmx19wsbEeNH9uPYZS4l6EM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aM0KyneF6J0kbr350tR9ug2MC19xkRcI8jTdD/cMzxgsDHJQXjrPqKlUmwTRzLYGadlN4p+fdAIw83ZYzH2Ak4tnDrlyzNACbkAfbMaXBxUKIfcASJmlQfQT2ELJ+94/9HfE1f+g8FJDgYR7z0ou33M2linXHhgp7GPCBVDSGlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0LCC/Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0LCC/Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A86C2BD11;
	Wed, 17 Apr 2024 07:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713339286;
	bh=H8D9bp7vCCWtIenrzvMMzmx19wsbEeNH9uPYZS4l6EM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q0LCC/UbhbqHP9gheBB2ZewgWmKZsjhNz15uKFSzR+WFSzYguS0pcNhnDhtS3prQe
	 RZT24L2HRYe5K4Iiu4K4SyNFyxJUzSm7Zgiu79KvjpTnXxUaShzDLZdb1a6C9/yb6/
	 mMLKLsG2k8lUNScSZl2SbWnX2sRTisiVhrfPL6ceM4rmYyHmCj8EQIfCvABd9KU+qP
	 ZqQZWlqc6rrG5675H7ZDCR6YP+FYoVDWmj8x62bJflZwFz4HCmK0vQGJ2LvbSuNI/x
	 fncjNz9xGU16nW6a+LNYsDE/bt4eqHP24ZHMl8BmV/6aeVS5L6ceM+ExFtqie/OAww
	 vIF137Y7Kwpzg==
Date: Wed, 17 Apr 2024 09:34:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Bill O'Donnell <bodonnel@redhat.com>, Christoph Hellwig <hch@lst.de>, 
	cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCHSET 1/4] xfsprogs: bug fixes for 6.8
Message-ID: <ibxnfee3yfdmfthqqcpgm46373s3i57ktazwzrbbce7tjil7gn@6gx7guanmuyo>
References: <20240416005120.GF11948@frogsfrogsfrogs>
 <xKvNEWiEWbanDpoNST0eV44uDLvsWDX_SkBPP3ZyelqJLqHGxCFtBonzokZzMuMUge-3CRvMu7D4c3K3gZbhnA==@protonmail.internalid>
 <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>

On Mon, Apr 15, 2024 at 05:57:47PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Bug fixes for xfsprogs for 6.8.

Hey, do you plan to sent a PR for such patches or you want me to pick them up from the list?

Carlos

> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-6.8-fixes
> ---
> Commits in this patchset:
>  * xfs_repair: double-check with shortform attr verifiers
>  * xfs_db: improve number extraction in getbitval
>  * xfs_scrub: fix threadcount estimates for phase 6
>  * xfs_scrub: don't fail while reporting media scan errors
>  * xfs_io: add linux madvise advice codes
> ---
>  db/bit.c             |   37 ++++++++++--------------
>  io/madvise.c         |   77 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  repair/attr_repair.c |   17 +++++++++++
>  scrub/phase6.c       |   36 ++++++++++++++++++-----
>  4 files changed, 137 insertions(+), 30 deletions(-)
> 
