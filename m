Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130774EBAC7;
	Tue, 13 Oct 2026 22:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929382; cv=none; b=p16QX0vTHAYGrRbacwKIXuQUSk0oVBOa28WWi1FaRgoVJqGrbiDeK3ahP1XZ4EE7W0t4ReW2XqzbHq9r1jS3Jva4c30gsskqudqsZ66J/8PTFSaW7lvfkRHoC2OI+SrYmtHle9P2cn/xVLSDDdwAXyR5CPLhsuY9iGlk/tcjZ5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929382; c=relaxed/simple;
	bh=WEYZ3J98KpR+UxeSqA7xaY2Y4RzXIGwC2ttOq5ulyok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXuI6k2mtfJ1Rq7SDqu376EOjjWd6JP2TdPRx34nA6EGg1OkZe4NDSOUeQXGqhLxaoidBx6X+JxXFYmBedwTVrAziYmu6vySLH0BIuULHzvBbP4q57QmR54Zg0B4Tw4GyA0pTH7ee+ZSBstRZJxmTxZl1R/YdGD7xxSVLp04q+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ds58Vcdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ds58Vcdy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CEA061F000FF;
	Tue, 13 Oct 2026 22:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791929380;
	bh=qls4g8YUAa7fch+xmhxHOWoEVnBiTm0WfNE6hOSDAro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ds58VcdyYjHFOtl9w9kQ/lwh1yCF2Q9VqSIKEgPVSUKhky92L8HJPjdgJi2+/wwfD
	 pX6m/MJwBYkuiMPpoNmh+RPB1QpYvEbgxjJ+kqrGiGoTNJRVaz1vL/TYClUfxfmxzm
	 ioWktmHsBZ6Mj/XOwh6kE6Rd+e5w3ruUGLcQYX8yzd6Z62WlgUTqMwrVX1/oUtDXsS
	 BjGPJYE7uDlUPWmeCDjvEtdtZ0RrFoWkWWtCBS3z1FmR05z+9AlX1UkayoC7p9o90V
	 RA2atP7VoiakED0tY5Ltjd2VpLDRO1zbc6rRlu4qwWtRQ9KtMd7CaRCA3p4CcpIpp7
	 1zYMBYZrKOVPA==
Date: Tue, 13 Oct 2026 15:09:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	Mark Tinguely <mark.tinguely@oracle.com>
Subject: Re: [PATCH RESEND 6.12 v2 0/6] Backport of XFS umount hang fixes
Message-ID: <20261013220940.GH2705364@frogsfrogsfrogs>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>

On Tue, Oct 13, 2026 at 03:07:23PM +0530, Siddh Raman Pant wrote:
> Backport of this series:
> https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/
> 
> I have added information in commit message upon conflict resolutions.
> 
> v2: Address Sasha's comments to v1 in the below mail:
> https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/
> 
> xfstests_xfs testing results:
> 	Generic:
> 		Ran: 001 to 771 (672 tests; gaps)
> 
> 		Failures before changes:
> 			Count: 4
> 			IDs: 633, 696, 697, 753
> 
> 		Failures after changes:
> 			Count: 4
> 			IDs: 633, 696, 697, 753
> 
> 		No new success or failure after changes.
> 
> 	XFS:
> 		Ran: 001 to 789 (311 tests; gaps)
> 
> 		Failures before changes:
> 			Count: 2
> 			IDs: 300, 556
> 
> 		Failures after changes:
> 			Count: 2
> 			IDs: 300, 556
> 
> 		No new success or failure after changes.
> 
> Thanks,
> Siddh

Looks good to me, thanks for actually running fstests!

That said -- generic goes up to 805 now, so I guess your branch is from
somewhere between July and October 2025?

Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Dave Chinner (6):
>   xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
>   xfs: catch stale AGF/AGF metadata
>   xfs: avoid dquot buffer pin deadlock
>   xfs: rearrange code in xfs_buf_item.c
>   xfs: factor out stale buffer item completion
>   xfs: fix unmount hang with unflushable inodes stuck in the AIL
> 
>  fs/xfs/libxfs/xfs_alloc.c  |  41 ++++-
>  fs/xfs/libxfs/xfs_ialloc.c |  31 +++-
>  fs/xfs/xfs_buf.c           |  55 -------
>  fs/xfs/xfs_buf.h           |   1 -
>  fs/xfs/xfs_buf_item.c      | 297 ++++++++++++++++++++++---------------
>  fs/xfs/xfs_buf_item.h      |   3 +-
>  fs/xfs/xfs_dquot.c         |   4 +-
>  fs/xfs/xfs_icache.c        |   8 +
>  fs/xfs/xfs_inode.c         |   2 +-
>  fs/xfs/xfs_qm.c            |  87 +++--------
>  fs/xfs/xfs_trace.h         |   1 -
>  11 files changed, 270 insertions(+), 260 deletions(-)
> 
> -- 
> 2.53.0
> 
> 
