Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E70351C25
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 06:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788849410; cv=none; b=WgaNKzTOofrYzQY/YCjR3+6RovMG0FbpO6flrMLo27i0UHyEtAwyeMcnDkvAauVLiIiYuwA184zXHyGnRCnieKMlCQthZAnb2KVCbjRSGMqPRpWiY3Sj1B+sdgiCSGwtdy3Bn6jkuXZHM71TzqWoCvAJ7U6QSHanMFB88Otv1g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788849410; c=relaxed/simple;
	bh=nyCC4pbhSjeV4tRLEDcM9disokcUoecie4cENWiIqf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGckqzB0Lg2CzcTpOiExa9tBPFMgXt7u4icfHABw72MBTLFRMNNAaV9xep5WXDqZsGCKoOYBq3luGBkUGfQYqsqS/Vp2JjkK4geDcD7/+/pOFSgKamq9Gq6jujwHl4Br4dsPfrrMgcva/95hxauHDmLuJJ+9UNuSx4SVNEBYd1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H42HxZ3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H42HxZ3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDDC1F00A3A;
	Tue,  8 Sep 2026 06:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788849409;
	bh=P9U7dSDSI45+oRFb8ME9/bbjBmDPfXwK+rGb2diSXcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H42HxZ3aje/9JysmZ/IcgeLxjtGjpIK6LD93CdeAZm4ZZhmp1DzGCI7uCAiynvJ2M
	 c3Zk2vXXboQd1kIT2O2AlVStnp3ScpLNmYmr0id3YBabvNz0Qh+AH6niaPXe6+EUJu
	 pWJAbTObmwGI0iIm7aZGYtnrZQUfrrOdPGGSGoQGp3mjdR0Mc1YIWf7hSJp+ty7y66
	 Synfb3xJVSCfxWRAFLKCPALEQt6PkFZpnKEjqfcspuLUhq2jdUCAMVOJ1BhuKD/j4E
	 4p8gg6F1O1C9rbhO8dlXT4FbYJBhvumVKyGR/P5u1khMgmEkZksxwQ+/5bkPV40v+t
	 eAb7iwxQdPf0Q==
Date: Tue, 8 Sep 2026 08:36:45 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] xfs: enable xfs_trans_cancel() to report and
 error code
Message-ID: <ap-sZcngHkwg-S33@andromeda.toxiclabs.cc>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-3-cem@kernel.org>
 <20260905011054.GF1933798@frogsfrogsfrogs>
 <ap5UR8Wlz18xKXFX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap5UR8Wlz18xKXFX@infradead.org>

On Sun, Sep 06, 2026 at 11:05:59PM -0700, Christoph Hellwig wrote:
> On Fri, Sep 04, 2026 at 06:10:54PM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 04, 2026 at 01:32:22PM +0200, cem@kernel.org wrote:
> > > From: Carlos Maiolino <cem@kernel.org>
> > > 
> > > Once in a while it's useful to know exactly what kind of error caused a
> > > transaction to be cancelled.
> > > Enable xfs_trans_cancel() to receive an error code to be reported.
> > 
> > Stylistically I think I'd rather have an explicit @error and some macros
> > to avoid the va_args machinery.
> > 
> > 
> > void __xfs_trans_cancel(struct xfs_trans *tp, int error) {...}
> > 
> > #define xfs_trans_cancel(tp) __xfs_trans_cancel(tp, 0)
> > #define xfs_trans_cancel_with(tp, error) __xfs_trans_cancel(tp, error)
> 
> Agreed.
> 
> 

Thanks! This is easily doable, I just wanted to avoid that on an initial
patch to don't clobber the patch with the changes. I'll get them ready
