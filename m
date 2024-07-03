Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8005A17C60
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 05:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719983854; cv=none; b=pBgQl4JQkVncXjKQcLkP8DNTa1KaY0i67NQSTZNp+2CXEtkulGiJx8NvrNQhGd6UyyhZGA/jXEhGA/+V/mdrwReOsEUbRJlj0w9EzBda7mUG1Z9hLvR1YO0UnnpqwFKe6hl5R0i1D2w0zIfRM+QVMVmmBOoBtUz0HNMXBSru4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719983854; c=relaxed/simple;
	bh=lN2Odru+0OnOFtcpJhZg0AiGTtQK9UB+4RO+LHusBjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nc8UfhcwlQqNwzJdbeZdmYOVvniUWebXgYWglS7VU4+FXs7qT5oapcKZwcd7OH7KZBh7c9AY4luukDSTNIq65SEtJdM/h/Uh9Xn27Iz0kobaNZYNlIoTJlBQ9flcFbhnTVzbfxrcXW0+lltMODb9R2ZwFlZMRDUJtxfCnXVNMyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnBAfDRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnBAfDRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145C6C32781;
	Wed,  3 Jul 2024 05:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719983854;
	bh=lN2Odru+0OnOFtcpJhZg0AiGTtQK9UB+4RO+LHusBjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tnBAfDRyVPI8yU9s98P36P00eMOUklFsootd3wQMZGTGtdaVunOnnVsEAdqgYK9PM
	 WgYU0pqY9LPPqPu24insa1XqiJ4cmw2Q7/JZLqpSQDLHLNVBzw6teIZjphmnAtPJMB
	 AjNW2FVw9+quT/C5VezHfj7Zn02wvkcyaDohMcGMre0rkRvSk8szz6iiX/CeuqhXG5
	 I7vhUObLyWAzVYDM0l/hFKRqScW2kZGHjmFn/yt2P3O0YHOxcVHEACgIFiVxozrlS1
	 yu/DPmdfsPYQ+QqibDc/0HewpKVgECzgOIzNIYuV1EHnC5q5u/3mOrxV2UWYn0uV1+
	 njUvlWhszuFbQ==
Date: Tue, 2 Jul 2024 22:17:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240703051733.GG612460@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
 <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs>
 <20240702053627.GN22804@lst.de>
 <20240703022914.GT612460@frogsfrogsfrogs>
 <20240703042922.GB24160@lst.de>
 <20240703045539.GZ612460@frogsfrogsfrogs>
 <20240703045812.GA24691@lst.de>
 <20240703050422.GD612460@frogsfrogsfrogs>
 <20240703051150.GA24923@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703051150.GA24923@lst.de>

On Wed, Jul 03, 2024 at 07:11:50AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 02, 2024 at 10:04:22PM -0700, Darrick J. Wong wrote:
> > > I know people like to fetishize file access (and to be honest from a
> > > shell it is really nice), but from a C program would you rather do
> > > one ioctl to find a sysfs base path, then do string manipulation to
> > > find the actual attribute, then open + read + close it, or do a single
> > > ioctl and read a bunch of values from a struct?
> > 
> > Single ioctl and read from a struct.
> > 
> > Or single ioctl and read a bunch of json (LOL)
> > 
> > I wish the BLK* ioctls had kept pace with the spread of queue limits.
> 
> Let me propose a new BLKLIMITS ioctl, and then we'll work from there?

Ok!

--D
