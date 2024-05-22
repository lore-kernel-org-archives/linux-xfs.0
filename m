Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D6811E0
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 22:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716416695; cv=none; b=EHHkYHqZwWL62iNW2uSPIXCqsNkICyJI3EKVdwU4rS5TjdDUWoyqfsO9b3de2wbCMHmqIT6rgaCwTr8MTqkOKCqX/yaZ/ZjPD47qHBQn84b6kOOIeptPmrImMZNl35t/dMwHYsZyB5xseArrt5JT5aHVKPvThnMlZFZB6hCLC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716416695; c=relaxed/simple;
	bh=GzjPy6EivSMlubqaOV6vQTnYHOgdV68ovC+yyDyHT38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGyJ1n7SPV2wv3b4UaJAisexqSrcxv0iMkeK0m7CcOs9/gK7BSjQUjB3/y3P/Hq+YjoVgs5Ze2wgjZZ2YjFF3rD/xIc9qXmtsC0b446Htkub80aKkYCNY+eoqzpR9z9nfhkEomJbHVbXsQi8CtQZEqz7xnQEwolUm+CjxbME2A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uVoSUjIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uVoSUjIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A59C2BBFC;
	Wed, 22 May 2024 22:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716416695;
	bh=GzjPy6EivSMlubqaOV6vQTnYHOgdV68ovC+yyDyHT38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uVoSUjIif019+xvujRZlxQQ5xijdKwVqfrQKDZY4G2seURdD6rTjcrxzSLcHuIqZ9
	 K8//SBiPF+vRzJVaxY1sKVFIWb8ny58wTjZtEFkewbekMs0TiwQ7HKbpYAKuTByky/
	 N8wQsh3bqPqTq1KrQAVx/nz/1US+LgfP9S6llUp6AUYYRnUhd6NhrBcmhwJ/1aGLSB
	 pMu1Z5l9/TosTwZ2pSsoeSCpkPZNh+uRqfZloau3SfAIagdM210sq/x/qzbERA0NcR
	 +ryWQpG5oHs4aoQwHBf5l35C0Da6AG77kWYSt1LQotqCGCZNzRNDdmMB9ScpzVe8+l
	 KhKmSdfDy73tg==
Date: Wed, 22 May 2024 15:24:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io: make MADV_SOFT_OFFLINE conditional
Message-ID: <20240522222454.GX25518@frogsfrogsfrogs>
References: <20240522220656.8460-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522220656.8460-1-bage@debian.org>

On Thu, May 23, 2024 at 12:06:56AM +0200, Bastian Germann wrote:
> mips64el does not have the symbol MADV_SOFT_OFFLINE, so wrap it in an
> ifdef.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>
> ---
>  io/madvise.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/io/madvise.c b/io/madvise.c
> index ede23395..1d664f8d 100644
> --- a/io/madvise.c
> +++ b/io/madvise.c
> @@ -101,9 +101,11 @@ madvise_f(
>  		case 'M':	/* disable merging */
>  			advise = MADV_UNMERGEABLE;
>  			break;
> +#ifdef MADV_SOFT_OFFLINE
>  		case 'o':	/* offline */
>  			advise = MADV_SOFT_OFFLINE;
>  			break;
> +#endif

Please #ifdef guard the -o line in madvise_help so it doesn't show up in
the help screen on mips64el.

With that added,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		case 'p':	/* punch hole */
>  			advise = MADV_REMOVE;
>  			break;
> -- 
> 2.45.0
> 
> 
