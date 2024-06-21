Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB96D1C14
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718992006; cv=none; b=LckZQSoDjwkuCAl4gOSwUnE+DUEdjNGZuzQHF1QgOpgLo4k/6lLaNCd0WmVE7WzMnDZk/Opbe1Zu+MBtb25MKcsz0KwsJ3OrnpC5wUVsn0UWdEAxnU/14c5iH4gns7n0lwj6B22OhO1O7magxswv/QqG4UOybk5tP9Dmwva3v3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718992006; c=relaxed/simple;
	bh=KvkoQZxtmnz8eXWD+aBLE86xmlEDL0xVytvx+BVbWLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/6ZE6TFHXYf/uNxpq5zuVI15agHyTWUo85cBVy3ah9zDXANO9NI8ER6ZmjqYlqDD0KjAmbSNhXVlelAaBZmj2oMMbNFTV2Bkw9nbTq0bcfBXJOk2DI5cmDSOV6xqQBUXVDVjoADdSiUMVYHGPwpPUT7CPVlYJ2v7CIzucAebh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGd/sd7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGd/sd7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573B7C2BBFC;
	Fri, 21 Jun 2024 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718992006;
	bh=KvkoQZxtmnz8eXWD+aBLE86xmlEDL0xVytvx+BVbWLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NGd/sd7CwO6+8lFGZhxZHYpMJ8s+tYZlaiHMbXl1Pwnp4qIxAH93a4ZergZhESjOj
	 CGR9prlRLnz2PKA11TAsGpJplLVVDz1Jn9Y8MtQpcYNY5+aejNaA/DChmfZggUPLMU
	 ChsS1SJJ2G4MNFYMZBtY+i0L0aX3CHIAOakr93bvCZXFACgRp+aGMkojgUbUCCMmx9
	 1C3mPvhHUjZCh4kgHJiw7VMBA3uMYZ0N22deT62KPyRTZzEpAWf4TR+AzLV444qpEC
	 Ydba1oaKuzOhr7QuKq/NLosihi740WhGqukwjHEepLCYILljOvlAO0odi79u9G9t8P
	 VRuLJVJ2eehqg==
Date: Fri, 21 Jun 2024 10:46:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: skip flushing log items during push
Message-ID: <20240621174645.GF3058325@frogsfrogsfrogs>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-12-hch@lst.de>
 <20240620195142.GG103034@frogsfrogsfrogs>
 <20240621054808.GB15738@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240621054808.GB15738@lst.de>

On Fri, Jun 21, 2024 at 07:48:08AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 20, 2024 at 12:51:42PM -0700, Darrick J. Wong wrote:
> > > Further with no backoff we don't need to gather huge delwri lists to
> > > mitigate the impact of backoffs, so we can submit IO more frequently
> > > and reduce the time log items spend in flushing state by breaking
> > > out of the item push loop once we've gathered enough IO to batch
> > > submission effectively.
> > 
> > Is that what the new count > 1000 branch does?
> 
> That's my interpreation anyway.  I'll let Dave chime in if he disagrees.

<nod> I'll await a response on this...

> > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_inode.c      | 1 +
> > >  fs/xfs/xfs_inode_item.c | 6 +++++-
> > 
> > Does it make sense to do this for buffer or dquot items too?
> 
> Not having written this here is my 2 unqualified cents:
> 
> For dquots it looks like it could be easily ported over, but I guess no
> one has been bothering with dquot performance work for a while as it's
> also missing a bunch of other things we did to the inode.  But given that
> according to Dave's commit log the іnode cluster flushing is a big part
> of this dquots probably aren't as affected anyway as we flush them
> individually (and there generally are a lot fewer dquot items in the AIL
> anyway).

It probably helps that dquot "clusters" are also single fsblocks too.

> For buf items the buffers are queued up on the on-stack delwri list
> and written when we flush them.  So we won't ever find already
> flushing items.

Oh right, because only the AIL flushes logged buffers to disk.

--D
