Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4261F76AF
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011562; cv=none; b=cu8bGPLJDXEn/e70VwqEDGVq1SNAFIslbObf/1beWOmpC4tHfcbMoQjEBREKXSVBml9MMJcfjejlqYzJLlD3cp7iKPSQxif1F14Ym5wjsxsro5cYTIyW28rycHwtuEIRTEHSqihVx/8hnxp/MMqT8xD0OLCCXIaMmggkpx8RhBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011562; c=relaxed/simple;
	bh=maLL6LadKpMfU+IVw8AExhpNKGmpCHRPd7rXDg5lNhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJ5ijlCRAUfKTb1z954fgQxPGtehseV88omBrvicljMUzMkf9lsOJYpmdV0chpZ4W3Yl8hv1aj086BIFS+JPsFxcNxEYLXD/WzmCB2uS6PBojJaxYao+7KzxPN7415LWqG3UNcfD/4BIQTSVglJd46/S0uq27XfbOvXODbTe35U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxsifxSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxsifxSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03F4C4CEC6;
	Tue, 15 Oct 2024 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729011561;
	bh=maLL6LadKpMfU+IVw8AExhpNKGmpCHRPd7rXDg5lNhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SxsifxSVhsAk8t/bDwlPimCDPHINxSrsiV1NcqhCNh/QvPkLyG4My0vHkMePN6BmM
	 sh+K5XzElV211MH1gYsB8nVrKZC809IHe4TKpRMFPibdgT8c89Um79ogWaW/onstER
	 eb74FNKoD3OVEtoW5RX98x7Xx7ggkbyJ1gpP2IGRt3TYyzBa+FN5Jgoyu/aYnNvJDF
	 bCMdJq9JfGiAkuAFcQcufnALfxuPv5eh5QHAgO8Hc2joJ51HWJ8ys/huDuNBK4BMUN
	 y5KPf5C70vaKbAyUCF7SctsH1VOE+dw55Y8N+J1RyrzbrWmhVDLnGjkuTtMZD8YNkM
	 CowI327LHcpWA==
Date: Tue, 15 Oct 2024 09:59:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <20241015165921.GA21853@frogsfrogsfrogs>
References: <20241011182407.GC21853@frogsfrogsfrogs>
 <Zw4xYRG5LOHuBn4H@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw4xYRG5LOHuBn4H@dread.disaster.area>

On Tue, Oct 15, 2024 at 08:09:53PM +1100, Dave Chinner wrote:
> On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Check this with every kernel and userspace build, so we can drop the
> > nonsense in xfs/122.  Roughly drafted with:
> > 
> > sed -e 's/^offsetof/\tXFS_CHECK_OFFSET/g' \
> > 	-e 's/^sizeof/\tXFS_CHECK_STRUCT_SIZE/g' \
> > 	-e 's/ = \([0-9]*\)/,\t\t\t\1);/g' \
> > 	-e 's/xfs_sb_t/struct xfs_dsb/g' \
> > 	-e 's/),/,/g' \
> > 	-e 's/xfs_\([a-z0-9_]*\)_t,/struct xfs_\1,/g' \
> > 	< tests/xfs/122.out | sort
> > 
> > and then manual fixups.
> 
> [snip on disk structures]
> 
> I don't think we can type check all these ioctl structures,
> especially the old ones.
> 
> i.e. The old ioctl structures are not padded to 64 bit boundaries,
> nor are they constructed without internal padding holes, and this is
> why compat ioctls exist. Hence any ioctl structure that has a compat
> definition in xfs_ioctl32.h can't be size checked like this....
> 
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,		8);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,		40);
> > +	XFS_CHECK_STRUCT_SIZE(xfs_exntst_t,				4);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fid,				16);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,			128);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,				8);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,			32);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,			256);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,			112);
> 
> e.g. xfs_fsop_geom_v1 is 108 bytes on 32 bit systems, not 112:
> 
> struct compat_xfs_fsop_geom_v1 {
>         __u32                      blocksize;            /*     0     4 */
>         __u32                      rtextsize;            /*     4     4 */
>         __u32                      agblocks;             /*     8     4 */
>         __u32                      agcount;              /*    12     4 */
>         __u32                      logblocks;            /*    16     4 */
>         __u32                      sectsize;             /*    20     4 */
>         __u32                      inodesize;            /*    24     4 */
>         __u32                      imaxpct;              /*    28     4 */
>         __u64                      datablocks;           /*    32     8 */
>         __u64                      rtblocks;             /*    40     8 */
>         __u64                      rtextents;            /*    48     8 */
>         __u64                      logstart;             /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         unsigned char              uuid[16];             /*    64    16 */
>         __u32                      sunit;                /*    80     4 */
>         __u32                      swidth;               /*    84     4 */
>         __s32                      version;              /*    88     4 */
>         __u32                      flags;                /*    92     4 */
>         __u32                      logsectsize;          /*    96     4 */
>         __u32                      rtsectsize;           /*   100     4 */
>         __u32                      dirblocksize;         /*   104     4 */
> 
>         /* size: 108, cachelines: 2, members: 20 */
>         /* last cacheline: 44 bytes */
> } __attribute__((__packed__));
> 
> I'm not sure we need to size check these structures - if they change
> size, the ioctl number will change and that means all the userspace
> test code built against the system /usr/include/xfs/xfs_fs.h file
> that exercises the ioctls will stop working, right? i.e. breakage
> should be pretty obvious...

It should, though I worry about the case where we accidentally change
the size on some weird architecture, some distro ships a new release
with everything built against the broken headers, and only later does
someone notice that their old program now starts failing.

I guess the question is, do we hardcode the known sizes here, e.g.

	XFS_CHECK_IOCTL_SIZE(struct xfs_fsop_geom_v1, 108, 112);

wherein we'd assert that sizeof() == 108 || sizeof() == 112?

Or not care if things happen to the ioctls?  Part of aim of this posting
was to trick the build bots into revealing which architectures break on
the compat ioctl stuff... ;)

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
