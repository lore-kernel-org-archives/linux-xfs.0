Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773D81F1511
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 08:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126583; cv=none; b=ADsftGlU8u4ZEMp/M3b96SLLpr3uhA/g3cBOc8hpd+oP1n+f0HNga1oQ5x2RT2I/IP0X9Qm1zwW1kAfFieYg48JcW7sDRHvJJ7WDeDNvNkvphPWI0PyeyNYc2Nwcz7XZgRfrtap/oxhKdN+NgeFeraRqEpaRYZkRsmv3txCf3Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126583; c=relaxed/simple;
	bh=1WPavJWUj5N07no8BnsdlQzZBmenRdwvzdO50t4E0c4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gu2b7ODvOet2tdaqGCtqmobczSZp0nGdHsfj2tz89EoZzuXz86E/ul/pESzVadMok66l1xv23xrRTxUsIk8sGafR7YgCEznXO9PRh2T95fw1ivQ3hK1DWtuPNFr9mUqX4LcWBtBRzCaVA04N7LLFU0uLYoe9IS1qHQ44yG0C5cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtRpMDR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtRpMDR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D96C4CEE4;
	Tue, 13 May 2025 08:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747126583;
	bh=1WPavJWUj5N07no8BnsdlQzZBmenRdwvzdO50t4E0c4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RtRpMDR9r8mO1EUJBhv+Tjkq/p+rjOQ1eocMzN3O9nm+Fd68V92aeRfWU9hQD3k2L
	 A8yzOgFUrWeREUYv+MP0i7Bwsf925ZcNBucKyxTaIGa6kiJa0A5RQcwrZoRu5XPNDi
	 8G3Mt3u1aodIMLoTCXD23ccmTLEIi8uWHqglYKVWhAHpi8dtyGlxfgl3PLwh97K3yT
	 6pWBiEnd+5mLqG2O0gPSoOQ5oveIQbPa+/uH7Moj/etJNQtTWb8mBFAIr0zZ4A5K78
	 eF9HFD/ZKD98DFRksxE/322lwr6oKP64rizBppywOLY0fldFQQO8iiCW2cRxtvGVTe
	 5WsebUFUHMSgg==
Date: Tue, 13 May 2025 10:56:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, cen zhang <zzzccc427@gmail.com>
Subject: Re: [PATCH] xfs: mark the i_delayed_blks access in xfs_file_release
 as racy
Message-ID: <psbrwt55eunk55bythcohtptyhcbbd5arzxwaxulxabxbzcgvf@lvug4rtwoosk>
References: <b0B7vqX5e__5JIDhxMANuyma5_RcE4wAhgR1-x-U6YY3qUy_mE220aCGAqsZ-LpEDc06cNfseqOGIgVw4BKmVg==@protonmail.internalid>
 <20250513052614.753577-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513052614.753577-1-hch@lst.de>

On Tue, May 13, 2025 at 07:26:14AM +0200, Christoph Hellwig wrote:
> We don't bother with the ILOCK as this is best-effort and thus a racy
> access is ok.  Add a data_race() annotation to make that clear to
> memory model verifiers.
> 
> Reported-by: cen zhang <zzzccc427@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks okay

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_file.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 84f08c976ac4..a4a2109cb281 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1549,7 +1549,11 @@ xfs_file_release(
>  	 */
>  	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
>  		xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
> -		if (ip->i_delayed_blks > 0)
> +		/*
> +		 * Don't bother with the ILOCK as this is best-effort and thus
> +		 * a racy access is ok.
> +		 */
> +		if (data_race(ip->i_delayed_blks) > 0)
>  			filemap_flush(inode->i_mapping);
>  	}
> 
> --
> 2.47.2
> 
> 
