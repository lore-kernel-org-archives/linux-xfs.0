Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D74340D9D
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 18:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764874086; cv=none; b=NSSbM50x2cIGSMXffQ5IdTbKAk5DCMm/CHIh6IUMM8qDWuAIknhE5ByH7hWh603/4J25YD5qnSHjsWrX/T2TGhqqkElO0V1r6hdcDhpr76ZFe/UPF+frkHQUueVdnBwvcriTOydTddYJY+2BTIHwa38fY1SSH0J12Q12/6dPlb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764874086; c=relaxed/simple;
	bh=LrB5r8LxhUjnkaSWrfHJ7k+i/ZKpj+8/CAON0TTc5Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0sJTkpAPNYfntantw5s3m5gCW4BXZySPmexu+3/Ja1zF3TD/mIBxbFncq5lc2VhuzpmT54D7lg9x3RTlFdNBu3tX/ZBrfTnh5cz8VrhdR7uAf64XaKUkJGL1xPNGb2aJpc9GXLeYia2uOFkJlVYG3utNPZUL1hDCigHw67mVwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tt4t6TuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tt4t6TuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC6AC4CEFB;
	Thu,  4 Dec 2025 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764874086;
	bh=LrB5r8LxhUjnkaSWrfHJ7k+i/ZKpj+8/CAON0TTc5Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tt4t6TuW416g8LUtP3nny1AU6cpZ8BLO88OTkTVxHDJ4J7gSn7WnYd6zBSHCXt8Xw
	 8z/K+nUqktxbYnahRZBKZnaTRBmoLkWqzO5l/MLWmT1J81SJipcapI06hpTNIHiddw
	 xeTE32OIOu9uT1VRb4cbQEtioM6G3S4pIWs3jL20Ho42WWW7gkxbL9QOwnGSAZBQo3
	 2Zp/XnuqgrWCzoGfdrzmyn4KlMguVZuBvVTCMytgxAV9HGO/YBdW1RJm2iLk+uQHzf
	 fSbUKwunDpHPlk26ZRm21u3obL5N9iPz9uAZsMOePQAy+WPHBu2Q8r/OBFafNAWP+9
	 VOgXGZ+JeY00g==
Date: Thu, 4 Dec 2025 10:48:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <20251204184805.GK89472@frogsfrogsfrogs>
References: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
 <176463876397.839908.4080899024281714980.stgit@frogsfrogsfrogs>
 <aS6Xhh4iZHwJHA3m@infradead.org>
 <20251203005345.GD89492@frogsfrogsfrogs>
 <aS_ZOpzcp04ovBwk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS_ZOpzcp04ovBwk@infradead.org>

On Tue, Dec 02, 2025 at 10:31:22PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 02, 2025 at 04:53:45PM -0800, Darrick J. Wong wrote:
> > On Mon, Dec 01, 2025 at 11:38:46PM -0800, Christoph Hellwig wrote:
> > > On Mon, Dec 01, 2025 at 05:28:16PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Since the LTS is coming up, enable parent pointers and exchange-range by
> > > > default for all users.  Also fix up an out of date comment.
> > > 
> > > Do you have any numbers that show the overhead or non-overhead of
> > > enabling rmap?  It will increase the amount of metadata written quite
> > > a bit.
> > 
> > I'm assuming you're interested in the overhead of *parent pointers* and
> > not rmap since we turned on rmap by default back in 2023?
> 
> Yes, sorry.
> 
> > I see more or less the same timings for the nine subsequent runs for
> > each parent= setting.  I think it's safe to say the overhead ranges
> > between negligible and 10% on a cold new filesystem.
> 
> Should we document this cleary?  Because this means at least some
> workloads are going to see a performance decrease.

Yep.  But first -- all those results are inaccurate because I forgot
that fsstress quietly ignores everything after the first op=freq
component of the optarg, so all that benchmark was doing was creating
millions of files in a single directory and never deleting anything.
That's why the subsequent runs were much faster -- most of those files
were already created.

So I'll send a patch to fstests to fix that behavior.  With that, the
benchmark that I alleged I was running produces these numbers when
creating a directory tree of only empty files:

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
real    0m12.742s
user    0m28.074s
sys     0m10.839s

real    0m13.469s
user    0m25.827s
sys     0m11.816s

real    0m11.352s
user    0m22.602s
sys     0m11.275s

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
real    0m12.782s
user    0m28.892s
sys     0m8.897s

real    0m13.591s
user    0m25.371s
sys     0m9.601s

real    0m10.012s
user    0m20.849s
sys     0m9.018s

Almost no difference here!  If I add in write=1 then there's a 5%
decrease going to parent=1:

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
real    0m15.020s
user    0m22.358s
sys     0m14.827s

real    0m17.196s
user    0m22.888s
sys     0m15.586s

real    0m16.668s
user    0m21.709s
sys     0m15.425s

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
real    0m14.808s
user    0m22.266s
sys     0m12.843s

real    0m16.323s
user    0m22.409s
sys     0m13.695s

real    0m15.562s
user    0m21.740s
sys     0m12.927s

--D
