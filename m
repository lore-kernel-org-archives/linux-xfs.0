Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2583A2C1A2
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725290435; cv=none; b=sTVdd+SPyoECZGiFzUPsP5XbtIF/NmOEPswyQV5pYHz/GXgO9R5U7z9aytMh9BbJ6yB2mX48f5kFcahsPQCYMWAmLWq81r6LN5DapE6SztdQaSVsRWYr+8C/scHSmWtdqboKP9Tjpjf/gdMDTPmyr57FG/mR05Z2kCUmNilyqu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725290435; c=relaxed/simple;
	bh=9bic+W7BLMzVjYcrJ1NaDn8zo3vYITlqCyi1WdLNIX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPE+V5CCOuqODq0ZAvhlox9S+MXzFkhlzYW1r6WQpYxQnNYr2AkEWzUxTkRNiIzQfXZY64srT0/C4OH92q9NPucul5b8oKVHcTIy3urfcD/O0eaLFZvXh6REDQEU16+6mH6DCIp6alZf8NhD41F7MxZxdCc1iFcOA3ra1xJ3p2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3LkO/yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3LkO/yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F32C4CEC2;
	Mon,  2 Sep 2024 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725290434;
	bh=9bic+W7BLMzVjYcrJ1NaDn8zo3vYITlqCyi1WdLNIX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S3LkO/yfxvSMr9tXDdiOc4wjHMcdFDxNobkp3ZYiOsRK26weStLW2WXTK5JhIrTZW
	 dRPuqeavnjs1iDpQjsmQ2KDYpZEzJ1mv40DcRIFZydk/l6R3JLP7CIU9PdZt9IfV5m
	 njLR0nfIcHiVcwzLxpavZgEGQNGbcDy9uvJ8RgdIxfw0p9CQ4KBUVJiZH+pri//kLJ
	 R5CJ7I6b+Y00UyLEmaUhLsjCQrEOyAnUhKivhGAUT/oF44a+GSotXneiDvqUpTpdOz
	 qPHpbBrEIVUw1nInLJNg1T8xG6tNgn9lN9Ktn8NP2AUhuFyJ4LBm+g4VPaAYPVvY04
	 uQXflPLt98Xfg==
Date: Mon, 2 Sep 2024 17:20:30 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: kernel@mattwhitlock.name, sam@gentoo.org, linux-xfs@vger.kernel.org, 
	hch@lst.de
Subject: Re: [PATCH 01/10] xfs: fix C++ compilation errors in xfs_fs.h
Message-ID: <ln36h3rmazpfgg5rzbr5menp24knvbfknywwfao2lzqueagxm6@xrw52vjm4pxt>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <utZpNzCfBMj6cNNGDBU78DwZ3uKScq-dX1vWRGar6JOHsu3VgvGjxTA6LbOawhd_T6jvis15ne4yZtEjpr9x0A==@protonmail.internalid>
 <172480131521.2291268.17945339760767205637.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131521.2291268.17945339760767205637.stgit@frogsfrogsfrogs>

On Tue, Aug 27, 2024 at 04:33:58PM GMT, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Several people reported C++ compilation errors due to things that C
> compilers allow but C++ compilers do not.  Fix both of these problems,
> and hope there aren't more of these brown paper bags in 2 months when we
> finally get these fixes through the process into a released xfsprogs.
> 
> Reported-by: kernel@mattwhitlock.name
> Reported-by: sam@gentoo.org
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219203
> Fixes: 233f4e12bbb2c ("xfs: add parent pointer ioctls")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_fs.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index c85c8077fac39..6a63634547ca9 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -930,13 +930,13 @@ static inline struct xfs_getparents_rec *
>  xfs_getparents_next_rec(struct xfs_getparents *gp,
>  			struct xfs_getparents_rec *gpr)
>  {
> -	void *next = ((void *)gpr + gpr->gpr_reclen);
> +	void *next = ((char *)gpr + gpr->gpr_reclen);
>  	void *end = (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
> 
>  	if (next >= end)
>  		return NULL;
> 
> -	return next;
> +	return (struct xfs_getparents_rec *)next;
>  }
> 
>  /* Iterate through this file handle's directory parent pointers. */

I'm taking this patch alone from this series, so we can fix 6.10 asap, we can
move it out of xfs_fs.h (which I agree with), and pull in the dummy code later.
Getting 6.10.1 out with this fix is priority by now.
