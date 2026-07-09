Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690F63290D5
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607587; cv=none; b=DJkGDi5w5oi7XH6KWMWifB0lXT2vQ9Tb4kF3ziAC6oqMb2QdM/C1R9ncuUyFTxuf6+FI5l/ujTWErXkb0sBdFqn/qjjfjKzj1p+2JUDWNNf7PJCZ2ivfMnMFugTvL7Eet8eJwf2m2hUCEEUFINgvWFqRJ9CjyTkIFHa/OBgNi5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607587; c=relaxed/simple;
	bh=7Y1szqPxk2mClRgbEu9d7zRu7EzvzLJHRwfXqAev/Yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPMWEaxXGZQTgyIODfnKhtRc3O+nTjk9gk+Ojespa2lH7Zf4QtLCAAczcgkPI9RRDXlnWbbZqX3aJ7+nTHT9VoeprhqAzm0tnzIKH//kD2dfPhxjTFluYKC9GAzsnBoFNcV81rQc3W1Cuw/la8tYIBuW7n7u7l5Te1Qq5cEydnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ib1IFgTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ib1IFgTD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3C5CB1F000E9;
	Thu,  9 Jul 2026 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783607586;
	bh=OoesXSTF1DE1Xgic8AmMeLJES7r9I8uEEEK2ljkKWuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ib1IFgTDTRVw/HE5vahDfWKHOrU9zTK2l0g+vbRiDTMKZQrZ2fmeg4Wv1vahdC88F
	 pzKvhES14ZlFSB+9xoLPaDIb/kfmCuZsB2VpS2/+4G1ZFrN4Ys5so9w11mwBC+IdDw
	 OV3O14xm9aM2f+f/yFIhGf7PcdymUKKP0QFMPiWIPIfctcuzHEMYvsGLfUqgg532ol
	 PL/oF33OiaxlPP1AkDz136yN/7oVh+VT1szQ8+qWozuwEB2MSxqQRSVi+HxATqaFfx
	 bHRpMbd0KmpNbVyFKiu1WCrpaa4KWXu3xwKKEoRc64WzQntePrBSBO/kmfWTN6sT+9
	 awDGJapoJNJbg==
Date: Thu, 9 Jul 2026 07:33:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Manognya Singuru <msinguru@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@redhat.com
Subject: Re: [PATCH] mdrestore: fix extent length overflow in v2 restore path
Message-ID: <20260709143305.GC15210@frogsfrogsfrogs>
References: <20260709103915.275363-1-msinguru@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709103915.275363-1-msinguru@redhat.com>

On Thu, Jul 09, 2026 at 04:09:15PM +0530, Manognya Singuru wrote:
> Aisle Research reported that a crafted metadump v2 extent
> length can overflow the signed int used for length,
> leading to incorrect size calculations and a
> potential heap buffer over-read in restore_meta_extent().
> 
> Change the length type to uint64_t and ensure all size
> arithmetic in 64-bit before converting to size_t for I/O
> calls.
> 
> Signed-off-by: Manognya Singuru <msinguru@redhat.com>
> ---
>  mdrestore/xfs_mdrestore.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index f10c4bef..9c7f77e0 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -395,11 +395,9 @@ restore_meta_extent(
>  	char		*device,
>  	void		*buf,
>  	uint64_t	offset,
> -	int		len)
> +	uint64_t		len)

Please make the indentation consistent with the existing code here and
elsewhere in the patch.

>  {
> -	int		io_size;
> -
> -	io_size = min(len, MDR_IO_BUF_SIZE);
> +	size_t io_size = min(len, MDR_IO_BUF_SIZE);
>  
>  	do {
>  		if (fread(buf, io_size, 1, md_fp) != 1)
> @@ -428,7 +426,7 @@ restore_v2(
>  	int64_t			mb_read = 0;
>  	int64_t			bytes_read;
>  	uint64_t		offset;
> -	int			len;
> +	uint64_t			len;
>  
>  	block_buffer = malloc(MDR_IO_BUF_SIZE);
>  	if (block_buffer == NULL)
> @@ -442,7 +440,7 @@ restore_v2(
>  			XME_ADDR_DATA_DEVICE)
>  		fatal("Invalid superblock disk address/length\n");
>  
> -	len = BBTOB(be32_to_cpu(xme.xme_len));
> +	len = BBTOB((uint64_t)be32_to_cpu(xme.xme_len));

/me wonders if BBTOB ought to cast its parameter to uint64_t but this
change here avoids shift truncation if xme_len is large, so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  	if (fread(block_buffer, len, 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
> @@ -503,7 +501,7 @@ restore_v2(
>  			break;
>  		}
>  
> -		len = BBTOB(be32_to_cpu(xme.xme_len));
> +		len = BBTOB((uint64_t)be32_to_cpu(xme.xme_len));
>  
>  		restore_meta_extent(md_fp, fd, device, block_buffer, offset,
>  				len);
> -- 
> 2.54.0
> 
> 
