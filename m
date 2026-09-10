Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D9C39A806
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 05:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019241; cv=none; b=AxspsFGe9hAJ9402ucLgrEzChRkBILOmZoev5UjRvIE2kyTAR/MlDVULL3rHYECaFO8RUlPaIbSDwgvjV8Ne/XTyKq7hrIXjPJFy61qG1vf7E8MF1AhTZkUgXtphcyFxOVmjREiByb341WgXRApxa2iLzbg4clFZLh6NE1xUczM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019241; c=relaxed/simple;
	bh=mzDf9ZiBux5NzWb8qk18Rmf4tlprjykKWs3gaGPn1D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADGURsUBRGpUUmfBThBc4t2YJBZ0POjJYf3zI1iC+TFzP49HcxDLPrTbyD2wyfdkZ+Dyeozes80lZ0DVY5OWv7dooEbYWKIZA2zRsNLcn4kI3ngSuB7btG+olNzAYisBr+nNYRXyfdU3lMOWgp2iNopIKrLV9lkeGab8/U3t9JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fuyzeVr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fuyzeVr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908C11F00893;
	Thu, 10 Sep 2026 05:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789019239;
	bh=pjTHyHoi7fDUsTIxFEWq5J0JO4DtPRTvYv0dN+V49yk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fuyzeVr82TrZ7JQxPq8OenVrsT+g//BMla0GtMXpT14ZUeoETUylW8KdSoKDkIAd9
	 QBrLG0iw0KhOek+2tvOxsa4FzmkqE3WhKuYZ+gBW9y1Czmq66FzT5cUEt9kUXzAMEG
	 /PszCoz4+RsGrFk/1kfCb/ztLlI3UyInArfcrIb9ho0C4wvE306/S7D/zcKsgxMJ+h
	 7ArpxEANECZse7ChTGm1SCZDj+98zZd+y6RLN8XlLFsbpG5Y3eHV+HEGf2GGIwWI3f
	 2H//i+ieTpHI2Q9iCYzpMEPNTtxREeDLCYSDQrJPEtgJZLutrgKN+O1xJBX3aWCbNF
	 Kd9k5aZUYvSxg==
Date: Thu, 10 Sep 2026 07:47:15 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: fix termination logic in xchk_bmap
Message-ID: <aqJEXaVgCnT2tJs6@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936706.4057962.7423867565222582609.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936706.4057962.7423867565222582609.stgit@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 11:05:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xchk_should_terminate can turn its @error argument into -EINTR if the
> user is sitting on ^C.  Unfortunately, this code here turns that into a
> 0 return, which isn't quite correct.  LOLLM complains about this, though
> I think it's a very minor matter because the only way -EINTR happens is
> if there's a fatal signal.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/scrub/bmap.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 3b0f1dbd9147ac..4f3c7f681bd921 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -1103,8 +1103,9 @@ xchk_bmap(
>  	 * the rmap must match the combined mapping exactly.
>  	 */
>  	while (xchk_bmap_iext_iter(&info, &irec)) {
> -		if (xchk_should_terminate(sc, &error) ||
> -		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> +		if (xchk_should_terminate(sc, &error))
> +			return error;
> +		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  			return 0;
>  
>  		if (irec.br_startoff >= endoff) {
> 
> 
