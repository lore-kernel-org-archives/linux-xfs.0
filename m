Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A7B1F8EEF
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734466741; cv=none; b=tptavEZNeHZtoBuK/uYKbExPVpKz9A/e9IqWEr8FDtEGJLpOHFiJAPGdRHqueaoYjyYSC8CvishYjxvMAztqA2tKfj9eE6aR6RB1HUO/Wg92rSaEBWJMB0eNK4GltaAYRdJIh2izxXcVrf57WcdfgQmcaJDEavY8cjgG+4ne18Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734466741; c=relaxed/simple;
	bh=TOV5nLzdSmzbc07urlrsn1eAe4qlQwB/sWGzyiq0FuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gP7J3BAQd2mXpn9IxxAsH2wG5aFiY4925OK7zIeZ6qYGmNp0Yth5b4E2cwam7k/xRYbQngOw12cN3T9vN1VCcFv78KSrcb+TvAtkn7fFgWnVeXorvf7qLLhEmT/DwscKoMf/cnThi3lykWCveSF0HPFc0PltzMA9nzuKAnXNpdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWMHH2BR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWMHH2BR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F318C4CED3;
	Tue, 17 Dec 2024 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734466739;
	bh=TOV5nLzdSmzbc07urlrsn1eAe4qlQwB/sWGzyiq0FuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWMHH2BRtaOnUNXDeJ0O9TZXlVCauk0n/EvK+gFQZAx9KqjgxBtCadKRbqR7D8d4N
	 iW6sMFxUXwlBiBnSQZCxJwp2gdlOn/Y2MypZI8PsDYoQ/lzui4a9nZQMvHUVpaFi5M
	 6bIDpg3m+dSa4oQB7pgeFLNyReX1bbwckJcoYGAvchKHlWuoSXlWyJ0gPPqST1zo/R
	 OgeV9L2xxYupEN4qCs9krO+IqX78pEKgMLU017Sa/JJBwJGSq6DfCydYvzvUSvJfRT
	 CJ6q59ESMwQHAu17Vhrg1H7kDIjVufEsE4ZFvXnd1w4sonTmMojgl8LZBtO3YPqAbg
	 //fmVc0ubEkPg==
Date: Tue, 17 Dec 2024 12:18:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/37] xfs: pretty print metadata file types in error
 messages
Message-ID: <20241217201859.GR6174@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123485.1181370.4679130203707005497.stgit@frogsfrogsfrogs>
 <Z1vUf5fuyMJk346p@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z1vUf5fuyMJk346p@infradead.org>

On Thu, Dec 12, 2024 at 10:30:23PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 05:03:11PM -0800, Darrick J. Wong wrote:
> > +static inline const char *
> > +xfs_metafile_type_str(enum xfs_metafile_type metatype)
> > +{
> > +	static const struct {
> > +		enum xfs_metafile_type	mtype;
> > +		const char		*name;
> > +	} strings[] = { XFS_METAFILE_TYPE_STR };
> > +	unsigned int	i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(strings); i++) {
> > +		if (strings[i].mtype == metatype)
> > +			return strings[i].name;
> > +	}
> > +
> > +	return NULL;
> > +}
> 
> Having this as an inline helpers means not just the code, but also
> the string array is duplicated in every caller.  While there are only
> two with your entire series that's still a lіttle suboptimal.  Maybe
> move it out of line to xfs_metafile.c?
> 
> And make the array file scope to be a little more readable.

Done.

--D
