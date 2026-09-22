Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC18481647;
	Tue, 22 Sep 2026 17:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098199; cv=none; b=T+zPZH3hvz1ChDelk6ghyfnL7isheGfht7hkJON/AtvzncRbe9EG8SQTfP7f3/0c0j8ML2PAaU5R9PVqeyVZcfb98F4rSgTvt0aiu4kXSYElh/GMAz4+wQELwlEA6lVFDNKkwY8ARyoX0k5tCaHXKS3zz5aDT9hzn4aBTpeT8rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098199; c=relaxed/simple;
	bh=hE5Ji2v4rNBVxaYKrAAdCUGlkng+pn1ujjr7DDJ0PHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkWOGsvmmEhGaoWR8syP/1r+vnjAlFacv4HmWeAPV0493ea3AYFXdbg9ywY/YMQwbfDNYuAl2uLjPernV1ctsTQBX5DSFWJiCWE58IIwh16EGBqNCcJ347T7NTKFcj21BWmfCXnMNE6JDyWZBNNJFQA2Aqb+skuhsX8ZvrpH2m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WR/oww9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WR/oww9s"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 78E161F00893;
	Tue, 22 Sep 2026 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790098195;
	bh=+SILJjdXfnxvQaHDrRrTX+Bb61DPsA0cuf5+zBTma90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WR/oww9sMGjaVgEdC+949/IY2GPQGRBR8JghbplJ8I5/UVe/3q8NkFcDKtbEmb6m6
	 WwvgLSS6D64Ye1MfZ1iFINDgck2196Cxc2VnioerKZtbTsdfnKjPl2lpo8mJb2oiN0
	 WpV+P+ox89bT/h9eGTrSaqACMcSTf/u0L52Q5dNa72yfxBktVZdA8wUtKJtPpxWzXw
	 C//Ac1Nd2Kdq3aVQPJIPK6Vsp/A6Mp2+cRc6+j9PQ3yC/zKR1WUwjP8SVea0YcYbln
	 QZeguFu0XKMq9pZ56YbFk/575Eu0v16PmmrauPJyDa92k7k2NEPH5QzBPw1UwCWtxf
	 U5E4ussXNvQXQ==
Date: Tue, 22 Sep 2026 10:29:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: pass xfs_trans_resv object to reservation
 calculation helpers
Message-ID: <20260922172954.GR2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120658.181988.9146739765881528995.stgit@frogsfrogsfrogs>
 <arIPvDO2vAM3jGw5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIPvDO2vAM3jGw5@infradead.org>

On Mon, Sep 21, 2026 at 10:18:52PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:16:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs_calc_namespace_reservations computes the directory tree related
> > transaction reservations for a given xfs_trans_resv object.  The helpers
> > it relies on, however, read the live one from the xfs_mount even if
> > we're doing this for minlogsize calculations.  In practice this
> > shouldn't be a big deal since the minlogsize and live reservation
> > objects don't differ in a meaningful way, but LOLLM complained about the
> > inconsistency so let's fix it anyway.
> > 
> > Cc: <stable@vger.kernel.org> # v6.10
> 
> Is this really a stable candidate?  Same for the current merge windos,
> at some point we need to split these fixes into those that could
> cause real issues and those who don't to not flood later -rcs with
> lots of updates.  And this looks like a very clear candidate to not
> rush.

I asked cem if we could just queue them all for 7.4 this morning and it
sounded like he was ok with that, what with ALPS and LPC coming up soon
anyway.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
