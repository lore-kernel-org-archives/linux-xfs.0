Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A42627E1
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740419691; cv=none; b=IVAx4aRWDA1FsLfair+288VPn8mptuDDxRlogyuY8qA1Z3iGTqnz3JNYieWgnLtU8ZqXijEi6bn62M8LFZlKq8o1F6zr8u8u7ZipTAmBFuDcFtr56XCarcYN12GbPCT+a4S81iIBjriMTC7fl/02+rifSRE0MdTVirDU3S3xtxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740419691; c=relaxed/simple;
	bh=mKntMTeXqKRaUBzaf6GqqM8qYu6PiNeENMAXHpqLARI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZH/cNpF/gbraUtzjg4m9nwR/yjg3Z89w5RfbSxjz/E09+4ZIkl+6dAn9DjypF/Fsyc5u52JXHsKk/AWUGshi07q08fIKePvFeaFFjHgznCVFpIojQT2Q9uf0n/4MYOQV+DnRrmO82qXPFRRgQpiOZqfu2jDiBLOUr7sz2nlavs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwme0ULw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwme0ULw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0C0C4CED6;
	Mon, 24 Feb 2025 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740419690;
	bh=mKntMTeXqKRaUBzaf6GqqM8qYu6PiNeENMAXHpqLARI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iwme0ULwEIafK3+R9DAFi9w0LQb6dlLmsp+JS8HaY6D9lUGx/Pamu1QZ7iujvUsD7
	 l1XdqPrAIvV2CDeLy97yoNrvOtzzzZaocEej7XCWiih6QVmj7NlyWxDRDUcj5Q3mPr
	 DHX49Dlg2S5gVcH0GW9+qpB0NZF9HPN8FSXtNrd8EzotXK2zzRlkeL6wW7GGM4rVg6
	 mJ7A7UtL3ihqyoLshENWLchpJMZqSxy4/xU5IKgbgm2WBummF/H/3+kuAzWeR/43R8
	 X1S7GBKzqzNVuAFfd5aNmqjgiIDNr9i9NZe6BGe3A6heqawW6EMWuOuuRd5aHJ6Pkh
	 CMKks8xzqieDA==
Date: Mon, 24 Feb 2025 09:54:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub: fix buffer overflow in string_escape
Message-ID: <20250224175450.GG3028674@frogsfrogsfrogs>
References: <20250220220758.GT21808@frogsfrogsfrogs>
 <20250224141103.GB931@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224141103.GB931@lst.de>

On Mon, Feb 24, 2025 at 03:11:03PM +0100, Christoph Hellwig wrote:
> On Thu, Feb 20, 2025 at 02:07:58PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Need to allocate one more byte for the null terminator, just in case the
> > /entire/ input string consists of non-printable bytes e.g. emoji.
> > 
> > Cc: <linux-xfs@vger.kernel.org> # v4.15.0
> > Fixes: 396cd0223598bb ("xfs_scrub: warn about suspicious characters in directory/xattr names")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  scrub/common.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scrub/common.c b/scrub/common.c
> > index 6eb3c026dc5ac9..7ea0277bc511ce 100644
> > --- a/scrub/common.c
> > +++ b/scrub/common.c
> > @@ -320,7 +320,7 @@ string_escape(
> >  	char			*q;
> >  	int			x;
> >  
> > -	str = malloc(strlen(in) * 4);
> > +	str = malloc((strlen(in) * 4) + 1);
> 
> Nit: no need for the inner braces.
> 
> But this open code string allocation and manipulation makes me feel
> really bad.  Assuming we don't have a good alternative, can you
> at least throw in a comment explaining the allocation length here?

Ok.  I'll change the code to read as follows:

	/*
	 * Each non-printing byte renders as a four-byte escape sequence, so
	 * allocate 4x the input length, plus a byte for the null terminator.
	 */
	str = malloc(strlen(in) * 4 + 1);

--D
