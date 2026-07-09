Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80452DEA9D;
	Thu,  9 Jul 2026 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783615533; cv=none; b=R+3h/N2zGwWutPoYF5K/P5P6dtXFa1Tg4glZNe3m01XIElyVebn67hk+myoMKfIzZaTDhvczJrXi5pnjHcpS+0JeY+Bn5DXYJ41FYiGmf+hPqCk648dnf0Xt1ljcOXfe7Pre9HS3QJQrSZEwlrpiuJ4nxQ0ft4hqeb7Ww6QYO3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783615533; c=relaxed/simple;
	bh=z6iuGu0wex3B78eriiKYr6JMMGbJvRWhL6lGMileugY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZ6+BPAyoXofIENEzV7pUclRQ8QIT3qjBh/+bC4mykm93+RB3SZQ7be9CvQ3cF+WANKChfzWiwattJ6WjfDBO0H2k9lTybCIKqa2bSsGsi/E3Q2dcWBVMJIgLe908MwyyluDRSsqZ3AQQZAYf35Vz6fBsEpqc3pSSx49EkCE0gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgYyLkOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgYyLkOU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 04ADF1F000E9;
	Thu,  9 Jul 2026 16:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783615532;
	bh=wV00Vl0MiDr3tSINkDZ/92OQYlqFmmYFNOocSOCzejM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mgYyLkOUHqT1T2QKuxK3J8dHCNYrqpgAqy6Vd+n0qkOyhoV51BTu8+OZyhfZLCCxa
	 Zd+8oJj6D29p57BQmDDxjQsd23TlGp8ZuDhUkE5C4tk62LOzrcYHMtU2zL6G8u9WYE
	 ADOJAUVnFGCQz5p5baBWmbY+nvqH5+u/rN9elDAsm83ZHYti2Azvm363I+HAqJhGqD
	 /O8wbXLYaYl+VXt1I/1rv0932rUdHeVOQGY1D0Gw9JNvGZvmgHHEa8JbLflgA8yLe7
	 5H4A2EDuyYTtWB58pzQP2PAvIiKQIkIQ7/Kq/b5120ivrFFaLj2lubxa45lkOU2Ysu
	 mhaP+ZG2BsFbg==
Date: Thu, 9 Jul 2026 09:45:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: don't replace the wrong part of the cow fork
Message-ID: <20260709164531.GE15228@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
 <178346726108.1271589.7681324440256265003.stgit@frogsfrogsfrogs>
 <20260708091220.GA5902@lst.de>
 <20260708152516.GG9392@frogsfrogsfrogs>
 <20260708175743.GI9392@frogsfrogsfrogs>
 <20260709044738.GA15144@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709044738.GA15144@lst.de>

On Thu, Jul 09, 2026 at 06:47:38AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 08, 2026 at 10:57:43AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 08, 2026 at 08:25:16AM -0700, Darrick J. Wong wrote:
> > > On Wed, Jul 08, 2026 at 11:12:20AM +0200, Christoph Hellwig wrote:
> > > > On Tue, Jul 07, 2026 at 10:03:24PM -0700, Darrick J. Wong wrote:
> > > > >  static inline void
> > > > >  xrep_cow_replace_mapping(
> > > > > +	struct xfs_inode	*ip,
> > > > > +	struct xfs_iext_cursor	*icur,
> > > > > +	struct xfs_bmbt_irec	*got,
> > > > > +	struct xfs_bmbt_irec	*rep)
> > > > 
> > > > This looks like something that should sit in xfs_bmap.c (or at
> > > > least xfs_bmap_util.c) and not in random scrub code.
> > 
> > To push back on this: there's only one user of this, why not keep it
> > local to the scrub code?  AFAICT there's nowhere else in xfs that needs
> > to replace a subset of an existing cow fork mapping with another
> > mapping.
> 
> Mostly so that all the code doing hairy operations on subsets of
> bmbt_irecs is kept together...

Ok.  I'll do the move as a separate patch though.

--D
