Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8A631B130;
	Mon,  7 Sep 2026 06:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762056; cv=none; b=pk/ZnwMHUlcrQaHMncWPZv+un01VMqb0hqsZwwIuU5QQKh9StDd5zM9HMsEtET5GeLFcAca7aVixQXUNEYAthlpv9TSVFMN71v7+BpRCtM9B7X8UP5ojH33q4pBNin6ecOKVsfG3eM7qKAmRL9DM8KfhpuqobwJActYoelP5Uqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762056; c=relaxed/simple;
	bh=i6+mpM4owi+29gk1kIQ5HTyYRPZ4PksFMJ3RR0VNUUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpS8rsLN3HWyxHmuKWOL9J1Es5PJR7U7QEied+FxVzMMDitAEjV6aUhKE3LWX29ii18pguM/dXMBsRVtyL39JlOWsGDg5z7aL2Fisa4TsJjBfhKaxh0bCxZhkAxMQUwVuStWPOIw+BQnbhDeGi3D68fqFGtGOL06jpPlRcEa2p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMsNhEJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMsNhEJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8005F1F00A3A;
	Mon,  7 Sep 2026 06:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762055;
	bh=xd5HV3wl6bRzHnyj2mKsQec8j5JuGLkFYiEuytv14CA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fMsNhEJyXDXWG2OT8FOABfn5iMZD4tLwhW6NpszhwnEjkXqnYhA6fZerjVOjbBomj
	 6rhHFWJbOLfeVDgmA9lnlQx30GH2Q/oZoVaIArR5hqW7u01duJZ27AkiaM21ZfaKqk
	 z5hqtr1MCQnBZLGJhmsOZKS8P7743fCUIoSHmZQbKMF/mguXqmEhC2kh+dJs0ElfFn
	 judMJJF6EbMtT2t+nfmayu/w7KhygLIImY85yBMfYIiLr5YmcRXDiDNcJNQvb5zz4j
	 cwCB6g8fXFsaKOGS+Flj2TV0dlpP0wh6SAPqYxdwuRM48GY7nVx+AYJ9BhkjOBkD5u
	 ctM4vEnt8oMmQ==
Date: Mon, 7 Sep 2026 08:20:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix repeated words in comments
Message-ID: <ap5XvVR9nbI1vaRC@andromeda.toxiclabs.cc>
References: <20260904112909.8197-3-hemanth.selam@gmail.com>
 <20260907042402.12893-3-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907042402.12893-3-hemanth.selam@gmail.com>

On Mon, Sep 07, 2026 at 09:53:59AM +0530, Hemanth Selam wrote:
> Please drop this patch, one of its hunks is wrong.
> 
>   fs/xfs/xfs_zone_alloc.c
>     "Stash our zone in the inode so that is is reused for future
>      allocations."
> 
> This is not a doubled "is"; it is "it is" misspelt.  My change leaves
> "so that is reused", which has no subject.  The correct fix would be
> 
>     "so that it is reused for future allocations"
> 
> Carlos, you also asked me to fold the two patches together and drop the
> mechanical wording from the changelog - I will do that in v2 and include
> this correction, unless you would rather not see the series again.
> 

Sounds good to me
