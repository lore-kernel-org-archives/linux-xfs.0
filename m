Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98081C5D59;
	Thu, 10 Sep 2026 05:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019955; cv=none; b=ql9dJD679R3uc4I4IqvoijY59N7H2PmebOpe0D3d4UmSFHjY5MiTh6U4UkBfGohcR5a361c1+nusZ+PAZGWR96h1lvCxvkdAeUY14qiQe2jaTuyaLcMAXuz5/FkReXeVXKry4WTIfDjEwZaBUXMmvm6x1lUOWrK/ROKsiyfPkQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019955; c=relaxed/simple;
	bh=HsGeQsnE0WhB7nvxR0yzD68C1zchcH6sEfIbyCFsOKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=erGYbi2srZhVIHXXa3/Qzki+AAkcvqtTBzYciRAe8JoPYW+ihT8NqpS7EvAk2GtGeOSsDguz/0wHbGEvNxKar79fUauyBVjXNzO9jNAoGW4cdGWTvWhfwM3oUaspxuorosMky7TpYZQcVNUdZuF7WpsM/nt6fudFKU5u8uXtkYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8/0xDT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8/0xDT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667911F00898;
	Thu, 10 Sep 2026 05:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789019953;
	bh=xxxEPOu8evdLxv2GdwMSPNmrKmxMUp1ONnNuYZu8Yjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B8/0xDT90xBpzTPKfgrg2Lbc89F3rMu+/1zITVmVPNWp6OlTRc7NbyHlhONrO4psb
	 VRU4p9Iue7cO9FakD+3fGF5zK2K4UHRYsQqXOFdHt5R/0Ot99Dwggg7sTs4CcnZR0k
	 tg6J+iJcYp1Zd0RLtQWkB8f75YPMwzDUMpkVJHUgAxBfLQwvC9HTrQ35aXqYA8d/hP
	 VIudU61ueKxwnsQnzx+jX0oRq9i8zWTO24jdCkXGhWxhHzIy3lKguSzIJ8f6Cc3Afi
	 P5FM8CIEJtL31N7k8Jgh7bBSg0cyFbIYNYkrZj2oCRFClMF3ny05aOsdLv/B2+CD37
	 SLEIoZ/2osOWw==
Date: Thu, 10 Sep 2026 07:59:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: reset parent pointer args before each dir tree
 unlink repair
Message-ID: <aqJHKAfQTD9UKQKA@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936749.4057962.1251607208695971705.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936749.4057962.1251607208695971705.stgit@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 11:05:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xfs_parent_removename only partially initializes the
> passed-in parent pointer arguments object.  In the directory tree repair
> code, we could decide to remove multiple links to a file, so we don't
> want state from one call to bleed into the next one.  Zero the whole
> thing explicitly.
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/scrub/dirtree_repair.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
> index 8acd55b8c7696d..1d1eafcf6eb598 100644
> --- a/fs/xfs/scrub/dirtree_repair.c
> +++ b/fs/xfs/scrub/dirtree_repair.c
> @@ -479,6 +479,7 @@ xrep_dirtree_unlink(
>  	}
>  
>  	if (xfs_has_parent(sc->mp)) {
> +		memset(&dl->ppargs, 0, sizeof(dl->ppargs));
>  		error = xfs_parent_removename(sc->tp, &dl->ppargs, dp,
>  				&dl->xname, sc->ip);
>  		if (error)
> 
> 
