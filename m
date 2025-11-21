Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F72135CE;
	Fri, 21 Nov 2025 16:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763742954; cv=none; b=frumITHpIaE5cwf12xqbwz4yY+B36Ra+usXDlAqENpYMveFNx788kp4CNe1VoN2Huy8qyE6gmKlNKIcVWdm4Dccma5GADVPTiruZm+u/Gy1fq6rgN1xkFJLqDyONN3kOJL66T4rbCc0QzsNoL3DSPOp2oMNcJJLXGs+vt1wlWG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763742954; c=relaxed/simple;
	bh=2UiKS+dmV086WopYnefuZPkUM31z9bm/uw2Iwxsyv+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+Z2z7DoA9mZxwN/nD9a9p9yeZLzjdRCnVXV5Ixp4/7MINBdd361cBgQr3htwXP7SaLjkG+wdp/jgjOGCErvs/7qZupn69EzzMRlwcjlN1u43/kc21v488UXNewVYGVcv0hdgIGW66VPGFVJeLsFAAucjDdDA72qf0GuwW0ROT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvUHI8YB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvUHI8YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEEAC4CEF1;
	Fri, 21 Nov 2025 16:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763742954;
	bh=2UiKS+dmV086WopYnefuZPkUM31z9bm/uw2Iwxsyv+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HvUHI8YBaEL6d0ut+891OJtN8cAhdKtQOvSm/QSLvPjHZQl7ClluPtmXRqNq5b/NJ
	 W3MCoKEy9RoKl8hb/DlxShpHEA1QELD7FN7qnY3bO2s4wvlMxvOe3Jf9Nc8Cj/plRu
	 16bHgXVjEwk7dnPnYlkKXz8CZRjHbKDCbGrhoN/oC7DFUQs185MmUewyCgIDGJiTPk
	 hWSlJm1wmMHKs/qOCfBhdqwfStZFrstMmHlOSAjheLZbn0IwCaAdeOzuFcT1fepT1Q
	 ExZ8MbqZxYPIZf7c/pXuDYy99dChhqstyzprjOg1vkFahATxjPFqClKgU1O+uKOtbL
	 U7hw/gR+mWw2A==
Date: Fri, 21 Nov 2025 08:35:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] generic/484: force I/O to the data device for XFS
Message-ID: <20251121163553.GM196366@frogsfrogsfrogs>
References: <20251121071013.93927-1-hch@lst.de>
 <20251121071013.93927-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121071013.93927-2-hch@lst.de>

On Fri, Nov 21, 2025 at 08:10:05AM +0100, Christoph Hellwig wrote:
> Otherwise the error injection to the data device might not work as
> expected.  For example in some zoned setups I see the failures in
> a slightly different spot than expected without this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Wow, how did I miss this all these years?

Ohhh, because this is an internal-rtdev failure isn't it?

How about removing the "unset SCRATCH_RTDEV" a few lines up too?

With that,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/generic/484 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/484 b/tests/generic/484
> index ec50735a5b58..0455efcb6000 100755
> --- a/tests/generic/484
> +++ b/tests/generic/484
> @@ -42,6 +42,9 @@ _scratch_mkfs > $seqres.full 2>&1
>  _dmerror_init
>  _dmerror_mount
>  
> +# ensure we are on the data device, as dm error inject the error there
> +[ "$FSTYP" == "xfs" ] && _xfs_force_bdev data $SCRATCH_MNT
> +
>  # create file
>  testfile=$SCRATCH_MNT/syncfs-reports-errors
>  touch $testfile
> -- 
> 2.47.3
> 
> 
