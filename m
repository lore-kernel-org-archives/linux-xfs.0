Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7FB3D64
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 03:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337422; cv=none; b=OX92uhP+EM9c6YBmObqhBjFDEZYI5B38/3AWHMKM1juvme4eoMEs8+hJuoFUHOljmF5LQxR64zlwLYTLbKsHcaChQ4pC1b69Zczc7v54VE0WkeQFMUG5fjX25PFefzKQucsjQNVOu03IYXqpDdnp/ykkOJpG5oCP992UjbuABAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337422; c=relaxed/simple;
	bh=Cnt66DG+2c7sl09qfVv5ztow6cVEa3dX8XH2EYUkR9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7jQPEszAjSGACHK5A3kKFkl5yfdLbr3AEvPZNxwJzQKC+mGubcIQUcb22c1lj1Sa91j9SQXe/kYkpiv4Vd9vpjdyxHBm6V/1IflU4mkiawtZPLoMFWUpKanVkjwslC//5rVdpjC4uaHp/TLzRvnTZSvJmLgG7cYY49O1ISPxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqkkDSgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqkkDSgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C862C2BD10;
	Fri, 14 Jun 2024 03:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718337422;
	bh=Cnt66DG+2c7sl09qfVv5ztow6cVEa3dX8XH2EYUkR9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eqkkDSgyzqNS+xJ32gLJttWugplq9XxepIG1Z+c47cFhwexeW7YzFcYnrTOkQLViP
	 wMdmCNE57GCMuJFW2zeuwldBuMjiJEveRDeEwjP1bFNqQAHCUQL3ggz+zjGDvOhPJ+
	 k2dOze571AIrGtu4/kWuf+Y6OpAkZG5uuMCfflGihwoT89zQQovcN1aRH5ngZKwV/Y
	 kfcSTbidGpbsfjyUTHyJsgR8QDNNLjAu2R0GOnVQkTdSndbcqD6psYKtN6Z0KQpbct
	 ZVwpm7W1EdwZjMukVHVm8YPVkmVtSRqZFxGYn+FawRZ2ttItyFvc3Lsiy2fwfsCNuG
	 YEoj9kEdn2Qjw==
Date: Thu, 13 Jun 2024 20:57:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE 0/8] xfs backports for 6.6.y (from 6.9)
Message-ID: <20240614035701.GF6125@frogsfrogsfrogs>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>

On Thu, Jun 13, 2024 at 06:49:38PM -0700, Catherine Hoang wrote:
> Hi all,
> 
> This series contains backports for 6.6 from the 6.9 release. Tested on
> 30 runs of kdevops with the following configurations:
> 
> 1. CRC
> 2. No CRC (512 and 4k block size)
> 3. Reflink (1K and 4k block size)
> 4. Reflink without rmapbt
> 5. External log device
> 
> Andrey Albershteyn (1):
>   xfs: allow cross-linking special files without project quota
> 
> Darrick J. Wong (2):
>   xfs: fix imprecise logic in xchk_btree_check_block_owner
>   xfs: fix scrub stats file permissions
> 
> Dave Chinner (4):
>   xfs: fix SEEK_HOLE/DATA for regions with active COW extents
>   xfs: shrink failure needs to hold AGI buffer
>   xfs: allow sunit mount option to repair bad primary sb stripe values
>   xfs: don't use current->journal_info
> 
> Long Li (1):
>   xfs: ensure submit buffers on LSN boundaries in error handlers

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
>  fs/xfs/libxfs/xfs_ag.c   | 11 ++++++++++-
>  fs/xfs/libxfs/xfs_sb.c   | 40 +++++++++++++++++++++++++++++++---------
>  fs/xfs/libxfs/xfs_sb.h   |  5 +++--
>  fs/xfs/scrub/btree.c     |  7 ++++++-
>  fs/xfs/scrub/common.c    |  4 +---
>  fs/xfs/scrub/stats.c     |  4 ++--
>  fs/xfs/xfs_aops.c        |  7 -------
>  fs/xfs/xfs_icache.c      |  8 +++++---
>  fs/xfs/xfs_inode.c       | 15 +++++++++++++--
>  fs/xfs/xfs_iomap.c       |  4 ++--
>  fs/xfs/xfs_log_recover.c | 23 ++++++++++++++++++++---
>  fs/xfs/xfs_trans.h       |  9 +--------
>  12 files changed, 94 insertions(+), 43 deletions(-)
> 
> -- 
> 2.39.3
> 
> 
