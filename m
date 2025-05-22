Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B2A50
	for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 00:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747873262; cv=none; b=IjrxO7Pg6wvsgefbINiBe91xJZYJfI+O+DhxZvdYsXBM5bwsJdm+XOzZL7XO3/j2XTjam7u21OKsw1j1mfap4j7MthRdkTWFVncOIVv2LAXPPDByofILOEHgCDqvFb5bCkiWVse4wbP6mC3sbJC3pe4GHoWdmbatj48QTE0FPJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747873262; c=relaxed/simple;
	bh=czJ7AhrlBP7/c1K6QTb9/+wakBkWWggOVGhugbuID+M=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8+fFIUT3ULwNvlEIVir/nAI+rwdA//Q7Zq8xBK3YH9pZnoQWDLWQejaCJht3NFFL2ikcW5A4JSZGv7UN9sGQs9pWxOaMRooDIvU7zUjPT6BbuzONNyVtWuHg2gart4yxiaG/m/DTOLtd83ts4HDq7HhuuZetZRlWM2M2D+0pJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvUsqgkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvUsqgkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B06BC4CEE4
	for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 00:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747873262;
	bh=czJ7AhrlBP7/c1K6QTb9/+wakBkWWggOVGhugbuID+M=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=kvUsqgkQE5PloiqxBFbTt1GhOUD/Js0yj5xnp35gVP4JK+zfVPLf74brVtZ3MJFuD
	 XQ/5DMYuYCc3AfYlbs4HTSbOk0r1OBEPz/qx1C/THTG3musiIDbYQ2+gX+qoVvIpA0
	 H95tcToymJua+SRocnONFZLDZ8a22qAUOXT3d81oGYRTOCMDyiHXGxAgThJy1vDV6Q
	 zyrfVdZaqSBCJMrsZ6ATw9rEz4Ec3xW117klK0h8LkW0D7tKcNQ3VmOOkXjfCD6ynJ
	 CiqxtLxoQohBrNZ+vqBbT+sXTH4U30YcTSmh7eWoS0ENloEq34CPgKH+b2xkrPOq5i
	 PJqnqELBYmviQ==
Date: Wed, 21 May 2025 17:21:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET RFC[RAP]] fuse: allow servers to use iomap for better
 file IO performance
Message-ID: <20250522002101.GD9705@frogsfrogsfrogs>
References: <20250521235837.GB9688@frogsfrogsfrogs>
 <174787195502.1483178.17485675069927796174.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174787195502.1483178.17485675069927796174.stgit@frogsfrogsfrogs>

Whoops, my eyes are tired and my script to strip out linux-xfs and cem
from the cc lines didn't work because I inverted a space and a comma in
the regexp.

Sorry about the noise.  Can we move off patchbomb development already?

--D

On Wed, May 21, 2025 at 05:01:22PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series connects fuse (the userspace filesystem layer) to fs-iomap to get
> fuse servers out of the business of handling file I/O themselves.  By keeping
> the IO path mostly within the kernel, we can dramatically improve the speed of
> disk-based filesystems.  This enables us to move all the filesystem metadata
> parsing code out of the kernel and into userspace, which means that we can
> containerize them for security without losing a lot of performance.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-iomap
> ---
> Commits in this patchset:
>  * fuse: fix livelock in synchronous file put from fuseblk workers
>  * iomap: exit early when iomap_iter is called with zero length
>  * fuse: implement the basic iomap mechanisms
>  * fuse: add a notification to add new iomap devices
>  * fuse: send FUSE_DESTROY to userspace when tearing down an iomap connection
>  * fuse: implement basic iomap reporting such as FIEMAP and SEEK_{DATA,HOLE}
>  * fuse: implement direct IO with iomap
>  * fuse: implement buffered IO with iomap
>  * fuse: implement large folios for iomap pagecache files
>  * fuse: use an unrestricted backing device with iomap pagecache io
>  * fuse: advertise support for iomap
> ---
>  fs/fuse/fuse_i.h          |  135 ++++
>  fs/fuse/fuse_trace.h      |  845 ++++++++++++++++++++++++++
>  include/uapi/linux/fuse.h |  138 ++++
>  fs/fuse/Kconfig           |   23 +
>  fs/fuse/Makefile          |    1 
>  fs/fuse/dev.c             |   26 +
>  fs/fuse/dir.c             |   14 
>  fs/fuse/file.c            |   85 ++-
>  fs/fuse/file_iomap.c      | 1445 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/fuse/inode.c           |   23 +
>  fs/iomap/iter.c           |    5 
>  11 files changed, 2730 insertions(+), 10 deletions(-)
>  create mode 100644 fs/fuse/file_iomap.c
> 
> 
