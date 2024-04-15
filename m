Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695BD15A49D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713210037; cv=none; b=dB5YbhHtqPKziH67NG/AokpgUP3b5MtoQ1XDGpBHdWkC0NdwHdzMUAfrFcu50WvutqMqNgI3Jss/hEPNb1CMO+iMSXbe8gxOAlGu24dJ+fglu1PZOl0r+YWOjvNSO3bUjPn4j1LkG++zJJIvl7OXDKbBZlkpYiKR+Vumh17CDcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713210037; c=relaxed/simple;
	bh=Ox3rPi/vDsR3vloa2toiIO9x/m1e1NSMjdXjCst7Dz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTqTG96FL2nTh55/D7jf8xehjBNDKccp+6ZUVNSyeLZGDCOt388NKKg3Nm8580JjxFwBiXcjCczvPrZmpweAl57XlrZ2/9rOs6YaTAxwK/BcpsGEjBMSg4qEzFyAghdeL4uT+t9NZslj6KsHw5cbfkHPSlX3QMGlqjBlZICjtys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhiOY4+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhiOY4+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6FFC113CC;
	Mon, 15 Apr 2024 19:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713210036;
	bh=Ox3rPi/vDsR3vloa2toiIO9x/m1e1NSMjdXjCst7Dz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RhiOY4+gbAHh4iOPkYCKYKxmEzNTmZh7x9i0E2fW/3MQKFMkKYfrMQ7Hsnd9P2rPA
	 mJY4OeAKCjz0f9zStdhJxLAXX+emCtqj8z0bCBrMV6qyH+cmmM9RYq7JCvBz1/MotJ
	 mXmDAzowl/VOtppMhHkihrS3Iwg/48NQO3Vr6YOB0cmSWtraaxkO8EdaPSgg3b/2Z6
	 D0Oy8+/kEClfKbEZ/mjgZaZqlg/RHUb7FvMbTbGxWGGfkY+fMrC2pdY57ogKTLOpxM
	 P68D6UEh0SQKgDP0XA1jNsvYGw0A3dzekROO79AQlga0KGQ1cl0+Tt36IZYa4QxNbT
	 2MLjmXe35zfJg==
Date: Mon, 15 Apr 2024 12:40:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240415194036.GD11948@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240414051816.GA1323@lst.de>

On Sun, Apr 14, 2024 at 07:18:16AM +0200, Christoph Hellwig wrote:
> [full quote deleted.  It took me about a minute of scrolling to find
> the actual contents, *sigh*]
> 
> On Fri, Apr 12, 2024 at 10:39:57AM -0700, Darrick J. Wong wrote:
> > I noticed a couple of things while doing more testing here -- first,
> > xfs_khandle_to_dentry doesn't check that the handle fsid actually
> > matches this filesystem, and AFAICT *nothing* actually checks that.
> 
> Yes.  Userspace better have resolved that, as the ioctl only works
> on the given file system, so libhandle has to resolve it before
> even calling the ioctl.

True, libhandle is a very nice wrapper for the kernel ioctls.  I wish
Linux projects did that more often.  But suppose you're calling the
ioctls directly without libhandle and mess it up?

> > So I guess that's a longstanding weakness of handle validation, and we
> > probably haven't gotten any reports because what's the chance that
> > you'll get lucky with an ino/gen from a different filesystem?
> 
> Not really, see above.
> 
> > The second thing is that exportfs_decode_fh does too much work here --
> > if the handle references a directory, it'll walk up the directory tree
> > to the root to try to reconnect the dentry paths.  For GETPARENTS we
> > don't care about that since we're not doing anything with dentries.
> > Walking upwards in the directory tree is extra work that doesn't change
> > the results.
> 
> In theory no one cares as all operations work just fine with disconnected
> dentries, and exportfs_decode_fh doesn't do these checks unless the
> accpetable parameter is passed to it.  The real question is why we (which
> in this case means 15 years younger me) decided back then we want this
> checking for XFS handle operations?  I can't really think of one
> right now..

Me neither.  Though at this point there are a lot of filesystems that
implement ->get_parent, so I think removing XFS's will need a discussion
at least on linux-xfs, if not fsdevel.  In the meantime, getparents can
do minimal validation + iget for now and if it makes sense to port it
back to xfs_khandle_to_dentry, I can do that easily.

(FWIW turning off reconnection would likely fix some of the annoying
behaviors of xfs_scrub where it tries to open a dir to scan it and then
sprays dmesg with errors from unrelated parents as it stumbles over
reconnection only to fail the open, at which point it falls back to
scrubbing by handle anyway.)

--D
