Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065D43403EC
	for <linux-xfs@vger.kernel.org>; Sat, 15 Aug 2026 09:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786784960; cv=none; b=aq2+KRrw/apGJ5oZVQeCqrotnU1prDqa293GDaKAcb4AAvWUv0UkFCueLdRyLT1OSXZxsV9Qqvuxsn+bB/dZ+p6SAJNP0gXXVBwJRoUHlYGfVyjv7PEvW2YfSZCouqlfoIjYBwwUykOVIjtg7x/rsQ2GNIvf06jZ9j2PU6DndoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786784960; c=relaxed/simple;
	bh=JLrbdFNtiG3qBRWmmGICrniNtnvUt3sYUz63xg4m1oU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrKrqoMTHZfiO7cVXnQbOQqHToxdViueOJMBVCef6vhOQsC5JVLjDeI8N0VdtxF+kA/x2I8fO7LRAbKXSe2AKj/ocg/hduEmILjTl7Cp73gML3kPUL4yKbdbso37Br6IBkGjKIjWMuKLYYGmgpMRUNdWWmaYq/pkBfSd2iRuESU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRDmQ/ae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRDmQ/ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA5F1F000E9;
	Sat, 15 Aug 2026 09:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786784958;
	bh=fcWbmTSWeXSzI3+dpPDOOdit17stvdCXFmk4A/bxMUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fRDmQ/aeFzazD1omM3D7UUNPGT1ipHEUKs3KKgNN9C/tmf5gjbH+ad6S+tt6mrF0m
	 lF1EvwYJojjcLIcNnmkj/V8lbVLY0flyxgBGl8YAO84RrXh3i5Ci4SgLFOn1ho3fuU
	 2jYdbW9Rutx2pqaAA/1ZRddBhWIcC7xJf0j3m4fBGAqh95Ixw1vpmtp+9FE7hxIZgF
	 lT46aQrsP80IEExQ81Co2EUNcrMcvASUxSL16P2cESbxhfrutxiyU2ToXKuG0KI2aE
	 150+J4CYekaTtE0A38PnMprX5MVCZ4ws3oRKGcWpnp5g1YTbXNn1/b+nxRe1yj58Qz
	 tb/yiz6xVGcJQ==
Date: Sat, 15 Aug 2026 11:09:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <aoAoLVzAsuM8WLQ0@andromeda.toxiclabs.cc>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com>
 <20260624173531.GQ6078@frogsfrogsfrogs>
 <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
 <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
 <CAK5ssPPC4Ov0KBbRphC_wZBZGu1Rr4-d2At4V+ZECFcuHxbEfg@mail.gmail.com>
 <an7Dk2Tn1ibCRsv2@infradead.org>
 <an9BQdSqrmzYhB3l@andromeda.toxiclabs.cc>
 <20260814182449.GI3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814182449.GI3556460@frogsfrogsfrogs>

On Fri, Aug 14, 2026 at 11:24:49AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 14, 2026 at 06:25:41PM +0200, Carlos Maiolino wrote:
> > On Fri, Aug 14, 2026 at 12:28:19AM -0700, Christoph Hellwig wrote:
> > > On Thu, Aug 13, 2026 at 09:43:44PM +0530, Aditya Prakash Srivastava wrote:
> > > > 
> > > > Are there any remaining concerns or feedback that need
> > > > to be addressed with this patch?
> > > 
> > > Still looks good to me, but I think it just go lost.  It's a bit close
> > > for the 7.3 merge window now, but I'd suggest you resend it in a week
> > > or two to get it onto the agenda for 7.4 early.
> > 
> > Yup, I was waiting for Darrick to follow-up then it fell on limbo.
> > Please follow Christoph's advice, please rebase and re-send on top of
> > the tree after 7.3 merge window.
> 
> I ignored the response because it's clearly AI slop, and obviously
> wrong.

I haven't read that email until now, just noticed it was addressed to
you, thanks for pointing it out.

Aditya... I don't care how you generate your patches, but YOU are
responsible for the content you generate.

Replying somebody's review comments with LLM generated content... I
can't emphasize enough how disrespectful I think this kind of attitude
is.

Darrick spent his time reviewing your patch. You used a LLM model to
reply his email which I already find disrespectful enough, and worse,
you didn't even check the result? Why do you delegate to others your
responsibility to review your content? If you didn't understand the
generated content, that would already be a red flag that you shouldn't
be sending it. If you thought it was right, it means you didn't check it
carefully enough as you didn't even add any information saying you got
this from a LLM and wasn't sure how right the information was.

We are all overwhelmed with the inflow of patches now that writing them
has never been easier.... Yet, we dedicate our time and effort reviewing
them in an effort to keep the project's quality high. And yet we have
just so much time in our hands and we would appreciate a little respect
with at least reviewing the garbage you generated.

You can use whatever tool you want to generate the patches, but Linux
policy has been that YOU are responsible for whatever you wrote with
whatever tool you use.

And yet, I can't really emphasize how disrespectful I think such attitude
is. Somebody's using a LLM to reply to somebody's else emails/messages,
to say the least, make me believe you think your time is much more valuable
than ours, giving you didn't even bother to review the email you sent to
Darrick.

Carlos

> 
> "In XFS, the canonical locking hierarchy is:
> 
> "sb_start_write (freeze lock) -> IOLOCK -> ILOCK ->
> xfs_trans_alloc"
> 
> Nope.
> 
> "xfs_file_release() already holds XFS_IOLOCK_EXCL (acquired via
> xfs_ilock_nowait())..."
> 
> Nope.  The snippet I suggested isn't fully formed, but this is obviously
> wrong; go read xfs_file_release.
> 
> static inline void xfs_file_release_eofblocks(struct xfs_inode *ip)
> {
> 	if (!xfs_can_free_eofblocks(ip))
> 		return;
> 	if (xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED))
> 		return;
> 
> 	/* take freeze protection and i_rwsem */
> 	if (!sb_start_write_trylock(...))
> 		return;
> 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
> 		goto out_sb_write;
> 
> 	/*
> 	 * recheck if we want to trim eofblocks and someone else hasn't
> 	 * already done this
> 	 */
> 	if (!xfs_can_free_eofblocks(ip))
> 		goto out_iolock;
> 	if (xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> 		goto out_iolock;
> 
> 	xfs_free_eofblocks(ip);
> 
> out_iolock:
> 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> out_sb_write:
> 	sb_end_write(...);
> }
> 
> "xfs_trans_alloc() is the canonical, centralized place in XFS to
> manage write-count blocking semantics."
> 
> Nope.  This isn't even talking about the same vfs lock here.
> 
> --D
> 
