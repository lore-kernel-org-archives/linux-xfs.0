Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FBD35B650
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574429; cv=none; b=YjM8OTV1s4UTHXk5uABu4IKvYIulJp+xGonFX6pgs6TF1GYXDgVUHkH9jztiYww8VbaTHhQVGaqQKhYTYSf7Kp0PyD3jdFb/o8VBI6+mJz8fCYiNSGDN5YQcwR82Hm1jUvjTAjLZhdb33uGhK8mLqUCeMuLwcQRSiP9mB8601ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574429; c=relaxed/simple;
	bh=T4ClcvFO2zLzXH4ah633+6pQvlRc0Mk01eD4wnZjTyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuAaRMaRHjZOKyf3u1CvbXOXKvwUZkE0Zpp4VMUR+YsmowWydkxVv5ZkAhbcERw623O99c3kaw2YyL+3wrJ8ayfAMoUMP+WLMYvIYWKz3RYO+qA1tRG/ngd3+LfJMz9KX18r9FKnDbyLnatfgu8LpfJ2mZzWGRe9KNhWfZSSjZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUHCyL8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUHCyL8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B26C116C6;
	Tue,  7 Apr 2026 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775574429;
	bh=T4ClcvFO2zLzXH4ah633+6pQvlRc0Mk01eD4wnZjTyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DUHCyL8HN31wCRaAIxbb1CIdhLfJegB3R0+sMIRXHlj07n8OLydSa6w7t5xK/qvK6
	 R3EERHkk6AZQwZbNTsureADb1TU6fRzePECWtumMtW0dCqpTqwruf5rI1G63x+DnS8
	 GyW5nzS44oO5SrDvMei0nGG9ej/VyN0bSi5thbVORClsaYdVUIXFUeuMANqquenMs0
	 BajMKDYJwPFVfVyOPA5BD0nh6piB6Ur/6JCjdrK5GKK63Q98f9/2wzkjYqjWFVbzmZ
	 P+bhQHcg4HdfHHpep83qFSFl9vTJqc+v4Ocd6ixWlbHqTQWGcgvwGvdqh+bWyutjxe
	 ZQhM8kmvHbA3g==
Date: Tue, 7 Apr 2026 08:07:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/2] fsr: always print error messages from
 xfrog_defragrange()
Message-ID: <20260407150708.GE1048989@frogsfrogsfrogs>
References: <20260407111507.79977-1-cem@kernel.org>
 <20260407111507.79977-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407111507.79977-3-cem@kernel.org>

On Tue, Apr 07, 2026 at 01:15:00PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Error messages from xfrog_defragrange() are only printed when
> verbose/debug flags are used.
> 
> We had reports from users complaining it's hard to find out the error
> messages lost in the middle of dozens of other informational messages.
> 
> Change packfile() behavior to print errors independently of verbose or
> debug flags.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
> V4: fix up previous rebase (fprintf accidentally removed)
> V3: Rebase on top of patch 1 changes
> V2: Update commit description
> 
>  fsr/xfs_fsr.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 390f7c5276df..e74180c143be 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1464,19 +1464,15 @@ packfile(
>  		case 0:
>  			break;
>  	case ENOTSUP:
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file type not supported\n"), fname);
> +		fsrprintf(_("%s: file type not supported\n"), fname);
>  		break;
>  	case EFAULT:
>  		/* The file has changed since we started the copy */
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file modified defrag aborted\n"),
> -					fname);
> +		fsrprintf(_("%s: file modified defrag aborted\n"), fname);
>  		break;
>  	case EBUSY:
>  		/* Timestamp has changed or mmap'ed file */
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file busy\n"), fname);
> +		fsrprintf(_("%s: file busy\n"), fname);
>  		break;
>  	default:
>  		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
> -- 
> 2.53.0
> 
> 
