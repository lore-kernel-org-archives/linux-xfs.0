Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593091F30A4;
	Thu, 16 Apr 2026 00:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776300947; cv=none; b=QNdATqJjjtYJ+w6la7Ahwlfb/8svKVQkBfrbAvcXZBNZF6aSoyXaWuvchgpclszoYmdZX5wMJAZ/JuS8A89UOHMEt3wiJotyKCe6Qp9AmyDLCfcWeEdQHJkkMjU/L9HyC++2WDOrQMwPe1oSPEmvpBLAJbk0MJZhz2yzc8oTOIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776300947; c=relaxed/simple;
	bh=JDf45ivgpxj6JEHkOMfx/W8FoU6jCzXmGNmhnWkysFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZ/PTDv1+ESW8ouTUDm3/7/9hdxUOkfnqsMXBfx6zesDdGB7bPjhq5PvzJVMu2zmYoJo5w/7nhsAbNxeAekfAxhJsbTGoNWKvJfbWrUZtWdltbOxP3Eo6gM5WYxkN4zJpoAawywcFjHCkmKhINRZWZAXKpqa5CzfamsjoF8zpYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuDBX54t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuDBX54t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ADFC19424;
	Thu, 16 Apr 2026 00:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776300946;
	bh=JDf45ivgpxj6JEHkOMfx/W8FoU6jCzXmGNmhnWkysFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BuDBX54tTOc5uZ2Qec2treibYRRA6A6alFIGXX/WdKKh5CLElghgD/uPLFzqd5ihp
	 Mx9FQ9pC9dfS3tQMTCeFCf6XIVkVBpwcQWESVwNjwtbn58bG9M3biJBTVhUHawKQt9
	 hDOn2L+YszZaOjqC+djP3D3GvnWIRfC+hcJ7aVpMnKiGXOdfFUkQZfN1tQm9RNXIJL
	 lKJeh5Mw2rjCwVSrQj1+m+X0Ujeew1EKKHN4gbcwJsAfgQzCgDKNlO5PIAZ/Llbkyd
	 bfd7evb1U9LQUUJA22ADNEQMuj136vuFcQu8R+5azes0a1NvFJzlX5g50Pk2v6DmQ0
	 8fAmEbnGlISwA==
Date: Thu, 16 Apr 2026 10:55:38 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: Re: [PATCH] xfs: start inodegc after quota initialization
Message-ID: <aeAziq2qsiCrvwBZ@dread>
References: <20260413004925.84518-1-pedrodemargomes@gmail.com>
 <20260413180940.GO1048989@frogsfrogsfrogs>
 <ad89k-qafk3jsx35@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad89k-qafk3jsx35@infradead.org>

On Wed, Apr 15, 2026 at 12:26:11AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 13, 2026 at 11:09:40AM -0700, Darrick J. Wong wrote:
> > > index ef1ea8a1238c..d6f75ab41337 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -1057,7 +1057,6 @@ xfs_mountfs(
> > >  		xfs_clear_using_logged_xattrs(mp);
> > >  
> > >  	/* Enable background inode inactivation workers. */
> > > -	xfs_inodegc_start(mp);
> > >  	xfs_blockgc_start(mp);
> > >  
> > >  	if (xfs_has_metadir(mp)) {
> > > @@ -1143,6 +1142,8 @@ xfs_mountfs(
> > >  		}
> > >  	}
> > >  
> > > +	xfs_inodegc_start(mp);
> > 
> > Why is it correct to defer inodegc until this point?  Can any code
> > between line 1060 and 1145 push an inode to the inodegc mechanism?
> > blockgc can unmap blocks from files, so why is it ok to leave the
> > blockgc_start call where it is?
> 
> Looking at this - I think actually performing inodegc before quotas
> are up sounds dangerous, as we'd miss th quota accounting.  So I
> think we need to defer starting the runners after that.  But we
> should support queuing up inodes before that.  blockgc has
> the same issues.

Chicken and egg.

inodegc has to be up before the first xfs_iget() call is made,
because releasing an inode could require inodegc to run to allow it
to be freed.

We are bringing all the metadir inodes, the root inode, the realtime
inodes, etc into memory before we start up quota. With the above in
mind, inodegc needs to be running to ensure we clean up and free all
inodes if mount fails anywhere along the path before quotas are
brought up....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
