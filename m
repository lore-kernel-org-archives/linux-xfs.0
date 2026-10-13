Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D8A3FA5C4;
	Tue, 13 Oct 2026 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901870; cv=none; b=NBQXF/yZQtMxw61dM/BDvxUg0o10NNRgKM5W4BjbKKbZeCiWL3Nuo1SVKz/z7nxkjkxjieZ90i2V2FgC4oKuPAUoWyYDi2el6VwTGFo2LAmxmrDvp2YXCSPm0D2TXtUtbwieaLNTQ77tbvEU6yKf413+kM5TRReGuN9ZWtAOHWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901870; c=relaxed/simple;
	bh=XezWxoxr52QgNTOigpQOkPZ/6USeVoHCDDfBlsURRzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtXhCMYs85t3z5gxgEULBy+SKzJEY4FO8dZ2ex6zqMQ/YjTc6pQlw/mri6ogkS0fUMIT5b03GrQk7JVlfMW6qViyZX8qEiVZf2mJQ9KF0RquTV8NdNDdaE/JhjLCiLB68WnlUXt7306DpEeilZdRviX6DEJppGOHmZ19dO7So78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjO7jhTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjO7jhTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E819C1F000FF;
	Tue, 13 Oct 2026 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901869;
	bh=2QEPzDdVqnC451L8dwbXZr7mHrBs04BcKxy5XlIs9Ww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kjO7jhTyvJge8n//nrwmgDlyfWiG6n00z+ytkheLV73Lm/eiUYYiwXbSNhSIvF4aa
	 +m7lWYk6NdnzfHGSXQhd4F+LLntekIjfVOCQ4G4uOfN1RVZ9rYgddrygaqNZlVeI18
	 dUKBJ4CULZv69nuFVl2KifTak2gcVzRcvk51/ZwzrIOOTa6tayinZv+noL9Ek31b+e
	 DruEtsTfoVzRHgymDuWdEPrcBw030n1wJ+y3SFGltOQZ3pA8vexwhljHgYlkB9Ft1Y
	 ArikOzSasbqY5WvfmpbDjy1OBs/DBGuHMttesOyByZYxJl4BTimUBkTm5oS8tUpvV3
	 l7YHl5IWyqUGw==
Date: Tue, 13 Oct 2026 16:31:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, 
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Message-ID: <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>
References: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001145153.308087-1-siddh.raman.pant@oracle.com>

On Thu, Oct 01, 2026 at 08:21:53PM +0530, Siddh Raman Pant wrote:
> Probably an (harmless) error in copy-paste.
> 
> Fixes: db6a2274162d ("xfs: catch stale AGF/AGF metadata")
> Cc: stable@vger.kernel.org
> Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
> ---
> Put in stables <= 6.12 after the backport series lands.

Fix the tags accordingly to Darrick's review and re-send please.

> 
>  fs/xfs/libxfs/xfs_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f762dcce8d13..0ffa82400007 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3461,7 +3461,6 @@ xfs_alloc_read_agf(
>  	if (!xfs_is_shutdown(pag_mount(pag))) {
>  		bool	ok = true;
>  
> -		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>  		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
>  		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
>  		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
> -- 
> 2.53.0
> 
> 
