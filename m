Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q/aXva+3"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C2F1BD0
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 22:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=sZTeP+sW+489dJM4+0pM0hzs5ibB+jYUJzHy8dQ0mBI=; b=q/aXva+3fdtWUntJbOhGYhxXDh
	1/md715Np0pwygRLbgRy9G0DZvbNQaTpGVI268woxHiIRnLhknT5XEZEUFRsKefDbZY3ZBCzJmDXG
	JyOAOsm9a8U6nIjCJ8rffLbCWBfwKmEu168HEEejQXqM9K6RLkl4v3VzD/JPEDWsCOzFQETiYXnrF
	/XJJbBjFp7lGWGxf5+FoAiOcleybJgfW3/mdLiqYQQU1A14fk3aC8LImtTBMbyw0as7HtGL9liWh4
	HcBHq9JvYLk0aa+9xDZhD72ideOV7hM8MbaqUbBFJ/Utl0Nv8wEX1ETtQVL5spkDmPGKoeg7qn1ET
	dt4BOX2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Dek-0079KB-1c;
	Wed, 29 Nov 2023 06:02:42 +0000
Date: Tue, 28 Nov 2023 22:02:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: repair inode records
Message-ID: <ZWbUAizpezw5fuZW@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927488.2771142.16279946215209833817.stgit@frogsfrogsfrogs>
 <ZWYek3C/x7pLqRFj@infradead.org>
 <20231128230848.GD4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231128230848.GD4167244@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 03:08:48PM -0800, Darrick J. Wong wrote:
> > 
> > We set the reflink flag by default, because a later stage will clear
> > it if there aren't any shared blocks, right?  Maybe add a comment to
> > avoid any future confusion.
> 
> 	/*
> 	 * For regular files on a reflink filesystem, set the REFLINK flag to
> 	 * protect shared extents.  A later stage will actually check those
> 	 * extents and clear the flag if possible.
> 	 */

Sounds good.

> > Hmm, changing a symlink to actually point somewhere seems very
> > surprising, but making it point to the current directory almost begs
> > for userspace code to run in loops.
> 
> How about '🤷'?  That's only four bytes.
> 
> Or maybe a question mark.

Heh.  I guess question marks seems a bit better, but the general idea
of having new names / different pointing locations show up in the
name space scare me a little.  I wonder if something like the classic
lost+found directory might be the right thing for anything we're not
sure about as people know about it.

> > > +	if (xfs_has_reflink(sc->mp)) {
> > > +		; /* data fork blockcount can exceed physical storage */
> > 
> > ... because we would be reflinking the same blocks into the same inode
> > at different offsets over and over again ... ?
> 
> Yes.  That's not a terribly functional file, but users can do such
> things if they want to pay for the cpu/metadata.

Yeah.  But maybe expand the comment a bit - having spent a fair amout
of time with the reflink code this was obvious to me, but for someone
new the above might be a bit too cryptic.

> > > +
> > > +	if (i_uid_read(VFS_I(sc->ip)) == -1U) {
> > 
> > What is invalid about all-F uid/gid/projid?
> 
> I thought those were invalid, though apparently they're not now?
> uidgid.h says:
> 
> static inline bool uid_valid(kuid_t uid)
> {
> 	return __kuid_val(uid) != (uid_t) -1;
> }
> 
> Which is why I thought that it's not possible to have a uid of -1 on a
> file.  Trying to set that uid on a file causes the kernel to reject the
> value, but OTOH I can apparently create inodes with a -1 UID via
> idmapping shenanigans.

Heh.  Just wanted an explanation for the check.  So a commnt is fine,
or finding a way to use the uid_valid and co helpers to make it
self-explanatory.
