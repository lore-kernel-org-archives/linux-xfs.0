Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA37C49DB91
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 16:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142669; cv=none; b=q6m17BHoJUS/Hxz5EuNMBJKvhFe5l5hEEhHfBkxKy1rlEzucyivuDTnS1J1ojlV3vuCvNUHJ0hH9vuk2lWVkbkanpJzdZFde81DTYsHxLiHCTbxw2g/6plborPgliCl/9t9EDOoBMjCEV0FJDGT0YZFlQGoNUIQ3JZn9Dx4kUQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142669; c=relaxed/simple;
	bh=8JFO80Mewk6lvCHIYI/6Emadfgwo7btn0ptYXEOZkOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfyzkFLWYhxvhDysrtG+AZSjM4msPNf5BgjWQ2ufV3euMYdwrQB0YUK1q+dy3UIwZHhmzzQAI02JGrANVnTEeP2MAzzBNpYTKv+ySCohE768co62qxYWUyhwiCXfJk4z5A2TgP1zdm9ySx+1947nwd1IlJeko6riAgU0CrS05VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6OFaOHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6OFaOHv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39A311F000FF;
	Fri, 11 Sep 2026 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789142668;
	bh=yahVQdvxIBtRsXFMPuBPcJD5Ef/mPVnrTVaqcQM/AaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V6OFaOHvnmK8ItUxxnkMDnd7XJdFaKH89XEmFRHc/8TYpiOi7XdZDZU7eF8ltlF+b
	 JCGaRlVhA012syKza3cKW4rs4XkTCWwzZwhSyxomf5RSqgNsVSjT57kBZvgJSFQakY
	 AlrVeQ7SbZSrqfznvTfISuzrVZhh6ZPW7zP6pwKbyNcIXH4cXUIiSkDWfUYr6xnpAj
	 g6bpcR7b/kMIbOGdo7XH2i31baT91+fU0Og0k46R9HRjeaobq3HvQ9jpy32axWQS7t
	 AJPFWneqCqi8LNebsMwFCBKsfRYYPWatnp+8xjQq5aDo393qfvxc+Qkyz9u7vz2FCr
	 Tn/KaKiBwFw6w==
Date: Fri, 11 Sep 2026 09:04:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] makecfg: add a few more file related options
Message-ID: <20260911160427.GI6265@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910659.4047311.5368828900056094997.stgit@frogsfrogsfrogs>
 <aqQjFPaZMbPVIoip@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQjFPaZMbPVIoip@infradead.org>

On Fri, Sep 11, 2026 at 08:49:40AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 08, 2026 at 11:02:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a few more configuration options for directory and inode related
> > options that might cause user-observable behavior changes.
> 
> Why not add those to the original patch?  What makes them different?

Same answer as for patch 6.

--D
