Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2801F63EE
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734546889; cv=none; b=odziFWoRxAyKSLc/x6qwjek/WbT/e85CuWLLgJQdp2Ebi+JUu1DCh3bPioIw4xoWmZus+UmSNI/ruUFhrh59/aV+Tifvsc91kXCxHmIxP9LIUHO578ahgZutAi+YWYvPCu9dikGdebiVdLORkTDRuwLdCt0MI5L7viWWGvsee0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734546889; c=relaxed/simple;
	bh=IhnG9q6SnQt1hOeWj9w4PzR2s4eaHrmJe0wK4l7w0jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUgtPgyFex+6srC0qGGk9gIX7fFqDEhJtvbZdUMSrWNkFIfYaPwn9TixP9BI5HHDhP5F1anTboGfQ9PORGEmp4uCkK7jhyXYrYYQz/hLYA1/CQwJzExjIHiLcY5vqdV4a/9KTIVX015/C5aet1mDPDLhI8Xm2R02UIhUh808AZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXtNu/x1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXtNu/x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866E2C4CECD;
	Wed, 18 Dec 2024 18:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734546888;
	bh=IhnG9q6SnQt1hOeWj9w4PzR2s4eaHrmJe0wK4l7w0jk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EXtNu/x1CDLb987VOKoGDnCOuvSNv5hMopCkpSoIqAJxKr4RpE0xae1DgJ5kG27E8
	 cNjPODaiRI6aJtjqW4OQ9jH9IM6QUjRUXzdu87SfPHjlOY/+I9HIIMTgh2NuyeYIUp
	 5nXOWd6N7ffHeM95IDCqo6dXwjIPZdPcVJR5FF1mU0h0uBteroTcLUZghzXx7+HYvs
	 FHNCXtl9MUVnStRAnGvW++ekLFaDCiMfeyXXH5pk4NxIEiG+dEMK+AaEznNC5X+BP+
	 /fN7gT55ChZMWupTEP4Yn7vMfjjQrlZjgbxv9+zpQDA0elPuEE4u3IDaLPQA1jHEor
	 HJXfQEdzHlP+w==
Date: Wed, 18 Dec 2024 10:34:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE 00/18] xfs backports for 6.6.y (from 6.11)
Message-ID: <20241218183448.GB6174@frogsfrogsfrogs>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>

On Tue, Dec 17, 2024 at 06:13:53PM -0800, Catherine Hoang wrote:
> Hi all,
> 
> This series contains backports for 6.6 from the 6.11 release. Tested on
> 30 runs of kdevops with the following configurations:
> 
> 1. CRC
> 2. No CRC (512 and 4k block size)
> 3. Reflink (1K and 4k block size)
> 4. Reflink without rmapbt
> 5. External log device

For everything except for patch 16,
Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Chen Ni (1):
>   xfs: convert comma to semicolon
> 
> Christoph Hellwig (1):
>   xfs: fix the contact address for the sysfs ABI documentation
> 
> Darrick J. Wong (10):
>   xfs: verify buffer, inode, and dquot items every tx commit
>   xfs: use consistent uid/gid when grabbing dquots for inodes
>   xfs: declare xfs_file.c symbols in xfs_file.h
>   xfs: create a new helper to return a file's allocation unit
>   xfs: fix file_path handling in tracepoints
>   xfs: attr forks require attr, not attr2
>   xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set
>   xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
>   xfs: take m_growlock when running growfsrt
>   xfs: reset rootdir extent size hint after growfsrt
> 
> John Garry (2):
>   xfs: Fix xfs_flush_unmap_range() range for RT
>   xfs: Fix xfs_prepare_shift() range for RT
> 
> Julian Sun (1):
>   xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
> 
> Zizhi Wo (2):
>   xfs: Fix the owner setting issue for rmap query in xfs fsmap
>   xfs: Fix missing interval for missing_owner in xfs fsmap
> 
> lei lu (1):
>   xfs: don't walk off the end of a directory data block
> 
>  Documentation/ABI/testing/sysfs-fs-xfs |  8 +--
>  fs/xfs/Kconfig                         | 12 ++++
>  fs/xfs/libxfs/xfs_dir2_data.c          | 31 ++++++++--
>  fs/xfs/libxfs/xfs_dir2_priv.h          |  7 +++
>  fs/xfs/libxfs/xfs_quota_defs.h         |  2 +-
>  fs/xfs/libxfs/xfs_trans_resv.c         | 28 ++++-----
>  fs/xfs/scrub/agheader_repair.c         |  2 +-
>  fs/xfs/scrub/bmap.c                    |  8 ++-
>  fs/xfs/scrub/trace.h                   | 10 ++--
>  fs/xfs/xfs.h                           |  4 ++
>  fs/xfs/xfs_bmap_util.c                 | 22 +++++---
>  fs/xfs/xfs_buf_item.c                  | 32 +++++++++++
>  fs/xfs/xfs_dquot_item.c                | 31 ++++++++++
>  fs/xfs/xfs_file.c                      | 33 +++++------
>  fs/xfs/xfs_file.h                      | 15 +++++
>  fs/xfs/xfs_fsmap.c                     | 30 ++++++++--
>  fs/xfs/xfs_inode.c                     | 29 ++++++++--
>  fs/xfs/xfs_inode.h                     |  2 +
>  fs/xfs/xfs_inode_item.c                | 32 +++++++++++
>  fs/xfs/xfs_ioctl.c                     | 12 ++++
>  fs/xfs/xfs_iops.c                      |  1 +
>  fs/xfs/xfs_iops.h                      |  3 -
>  fs/xfs/xfs_rtalloc.c                   | 78 +++++++++++++++++++++-----
>  fs/xfs/xfs_symlink.c                   |  8 ++-
>  24 files changed, 351 insertions(+), 89 deletions(-)
>  create mode 100644 fs/xfs/xfs_file.h
> 
> -- 
> 2.39.3
> 
> 
