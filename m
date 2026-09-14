Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B330E827
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425871; cv=none; b=bnLOGGNg0S5jTUPYHYsavAEkaVskPfp+oLDSoSTzapdfdyabfyyBlzohiwNHH2UD66NOrTXKKy6qW3Vin5YkY7V8Kie01Tq/noKFNwFwAV3Vv/WCS+9pHyF904sC3+frqg5aJvUtb+QDcuHq1SBPLDUNmEiWbJVLAD6gjMwEis0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425871; c=relaxed/simple;
	bh=jTckGJ0968D8kYeBo5+mMjbZaPVpxjjWRvpiYc3GKyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThR5Xr2R511LlgSP+IL/TA4xiW1bOs4+nc78cSZUXNA/4htQhE0LIat0iKX0IgQB1U9i4Sw9CGpPh6YrmCwChF+3nJEbDWRxnEVkRB3X2Lckz4HryHWE2lAR38X4/3J3KV0PEgQgvuz11RkF/nC2Ui40svwjflGLGjF6zEBHyks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMoGNPRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMoGNPRl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C98931F000FF;
	Mon, 14 Sep 2026 22:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789425869;
	bh=VHPs8125rJRQCYJQc4R5em080q3KBXhi8Iq1eB8hSkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZMoGNPRlzFdEWW/P7+NBDkCDmoPC9RsMc3zexcdXGQnniPjOv4JqhZYlMVMxpHQSy
	 xSOapvNtraFo7L8wDgJJCeCoL6arxJE+jDqRR/DvtVZfnnhYmyG6TRpy42q7gjGCpl
	 Hp/4j1gwtQBdnJ26h7XUS63pbh/ZexMQTIxXYrAuruV+uSweU7GMO0GddbkiAPU/YL
	 R2hXGSKVZUjjEitrxkJvnBRGzQvWNYOoWOhJO8gEGGYo+E2zIE+/OvduoErcK9ROY2
	 /SgGrKM7sLQJduZi1Bceryb6n3FX9yYI8+JRH4O2Eu6+yKkd5nLmsxNUd4Kafg9iRu
	 uDSKJWQZ5K3kw==
Date: Mon, 14 Sep 2026 15:44:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 0/14] xfs: remove unused arguments from many functions
Message-ID: <20260914224429.GA2705364@frogsfrogsfrogs>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>

On Mon, Sep 14, 2026 at 05:28:46PM -0500, Eric Sandeen wrote:
> V2: Sorry, that was stale already. This is against for-next in
>     https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git :(
> 
> Seems it's cleanup season lately on the list, so figured I'd play
> too.
> 
> This removes unused arguments (mostly mp) from a bunch of functions.
> 
> I did a quick check of the xfsprogs port, and it should be fine.
> (Left out xfs_rmapbt_maxrecs changes for that reason; all the
> .maxrecs functions in xfs_db need to match.)
> 
> Assisted-by: gcc version 15.3.1 20260722 (Red Hat 15.3.1-1) (GCC)

Giant Cognitive Computer?  Never heard of this model, is it any good?

> Total diffstat:

The whole series looks fine to me, assuming that the build robots don't
cough up errors & fstests doesn't explode.  For the series,

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> $ git diff 654ae5d73c05.. | diffstat
>  libxfs/xfs_attr.c             |   14 ++++++--------
>  libxfs/xfs_bmap.c             |    5 ++---
>  libxfs/xfs_bmap.h             |    2 +-
>  libxfs/xfs_btree_mem.c        |    6 ++----
>  libxfs/xfs_exchmaps.c         |    1 -
>  libxfs/xfs_exchmaps.h         |    3 +--
>  libxfs/xfs_ialloc.c           |    2 +-
>  libxfs/xfs_ialloc_btree.c     |    1 -
>  libxfs/xfs_ialloc_btree.h     |    5 ++---
>  libxfs/xfs_metadir.c          |    2 +-
>  libxfs/xfs_parent.h           |    1 -
>  libxfs/xfs_rmap.c             |   13 ++++++-------
>  libxfs/xfs_rtrefcount_btree.c |    8 ++++----
>  libxfs/xfs_rtrefcount_btree.h |    5 ++---
>  libxfs/xfs_rtrmap_btree.c     |    6 +++---
>  libxfs/xfs_rtrmap_btree.h     |    3 +--
>  libxfs/xfs_trans_resv.c       |    7 +++----
>  libxfs/xfs_types.c            |    7 ++-----
>  libxfs/xfs_types.h            |    7 +++----
>  scrub/bmap.c                  |    9 ++++-----
>  scrub/bmap_repair.c           |    4 ++--
>  scrub/inode_repair.c          |    6 +++---
>  scrub/orphanage.c             |    2 +-
>  scrub/quota.c                 |    2 +-
>  scrub/quota_repair.c          |    4 ++--
>  scrub/rtrefcount_repair.c     |    3 +--
>  scrub/rtrmap_repair.c         |    2 +-
>  xfs_bmap_item.c               |    2 +-
>  xfs_exchmaps_item.c           |    4 ++--
>  xfs_exchrange.c               |    2 +-
>  xfs_inode.c                   |   20 ++++++++++----------
>  xfs_rmap_item.c               |    2 +-
>  xfs_super.c                   |    2 +-
>  xfs_symlink.c                 |    4 ++--
>  34 files changed, 73 insertions(+), 93 deletions(-)
> 
> 
> 
