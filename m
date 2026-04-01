Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A55175A79;
	Wed,  1 Apr 2026 21:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775078344; cv=none; b=o9y4uugMKHGO4xCvNzmTz2BWoPHVg3hWgaT3I0IqKWZYpN4BVGVPviNPvf0nM4ocX42u1f64A7B82CGaNMsaYK74Z6Axn7qJFIBYmCAkf61pXvNMZIC2ujwZDC/jGMcOcnxwrv6YNVX9aE4rNEgKwOh2xz1+ZBfARX76qlzq2q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775078344; c=relaxed/simple;
	bh=ZUftJy/Eg2vooutQH6w/+XirdMYySx6JVlXp754Vgdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5zhdi62WO3MjJvhmedDJg6252op22AGTnw8XdIM0UmPqOYWinnxOk6Q3T5S5+2QnatnUouJcdAzq7LPYYiKd31s1ruI3ISfLhnWs/A1Jp8U+NuAUOvtuRJXQlU+Ikd2Rq5KXfV5m7vGHnI1sPRe883kTvu4z7GMd/SU7jbYf4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jD3Jb1ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jD3Jb1ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E56C4CEF7;
	Wed,  1 Apr 2026 21:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775078343;
	bh=ZUftJy/Eg2vooutQH6w/+XirdMYySx6JVlXp754Vgdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jD3Jb1tyAXHJ7rlEQVgRfpLV2q36bVM+ZajV5KTZtkYLuqlKdfLGdjCpcy0YnRnbi
	 LoLgBIqHi+42FatuccDnBFDivdoaKpF07bf+PUeofoud0KB0kILvHTwfnNr+wV1Aa6
	 ojA8OH7ghnBr07KKD5W+MJmxN0ig7il2HpVBOqc3Si1yz5HvBAiqiaYP7rfDfiQXz5
	 gvCbKx8DnrxuEsyb7EO6QrlJeDeTqifD0tfUem+skhvVcglnV+FvF/Xw4hsMFllqjZ
	 y+d3meadPcE1/VqbKbjkdKbo9sj1+GwnPXFD2uG1NnYG5a8cUTLgXieYD+hkSeKO8n
	 ECkQRhTDfjUOA==
Date: Wed, 1 Apr 2026 14:19:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 01/22] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <20260401211901.GF2466@quark>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-2-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:02PM +0200, Andrey Albershteyn wrote:
> Reported verification errors to fsnotify through recently added fserror
> interface.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/verity/verify.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Eric Biggers <ebiggers@kernel.org>

>  		if (memchr_inv(dblock->data, 0, params->block_size)) {
> +			fserror_report_data_lost(inode, data_pos,
> +						 params->block_size, GFP_NOFS);
>  			fsverity_err(inode,
>  				     "FILE CORRUPTED!  Data past EOF is not zeroed");
>  			return false;
> @@ -312,6 +315,7 @@ static bool verify_data_block(struct fsverity_info *vi,
>  		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
>  		params->hash_alg->name, hsize,
>  		level == 0 ? dblock->real_hash : real_hash);
> +	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);

The first case does the fserror call first and the log message second,
and the second case does them in the opposite order.  I don't think it
matters what the order is, but they should be consistent.

- Eric
