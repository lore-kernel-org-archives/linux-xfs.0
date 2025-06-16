Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16D9224228;
	Mon, 16 Jun 2025 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750061499; cv=none; b=UGxE0FQMipn4JgFTU1WuZ7JO83qqp/S/MZeJFIJdvU9HJ/t48NUpsgfS41yHy84VcaL7FnX+N+7GeGP6553KP5duS8UodSddk4BZiN6CDwHKcbFgPaH47eMdTA88BbH5rA7Zc6DdY/2pzDY9UcByrJiEkWFsO+zwH5stcv3FZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750061499; c=relaxed/simple;
	bh=te8dm/diw0y2VhNPSG+i9Er+pf2FUpm9NdYwsE1lfRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TymF79+mqv3ON8uf2WTorzoV1pwbz0q9l03HAjjPzrBZTCFe8gl8D4oEY1Pgx/mh0aN7/N2TIuzym9HgwDNF+H2jLnuUbbFKJ6fFfYyYLV6tjb95/VU58fLLXAWo9UEFjzhfN1EZoNKlluEwrvauOiHP9RMm9nijTMORn2gshg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liDb1+Cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liDb1+Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB925C4CEEA;
	Mon, 16 Jun 2025 08:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750061497;
	bh=te8dm/diw0y2VhNPSG+i9Er+pf2FUpm9NdYwsE1lfRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=liDb1+CzxOC7TFLqFNvaVYpgqck1ifdIRFmFXxb1SZYO8Fmh5Bi7HoDmI05PuUN8I
	 c5oLA1FZVcnfhm1M9M0SAzY/hN1ct3Vug7B7ZQzWMpi2M6chbabHzaRBw21mHU5PmK
	 indb/gSUeExljMnpz8hX1qHV+nM5MHhsFTYFAWHL8JAbbm9v6ZgyqkNaB46pC0xIab
	 0jkZ2yOyDWzsOfmmiluwW/W6Du78ecFaJbzkV+925pN5rb+vQuJzrHppdVOGiJ8l2r
	 WNdsANwogjGPLUc9Y0SbCvWW4qx96GvZUIqltYeEo4l/MH5A0CnyRyK3jNgQsXD0Jv
	 BkTvvkoFc/P8Q==
Date: Mon, 16 Jun 2025 10:11:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, 
	Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: actually use the xfs_growfs_check_rtgeom tracepoint
Message-ID: <f4ffv2wantwfworrki5qc6uvihdozwka4khsvahnwxthcul4ww@dzygdh3a334h>
References: <z8SkjCilUqL9QYTBGvwhNH_vmCnFBUNOAxN2XMHSNODzcSh0cS3ZP_mqpytvGOmXGr1KHC3JD6jueHX0V6SSZw==@protonmail.internalid>
 <20250612175111.GP6156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612175111.GP6156@frogsfrogsfrogs>

On Thu, Jun 12, 2025 at 10:51:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We created a new tracepoint but forgot to put it in.  Fix that.
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Cc: rostedt@goodmis.org
> Cc: <stable@vger.kernel.org> # v6.14
> Fixes: 59a57acbce282d ("xfs: check that the rtrmapbt maxlevels doesn't increase when growing fs")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6484c596eceaf2..736eb0924573d3 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1259,6 +1259,8 @@ xfs_growfs_check_rtgeom(
> 
>  	kfree(nmp);
> 
> +	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
> +
>  	if (min_logfsbs > mp->m_sb.sb_logblocks)
>  		return -EINVAL;
> 
