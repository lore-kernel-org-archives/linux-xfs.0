Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669D5130492
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713283632; cv=none; b=PuDo7TXJysohmWmv2bgWamm7OK6rNUr7so2zk5JBJ89h8I+Q8V09fdlYeweKJb/7jefVImXSKZ3ndoiiSU3Xv+D/7bg90cyqM28IAe0MCOClnfhzL9I7ECYEPMVvXiHXRhdH9GmeUXYj/kVdoiKbZb9odYod5J7d2ckjl/A5nj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713283632; c=relaxed/simple;
	bh=rYOEw5vSB0mk1ve9lOi48LcX1/bRvwr1PBrP/mJLmsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBEr/HEc+26PAcfN7OSuYYJnp2eZIR33tZEnHqH/BABvk5GqXmCfmqW23kCisM85XY518aY/94Qv6Gd8kkJXr77REUl4azY1a7lDHe2UDwHEImDrUBk0aV1TZvezjYsvwTXFFzhvfnIvnBlvfIF8mNA4onX1Kz7gwk4uo7H854M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvTj7yai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvTj7yai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDFAC113CE;
	Tue, 16 Apr 2024 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713283632;
	bh=rYOEw5vSB0mk1ve9lOi48LcX1/bRvwr1PBrP/mJLmsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uvTj7yaiIux5nltjgaX2LH3HBleFVcZ/dkRwAtTB4iydaTMY8qjr+fJJpxSFgHD4B
	 iRfZZqhxvvhuYc5C+cGf6uqypU+BMEtDC8d/iUg64ZoPkjye6S5vfcgLaui0rto4Qq
	 m2TeYqt4lg68oWWjU8T79l1+8MCu8j9BimwyDT779crhaUx5ywJv0Bz70HXmcf3G4O
	 09UZTetL9bcak+IFLeasBE7h8/+znDSyj3ROI42zCsteFB6v8mxGDCTmIlisaa1OU1
	 o1nKSiOUnnryOxUMna5RVM4qJZE4yNdLjBzpH//uf4MUlXDTwbqKaJE5avO7UqvdZZ
	 GrKCFqGRQAQgQ==
Date: Tue, 16 Apr 2024 09:07:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_db: fix leak in flist_find_ftyp()
Message-ID: <20240416160711.GJ11948@frogsfrogsfrogs>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416123427.614899-2-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 02:34:23PM +0200, Andrey Albershteyn wrote:
> When count is zero fl reference is lost. Fix it by freeing the list.
> 
> Fixes: a0d79cb37a36 ("xfs_db: make flist_find_ftyp() to check for field existance on disk")
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Yep, that's a leak.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/flist.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/db/flist.c b/db/flist.c
> index c81d229ab99c..0a6cc5fcee43 100644
> --- a/db/flist.c
> +++ b/db/flist.c
> @@ -424,8 +424,10 @@ flist_find_ftyp(
>  		if (f->ftyp == type)
>  			return fl;
>  		count = fcount(f, obj, startoff);
> -		if (!count)
> +		if (!count) {
> +			flist_free(fl);
>  			continue;
> +		}
>  		fa = &ftattrtab[f->ftyp];
>  		if (fa->subfld) {
>  			flist_t *nfl;
> -- 
> 2.42.0
> 
> 
