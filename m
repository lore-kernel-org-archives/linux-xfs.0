Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFECC413781
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2026 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822997; cv=none; b=s686pW5MRZIckhU6N5a1phSy+H1ylbasItCvv4OEx1HAjCMVqoNNToh2VfHqMdHglUhLWwsnlyvhx0cRKi30y36pwp1ZcaF5tN1k2UFTCmSgreYXaxbabvg93azyiMQtbpC9TwYstNXf7ZdFr+ftEqdRJZ/iX5KjTLM6XyIj6Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822997; c=relaxed/simple;
	bh=Nv7jWoPQGvh+5jzmo0kxcpirOn2hP9mjpbJcgIziip4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7Z5AyUIfgxYcxkVK79+Tary1zGmxLcdZaxLGzUbjZtZPNBlCgCvOfNf5fnqOvL3CrBFYImrL+eB1nzhIMfeYPBGaT8H6cuE3e6txMLgYBqBWxB3aV0T7emHGGdJ6WnSONuetoqnaiNXw5HQxGlJXXVzJLF5JWG1rzdFG8dsPI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=EhmGG5WY; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="EhmGG5WY"
Received: from macsyma.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66NG9MfQ006977
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 12:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784822965; bh=alaeQZLNPhmSTF7zpHY3XpjcKZarabGNzK/9NRZA0lQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=EhmGG5WYFZ8I4343u61PucOxh7OuB0+3+SLgsPzFdJtP12VJ9UqNo03v6DSuc7Sr9
	 6RQcFi2PKlGcmrvMTHW5LpNMQNcYxfwOGvGftglpVL6HoJPmvg1vpT+rFDVChlVXZu
	 FOWQkc5MoOvL4DtDdF9MiQ8YuSQ61+O9kwBIl8jalTOVGpvWEk4m7gXy+fzC1cI36S
	 nYjZ3n1tS52amlT3xnZ4YoEdEugWcwKAAX2xUyee6aXUwW5xcjGs/rfQQElr/2DXTv
	 XruvriZ/IogM9Tda00Lww0hrkLQdGrxhFCNd64S7WtHU3B2H94xReCLMbCtErO7nU6
	 I/ETzYdheSwoA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id B79FBBD1D38; Thu, 23 Jul 2026 12:08:21 -0400 (EDT)
Date: Thu, 23 Jul 2026 12:08:21 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joanne Koong <joannelkoong@gmail.com>,
        changfengnan@bytedance.com, Christian Brauner <brauner@kernel.org>,
        Carlos Maiolino <cem@kernel.org>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from
 iomap_dio_rw
Message-ID: <amI3Kf3lFz4FMqXh@mit.edu>
References: <20260722124931.3159664-1-hch@lst.de>
 <20260722124931.3159664-3-hch@lst.de>
 <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
 <20260723045347.GA6641@lst.de>
 <20260723151021.GC7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723151021.GC7380@frogsfrogsfrogs>

On Thu, Jul 23, 2026 at 08:10:21AM -0500, Darrick J. Wong wrote:
> > Yes.  Sashiko also reported that yesterday and I replied with a patch,
> > but I now noticed the report and thus my reply only went to me,
> > a sashiko-review list and Ted, but not everone else or the lists.
> > 
> > WTF?
> 
> Sashiko doesn't email the lists by default, and I don't think we want to
> turn that on for the fsdevel firehose.

Whether or not the review goes to a mailing list is up to each
subsystem to determine.  Some people have violently objected to the
review going to the mailing list, which is why it's optional.

I have asked to have ext4 reviews to be cc'ed to the linux-ext4
list[1].  It would be up to the VFS maintainers whether or not we want
to enable it for linux-fsdevel.

[1] https://github.com/sashiko-dev/sashiko/pull/365

The XFS maintainers can request if patches cc'ed to linux-fs should
get reviewed and sent back to authors and/or the maintainers and/or
the linux-fs mailing list.  You can either ask the Sashiko devs to
edit the email_policy.toml file, or you can send a pull request yourself.

						- Ted
