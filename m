Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49A33C4561;
	Tue, 26 May 2026 14:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807164; cv=none; b=kIa6TH+RMxg0XcQ2kqmkjr/9GJvkaSDqQ1pMx5tnOlPUUzGk40GWwGnfth0OaaiZ4c0vZLoT3D3YwFz4FN5Iu7l3DIdtITqPsGN12JiSwe6OTgmTvurIKZVh8fIsTj2dmP1/JfT2YyGj7CeNdToyZf15/5IWcSLZsXdQbVV6zPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807164; c=relaxed/simple;
	bh=c3plpIRUwuD70K4OuO176t71xGFDKVcZjoWXSUi5uX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agqEjQMQpad1pvrgsAcXAwV11E+MdzZsib3p/TjNzf66yw0RgS/Ms2njhhdQJM1M5HVHuEXZC9HHwb+AqcMdHcy/IsUunRL49zyUJxLmSfYIU2ULhBUjF6QdtCg3p21WxJlYBuvJ2UgLptxDGIqv0nkiOCkJWvclYnr6+CqD5KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIveekTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIveekTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781251F000E9;
	Tue, 26 May 2026 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779807163;
	bh=siFU01K+DXmcB5DEIufRoB8Utlee6qnlKR0FaUS8Dvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kIveekTeLgzjYUtcBpLVVLA69GFDN0An95TopD2N9aDfYPH29rnCiqXTGrL568fkW
	 4/trTyTyhGmK3lnObi8UAFJUpNxI35EUHXPQxmlmjccY1XIW4+brkCEVPAnrquV+tO
	 D6DGDQh52vG+a75yXRAmfwyqSEL36etaI7Op1xIySBCYP7tnIjV6XrS0dvyc1rS3vv
	 m/0XJ9Dq+mItVPXlwXaPVwM3EUxBn+S+iQAmkos+fYFyfBZOIlVT0mOvoJXQPngg0M
	 8ZnifLAXNjNp6DMZTYiogMw0ZJu8sKWC6yrehNn6iulOMu50GygmB5NWc2XNsiUuLG
	 Z4lh15PEfdYhQ==
Date: Tue, 26 May 2026 16:52:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix error returns in CoW fork repair
Message-ID: <ahWzfNU7n2bYTPrQ@nidhogg.toxiclabs.cc>
References: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
 <20260526123243.1078867-2-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526123243.1078867-2-gaoyingjie@uniontech.com>

On Tue, May 26, 2026 at 08:32:42PM +0800, Yingjie Gao wrote:
> The non-realtime CoW fork repair scan returns success after the
> common cleanup labels, even if the AG setup, btree queries, or bitmap
> updates failed.  This can make online repair continue with an
> incomplete bad-file-offset bitmap instead of stopping at the original
> error.
> 
> The force-rebuild path has the opposite cleanup problem: if marking
> the entire mapping fails, it returns directly and skips the scrub AG
> context and perag reference cleanup.
> 
> Send force-rebuild failures through the existing cleanup label and
> return the saved error from the function.  Successful scans still
> return zero.
> 
> Fixes: dbbdbd008632 ("xfs: repair problems in CoW forks")
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> ---
>  fs/xfs/scrub/cow_repair.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index bffc4666ce60..bc3838bac71a 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -304,14 +304,14 @@ xrep_cow_find_bad(
>  		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
>  				xc->irec.br_blockcount);
>  		if (error)
> -			return error;
> +			goto out_sa;
>  	}

The goto here is pointless as it jumps to the very next line, it could
simply let the code fall through.

>  
>  out_sa:
>  	xchk_ag_free(sc, &sc->sa);
>  out_pag:
>  	xfs_perag_put(pag);
> -	return 0;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.20.1
> 
> 
