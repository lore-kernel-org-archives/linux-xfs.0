Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A78294A16
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804327; cv=none; b=HDv36JT6cYehlyklT8l3/phLbRokQ1MhGN8r/vx0r+rgfh6OVtezP/EWe/9W3D+hleC9cO31Gc6GorhtbJRDK6A5SaavF+yt0UBL/Tvst0ZKJdFL7tGosd35A++/4orF7GoQu5+uWBs3B0EC/A/AFYf27e0ivWcsqlcKKPrRdtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804327; c=relaxed/simple;
	bh=801ltDIEMD7IlnPzK1CtAyaCeIGSIVezNyYsjBngNoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjXzbTwibkEJMcySkiV2xixo77lCcYc/Z76anQr1dC2ZnA+nc87KULYsWgLJaE6WZNp9WxdNIJ8EiH1tZogWD6EiWsTBcnZSqp+D/+rw3L/XdS230IA92a3p3y+nk61oCMO10h6qzonzdG4Yf2q2r88MLRuLLLW06dCVcoVV1ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9FLswoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9FLswoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4FEC4CEF4;
	Tue, 29 Jul 2025 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753804326;
	bh=801ltDIEMD7IlnPzK1CtAyaCeIGSIVezNyYsjBngNoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T9FLswoUSBpB/xbA9HB0xHmYbiRpiU5F7/c2hxAln+Wer5MisklmpauIievOtIIkG
	 wz7Z3ooxmmLrpBaKkgLBf1iWO87N0joyuGh3OMCg5zJI8fny/sllUguorWqPzU38tv
	 lrG1/fyNxsbXyd/CcTkk/dmqbSEJxNKL+3JGziqoVkmBjbtK7PCv7aFFMAXDAi/7gS
	 5I9aJ88/939YM86+ymB7U6ULf3n+FooEjBuS5Bl9v8T5FWaBF1xBNXR1dr3CxjyN2c
	 Y4a3MJK7k0AjlPo+bU6eDpLqkJ1aumZTPIZbH1eZKO4yH8BysLC3U5+RQGfrpu92ZL
	 vv+1bBjHmbZYA==
Date: Tue, 29 Jul 2025 08:52:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Use new syscalls to set filesystem inode attributes
 on any inode
Message-ID: <20250729155205.GF2672070@frogsfrogsfrogs>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
 <20250729143411.GA2672049@frogsfrogsfrogs>
 <5jw4nzpg26faxkzyeo3n2yczqxjczyq5c7qukfvqkx5e254m4k@tafsr7bdstcd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5jw4nzpg26faxkzyeo3n2yczqxjczyq5c7qukfvqkx5e254m4k@tafsr7bdstcd>

On Tue, Jul 29, 2025 at 05:50:08PM +0200, Andrey Albershteyn wrote:
> On 2025-07-29 07:34:11, Darrick J. Wong wrote:
> > On Tue, Jul 29, 2025 at 01:00:34PM +0200, Andrey Albershteyn wrote:
> > > With addition of new syscalls file_getattr/file_setattr allow changing
> > > filesystem inode attributes on special files. Fix project ID inheritance
> > > for special files in renames.
> > > 
> > > Cc: linux-xfs@vger.kernel.org
> > > 
> > > ---
> > > Darrick, I left your reviewed-by tags, as the code didn't changed, I just
> > > updated the commit messages. Let me know if you have any new feedback on
> > > this.
> > 
> > It all looks ok except for s/(file| )extended attribute/fileattr/
> > 
> > Seeing as the VFS part just went in for 6.17 this should probably get
> > merged soonish, right?
> 
> Without this special files won't be able to use these syscalls, but
> otherwise, for regular files nothing changes. So, I think it not
> necessary for this to get into this merge window.

<nod> Ok.

--D

> > 
> > --D
> > 
> > > ---
> > > Andrey Albershteyn (3):
> > >       xfs: allow renames of project-less inodes
> > >       xfs: allow setting xattrs on special files
> > >       xfs: add .fileattr_set and fileattr_get callbacks for symlinks
> > > 
> > >  fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++-------------------------
> > >  fs/xfs/xfs_ioctl.c |  6 -----
> > >  fs/xfs/xfs_iops.c  |  2 ++
> > >  3 files changed, 36 insertions(+), 36 deletions(-)
> > > ---
> > > base-commit: 86aa721820952b793a12fc6e5a01734186c0c238
> > > change-id: 20250320-xfs-xattrat-b31a9f5ed284
> > > 
> > > Best regards,
> > > -- 
> > > Andrey Albershteyn <aalbersh@kernel.org>
> > > 
> > > 
> > 
> 
> -- 
> - Andrey
> 
