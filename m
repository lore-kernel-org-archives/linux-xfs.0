Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F512417DA
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738883242; cv=none; b=aOUElYxdXFYnIVjEQJHUxO+q24t6guycBSWpl0U59SptUd/SNL2gRxFZqgcJoOhgwSTl0M7yny/VwF4PaTvHMycfJJewiomWfSd5m08zS8RLSRqQNMYJtxwgB7a7bmRWfBCwoYFqS+vaVyoGS03e0X9hln9xB/IKPbHc9vllWU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738883242; c=relaxed/simple;
	bh=vSqNxEkl72TcZFt/HVNiphd57dV1hWqaqGY+PHNMnvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O84/1fB8s+uduWs6182bPrWjmLopDBVIBc/vTo2k+aph0L2MXJpqe6RsMvvMOu3XilVTdUd/HMDN/Cy+XYUITUCp4GAa3iFGKlH+d4Q3ARQQMKvcc5356Hmk0x3uA7M4eD/+eBzjPQW+zR+FLDbkH5KuZr1hFILA0oMMTvQXmM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEHo4sja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEHo4sja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3978FC4CEDD;
	Thu,  6 Feb 2025 23:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738883242;
	bh=vSqNxEkl72TcZFt/HVNiphd57dV1hWqaqGY+PHNMnvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qEHo4sjaMvZZTRC4fuodHMooNGDt8BK1RKdKdaCErxTB/mKoCxc5M6s7N/Ly8tfnT
	 6O/8aQpbDz2ubsmtETTCBQMqpkTOQmSOwJktXaP6Hi2IeB4bFTWxGBR+8VB2XEm2GR
	 9smLc8q06Dl5Bd+L5doZ+1/KGZgQGChpNmVOYpfgq2fGdmOFPG1N8LhWePThJ+9Q0o
	 0uKQNWShMpw6IbxZ3tmr7G3Ak0PD5yW6LOhp2OaV2V4NXrNK3OZwUHbLT+abjrgN8W
	 UTbI6KSf7DbCuvmCEEddlDRAp4EtxaIHqepOaXstQIuU1yOWoEtmuCNEWpOMtFK3ES
	 CRNYJUUKwox8Q==
Date: Thu, 6 Feb 2025 15:07:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: da.gomez@kernel.org, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <20250206230721.GC21808@frogsfrogsfrogs>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
 <Z6U8tAQ3AKMKIlWs@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6U8tAQ3AKMKIlWs@bombadil.infradead.org>

On Thu, Feb 06, 2025 at 02:50:28PM -0800, Luis Chamberlain wrote:
> On Thu, Feb 06, 2025 at 02:27:16PM -0800, Darrick J. Wong wrote:
> > Now you've decreased the default blocksize to 512 on sda, and md0 gets
> > an impossible 512k blocksize.  Also, disrupting the default 4k blocksize
> > will introduce portability problems with distros that aren't yet
> > shipping 6.12.
> 
> Our default should be 4k, and to address the later we should sanity
> check and user an upper limit of what XFS supports, 64k.

I don't think it's a good idea to boost the default fsblock size beyond
4k until we get further into the era where the major distros are
shipping 6.12 kernels.  I wouldn't want to deal with people accidentally
ending up with an 8k fsblock filesystem that they can't mount on fairly
new things like RHEL9/Debian12/etc.

--D

> Thoughts?
> 
>  Luis
> 
