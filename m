Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD333438B9;
	Thu, 28 May 2026 04:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779943484; cv=none; b=lKmIecN4T4CS5jMEfjEeBsfpOUI8dTNgAUT7qlpC/pd6Tvt3HEvWUtApiCgmvF8XZryM7GdFCalAjKisdLfZifnR8vZp2sb+wD45rnLrydQ5MxPmM+6JMZTSVtc3SD/3eHbbUCsUHfFAFSdzRrgx0YjmDOu7mAK1Tj0HCHfJ7dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779943484; c=relaxed/simple;
	bh=Cj3UqSHUHgaivDq+KTxlSkeLUMdl2F7INewSUc55kM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPGRc2v9cH8GuQ2gL0w43YOXbWCfa67xrca2/2sAkUZTekYhR3OF4LRli6Npdq6lkoGDG1m5SAlE83h3HbtPPDZotX8Z4/JtMxZvyyyO0JbNkrvmHUj3Afxy7BI3R2HTo7eUvVvBQRnMTgPPp9bTLQkg9MZJxMl7SHX0jnjtGTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WpfraCfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpfraCfE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0F0871F000E9;
	Thu, 28 May 2026 04:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779943483;
	bh=3DVDcLVVUPDMVvYhzxZSFh7FfqKTh4g4C4CBuZH9qIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WpfraCfEjkEVyCA+73yKCA3dle2iUKWooyIW48Hiuy4T4gJpN+tUmlcrd+0oLwC7+
	 3jW4ZCZxjNj1Vh/DwXcGZ/xX1R4dnJuMyARBQsZsNMoAi097NDl2agkFB68wVuQakP
	 K/Uy0tjc5h6Xz5LcEK9S4fYnT7/QccQJiTbbTq8uBotCAFXnuiiD5JPHMp0I9Kmeco
	 FwLmG+4AWOK01gnB2S1S/GxGurSFHaD4sn476CC0V3UWBwqiloFSdW85xGc8g/o/OT
	 AlNNnBo9eK5oOJ1FmwN36NO0oeb/oUppPfLK3DrsTwP0V5OY49KXmWkM4BPlTvXJXJ
	 zZ2kQeqND7WMQ==
Date: Wed, 27 May 2026 21:44:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: fix error returns in CoW fork repair
Message-ID: <20260528044442.GA6078@frogsfrogsfrogs>
References: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
 <20260527043134.1550710-1-gaoyingjie@uniontech.com>
 <20260527043134.1550710-2-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527043134.1550710-2-gaoyingjie@uniontech.com>

On Wed, May 27, 2026 at 12:31:33PM +0800, Yingjie Gao wrote:
> xrep_cow_find_bad() returns success after the cleanup labels even if
> AG setup, btree queries, or bitmap updates failed. This can make
> repair continue with an incomplete bad-file-offset bitmap instead of
> stopping at the original error.
> 
> The force-rebuild path has a related cleanup problem. If
> xrep_cow_mark_file_range() fails, the function returns directly and
> skips the scrub AG context and perag cleanup.
> 
> Let the force-rebuild path fall through to the existing cleanup code
> and return the saved error after cleanup.
> 

Cc: <stable@vger.kernel.org> # v6.8

(please make life easier for Theodorics A and B who are half-assing LTS
QA these days)

> Fixes: dbbdbd008632 ("xfs: repair problems in CoW forks")
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> ---
>  fs/xfs/scrub/cow_repair.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index bffc4666ce60..a6ff09ace43d 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -300,18 +300,15 @@ xrep_cow_find_bad(
>  	 * on the debugging knob, replace everything in the CoW fork.
>  	 */
>  	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
> -	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
> +	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
>  		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
>  				xc->irec.br_blockcount);
> -		if (error)
> -			return error;

I personally would have stuck with the v1 logic of turning that into a
"goto out_sa" but either way is correct.

With the cc tag added,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> -	}
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
