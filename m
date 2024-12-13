Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFC71946AA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130041; cv=none; b=I+/TdU7DTLfXy8uyw/cJ6jCO4aqV35O7CQL1qJE51K+J9H59DG3n4bmpifdoLQErn+NDA1i26fwnn75S/nNz0VfHruQAp1k9io85QkID8ZgkZGOlIjVDzy11cOkwR1Iw5NAzK/EuQ/G+F5w8NmxL7FTqTwPbY7SeGMDMuybAsBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130041; c=relaxed/simple;
	bh=IpQDjAGCS/ruXeJRHNF5WZk98qyMBkX+54+Rrx5hJhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9Pm/Uku0433H7U817aTmJfsIoOyBSM1YHswx/OfKeEDxW6S6DDf04AS0FfzoHq+NQbpQyLdJFUhiBkukWflVnehCbcmwtpHAeEbhgr0iZjhW5+Dtoa0VwMU4gDjhxCW5JJWuM98qO8XGdS60LO+zppoMNThbK7GTkhabu/zgHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OL+cC/J+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OL+cC/J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D201C4CED0;
	Fri, 13 Dec 2024 22:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734130041;
	bh=IpQDjAGCS/ruXeJRHNF5WZk98qyMBkX+54+Rrx5hJhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OL+cC/J+v6A9Hi4v2pEZ3UyUXgomkXsaROO3AsiMdbI2SqZHVvxCp4i+O2l4+wtp9
	 7Ag04UF59v8f9m29f5D0hmNP1TSwFwU9M3qDdMJ1X9B18F1LuQ8pn1CG0teFE+Y8MV
	 WZtJCns5711gnqqXwpqqNal+qyY5YNcREwcUQuTIltlv001YfPesaOH5Qe4gDSDvpw
	 speRB3d6c1IHm35/2kb9ZC8eU7xdzxoTRBMw52QN2+REkcnGtmodqTMSuAYDCnSPq9
	 zmjYOodOdxP+PHzDonLX/uKCCudNot00Erbg7jjvPi3xhNy4Qk248g7LBNfdoB3JmX
	 BlYTDiHcg6VYA==
Date: Fri, 13 Dec 2024 14:47:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/43] xfs: allow COW forks on zoned file systems in
 xchk_bmap
Message-ID: <20241213224720.GV6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-33-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-33-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:57AM +0100, Christoph Hellwig wrote:
> zoned file systems can have COW forks even without reflinks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 66da7d4d56ba..cfc6f035ecaa 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -1039,7 +1039,7 @@ xchk_bmap(
>  	switch (whichfork) {
>  	case XFS_COW_FORK:
>  		/* No CoW forks on non-reflink filesystems. */
> -		if (!xfs_has_reflink(mp)) {
> +		if (!xfs_has_reflink(mp) && !xfs_has_zoned(mp)) {

Might want to update the comment

/* No CoW forks filesystem doesn't support out of place writes */

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
>  			return 0;
>  		}
> -- 
> 2.45.2
> 
> 
