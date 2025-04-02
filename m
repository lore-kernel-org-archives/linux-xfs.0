Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36601524C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Apr 2025 05:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743573059; cv=none; b=aZYdWzXpJeR6oaKDWJ9bQdmL7GMOvOVHegmensI8A/N6+8KYbSddNNi19pW5zsu+CunJ475bdBQpczJ1+MmAjGMGp77LbkTaoyW8xi7nPxt9OiP2aEdaEFHFtBbGRCegkDlEkEXuwN9kmkRAwcbIhuhbiRHwdHYmq8jGbZeXwts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743573059; c=relaxed/simple;
	bh=bAzvD5l0qWLJ+5iDSdKjkYGYLjlYKlYi7uxOkyy0nZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YX7gsp/NYA08Dde079v6TArS8kZHIcCKPxb0jZ7sKbajX++EUigy5IQdovVwPqmM8Kdy3+R3ICAvxgefOZIxCp9ZZqM5M36R89M47U3N1FtEMTM1ubs1o5UpxCQHuLHYosMWMve1LX0vIx1nROM3MGKfJohtiI2StkHrUdTiI5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVQpBuqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVQpBuqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB3CC4CEDD;
	Wed,  2 Apr 2025 05:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743573058;
	bh=bAzvD5l0qWLJ+5iDSdKjkYGYLjlYKlYi7uxOkyy0nZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MVQpBuqEt6V5ClNyQ/I1VU5Meq6DvJu381m6j5efoWVDE2WbWPTNcccbGYn8Ea0Hk
	 FwwRQySBmzrexXX8toW06k2vW5pk01rcDAOhY65WQmvsAQhyYcXylDwI8/NkW4ttoY
	 /3fsF7pMPUHxXJSUGkpHqMbaVyR8iylf7QxqmrvF8XV5Wr633i3I6WDFIGbSn6/OkG
	 TaRnC/3nYUusBSs7AHZCCMH9vSBB8xcNfstq8bPWXlZqu+Cm78nWZjS5i5PmEuQPl2
	 MFrGjY1/Al8L0eUmro99jlyVQz9ta4oqJAcFXzOyjuZ3BXt/RVUREFB+0tgf6pzCTh
	 3cNEu8a5LQdQQ==
Date: Wed, 2 Apr 2025 07:50:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Pavel Reichl <preichl@redhat.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@redhat.com>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: Fix mismatched return type of filesize()
Message-ID: <p3dvpjn4pqx72pnfuqwsbwztqvmsnauga6pdzciyg77jccbffk@lhpvtd2j4ipy>
References: <rVcV0bUochTHYCUeMeo8VPv0LODkI0DQY8oB8J3Pf1--Zp8jG4weSLdbo-ME7csTl1V_Cdw3SXvCzwH-8jBFNQ==@protonmail.internalid>
 <20250402002233.GA2299061@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402002233.GA2299061@mit.edu>

On Tue, Apr 01, 2025 at 08:22:33PM -0400, Theodore Ts'o wrote:
> On Fri, Feb 21, 2025 at 07:57:57PM +0100, Pavel Reichl wrote:
> > The function filesize() was declared with a return type of 'long' but
> > defined with 'off_t'. This mismatch caused build issues due to type
> > incompatibility.
> >
> > This commit updates the declaration to match the definition, ensuring
> > consistency and preventing potential compilation errors.
> >
> > Fixes: 73fb78e5ee8 ("mkfs: support copying in large or sparse files")
> 
> I had run into this issue when building xfsprogs on i386, and had
> investigated the compilation failure before finding this commit in
> origin/for-next.  But in my fix, I also found that there was a missing
> long -> off_t conversion in setup_proto():
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 7f56a3d8..52ef64ff 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -61,7 +61,7 @@ setup_proto(
>  	char		*buf = NULL;
>  	static char	dflt[] = "d--755 0 0 $";
>  	int		fd;
> -	long		size;
> +	off_t		size;
> 
>  	if (!fname)
>  		return dflt;
> 
> ... since setup_proto() also calls filesize():
> 
> 	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> 
> How important is it fix this up?  I can send a formal patch if that
> would be helpful, but commit a5466cee9874 is certainly enough to fix
> the build failure so maybe it's enough.

Every fix is welcome, this is something that can clearly be tripped over in the
future.
 
> 
> Cheers,
> 
> 					- Ted
