Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE371280335;
	Fri, 24 Jul 2026 12:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897285; cv=none; b=ATcc+UJykvVNTfoTiTE7NnYl6hxtx1Vm3cW/cW8EycUosLrUvmPvGGVfqEALJmxjdgO5YgBh6e5KN06rvMkJobeP4lBiCYf8ajoGagJG9wdv3ds/3UyEB6BqndnXsDI76hRP9WOG8NZDwWIXZL5FJvugZSuec41dst8n7LleM6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897285; c=relaxed/simple;
	bh=CnE5O4uHVrLBzSi3Mn+L+2J7mE9Ep0Zn8ByryFdYAoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HfH2g5YLRGQBOk/AWitVcPAFFutZNi05+51A3OXsRIO+awlgxQ4CfQaQuKYq/u8DC3pQ04uirbjDUC8Gii57CHwgFPiN1pm6W1FfBfZyKY30VD67CuxS98sTqYsZRThbMvK/nMvzyDjZRM3c1PD2vXbkR6Oy6ShMLzajKFFeEHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJhIqkBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJhIqkBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C2B1F000E9;
	Fri, 24 Jul 2026 12:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784897283;
	bh=x03Q1oAfo+dNzaSpFrHI/pMCaAPr+jTry/+A/jodG9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DJhIqkBnT854TcQWlFC4FOqzGyds2ugGVaJCOGHZXsQr1GtEEUFMalkL5VUEZBYtb
	 l9tKP1obi4UkDitgjoPlnA4UFeZA2QOClMEmTq6+0tqjSB9srAvY4a5jsfiiPFVLmO
	 urTm8BF4kvAeocaPqGMf/7nJrZr6d76TZ5LuG6Eg1ZCtBljXDfuhiXn2Mxw2ZWesEv
	 58ev2a1rh1qUCNTvou1sEqudF84h4mW+e/o47/Ja1ingY41YpQM8z0K8x88AVcmii8
	 ISLG6+EGPLyJPMJhO90gR54B17GrwSnGg9K1bAq9waQ7nqFnByu6YOHePNvwyokJTR
	 KLNt4iFgAquvg==
Date: Fri, 24 Jul 2026 14:47:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Joanne Koong <joannelkoong@gmail.com>, changfengnan@bytedance.com, 
	Christian Brauner <brauner@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from
 iomap_dio_rw
Message-ID: <amNerp4LwjSkHS5t@andromeda.toxiclabs.cc>
References: <20260722124931.3159664-1-hch@lst.de>
 <20260722124931.3159664-3-hch@lst.de>
 <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
 <20260723045347.GA6641@lst.de>
 <20260723151021.GC7380@frogsfrogsfrogs>
 <amI3Kf3lFz4FMqXh@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amI3Kf3lFz4FMqXh@mit.edu>

On Thu, Jul 23, 2026 at 12:08:21PM -0400, Theodore Tso wrote:
> On Thu, Jul 23, 2026 at 08:10:21AM -0500, Darrick J. Wong wrote:
> > > Yes.  Sashiko also reported that yesterday and I replied with a patch,
> > > but I now noticed the report and thus my reply only went to me,
> > > a sashiko-review list and Ted, but not everone else or the lists.
> > > 
> > > WTF?
> > 
> > Sashiko doesn't email the lists by default, and I don't think we want to
> > turn that on for the fsdevel firehose.
> 
> Whether or not the review goes to a mailing list is up to each
> subsystem to determine.  Some people have violently objected to the
> review going to the mailing list, which is why it's optional.
> 
> I have asked to have ext4 reviews to be cc'ed to the linux-ext4
> list[1].  It would be up to the VFS maintainers whether or not we want
> to enable it for linux-fsdevel.
> 
> [1] https://github.com/sashiko-dev/sashiko/pull/365
> 
> The XFS maintainers can request if patches cc'ed to linux-fs should
> get reviewed and sent back to authors and/or the maintainers and/or
> the linux-fs mailing list.  You can either ask the Sashiko devs to
> edit the email_policy.toml file, or you can send a pull request yourself.
> 

IIRC the discussion we had a while back was to keep the reviews emailed
to authors only...

Now I wonder how feasible would be to have a "linux-xfs-review" list to
send sashiko reviews to, then people opt-in to it? Would it be overkill?
