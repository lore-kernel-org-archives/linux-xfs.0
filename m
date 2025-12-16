Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F66247DE1;
	Tue, 16 Dec 2025 19:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911917; cv=none; b=WpftM8iAGDg65FJigcXyM7q97o9JiDR8oIAy4yPO08VPFUxw2lXTvgLaBtTjDTeb+eoxgMvXyo41YbtrnntTBoI55pFPxScuTCn3viV432NYJxTSN8hqjMd2La9LxZPGaX4ycuu8a96HSlXi+WEHlNxYiYK8X0f0Nb+rHc6VtYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911917; c=relaxed/simple;
	bh=tszyIee8QQiwVf3eWQq0zgt+oOG6xxOhTFlv1uH82Vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MeNsy3vfwcQ/Aysyi6dtOw4j5ZS1N/gmYvWuTX8pkRELTkcKlxeyLRCaFqHtKaJdX1PbiKPCeAOcojogqL+E6Kq0lmZFWUcvt0J19zif9FcT4I2k3IfY7JH9s6oZdNWFP0053C/nby9OqagTlJSzzs8l7ZeaM58fhbMhfRrLVPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+sH6mjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+sH6mjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DC4C4CEF1;
	Tue, 16 Dec 2025 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765911916;
	bh=tszyIee8QQiwVf3eWQq0zgt+oOG6xxOhTFlv1uH82Vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y+sH6mjIl3yEWwOkWa+rnICi0elhaUiFHcpI5hMV4VFl2Dm5s/MZf/4PjOvW6/Z6U
	 lp61ebRj+FyS3yWLCnebkVD6/2C9V4n+AkLD5M51qzbNrahZDnaCoaDafZHn6ug/zL
	 YOkqzQqVKU6CvAIx0FLfubM9Oy9xLVf0qMXadEV7mVvV0laL06nvekwe3x57x3p19G
	 WAJlRMLCFl/gZ9crBuwbMNTvH2RzwCop2w/Qo1RyeMASOfv38RWjBVQ3htBtrEx3O9
	 EnVNargKDEZWryoILs2ugLj7G8t4RmtwBBjLANVwdka2ieZoMXxmBKTFSJaA/TZIjU
	 GYq5bIq6B+CMQ==
Date: Tue, 16 Dec 2025 11:05:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a test that zoned file systems with rump
 RTG can't be mounted
Message-ID: <20251216190516.GH7716@frogsfrogsfrogs>
References: <20251215095036.537938-1-hch@lst.de>
 <20251215095036.537938-2-hch@lst.de>
 <20251215193345.GM7725@frogsfrogsfrogs>
 <20251216051205.GB26237@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216051205.GB26237@lst.de>

On Tue, Dec 16, 2025 at 06:12:05AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 15, 2025 at 11:33:45AM -0800, Darrick J. Wong wrote:
> > > +_scratch_mkfs > /dev/null 2>&1
> > > +blocks=$(_scratch_xfs_db -c 'sb 0' -c 'print rblocks' | awk '{print $3}')
> > > +blocks=$((blocks - 4096))
> > > +_scratch_xfs_db -x -c 'sb 0' -c "write -d rblocks $blocks" > /dev/null 2>&1
> > > +_scratch_xfs_db -x -c 'sb 0' -c "write -d rextents $blocks" > /dev/null 2>&1
> > 
> > You could put both of the write commands in the same invocation, e.g.
> > 
> > _scratch_xfs_db -x \
> > 	-c 'sb 0' \
> > 	-c "write -d rblocks $blocks" \
> > 	-c "write -d rextents $blocks" > /dev/null 2>&1
> > 
> > For a little bit lower runtime.
> 
> I can do that, but I doubt it really matters..
> 
> > > +if _try_scratch_mount >/dev/null 2>&1; then
> > > +	# for non-zoned file systems this can succeed just fine
> > > +	_require_xfs_scratch_non_zoned
> > 
> > The logic in this test looks fine to me, but I wonder: have you (or
> > anyone else) gone to Debian 13 and noticed this:
> > 
> > # mount /dev/sda /mnt
> > # mount /dev/sda /mnt
> > # grep /mnt /proc/mounts
> > /dev/sda /mnt xfs rw,relatime,inode64,logbufs=8,logbsize=32k,noquota 0 0
> > /dev/sda /mnt xfs rw,relatime,inode64,logbufs=8,logbsize=32k,noquota 0 0
> > 
> > It looks like util-linux switched to the new fsopen mount API between
> > Debian 12 and 13, and whereas the old mount(8) would fail if the fs was
> > already mounted, the new one just creates two mounts, which both then
> > must be unmounted.  So now I'm hunting around for unbalanced
> > mount/unmount pairs in fstests. :(
> 
> The old mount API also supported that at the syscall level, but it got
> disable in mount(8), so if mount now does this and previously didn't it
> seems like an unintended change.

Oh, it's very much an intentional change.  Someone complained and the
maintainer declined to revert:
https://github.com/util-linux/util-linux/issues/3800

because we can all just add --onlyonce to our scripts if we want the old
behavior.  Or set LIBMOUNT_FORCE_MOUNT2=always and hope that doesn't go
away.

--D
