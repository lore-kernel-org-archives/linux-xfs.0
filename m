Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F414D58F
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umkNv26O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1A4C433C7;
	Wed, 10 Jan 2024 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704908843;
	bh=rarbayFg4ojRToz3K39LuGUIqO/ygiazw93J+JF5IJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=umkNv26OZoy9MEPQ5cZejSyiv/KywoLB0+k8gW2caw2QnbukkM89V5opgI0qwnBiq
	 uLHbf+B+uFqTckoubfenJ/37Va9Uu5GSDPozqOA1LSw+RxpRg592afB0oXwgnQprjj
	 lsW+x+6ago6BDNPmYeiinyoUA2QzQGRU4xS9R/D1LS7qHkVRqyVr/h/syiuaUuhHB2
	 4/wgNKMw/MIuKuY7ow/3LK5bCittpK8F+np92FYdPuVzlxoQs3shMmqpf9uqyaGO5k
	 3reoEG790VBSEb+6QqsfHW22TKYshDnxA8Qpp7PBf8ZmktAv6OdeH5SxZaBH1zYk0N
	 SJqNhFxn4jkaw==
Date: Wed, 10 Jan 2024 09:47:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix backwards logic in xfs_bmap_alloc_account
Message-ID: <20240110174723.GI722975@frogsfrogsfrogs>
References: <20240109021734.GB722975@frogsfrogsfrogs>
 <87cyu9ijfc.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cyu9ijfc.fsf@debian-BULLSEYE-live-builder-AMD64>

On Wed, Jan 10, 2024 at 03:41:32PM +0530, Chandan Babu R wrote:
> On Mon, Jan 08, 2024 at 06:17:34 PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > We're only allocating from the realtime device if the inode is marked
> > for realtime and we're /not/ allocating into the attr fork.
> >
> > Fixes: 8a3cf489410dd ("xfs: also use xfs_bmap_btalloc_accounting for RT allocations")
> 
> The commit ID should be 58643460546d
> (https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?id=58643460546da1dc61593fc6fd78762798b4534f)
> right?
> 
> If yes, I will fix it before pushing it for-next.

Yes.  Apparently I ran git blame on the wrong branch. :(

--D

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index ed7e11697249e..e1f2e61cb308e 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3320,7 +3320,7 @@ xfs_bmap_alloc_account(
> >  	struct xfs_bmalloca	*ap)
> >  {
> >  	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
> > -					(ap->flags & XFS_BMAPI_ATTRFORK);
> > +					!(ap->flags & XFS_BMAPI_ATTRFORK);
> >  	uint			fld;
> >  
> >  	if (ap->flags & XFS_BMAPI_COWFORK) {
> 
> -- 
> Chandan
> 
