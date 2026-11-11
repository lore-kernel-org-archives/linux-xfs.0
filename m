Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794396720;
	b=MV+0IoeZM38sMOL/KurnW4oRtBnMMVfqmb/kL1SziZ1gmpkLWilxN19ODrnYy9eog+b+
	 YRoSBBGgQHS4uUjy3orXlwolomZ2ltBGjKwOBM7gOu30JXG7VxYUxmi7vjYNiMHC6Tcdb
	 TJUPPb+qbO4+xfJxgm7fIEJbP58UNWaj3PMpu0Cyi6yDFox8dVzG//eIYcf/6UGmECctA
	 qlguR20NGkXvfhhuj72QE68OecGqE2cug1IxJYHDuxsNVz3quANKVFOX514VADBuB0HKX
	 /y33iHIXtQj91+JzA/+sYxyYnjJdGV3fsoC4Mkt71q4Zifpm64em/INLscYmYA6eAOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794396720;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=35V3MBb3/B+i0WSH1JZearQNILa3rdNf4KCJ9ar7n0Y=;
	b=B+AojX3vubYGiM2q//RAukDX0X12U0q7l7eUa77/J7cdG9DOGkg0GxCTh1CUMfh4Nao6
	 Uu8a35M0f3kkPVP7YKN086zG15aP9sv+dTh+dsy4iMnVL3gqXak1xwUPal5EscDgywkeY
	 G+wtQrnM742s6VBdhvSXC/42Bti6oZoa3H0lnLMSVkfFSg2CEa5Va9X0m9ZONz+hkPcWi
	 1EVMsLWQaMf6AvAS97yc8DjFonCAOG+Szqe9EiU6L/KpddmZdVFNHnYKsolgTmGzDCyvq
	 7LVYZ7BH+GHq81KWu9Nmy/Dk+uRlhXLGp+dxECUOY6luIKHtT49rQnx5AS3mYR+1izw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=obfStFx7;
	arc=none smtp.remote-ip=95.215.58.44
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C5606A321
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 11:31:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF6C5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=obfStFx7
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oqWUGVElRBr5oQDm9wyWE9Xl/dvm1ksZ5tyenrhg2NY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794396716; v=1; x=1795001516;
 b=obfStFx7nGxEJk0Bi6v0awaFc19JwMkH56pO5pke9JK9Kq6n+6cIqv5gwi9RP7bkKiLP2RGA
 YcusUgS9EPQgjDXmwlCdrqQ+AoC2qINVuXePAOzMsXD+51J2F8TfCssGQYRrLg0iAZWo9obGi48
 +VnUnDKr7wV0hMNRGT9eIEaM=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7e5b0a92b0c43409;
	Wed, 11 Nov 2026 11:31:56 +0000
X-Mizu-Trace-ID: 7e5b0a92b0c43409
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 12:31:52 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/25] xfs: add support for reading with data checksums
Message-ID: <avRPwNoGozhWLdJz@quentin>
References: <20261104085929.317544-1-hch@lst.de>
 <20261104085929.317544-17-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104085929.317544-17-hch@lst.de>

On Wed, Nov 04, 2026 at 09:57:20AM +0100, Christoph Hellwig wrote:
> All reads from files with data checksums have the returned iomaps for
> data blocks limited to be inside a single RT csum file block, so that
> each data read only needs to deal with a single checksum buffer.
> 
> All reads on checksummed files need to use ioends so that the checksum
> can be verified from process context.  The ioend submission path looks
> up the checksum buffer and kicks of an asynchronous read of it.  The
> completion path waits for the buffer if needed and verifies the checksum.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  |   3 +-
>  fs/xfs/xfs_ioend.c | 120 +++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_iomap.c |  23 +++++++--
>  3 files changed, 126 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c30e688cfc9f..db834e5e60c1 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -601,7 +601,8 @@ xfs_get_iomap_read_ops(
>  {
>  	struct xfs_inode		*ip = XFS_I(mapping->host);
>  
> -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +	if (xfs_has_rtcsum(ip->i_mount) ||

Shouldn't this be xfs_is_rtcsum_inode(ip) instead of a per mount option?

> +	    bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
>  		return &xfs_iomap_read_ops;
>  	return &iomap_bio_read_ops;
>  }
-- 
Pankaj
