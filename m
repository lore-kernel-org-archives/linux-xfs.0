Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D14B3FE53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 23:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPRHxtqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5733FC433C7;
	Tue,  5 Dec 2023 23:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701817724;
	bh=ckAgEOakM0kvx/WBJKNiVn21lPZtFJN8Vs/9mGs/uOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RPRHxtqIqcO2Z1SKq3rSRmN1kkv/GXsEiLIcR7L6y56Rbq65QaYePaOOapO0bt1R2
	 ZAN/I8MKINMA21T4Z0oQSH5bBrPl6rpHaQV8U/aQ4RLXxddQnuKPZmEBleYUKOkpMM
	 qwdPCVt7+NiO28a8tB8yaulhwjjluid11w1gb2Lu9++bvTQ0SC3bvqteefIBJSjOLs
	 dGlrQGmAsShFvx8sudMCZW3RncY1zz4BRwR731x/M4aTqGjawkKO4vhKbmwAnPbjsP
	 sZfPM5M/3FytElaRNff0Vf0YHvcQ19rU6VYSiuVsJ8dg01/3atkM9jSksnM55qVwyr
	 mE47EqmULPKaA==
Date: Tue, 5 Dec 2023 15:08:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: repair inode records
Message-ID: <20231205230843.GO361584@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927488.2771142.16279946215209833817.stgit@frogsfrogsfrogs>
 <ZWYek3C/x7pLqRFj@infradead.org>
 <20231128230848.GD4167244@frogsfrogsfrogs>
 <ZWbUAizpezw5fuZW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWbUAizpezw5fuZW@infradead.org>

On Tue, Nov 28, 2023 at 10:02:42PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 03:08:48PM -0800, Darrick J. Wong wrote:
> > > 
> > > We set the reflink flag by default, because a later stage will clear
> > > it if there aren't any shared blocks, right?  Maybe add a comment to
> > > avoid any future confusion.
> > 
> > 	/*
> > 	 * For regular files on a reflink filesystem, set the REFLINK flag to
> > 	 * protect shared extents.  A later stage will actually check those
> > 	 * extents and clear the flag if possible.
> > 	 */
> 
> Sounds good.
> 
> > > Hmm, changing a symlink to actually point somewhere seems very
> > > surprising, but making it point to the current directory almost begs
> > > for userspace code to run in loops.
> > 
> > How about '🤷'?  That's only four bytes.
> > 
> > Or maybe a question mark.
> 
> Heh.  I guess question marks seems a bit better, but the general idea
> of having new names / different pointing locations show up in the
> name space scare me a little.  I wonder if something like the classic
> lost+found directory might be the right thing for anything we're not
> sure about as people know about it.

Hmm.  I suppose a problem with "?" is that question-mark is a valid
filename, which means that our zapped symlink could now suddenly point
to a different file that a user created.  "/lost+found" isn't different
in that respect, but societal convention might at least provide for
raised eyebrows.  That said, mkfs.xfs doesn't create one for us like
mke2fs does, so maybe a broken symlink to the orphanage is... well, now
I'm bikeshedding my own creation.

May I try to make a case for "🚽"? ;)

> > > > +	if (xfs_has_reflink(sc->mp)) {
> > > > +		; /* data fork blockcount can exceed physical storage */
> > > 
> > > ... because we would be reflinking the same blocks into the same inode
> > > at different offsets over and over again ... ?
> > 
> > Yes.  That's not a terribly functional file, but users can do such
> > things if they want to pay for the cpu/metadata.
> 
> Yeah.  But maybe expand the comment a bit - having spent a fair amout
> of time with the reflink code this was obvious to me, but for someone
> new the above might be a bit too cryptic.

	/*
	 * data fork blockcount can exceed physical storage if a
	 * user reflinks the same block over and over again.
	 */

> > > > +
> > > > +	if (i_uid_read(VFS_I(sc->ip)) == -1U) {
> > > 
> > > What is invalid about all-F uid/gid/projid?
> > 
> > I thought those were invalid, though apparently they're not now?
> > uidgid.h says:
> > 
> > static inline bool uid_valid(kuid_t uid)
> > {
> > 	return __kuid_val(uid) != (uid_t) -1;
> > }
> > 
> > Which is why I thought that it's not possible to have a uid of -1 on a
> > file.  Trying to set that uid on a file causes the kernel to reject the
> > value, but OTOH I can apparently create inodes with a -1 UID via
> > idmapping shenanigans.
> 
> Heh.  Just wanted an explanation for the check.  So a commnt is fine,
> or finding a way to use the uid_valid and co helpers to make it
> self-explanatory.

Yeah, I think this converts easily to:

	if (!uid_valid(VFS_I(sc->ip)->i_uid)) {
		/* zap it */
	}

--D
