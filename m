Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76F53CD8CC;
	Wed, 14 Oct 2026 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966369; cv=none; b=nyRtyZPjS/HbWZZ1CSO4QMRoPeMFNGiztTXCWuxZfRv9QNIBOWtjPk15QG/ssA4AX3Kqkb0/6ZGTAcNtCxxxvXO/mU4ZJeoTjgM4J/5mdRkkdE2kSAPmnlOib9ORVm42AvJyawRMo3MhffSxigeyJ7wfRbBZljpmqnumd26tGnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966369; c=relaxed/simple;
	bh=HRpefeCt5TyM9/jY7NCZNymQcqzwCq/t+7xXxrz5yBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBjrjjjk66KDMxiL2xXFBivJjS/Xjy+1FSMwj+YS5S9TVW/eSAsSSJmSGM6euqbXmxHYGBxGK6jZFh/yno6DVkt1o9AcXUr/3F1evaQogses/1DmyfbZyKESpKqb9FBC1eQktmMKNjmrdofn5kvLDBa/l0GFwyQ9MngCxzWPvXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBhr0tlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBhr0tlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FE81F000FF;
	Wed, 14 Oct 2026 08:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966368;
	bh=n7sLI8QOUy1+nUVtcltDjwfqE6ymusYmueihwZ/IRQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TBhr0tlrccACe1beQ2pDhFyRNHw+C980Zs1ielkApWmHx6asWOT1Z4rkbF+brhicQ
	 US4mny7g3z+Gq2mlLBvT+j5yNWXLopMa1y2HUq8khUwcHHWNlOSg+6eewNg36sYgt6
	 hUNBs8z5nN1C/UAHFhV74xKnBkYsjyyiBrROpofmwnJLBzqm2NhG0FOGQxdGjKkrBr
	 soPtf0T/xivTlcoeIfRM1mJzNK2hxzh6oZ8n2blleI5KHOxQnffbXJO03nNDawQVRp
	 x0BBBMx4fFQhnDLLearoGUhXGllezqnOJfzMH7Jz53dPhxtb0g8ds93QWLEhITm0BL
	 +Ca2ljXLUawzg==
Date: Wed, 14 Oct 2026 10:26:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: check for fragments when full-extent sharing
 matches
Message-ID: <as84RR9BrH82CPMG@nidhogg.toxiclabs.cc>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
 <179186107290.1898400.11595388650663319200.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179186107290.1898400.11595388650663319200.stgit@frogsfrogsfrogs>

On Mon, Oct 12, 2026 at 11:07:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
> if there are enough rmap records that overlap the space referenced by a
> refcountbt record to match the refcount in that refcountbt record.
> Unfortunately, it never checks the fragment list in this case, so it
> won't find the discrepancy between the rmap and refcount btrees.
> 
> Cc: <stable@vger.kernel.org> # v4.16
> Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Same thing for this patch... Final patch is:

commit 95e213c1ddb40dfb0a8178ed35c9f29992a320e1
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Mon Oct 12 23:07:01 2026 -0700

    xfs: check for fragments when full-extent sharing matches


> ---
>  fs/xfs/scrub/refcount.c   |    5 ++++-
>  fs/xfs/scrub/rtrefcount.c |    5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index a900d13c9e27c0..883c273cb9883f 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -185,8 +185,11 @@ xchk_refcountbt_process_rmap_fragments(
>  	xfs_nlink_t			target_nr;
>  
>  	target_nr = refchk->refcount - refchk->seen;
> -	if (target_nr == 0)
> +	if (target_nr == 0) {
> +		if (!list_empty(&refchk->fragments))
> +			refchk->seen = 0;
>  		return;
> +	}
>  
>  	/*
>  	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
> diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
> index 00da8e98506d63..c312096e410561 100644
> --- a/fs/xfs/scrub/rtrefcount.c
> +++ b/fs/xfs/scrub/rtrefcount.c
> @@ -200,8 +200,11 @@ xchk_rtrefcountbt_process_rmap_fragments(
>  	xfs_nlink_t			target_nr;
>  
>  	target_nr = refchk->refcount - refchk->seen;
> -	if (target_nr == 0)
> +	if (target_nr == 0) {
> +		if (!list_empty(&refchk->fragments))
> +			refchk->seen = 0;
>  		return;
> +	}
>  
>  	/*
>  	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
> 
