Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A015B99A
	for <linux-xfs@vger.kernel.org>; Wed, 29 May 2024 07:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716966832; cv=none; b=nxTjMFHygqI0guQjxph3n3IkVDCH0AGRGQvRUV4t0n4k4pUUbXOiNQfsch2Tt8fBY6z6x/aD0l1XiqGP3x0pCrxYwPNXaf/4OTZNjjHhkD5k4tFKxT+emBD98QcRQJR+SriXNOju6T03FP8LrJWYnj6do9uMQPltrSkSB/Jqm8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716966832; c=relaxed/simple;
	bh=q+6DGofejyWJwZMfQce/qAs8oSL6Sj8lNquP/+7a+d4=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=q03AM3Zl/+lUEqfcAU0jDr96L86igrIJGtOtczGXkAn/i66PbCxt9njtbsJEtF0vN4BD5HbppDFLuvht/S9rgTEKBdV2/ljHKCyfonezr83bkAs8byQu0eXZoG0T4USEcfL1/WL4EfnWv+KMRH7RnOH2eLgSBKGbqaIY3uPb+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDrlvjSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDrlvjSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ED1C2BD10;
	Wed, 29 May 2024 07:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716966832;
	bh=q+6DGofejyWJwZMfQce/qAs8oSL6Sj8lNquP/+7a+d4=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=kDrlvjSLOZ6nEXY/gMS4yN89BX1vJU1AUdorRXVOWns4c1DpXVYhNfYELKMOvyUdc
	 GEl7x+q8QKDK/iqLagi+wfWgkE9KJVoCMOvNiYMv6gGOg/0fKF6ZMBXDka6MDlLgli
	 eRCmG3QVLqGMhlPP26Ukyh+SZZranP5tQoIwK2DqtWInJ84lO58JUkqLv7faNJS/Ev
	 A/TliVcJeVCD32NvG9bdRMTfXokZzvIRBiPWvEkAhJ6SWkYLef2ViN94y16gmx1GHO
	 VtD+e6iVLq/UyleTxJQvRI4CcQda2/mbBqd4+KWkCB7LDmFwB4nHIlP5WL6JwXQFEw
	 dfsdeo2eoCENw==
References: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
 <171635763423.2619960.122476714020756620.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: allow symlinks with short remote targets
Date: Wed, 29 May 2024 12:40:08 +0530
In-reply-to: <171635763423.2619960.122476714020756620.stgit@frogsfrogsfrogs>
Message-ID: <878qztqee2.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, May 21, 2024 at 11:02:16 PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> An internal user complained about log recovery failing on a symlink
> ("Bad dinode after recovery") with the following (excerpted) format:
>
> core.magic = 0x494e
> core.mode = 0120777
> core.version = 3
> core.format = 2 (extents)
> core.nlinkv2 = 1
> core.nextents = 1
> core.size = 297
> core.nblocks = 1
> core.naextents = 0
> core.forkoff = 0
> core.aformat = 2 (extents)
> u3.bmx[0] = [startoff,startblock,blockcount,extentflag]
> 0:[0,12,1,0]
>
> This is a symbolic link with a 297-byte target stored in a disk block,
> which is to say this is a symlink with a remote target.  The forkoff is
> 0, which is to say that there's 512 - 176 == 336 bytes in the inode core
> to store the data fork.
>
> Eventually, testing of generic/388 failed with the same inode corruption
> message during inode recovery.  In writing a debugging patch to call
> xfs_dinode_verify on dirty inode log items when we're committing
> transactions, I observed that xfs/298 can reproduce the problem quite
> quickly.
>
> xfs/298 creates a symbolic link, adds some extended attributes, then
> deletes them all.  The test failure occurs when the final removexattr
> also deletes the attr fork because that does not convert the remote
> symlink back into a shortform symlink.  That is how we trip this test.
> The only reason why xfs/298 only triggers with the debug patch added is
> that it deletes the symlink, so the final iflush shows the inode as
> free.
>
> I wrote a quick fstest to emulate the behavior of xfs/298, except that
> it leaves the symlinks on the filesystem after inducing the "corrupt"
> state.  Kernels going back at least as far as 4.18 have written out
> symlink inodes in this manner and prior to 1eb70f54c445f they did not
> object to reading them back in.
>
> Because we've been writing out inodes this way for quite some time, the
> only way to fix this is to relax the check for symbolic links.
> Directories don't have this problem because di_size is bumped to
> blocksize during the sf->data conversion.
>

Darrick, This patch causes xfs/348 to fail. To be precise, the case where the
test sets the file type of all inodes to 12 (a symbolic link) causes the DATA
inode (i.e. a regular file) to be interpreted as a symbolic link. The test
however expected 'stat' to fail with EUCLEAN. Hence the test needs to be
fixed.

-- 
Chandan
