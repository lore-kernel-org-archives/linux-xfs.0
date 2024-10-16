Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42672D520
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729099940; cv=none; b=R7kbtg6OdqwGrgquvWJCdf/9wuUdo3G7FnLx+U8zEpQwWdCMG6nB/lIEepbLFFbG2wk+koB/QqL23WPJGs7uBSwvnzswLk2Xv9VaDLG3hDHlBN7/7QzMnA+tyYUSQRYlkpvlERkIl3KOOA2jGcU9bZpDbJmgjsh6JgMKWBG7OBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729099940; c=relaxed/simple;
	bh=G5d6wYf8inE3LXLwJ4a11CwrNfpGFvNP3PqjhvJ92sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrie3D0RpRmH5deiXHzwxc7Q76idcPOb4LW1joHZyqwvB3kqV9Ja4KDl9q5Gz4kfaCBVehjiohwxf/JGrWKIAeUj4Qi6HxYzoUrntFpNfhsevbOad3hf5WNoGUGVwQrx4wSpQQyF6StXCf3JtCoNjMicJzHvAekUeJdBA07S32M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssf5OilQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssf5OilQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3525C4CEC5;
	Wed, 16 Oct 2024 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729099939;
	bh=G5d6wYf8inE3LXLwJ4a11CwrNfpGFvNP3PqjhvJ92sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssf5OilQ73xrwbVDBond6sYZK1SW5yZeihc1GY15S360cti6UeYybbdxsBNNaIgcl
	 4po65CglZugczheZ1DGeSxJakIXgYhUsY7l1316av400oMYNelHTz4Dzr3A2ZYkRQU
	 30sOIdUjVRh0LO4ndXfLH7HN7DuFesCejSaVetdXwP0c2biOMWEv8mTMaIN9KMCsca
	 Yn2xh1qHSyIV5HAx/nKV+Eu3gCfjwn9QpxmlKXVwOnJsXfRAy/DYy92OZBkzcA0SdI
	 pSNwW6D9ZHTRQAEuS2v2JdnAaxuhA2VFTJLf/O0pr7zhok7zqhX3EMNvba01IPNzDk
	 H3RxOZHJrB5uw==
Date: Wed, 16 Oct 2024 10:32:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <20241016173219.GM21853@frogsfrogsfrogs>
References: <20241011182407.GC21853@frogsfrogsfrogs>
 <Zw4xYRG5LOHuBn4H@dread.disaster.area>
 <20241015165921.GA21853@frogsfrogsfrogs>
 <Zw7mKivaebxnZa7C@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw7mKivaebxnZa7C@dread.disaster.area>

On Wed, Oct 16, 2024 at 09:01:14AM +1100, Dave Chinner wrote:
> On Tue, Oct 15, 2024 at 09:59:21AM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 15, 2024 at 08:09:53PM +1100, Dave Chinner wrote:
> > > On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Check this with every kernel and userspace build, so we can drop the
> > > > nonsense in xfs/122.  Roughly drafted with:
> > > > 
> > > > sed -e 's/^offsetof/\tXFS_CHECK_OFFSET/g' \
> > > > 	-e 's/^sizeof/\tXFS_CHECK_STRUCT_SIZE/g' \
> > > > 	-e 's/ = \([0-9]*\)/,\t\t\t\1);/g' \
> > > > 	-e 's/xfs_sb_t/struct xfs_dsb/g' \
> > > > 	-e 's/),/,/g' \
> > > > 	-e 's/xfs_\([a-z0-9_]*\)_t,/struct xfs_\1,/g' \
> > > > 	< tests/xfs/122.out | sort
> > > > 
> > > > and then manual fixups.
> > > 
> > > [snip on disk structures]
> > > 
> > > I don't think we can type check all these ioctl structures,
> > > especially the old ones.
> > > 
> > > i.e. The old ioctl structures are not padded to 64 bit boundaries,
> > > nor are they constructed without internal padding holes, and this is
> > > why compat ioctls exist. Hence any ioctl structure that has a compat
> > > definition in xfs_ioctl32.h can't be size checked like this....
> > > 
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,		8);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,		40);
> > > > +	XFS_CHECK_STRUCT_SIZE(xfs_exntst_t,				4);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fid,				16);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,			128);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,				8);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,			32);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,			256);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,			112);
> > > 
> > > e.g. xfs_fsop_geom_v1 is 108 bytes on 32 bit systems, not 112:
> > > 
> > > struct compat_xfs_fsop_geom_v1 {
> > >         __u32                      blocksize;            /*     0     4 */
> > >         __u32                      rtextsize;            /*     4     4 */
> > >         __u32                      agblocks;             /*     8     4 */
> > >         __u32                      agcount;              /*    12     4 */
> > >         __u32                      logblocks;            /*    16     4 */
> > >         __u32                      sectsize;             /*    20     4 */
> > >         __u32                      inodesize;            /*    24     4 */
> > >         __u32                      imaxpct;              /*    28     4 */
> > >         __u64                      datablocks;           /*    32     8 */
> > >         __u64                      rtblocks;             /*    40     8 */
> > >         __u64                      rtextents;            /*    48     8 */
> > >         __u64                      logstart;             /*    56     8 */
> > >         /* --- cacheline 1 boundary (64 bytes) --- */
> > >         unsigned char              uuid[16];             /*    64    16 */
> > >         __u32                      sunit;                /*    80     4 */
> > >         __u32                      swidth;               /*    84     4 */
> > >         __s32                      version;              /*    88     4 */
> > >         __u32                      flags;                /*    92     4 */
> > >         __u32                      logsectsize;          /*    96     4 */
> > >         __u32                      rtsectsize;           /*   100     4 */
> > >         __u32                      dirblocksize;         /*   104     4 */
> > > 
> > >         /* size: 108, cachelines: 2, members: 20 */
> > >         /* last cacheline: 44 bytes */
> > > } __attribute__((__packed__));
> > > 
> > > I'm not sure we need to size check these structures - if they change
> > > size, the ioctl number will change and that means all the userspace
> > > test code built against the system /usr/include/xfs/xfs_fs.h file
> > > that exercises the ioctls will stop working, right? i.e. breakage
> > > should be pretty obvious...
> > 
> > It should, though I worry about the case where we accidentally change
> > the size on some weird architecture, some distro ships a new release
> > with everything built against the broken headers, and only later does
> > someone notice that their old program now starts failing.
> > 
> > I guess the question is, do we hardcode the known sizes here, e.g.
> > 
> > 	XFS_CHECK_IOCTL_SIZE(struct xfs_fsop_geom_v1, 108, 112);
> > 
> > wherein we'd assert that sizeof() == 108 || sizeof() == 112?
> 
> This feels kinda fragile. We want the compiler to do the validation
> work for both the normal and compat ioctl structures. Just
> specifying two sizes doesn't actually do that.
> 
> i.e. this really needs to check that the structure size is the same
> on all 64 bit platforms, the compat structure is the same on -all-
> platforms (32 and 64 bit), and that the the structure size is the
> same as the compat structure size on all 32 bit platforms....
> 
> > Or not care if things happen to the ioctls?  Part of aim of this posting
> > was to trick the build bots into revealing which architectures break on
> > the compat ioctl stuff... ;)
> 
> If that's your goal, then this needs to be validating the compat
> structures are the correct size, too.

My goal was to get rid of xfs/122 but as this is turning into a messy
cleanup I'm going to drop the whole thing on the floor.  I don't think
anyone runs xfs/122 anyway so I'll just put it in my expunge list;
someone else who isn't as burned out as I am can pick it up if they
choose.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
