Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B007C1D559
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711473774; cv=none; b=Sm3SMv99LOGzAiBVNlMDIXZcuEv5UTTPFfW2c9gKoQq6Opq/ahB8ixfZpkes5FlQcLtqpr3w2Xjh3YgwK7ShHuGHqFRA4qTTDtxDgsrYR6GTccV7Chw8Y1+peA47bSZ37b/yDXS+NjNI3/W4KdLaPKTWP8QMu00+XmxrPF2OIIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711473774; c=relaxed/simple;
	bh=7vmG7Eqx3qEr0Wd9M2YjMLgyZryrGy2K0AMBp+MkeUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fT2s1NCAZ9CesGcKSin9L7F1w9WeoxxbJiDB5gPv0PSB7eBsiTXun0baPFDoek1aGFZZfRLHp7+unJO6tkJRg5Lw9v46sBmyTOk2JWEUKwVii1ab5E6oNLsDcDwKsZ1JXOE+RSenzn4vpJNa6AzmBvfTfEv+DYruM3vGf87iIgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqwFef9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqwFef9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34447C433F1;
	Tue, 26 Mar 2024 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711473774;
	bh=7vmG7Eqx3qEr0Wd9M2YjMLgyZryrGy2K0AMBp+MkeUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lqwFef9JvFFHCp92zrd4t4pKZ3OAfxp2f9eq98ob3wWh1OcBaB6E43/rtyz5RC5MK
	 1h/jZt0QEbxsricKDXQhM7g1wi/8Zk21qSs5zeGjnbndgxNCvtZWib4SnAkNYaocgU
	 orzZ4/cK2STrmpSfrB0EINwjs7FHbJOJaZ9szmXnDF5lRmxFsvymKNqbrHVCfr/ygN
	 /707hmIIrWEIMP8keFDF2VW8hYqk7Zroodf6ZUW9IzvsGvK5afnFXWkaw7K2/XhZIo
	 Rj8TL//yIyV3uKcf1iMYFpO78EGFct1OWKTh3zH4wLbOMAIIMvPctl4GGt5Gaus2pH
	 dvep/obECoOLw==
Date: Tue, 26 Mar 2024 10:22:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: define an in-memory btree for storing
 refcount bag info
Message-ID: <20240326172253.GR6390@frogsfrogsfrogs>
References: <171142135076.2220204.9878243275175160383.stgit@frogsfrogsfrogs>
 <171142135095.2220204.16042670537695757647.stgit@frogsfrogsfrogs>
 <ZgJj5Y2ORvXhKSXR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJj5Y2ORvXhKSXR@infradead.org>

On Mon, Mar 25, 2024 at 10:57:57PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 25, 2024 at 09:01:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new in-memory btree type so that we can store refcount bag info
> > in a much more memory-efficient format.
> 
> There's probably a reason to not just shared this directly with the
> kernel?

Add to the commit message:

"The xfs_repair rcbag btree stores inode numbers (unlike the kernel
rcbag btree) because xfs_repair needs to compute the bitmap of inodes
that must have the reflink iflag set."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
