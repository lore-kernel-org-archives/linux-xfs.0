Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1BE3A168F;
	Wed, 15 Apr 2026 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776265958; cv=none; b=GhmggiLAwxiq4xvO6uYGdmHrvasXvWLk3CcST3fiFYpKiqXPL4ZZ9otcyky5SYDCKdl1Lvgt6LO+3i8Svty6psy5HnNdgVCHydnDWrmTYap35O4ZIiaFjmSVL+eSrOQ6IHbSkY8WsOthUohewAQQKpAUOro/m/5/OGP2gjqnNO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776265958; c=relaxed/simple;
	bh=AS2hYBGRC9hDYcaVNPHpfXzVDzefp2LheycrPQtBeyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuKcdfMjbtRsfRQbBxQoekeJqIKwBwRNmZx0/FooZmsBjioOJeIPCtgLevh/dpejJvbXpMg7Ykx3/1qRJBglgv8m2P2yW6BUX2NRyU6stwZD+CzajFdlC4npkjUyb9bUZ6m9kDkTw+UI0CWJ0xvi7Ls693kEgEPyiDEM6TbLJIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXWYyFC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXWYyFC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D0DC19424;
	Wed, 15 Apr 2026 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776265958;
	bh=AS2hYBGRC9hDYcaVNPHpfXzVDzefp2LheycrPQtBeyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AXWYyFC9DvGsgYes7+CA7kqRs8JiG9820a3j7Obf/JJbdqSq3EpdGarSqDX+ihkKz
	 yE/xi4mC2yHPlOFZEfmB/cFCKgQ7sUdTj/syvnjokNpmxYo4Rkzj+kQEBijYGtVJoG
	 syKqOHz+2Y2dYqRHrQEbVNfJdgEGqt5YE7pw5BCb8R6ADQqxuTEZeQ5V/JFNxamNyW
	 LErL7oqL/HqHxzTd9/xVOoE4kbxMe3hKoCbFD7WC6C5282mK2/DvjFI2YFMjoHuq3H
	 +7b+da1+xNT95aTOylNhJwDCE6OTmPlx8txld3Fm5LwiJxLzUGT9uQW3CITjg7gM+q
	 G6rtnxmHGUGhw==
Date: Wed, 15 Apr 2026 08:12:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: Re: [PATCH] xfs: start inodegc after quota initialization
Message-ID: <20260415151237.GA114209@frogsfrogsfrogs>
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

Hmm.  Very very occasionally I'll see one generic/388 fail in xfs_repair
with slightly wrong quota icount.  /me wonders if this might be it?  In
theory quotacheck could be run to fix the accounting inaccuracies (ugh)
but it's probably better just to defer gc startup.

My original question ("can any code push an inode to gc...?") remains.

--D
