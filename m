Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0910F1482E1
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 14:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740406277; cv=none; b=AgZwhvK9OCb4u0L3n5RgOagBSCYMUj1NbQTeWVE3yfpo0TyUKPcaAbR9qrAMpiJjoplCiNQ6CKlXTXQRCoFuBEUl5GcpZRRZ2APSI66d38N2b0CkJzbTr/JZvUxU5OK5B3MRXNvCxOP4lPqk/H+IQ7TrPXJr5WFFYdCC2Qv7ZcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740406277; c=relaxed/simple;
	bh=sCjdFXzj1sw0dp4qAE5FojUl3PUZL5UpbiX06fDh/FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+9dvMfKvK9MrjCUAbqVo2tIF8RvOWs+m5bSLWfXdoZsOGGh0sDQFPqpb/7FQs5yV/ItGesXTeBEaFSlsGH59JhDTJ4dSi0h8DzF/lIVD00u0mCL/WQVYyhm+owczXc61kPpmYgCYsNOOoqsdrG8y+4ELYPKra/AbTdJBJQt2AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE17168B05; Mon, 24 Feb 2025 15:11:03 +0100 (CET)
Date: Mon, 24 Feb 2025 15:11:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub: fix buffer overflow in string_escape
Message-ID: <20250224141103.GB931@lst.de>
References: <20250220220758.GT21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220220758.GT21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 20, 2025 at 02:07:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Need to allocate one more byte for the null terminator, just in case the
> /entire/ input string consists of non-printable bytes e.g. emoji.
> 
> Cc: <linux-xfs@vger.kernel.org> # v4.15.0
> Fixes: 396cd0223598bb ("xfs_scrub: warn about suspicious characters in directory/xattr names")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  scrub/common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 6eb3c026dc5ac9..7ea0277bc511ce 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -320,7 +320,7 @@ string_escape(
>  	char			*q;
>  	int			x;
>  
> -	str = malloc(strlen(in) * 4);
> +	str = malloc((strlen(in) * 4) + 1);

Nit: no need for the inner braces.

But this open code string allocation and manipulation makes me feel
really bad.  Assuming we don't have a good alternative, can you
at least throw in a comment explaining the allocation length here?

