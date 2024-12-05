Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEC7391;
	Thu,  5 Dec 2024 06:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733380964; cv=none; b=vBx1lIHxu7V6GxrCdb0wDm7ebNHihbPjtuOjO3DWiIj3Q/TlFd7jzZy+HELDCtW1OlBf5fC8gWTpSNfFWUU03QuQ6EF/Ae1+GU7y928obKwGJvQPazrsYXim53hhxQK/Mp96f83kwFAocXUNcTM+Wy7NXNi0bMVh8DYrUhckuck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733380964; c=relaxed/simple;
	bh=njHXXqjPB3UdY35dCliuUAwBUnuq7Yn/MhEuPBQcXrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHTzKMTWhLURyfHF4grxZxWys/iuSuviuG5V/Hnu0u6b3Id7OuPt5zpKeImqNgF7sjofkKoqFw33kC0Q+4gbny+vgb5V6KNqUBbBtZI9TuHpGiv/rw9GfB2N3FS19oD5GhOcxVQdyesCcy54rOpxkhVCXtBSgGx7mC+c9J1CgVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1P1l0L5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1P1l0L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7962C4CED1;
	Thu,  5 Dec 2024 06:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733380963;
	bh=njHXXqjPB3UdY35dCliuUAwBUnuq7Yn/MhEuPBQcXrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L1P1l0L5JAn5LAaX0D+gT7Me+yjR+kyk+CArvEpOdWOq9I08fjqUfVFJy3xGZTHAN
	 cJRTroxrUDdr6INjIbyLi/gN+vlfHdKY5U+Mewjv2YVkBPIPCGx5ysaBHWKAZBvYT2
	 z5KCN2U8ht/00pAgxQ1rvuxV6NeNEP7Y6m3TrBKF6haWpn7WJb6VUvtlVaa4FgYIU+
	 zZ9LGOrqSwkCAC2VHKRv5/A5Ip6x7y+ea6QcevaAOxjFaOwZe6WWThkpPmDxnYlspX
	 /VEekr8/lj/qupCGEYBFK/DKH3GbfbsmixFCa3S0WGGCy1PU0XNeCwtfMgr9JzWUD0
	 zKtrhFKrgqrNA==
Date: Wed, 4 Dec 2024 22:42:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: cem@kernel.org, stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <20241205064243.GD7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1EBXqpMWGL306sh@redhat.com>

On Wed, Dec 04, 2024 at 07:26:54PM -0600, Bill O'Donnell wrote:
> On Tue, Dec 03, 2024 at 07:02:23PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here are even more bugfixes for 6.13 that have been accumulating since
> > 6.12 was released.
> > 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > With a bit of luck, this should all go splendidly.
> > Comments and questions are, as always, welcome.
> > 
> > --D
> 
> Hi Darrick-
> 
> I must ask, why are these constant bug fixes and fixes for fixes, and
> fixes for fixes for fixes often appearing? It's worrying that xfs is

Roughly speaking, the ~35 bugfixes can be split into three categories:

1) Our vaunted^Wshitty review process didn't catch various coding bugs,
and testing didn't trip over them until I started (ab)using precommit
hooks for spot checking of inode/dquot/buffer log items.

2) Most of the metadir/rtgroups fixes are for things that hch reworked
towards the end of the six years the patchset has been under
development, and that introduced bugs.  Did it make things easier for a
second person to understand?  Yes.

3) The rest are mostly cases of the authors not fully understanding the
subtleties of that which they were constructing (myself included!) and
lucking out that the errors cancelled each other out until someone
started wanting to use that code for a slightly different purpose, which
wouldn't be possible until the bug finally got fixed.

4) The dquot buffer changes have been a known problem since dchinner
decided that RMW cycles in the AIL with inode buffers was having very
bad effects on reclaim performance.  Nobody stepped up to convert dquots
(even though I noted this at the time) so here I am years later because
the mm got pissy at us in 6.12.

5) XFS lit up a lot of new functionality this year, which means the code
is ripe with bugfixing opportunities where cognitive friction comes into
play.

> becoming rather dodgy these days. Do things need to be this
> complicated?

Yeah, they do.  We left behind the kindly old world where people didn't
feed computers fuzzed datafiles and nobody got fired for a computer
crashing periodically.  Nowadays it seems that everything has to be
bulletproofed AND fast. :(

--D

> -Bill
> 
> 
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=proposed-fixes-6.13
> > ---
> > Commits in this patchset:
> >  * xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
> >  * xfs: don't crash on corrupt /quotas dirent
> >  * xfs: check pre-metadir fields correctly
> >  * xfs: fix zero byte checking in the superblock scrubber
> >  * xfs: return from xfs_symlink_verify early on V4 filesystems
> >  * xfs: port xfs_ioc_start_commit to multigrain timestamps
> > ---
> >  fs/xfs/libxfs/xfs_symlink_remote.c |    4 ++
> >  fs/xfs/scrub/agheader.c            |   66 ++++++++++++++++++++++++++++--------
> >  fs/xfs/scrub/tempfile.c            |    3 ++
> >  fs/xfs/xfs_exchrange.c             |   14 ++++----
> >  fs/xfs/xfs_qm.c                    |    7 ++++
> >  5 files changed, 71 insertions(+), 23 deletions(-)
> > 
> > 
> 
> 
