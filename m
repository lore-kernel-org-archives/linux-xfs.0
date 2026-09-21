Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8208044062C;
	Mon, 21 Sep 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030074; cv=none; b=LMLXVDoXejoGfVuhQg+whVNU7EZs3YiN/NBkK8CnIAeQrEhChtX6pW9QZNv+bI53bsf1R/4sbdedylaXB2qytRWD0EIVVx4b0Ehg6yLH3JgpbcIWgdlHf6umk9ty3LNOkcAFc6KvnFsJWS+92NGNkNIMGAlEYFZuLnHB+puyCEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030074; c=relaxed/simple;
	bh=wxdd4aRE/wxIATjOmI2ulFK1irn2dZLFgW3E7+ehEKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pb9GXRRXkq7oLkb3PvIpbXX+5cBdbMz73tHrpFZTUTPM+wIT5ifDziYtrVYDXqLTr2FI0woaeD6SCf+ccY3m8UJYVWfx55fDkCR0xU8QmdgpK0FFk/JZz5lFmz3i618c3qkjUbSmYPxNaRTPaX0tWiLG/98E2gp9ULwnoa3z0as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWis54ER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWis54ER"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0C1681F000FF;
	Mon, 21 Sep 2026 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790030073;
	bh=UKwQax2euo3fH0Wc12uFGQaKUN+XldVi7Z0vDTxU1q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MWis54ERXQmA2L2GYCjQvOFLzKJRodC5Ti5ImayPVQbMvXMJzqzfKscf7ecSuWQ/W
	 M8bbhWjJbtAd2k9X4TuowrePTT6q66S8nYxJeWyd6JYExIkaI4F59rvl6g9yIMyWD6
	 XQKZWGySAeMvy1rtnAdg44E1lYew0SgkHxTf2FO/IAO3kqkr81ouchYhPCuIbQAyKm
	 OIOL8sOc7mxVFXpQrD0h8w3zoMzKM0H1m1vOWNAHkerx04K0v/K2B9c+qPkQsNnq0D
	 bSBhekRog0CVVSGaUT5QbR6WGfOUz1+d1ypZq74hUEk8lfAZDAi+ZnQVstUQYmGaMD
	 j39FbLOlTpGDQ==
Date: Mon, 21 Sep 2026 15:34:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <20260921223432.GO6283@frogsfrogsfrogs>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-4-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921083133.2960-4-parri.andrea@gmail.com>

On Mon, Sep 21, 2026 at 10:31:33AM +0200, Andrea Parri wrote:
> iomap_dio_bio_iter() falls through to the sub-block tail zeroing when
> the data bio submission fails, so that the rest of the block is still
> zeroed and stale data is not exposed.  The zeroing result is assigned to
> ret, which overwrites the submission error with the successful zeroing
> result (zero) and the failed write is reported as success.
> 
> Store the zeroing result separately and only use it when the data path
> did not already fail.
> 
> Fixes: 10553a91652d9 ("iomap: fix iomap_dio_zero() for fs bs > system page size")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>  fs/iomap/direct-io.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8b4039d16ce89..8ae3fe64e475c 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -581,9 +581,14 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>  		/* zero out from the end of the write to the end of the block */
>  		pad = pos & (fs_block_size - 1);
> -		if (pad)
> -			ret = iomap_dio_zero(iter, dio, pos,
> -					     fs_block_size - pad);
> +		if (pad) {
> +			ssize_t zerror;

Why ssize_t?  iomap_dio_zero returns int, right?  I may have missed
something in my absence, but AFAICT it should be:

			int ret2 = iomap_dio_zero(...);

			if (ret2 && !ret)
				ret = ret2;

--D

> +
> +			zerror = iomap_dio_zero(iter, dio, pos,
> +						fs_block_size - pad);
> +			if (!ret)
> +				ret = zerror;
> +		}
>  	}
>  out:
>  	/* Undo iter limitation to current extent */
> -- 
> 2.53.0
> 
