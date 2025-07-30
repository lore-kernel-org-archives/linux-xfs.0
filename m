Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7199E15853B;
	Wed, 30 Jul 2025 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753887310; cv=none; b=amlVgIRr6svo2z5Gzd1IsyF1pxRv9sZb4cwKUdzjlbH8hldrOU4o/934KVaXu/Xk0tkXeYgOrXk/hGwcE97TdQZ+S8Kdy0srRNKG4Mmt4xU8VTgXGVuQ0wXXONADBLirBD/pwe09xMdCzmJ1+o8i+svgwYj9J1giuKR6/bsqbHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753887310; c=relaxed/simple;
	bh=Is5SR4yjs0yXGmobo01WhgVR/Cx5zQf8yEdy2rG2+lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1DxSF2RhhAIkffjtEeakfC0sW8uowCpbJ8JaJcSlbhsG9KL4OqHQRJHcu+GoKx8G83Ye3o2nXYml3Z18l9USJYFouaIB/TWAAmtTiyn+n807grUFeXjCzjf4zsGQbnGwlyWJQfHxvfeQwsm6Dey5E2/SIyQ+h9asyELf/3a0wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y34oZX3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y34oZX3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFD5C4CEE3;
	Wed, 30 Jul 2025 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753887310;
	bh=Is5SR4yjs0yXGmobo01WhgVR/Cx5zQf8yEdy2rG2+lk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y34oZX3sVh+w1AMS27DbfFbqRZFjMA1nPPkr6GY9a+TUv2trfvxLyfw2HG/YtGVtP
	 NC0btV8FIC0XxOEhSnYMGcVYQOta603mkfPK9UFqyXQvJvR8vZMzgRtsCqmSJ/GQ0I
	 fOBmxqCFfX1X1mP6TTgOvm2aY3WfonHD4oof6vTt01FpFfkK2z2Q1i6UcuTYr4Hw+b
	 MvfNTgaxcOUZSdgtfE9zxk956W+8qngH5Uyf5+Nmq85QUJbDFTc37KXp1BhO/OeoDu
	 hQyeSbjn/QBOOhsTVp2gTz5RbE7YaFh63oX5mes1Q13K5TLDkJXd+ny0d88IcwhF3j
	 DJP6fhoqdeAkg==
Date: Wed, 30 Jul 2025 07:55:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fsstress: don't abort when stat(".") returns EIO
Message-ID: <20250730145509.GX2672039@frogsfrogsfrogs>
References: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
 <175381958421.3021194.16249782318690545446.stgit@frogsfrogsfrogs>
 <aIoq3LgL2ODgENFy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIoq3LgL2ODgENFy@infradead.org>

On Wed, Jul 30, 2025 at 07:23:24AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 29, 2025 at 01:10:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > First, start with the premise that fstests is run with a nonzero limit
> > on the size of core dumps so that we can capture the state of
> > misbehaving fs utilities like fsck and scrub if they crash.
> 
> Can you explain what this has to do with core dumping?
> 
> I'm just really confused between this patch content and the subject of
> this patch and the entire series..

It's a bugfix ahead of new behaviors introduced in patch 2.  I clearly
didn't explain this well enough, so I'll try again.

Before abrt/systemd-coredump, FS_IOC_SHUTDOWN fsstress tests would do
something like the following:

1. start fsstress, which chdirs to $TEST_DIR
2. shut down the filesystem
3. fsstress tries to stat($TEST_DIR), fails, and calls abort
4. abort triggers coredump
5. kernel fails to write "core" to $TEST_DIR (because fs is shut down)
6. test finishes, no core files written to $here, test passes

Once you install systemd-coredump, that changes to:

same 1-4 above
5. kernel pipes core file to coredumpctl, which writes it to /var/crash
6. test finishes, no core files written to $here, test passes

And then with patch 2 of this series, that becomes:

same 1-4 above
5. kernel pipes core file to coredumpctl, which writes it to /var/crash
6. test finishes, ./check queries coredumpctl for any new coredumps,
   and copies them to $here
7. ./check finds core files written to $here, test fails

Now we've caused a test failure where there was none before, simply
because the crash reporting improved.

Therefore this patch changes fsstress not to call abort() from check_cwd
when it has a reasonable suspicion that the fs has died.

(Did that help?  /me is still pre-coffee...)

> > This is really silly, because basic stat requests for the current
> > working directory can be satisfied from the inode cache without a disk
> > access.  In this narrow situation, EIO only happens when the fs has shut
> > down, so just exit the program.
> 
> If we think it's silly we can trivially drop the xfs_is_shutdown check
> in xfs_vn_getattr.  But is it really silly?  We've tried to basically
> make every file system operation consistently fail on shut down
> file systems,

No no, "really silly" refers to failing tests that we didn't used to
fail.

> > We really should have a way to query if a filesystem is shut down that
> > isn't conflated with (possibly transient) EIO errors.  But for now this
> > is what we have to do. :(
> 
> Well, a new STATX_ flag would work, assuming stat doesn't actually
> fail :)  Otherwise a new ioctl/fcntl would make sense, especially as
> the shutdown concept has spread beyond XFS.

I think we ought to add a new ioctl or something so that callers can
positively identify a shut down filesystem.  bfoster I think was asking
about that for fstests some years back, and ended up coding a bunch of
grep heuristics to work around the lack of a real call.

I think we can't drop the "stat{,x} returns EIO on shutdown fs" behavior
because I know of a few, uh, users whose heartbeat monitor periodically
queries statx($PWD) and reboots the node if it returns errno.

--D
