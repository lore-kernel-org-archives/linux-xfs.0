Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A711C3BFC
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774877033; cv=none; b=pba6EcvzfQqo+hkWSb2UcHRffPKkp5D3wGkJNyqRR2qt2ZvZSgvBxHoQ2t55ESC69WvYCIvVYvHnx3Xr4cvAfjTM7pDkWo1AJdqTWOzLNzA9GYh7SyiNeH0RPkAb5Lfxl5hSWrvqtvW8V7bm+uCQgUZ5Sq+GhoBjr94qUoertiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774877033; c=relaxed/simple;
	bh=ywjJHB5kN7zGvQ5XMGvxHUiJ0ERemeVRHZPGR8lM1Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXd/Y3p/zUewVSGPqFq7d39tgYXf6gMZYyOfOVXy+7atfnFd4/ri3/lXMNY7m7CRMa8sfEbOHuBxnLKXcffzIOtuddPHcA/8uBFCEgDtwLB+2EzS6/Y1d+L7bHuDSeA3J4izkJvBUJh8GG3oTRH9FZPTdaVpMbnjjkkMPl78XMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQkV+jx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQkV+jx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C104C4CEF7;
	Mon, 30 Mar 2026 13:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774877033;
	bh=ywjJHB5kN7zGvQ5XMGvxHUiJ0ERemeVRHZPGR8lM1Xk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VQkV+jx9lt5wHFeaSQLxTcuKoOMLcDtYanwQ1As5pODKZBcXwxrN1T4nTqJVRD7g+
	 ppnYDjWDgkjQgqwvrQLBSgE+yMUvStf5CmukyahJ29qe5crhug//kB4AErkSLKrkgP
	 CoPw9H+Hcy9VT8dj4kyg34inIh269pAVs4+4xMfE9RTiLdoxtcFYG7oL4tiolWPsoT
	 Fyz2S3z8LJPszqW+HxJkMnDgpjfTfaxs063lPzKNYKVYUo243UOuLxx28idZoJCRgX
	 KfNS3wogUZH1NaraE/Rlq90gV3rCGBt9xTJJk11rsVCyrfiGVVzrTNVs11TOSdyUla
	 4thul6wAkhiYA==
Date: Mon, 30 Mar 2026 15:23:49 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
Message-ID: <acp5WG3FyZoe-gDG@nidhogg.toxiclabs.cc>
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-5-hch@lst.de>
 <20260330054732.GA5079@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054732.GA5079@lst.de>

On Mon, Mar 30, 2026 at 07:47:32AM +0200, Christoph Hellwig wrote:
> Note that this patch actually requires the "cleanup open GC zone handling"
> series.  I had the two the other way around in my local tree, but decided
> to send the series with the fix out first after a trivial rebase worked
> fine, which obviously wasn't a good enough test.  Sorry.

No bid deal. Thanks for letting me know.
