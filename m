Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C74C3C30
	for <linux-xfs@vger.kernel.org>; Sun, 14 Apr 2024 05:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713071911; cv=none; b=pMsXIr9KZgbj0ufsh8AoiibPluFn2LI4mojOckyht6Z9wpqDtTSe8ETHsecOYQD2YEpfKHKWQIJPkRjcYIohu88+HTHRBXMIWDaLp5sCT+8IZYVs+qNwAfFeAEnewjjOE/osaDtWXsCISPcE4gRcUTX5EUGqivfB/cnRqC/9tLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713071911; c=relaxed/simple;
	bh=uoPNhfTyf4rzZLP4KBzDIyciAvqTVT3A23MFHN1wNDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f36vkL2xZEfGyJ2X8T/j8kz7ERIRywfpB7lMdsijTKYez3qjDIVxVRNfIqptGGGtdkC2KBZAY6Wa01K4z8A8PZIqKgCvNschMU32+hG6OwPon3W7YsLlOcmptlo/BZEkXcFXeP9DErMQMnZ0kDthOTvRjB01zhSgg7SbXeOGKF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3288B68B05; Sun, 14 Apr 2024 07:18:16 +0200 (CEST)
Date: Sun, 14 Apr 2024 07:18:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240414051816.GA1323@lst.de>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs> <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs> <20240412173957.GB11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412173957.GB11948@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

[full quote deleted.  It took me about a minute of scrolling to find
the actual contents, *sigh*]

On Fri, Apr 12, 2024 at 10:39:57AM -0700, Darrick J. Wong wrote:
> I noticed a couple of things while doing more testing here -- first,
> xfs_khandle_to_dentry doesn't check that the handle fsid actually
> matches this filesystem, and AFAICT *nothing* actually checks that.

Yes.  Userspace better have resolved that, as the ioctl only works
on the given file system, so libhandle has to resolve it before
even calling the ioctl.

> So I guess that's a longstanding weakness of handle validation, and we
> probably haven't gotten any reports because what's the chance that
> you'll get lucky with an ino/gen from a different filesystem?

Not really, see above.

> The second thing is that exportfs_decode_fh does too much work here --
> if the handle references a directory, it'll walk up the directory tree
> to the root to try to reconnect the dentry paths.  For GETPARENTS we
> don't care about that since we're not doing anything with dentries.
> Walking upwards in the directory tree is extra work that doesn't change
> the results.

In theory no one cares as all operations work just fine with disconnected
dentries, and exportfs_decode_fh doesn't do these checks unless the
accpetable parameter is passed to it.  The real question is why we (which
in this case means 15 years younger me) decided back then we want this
checking for XFS handle operations?  I can't really think of one
right now..

