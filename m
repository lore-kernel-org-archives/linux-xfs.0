Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD828136E
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531703; cv=none; b=cOpbndLkfQAhneHjBrVb6oS72GVvvvwKDphZ/wadKv3vNR+AgenoWGN6gM9KVk4rNDN+GkYQeYLgMTUDXXtzSIU4JTPvt6hPQIDEhUuZi51jYPvHK1xvqgT7jbGyAofRLpUpHp4WepI3VnTMVpQaFCeIHD5lMpGrt4ebgBqsxH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531703; c=relaxed/simple;
	bh=Lc6wSOB9mzo2a0Hwc9lddT1VvS+pkRqwSiXd49RmDRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXXw1dGlVr7Q5/YLT2CXM8jHlQyPxLaODa+yCgvpdcKxqMvD2fNTn+AT9PP5dmz3W6U5x6i34YMtLmH/Yh1GvFpzbV0epJnQXshkT1ySVAxN4chraLhctcQOUH/mxhTq2bUejVuvmLV6eA29aFT5pTLqsBX/+RUePEWNSs5Es9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRXUHLLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRXUHLLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BA8C4CEE4;
	Thu, 24 Apr 2025 21:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745531702;
	bh=Lc6wSOB9mzo2a0Hwc9lddT1VvS+pkRqwSiXd49RmDRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mRXUHLLmgxSvwyJkFlvrN207tFebJciPCJiJ4v3711WRHcKvQS0jgPuQJ+YkhaYEv
	 Uf5znJWLUlMjl7yAt0DN7t/9tKm/n3alvCjds5dv+q8FKeZ776HxOsdp0UvnEe4yHz
	 qSE31SW07Rm8UFY+DFjPw0h5oiH3KZvYNPUJXHsJrbuRYrWgdcDulW9km6CSZX5wLP
	 Pq/iEKGcPFYSJkG7kuSTH76UOKnt0f7oZxECcVB1MwAz3PH8/dzCXAZWI7ThzBZA5P
	 2CoCaQ6kUckplQe9sS2bJ+ogHzzFSu7V8L6E+rvl3q9x7Rz2I2XUzzBqSElsHHgUlN
	 bB4OOacQTqUhw==
Date: Thu, 24 Apr 2025 14:55:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v6 3/4] mkfs: add -P flag to populate a filesystem from a
 directory
Message-ID: <20250424215502.GJ25675@frogsfrogsfrogs>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-4-luca.dimaio1@gmail.com>
 <20250423200914.GH25675@frogsfrogsfrogs>
 <rb5jppjdx4c5b4qxqmlxinheztreysqts5o6fx575zvceszart@mtpo6ngxms5m>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rb5jppjdx4c5b4qxqmlxinheztreysqts5o6fx575zvceszart@mtpo6ngxms5m>

On Thu, Apr 24, 2025 at 02:01:06PM +0200, Luca Di Maio wrote:
> On Wed, Apr 23, 2025 at 01:09:14PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 23, 2025 at 06:03:18PM +0200, Luca Di Maio wrote:
> > > -	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
> > > +	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:P:m:n:KNp:qr:s:CfV",
> > >  					long_options, &option_index)) != EOF) {
> > >  		switch (c) {
> > >  		case 0:
> > > @@ -5280,6 +5283,9 @@ main(
> > >  				illegal(optarg, "L");
> > >  			cfg.label = optarg;
> > >  			break;
> > > +		case 'P':
> > > +			cli.directory = optarg;
> > > +			break;
> >
> > Uh... why not modify setup_proto to check the mode of the opened fd, and
> > call populate_from_dir if it's a directory?  Then you don't need all the
> > extra option parsing code.  It's not as if -p <path> has ever worked on
> > a directory.
> >
> > --D
> >
> 
> Alright, that makes things easier yes, I'll just make sure to clearly
> explain the difference in the man page and help so it's clearer,
> something like:
> 
> ```
> -p prototype_options
> Section Name: [proto]
> 	These options specify the prototype parameters for populating the
> 	filesystem.  The  valid  prototype_options are:
> 
> 		[file=]
> 
> 		The  file= prefix is not required for this CLI argument for
> 		legacy reasons.  If specified as a config file directive,
> 		the prefix is required.
> 
> 		[file=]directory
> 
> 		If the optional prototype argument is given,
> 		and it's a directory, mkfs.xfs will copy the contents
> 		of the given directory or tarball into the root
> 		directory of the file system.
> 
> 		[file=]protofile
> 
> 		If  the  optional prototype argument is given,
> 		and it's a file, [ ... continue with existing man ... ]
> ```
> 
> So it's clear from the docs that the option is there and it's the same
> flag.

Sounds good to me!

--D

> L.
> 
