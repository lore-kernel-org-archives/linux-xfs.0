Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A5285C46
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928976; cv=none; b=iTYGolKsU+b8+lIal9xpdY9Vurv8cAao2hiXk3XqUoyggUbVd8+u5lZgtXOzq/T9MoiNnJVUCnX1GySOCIi8abEFBYbCz26DKPO5dxb3y7z311SKsUPYmiHqgYBrx/EyUmiEnCPNe7NrVpyDOjNsaIBGSWskvks3Rcr/y89kqbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928976; c=relaxed/simple;
	bh=M9lYBki/IV0sZsX52ToeFdx2lRQVsr9Bta3EhTE/0KE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqREBFnlJuRTrhf6fCpNZMEAyi2zrwbG7QYNLF9RwR8UC/mO4iPCq5IVJ57Kv6Fi3V/zD63L44eTcdFgtK649i186BHjtcdDOXnuCidEdaBJLwHUymRWjKWCYYRK4p/wegnurzW5JB4NdPEGlHI0B9Xdj0ZVLmsFZqk63OEQ/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1ChpOtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1ChpOtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B15C116B1;
	Wed, 24 Apr 2024 03:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928976;
	bh=M9lYBki/IV0sZsX52ToeFdx2lRQVsr9Bta3EhTE/0KE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1ChpOtN1UsucHCQhtJNzDAml4/wIPG+ve1UIV/FWedN/5wOQgbvikuu0UXrOzMtf
	 f6v1Vv+PZw5Z9r/ksX5FdXXNrbasdTSe6R31BJydvFcdPMe6anXpBuV43qEjINL/BB
	 rO8XVA1G3NWT5zguy4q8af3rRb3a4wx9GZ5w5Dq9XHSEqtZIz5JEYAkDZDp3muXmeP
	 a9ZmxFeYpEL3qf2RwtdTiLL18m+tln/UIRde3P7HglkX0z9uRFITfYoDqMexe+CBQv
	 /mgRkBrss2Ti7BXN2AElg96QQiy82iw4g/r2E1ai6U9Eqb3iB9Q8NMLRwh5vuzO+6Q
	 XA9kcNYgtqncQ==
Date: Tue, 23 Apr 2024 20:22:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <carlos@maiolino.me>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to d5d677df7
Message-ID: <20240424032255.GD360919@frogsfrogsfrogs>
References: <6edmi2wfmto4sbw4miohlhfvbiyhg5hdan52dk27canoug6425@6c4acq6bzngn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6edmi2wfmto4sbw4miohlhfvbiyhg5hdan52dk27canoug6425@6c4acq6bzngn>

On Tue, Apr 23, 2024 at 02:42:05PM +0000, Carlos Maiolino wrote:
> Hello.
> 
> The xfsprogs for-next branch, located at:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next
> 
> Has just been updated.
> 
> Patches often get missed, so if your outstanding patches are properly reviewed on
> the list and not included in this update, please let me know.
> 
> The new head of the for-next branch is commit:
> 
> d5d677df76af140532dc95f8fb133ba340ea64c8
> 
> 118 new commits:

<snip>

>       [164a5514c] xfs_repair: push inode buf and dinode pointers all the way to inode fork processing
>       [e88445180] xfs_repair: sync bulkload data structures with kernel newbt code
>       [b3bcb8f0a] xfs_repair: rebuild block mappings from rmapbt data

Heya, the first non-experimental user of the rmap btree data!

Thanks for merging this :)

--D
