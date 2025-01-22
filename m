Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD488467;
	Wed, 22 Jan 2025 04:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737518915; cv=none; b=JCSYMSEQwAs9Chiv8k+02Q/rKO7RHsp+iiEKGqo3ibBjDnE9jQ2SqG9KFWjM3qy/ihOBMcAsLcce4cNfuZa3DTzRiww62pKaelJ9gnpRGUgJrM8oT3ZxAsuGiF2I5lv4NiItyYlZBnlu1YYC0IsLFDWFduUmDofjvofc55LfnRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737518915; c=relaxed/simple;
	bh=ve9kZowSsLkfZE8y9TL97AxOZf/CwYp08bU7c3S9hBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLUXmsOei29M9hkTcq/vxNQTZP5zODlPO+RQqb8zVoIhpdePLy+KJCiIo3CT28TgP6YXVY8PbsT5IUVvpjUS1HmEeVhe+pPdNsrlVK8W7Akx+cuVU09Dup8qk0aVAiCuE1A+rDhXratVCgzsjVmQbNKDsxe470OPBbhqynYKjhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2P0vAhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2P0vAhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A89C4CED6;
	Wed, 22 Jan 2025 04:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737518914;
	bh=ve9kZowSsLkfZE8y9TL97AxOZf/CwYp08bU7c3S9hBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T2P0vAhNK/0in6g7CDpintnDDJX0bnZN18KCmogwMCVr+bvPqF3DvJPYN6utsPAfN
	 IKFObB/fdVOPxzDCe/9IjTWr4GFbDBjwMghVRk0DekRBz5u45jE69uPf0cWHvwzzPt
	 jIm31dqySnEt7/mjIcXaZV8G8Cx3GAYz1owjIGHgzVV/twsDEVJqVj6s0vLe5kLTAJ
	 2sfW8MZx9K5+VxF26HNeQwXMaZKIjeB3i3r5v59RrHaRjoy9EUq64xom4Oj8468Xg5
	 jlvmtBnUk1ACcVAK9I4KYHEUcgPs95aZPshxrwX2SIbGLTZuXJ+JDKEvUWkwqUbr9F
	 XW+EBOFgebEhQ==
Date: Tue, 21 Jan 2025 20:08:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/23] generic/032: fix pinned mount failure
Message-ID: <20250122040834.GW1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974288.1927324.17585931341351454094.stgit@frogsfrogsfrogs>
 <Z48qm4BG6tlp5nCa@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48qm4BG6tlp5nCa@dread.disaster.area>

On Tue, Jan 21, 2025 at 04:03:23PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:28:49PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/032 now periodically fails with:
> > 
> >  --- /tmp/fstests/tests/generic/032.out	2025-01-05 11:42:14.427388698 -0800
> >  +++ /var/tmp/fstests/generic/032.out.bad	2025-01-06 18:20:17.122818195 -0800
> >  @@ -1,5 +1,7 @@
> >   QA output created by 032
> >   100 iterations
> >  -000000 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  >................<
> >  -*
> >  -100000
> >  +umount: /opt: target is busy.
> >  +mount: /opt: /dev/sda4 already mounted on /opt.
> >  +       dmesg(1) may have more information after failed mount system call.
> >  +cycle mount failed
> >  +(see /var/tmp/fstests/generic/032.full for details)
> > 
> > The root cause of this regression is the _syncloop subshell.  This
> > background process runs _scratch_sync, which is actually an xfs_io
> > process that calls syncfs on the scratch mount.
> > 
> > Unfortunately, while the test kills the _syncloop subshell, it doesn't
> > actually kill the xfs_io process.  If the xfs_io process is in D state
> > running the syncfs, it won't react to the signal, but it will pin the
> > mount.  Then the _scratch_cycle_mount fails because the mount is pinned.
> > 
> > Prior to commit 8973af00ec212f the _syncloop ran sync(1) which avoided
> > pinning the scratch filesystem.
> 
> How does running sync(1) prevent this? they run the same kernel
> code, so I'm a little confused as to why this is a problem caused
> by using the syncfs() syscall rather than the sync() syscall...

Instead of:
_scratch_sync -> _sync_fs $SCRATCH_MNT -> $XFS_IO_PROG -rxc "syncfs" $SCRATCH_MNT

sync(1) just calls sync(2) with no open files other than
std{in,out,err}.

--D

> > Fix this by pgrepping for the xfs_io process and killing and waiting for
> > it if necessary.
> 
> Change looks fine, though.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
