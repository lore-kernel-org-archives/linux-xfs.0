Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBB430C618;
	Tue, 28 Jul 2026 04:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785211286; cv=none; b=rX5vcqguhszM+3RQCPPT//Vzc5igCCKLXZ9ggFx+6YJ+NGUNaSh9UBbdszStN7+h46+fRC9oeGgVK4UJlw2kMWKvS7Mf/GHzJmuQFKkc57pmErcNv+9PaiaoqUE3Q9Lf3HzOCWqmiwxBDFqXpxuRzLlNKohf69lK1na5s3AN5TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785211286; c=relaxed/simple;
	bh=faHX5i85zebVWjKFu0EE6bu5qzTsxOvkJ1xSUWLRy2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFik8awJ8zfHy44E/0wHY8yxCdvxgK5TDKTQcFxk2g6Ypvqtfp/Kd1cv52Cqn+nFImC3EJxER412HUFT9EU8YL0NTDec7/TyrjzF0JgAdWylQ9Vnbi7TodNLbqaBqM9LgcGz38hCX309DyEdW3ND3WSemZ47tFVCoLCTPp3vgl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB55668AFE; Tue, 28 Jul 2026 06:01:20 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:01:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Joanne Koong <joannelkoong@gmail.com>, changfengnan@bytedance.com,
	Christian Brauner <brauner@kernel.org>, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	workflows@vger.kernel.org
Subject: selective Sashiko replies, was: Re: [PATCH 2/3] iomap: decouple
 simple direct I/O reads from iomap_dio_rw
Message-ID: <20260728040120.GA19400@lst.de>
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-3-hch@lst.de> <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com> <20260723045347.GA6641@lst.de> <20260723151021.GC7380@frogsfrogsfrogs> <amI3Kf3lFz4FMqXh@mit.edu> <amNerp4LwjSkHS5t@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amNerp4LwjSkHS5t@andromeda.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 02:47:58PM +0200, Carlos Maiolino wrote:
> > Whether or not the review goes to a mailing list is up to each
> > subsystem to determine.  Some people have violently objected to the
> > review going to the mailing list, which is why it's optional.
> > 
> > I have asked to have ext4 reviews to be cc'ed to the linux-ext4
> > list[1].  It would be up to the VFS maintainers whether or not we want
> > to enable it for linux-fsdevel.
> > 
> > [1] https://github.com/sashiko-dev/sashiko/pull/365
> > 
> > The XFS maintainers can request if patches cc'ed to linux-fs should
> > get reviewed and sent back to authors and/or the maintainers and/or
> > the linux-fs mailing list.  You can either ask the Sashiko devs to
> > edit the email_policy.toml file, or you can send a pull request yourself.
> > 
> 
> IIRC the discussion we had a while back was to keep the reviews emailed
> to authors only...
> 
> Now I wonder how feasible would be to have a "linux-xfs-review" list to
> send sashiko reviews to, then people opt-in to it? Would it be overkill?

The main problem is that reducing the recipient list for replies is
incredibly stupid.  You can do that for a private offlist conversion
on something sensitive, but not by default.  If I get a reply, it needs
to go everywhere.  I have to admit I find the sashiko replies a lot
less useful than the web interface, but the important bit is to be
consistent.
