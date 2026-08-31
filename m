Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68353AA1A8;
	Mon, 31 Aug 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199032; cv=none; b=SsXgZmon9oDg6J6MnUeq7oILrsgSeLmGanHeRzhguVLmXyew3yMlsqDjG1GAZVkOkNFT0oZRuo8GRp5Bv8tvPa238hD9AP+paat64YcfikeUh2XRkR11Ls4zBH/sibF7TDQo2M/ei7imQ5oJXe0Be/Ir40wX2eKBVnXY3JVeeL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199032; c=relaxed/simple;
	bh=NfgZi+thNUubjF0AZA/2ThwgqWSDa0sCua91clAzW+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PF0ke2BdMSDzN8rudH5fF6vNoWTEJHFpwCv5UxOY6v5Nle+TAqgjubnvxl+BTK38ROtwRUPw+7tXLFrDwN+1+Pn86culhzhEUypCOG2WNdvZgc9FJCSsFN2SHbDlN3TIGfHO2uS1ddEuTldo80QcsZcgRjFVMonmdWLNJpl6FoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtLT+JgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtLT+JgH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8E9091F000E9;
	Mon, 31 Aug 2026 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788199031;
	bh=xnZu7FLFFCOgixJljZrf4ydD+LeRMBhCpgj6vcr9Mos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jtLT+JgHWwjpHkOVPxOrSb2CUZz/0NND62c2MXj8HPdwxmwe3TqcnbcLXJZYXtvSk
	 1xmHpwS4sT0iq86BrVpsvUn0W9P2p+xpTbkz0coQ6fA6Ei2ON5uuMujcbAx6Vz0Jy4
	 nKZUO4DbokMN2uuIkiXNiimLgBeRBl2mdPWP7DfqO47azlMQMfSuxDGpTa2TOJgU7t
	 /K+zKp8ZPI4qkg7uwqdyoRynoBj1lhePIFPgeW4NFdFpwPdWh64OwI/Xm5fW4t70M/
	 VsOqpNgtTGz9XhSvxLyZgrjjLxf6gkOmjFPLa8Ihe56NsKfr4hfgPhOCbbY+geTGPG
	 W9UPy7CbfmGVw==
Date: Mon, 31 Aug 2026 10:57:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/17] block: export fs_bio_integrity_{alloc,free}
Message-ID: <20260831175710.GG1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-5-hch@lst.de>

On Mon, Aug 31, 2026 at 09:39:52AM +0300, Christoph Hellwig wrote:
> We'll move integrity generation and verification into the iomap
> submission helpers, which means they will be needed in modular file
> system code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio-integrity-fs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
> index 692403dfa047..4f67b34bf289 100644
> --- a/block/bio-integrity-fs.c
> +++ b/block/bio-integrity-fs.c
> @@ -31,6 +31,7 @@ unsigned int fs_bio_integrity_alloc(struct bio *bio)
>  		bio_integrity_setup_default(bio);
>  	return action;
>  }
> +EXPORT_SYMBOL_GPL(fs_bio_integrity_alloc);
>  
>  void fs_bio_integrity_free(struct bio *bio)
>  {
> @@ -43,6 +44,7 @@ void fs_bio_integrity_free(struct bio *bio)
>  	bio->bi_integrity = NULL;
>  	bio->bi_opf &= ~REQ_INTEGRITY;
>  }
> +EXPORT_SYMBOL_GPL(fs_bio_integrity_free);
>  
>  void fs_bio_integrity_generate(struct bio *bio)
>  {
> -- 
> 2.53.0
> 
> 
