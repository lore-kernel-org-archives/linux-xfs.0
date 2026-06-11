Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF5E40D57A
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186839; cv=none; b=P34fX/RcnJm3oEtxrxOweCFQO8h9yYcITpVd/y3tTYSamJuu1V/yDR7z9AIAxBFfXeCHuiOF7OHRG9k5hm6UJXzyirLFTVtBYXTxqkK0fa3kIV2M3b5Nmwe0Y/C9szSoM5ahVWL3kcNWIIFh11J0phcNP2zRc2RyJUCV9DWHTXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186839; c=relaxed/simple;
	bh=xsz46JkjeS0u5bODBWGidhdjzFuqqSTu7bODkfkDxnM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mNKrGeOi/CGAYfipZebxbSt6XI58cTQRmYiwd/pO0nRfSOpZx6Y74gzMBxXQdM2gVlQLD3jX/UMbRDlZU78jtBIsL0s8R6j308L2CO+SSclUbSLLaXjBvxvkyfFu5idhd8K5gRMx8ZD96dZtAvNJ3bGUOyk33h/IOphZn3Y+lxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdPUgAou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdPUgAou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070C11F00898;
	Thu, 11 Jun 2026 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186838;
	bh=mieMSiUTPj1dKMhGES/Zhyci3Q2zB40DZC/JoaVl4JI=;
	h=Date:From:To:Cc:Subject;
	b=JdPUgAouHEuLV8zeBIt0KGge3voQHoWTYKvUYorHW8yAnxeTadcMtG9duK2UVUKxI
	 4/FPx9gvQ+Ntc1xJ3LmPiaQiK73yy+LYoC845K/LzeZsqzWOVI7Gf2FX6qy0LVfs2F
	 aRbzyxs9C7JHt/ocNBq/lV8GaKsi6Dgbz4nM+hUe2G4hrF/62ene2ITCMb+FSvewM/
	 0R7m6w1nPh+PMmyCOR6+8QaVi0i+YP7t+BxMS43LV/r9AABZZcIvelQwJnnl3uJ8XM
	 3dzhUW4XgrVuwdP+KtHprsijwWe4FZJ73ncCv3ZJd50PZVtvieDpBqdHlm9y1tG0eH
	 iUyALNNMD6pVg==
Date: Thu, 11 Jun 2026 16:07:15 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, romain.naour@smile.fr
Subject: [ANNOUNCE] xfsprogs: for-next updated to 5556c32a0304
Message-ID: <airA_mj3i_I1braZ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

5556c32a0304984854c11747c801be95034e5557

New commits:

Darrick J. Wong (28):
      [1aadfecf6afb] xfs_healer: fix error reporting
      [d21aab594247] xfs_healer: recommend offline fsck for XCORRUPT repairs
      [44849c72c720] xfs_healer: initialize variable here
      [fc76bac6ce1f] xfs_healer: run a full xfs_scrub repair if we don't know how to do a spot repair
      [79551362141a] xfs_healer: fix Makefile errors
      [4d62c2fa83ba] xfs_healer: don't leak wh->mntpoint if fd_to_handle fails
      [a6b85058f1ae] xfs_healer: coordinate access to weakhandle::mntpoint correctly
      [de2bc2763b53] xfs_scrub_media_fail: reduce security lockdowns to avoid postfix problems
      [ff0aeb233200] xfs_scrub_all: fix broken command line string array construction
      [ee3ea981af6b] xfs_scrub_all_fail: reduce security lockdowns to avoid postfix problems
      [24362b13fb76] xfs_scrub_fail: send content headers for xfs_scrub_all failures
      [472b010d0c84] xfs_scrub: fix uninitialized variable
      [a42fc3ec97db] xfs_scrub: fix integer overflows
      [9d36b3db1212] xfs_scrub: don't count internal log space in the data device used count
      [064834b6a0a2] xfs_scrub: widen scrub and repair dependency mask
      [44eee006149b] xfs_scrub: fix work estimation for rtgroups filesystems
      [5db0a8b13358] xfs_scrub: don't report media errors in specially-owned areas as file data
      [b65854f9e580] xfs_scrub: return SCRUB_RET_OPERROR if unicode collision detection fails to initialize
      [a34231de7668] xfs_scrub: fix nonsense advice after a scrub finds errors
      [25c97ededd3e] xfs_scrub: don't allow NAN as fstrim percentage
      [709b7eab8977] xfs_scrub: reset bulkstat pointer on retry
      [dc4e11fa3d7c] xfs_scrub: don't return garbage value from bulkstat_the_rest
      [d0b07b57faf0] xfs_scrub: don't continue with phase1 if autofsck=none
      [4a093a994c63] xfs_scrub: don't crash trying to complain about clean health
      [353333f0f3ff] xfs_scrub: fix inverted return value from ptvar_get
      [a5732e6c61f5] xfs_scrub: don't obscure repair failures in repair_list_schedule
      [33cc9bbc4dce] xfs_scrub: bitmap iteration functions must retur
      [5556c32a0304] xfs_scrub: read verification isn't ok if it hit runtime errors

Romain Naour (1):
      [188dc92e4e57] xfsprogs: include/buildrules: fix ltdep

Code Diffstat:

 healer/Makefile                        |  5 ++-
 healer/fsrepair.c                      | 28 +++++++++++++---
 healer/weakhandle.c                    | 61 ++++++++++++++++++++++++----------
 healer/xfs_healer.c                    |  9 +++--
 include/buildrules                     |  2 +-
 scrub/inodes.c                         | 17 +++++++---
 scrub/phase1.c                         |  5 ++-
 scrub/phase2.c                         |  2 +-
 scrub/phase3.c                         |  4 +--
 scrub/phase4.c                         | 11 +++---
 scrub/phase5.c                         |  4 +--
 scrub/phase6.c                         |  4 +++
 scrub/phase7.c                         |  4 ---
 scrub/phase8.c                         |  2 +-
 scrub/read_verify.c                    |  2 +-
 scrub/repair.c                         | 10 +++---
 scrub/scrub.c                          | 23 +++++++++----
 scrub/scrub_private.h                  |  2 +-
 scrub/xfs_scrub.c                      | 18 +++++++---
 scrub/xfs_scrub.h                      |  2 +-
 scrub/xfs_scrub_all.py.in              |  2 +-
 scrub/xfs_scrub_all_fail.service.in    | 59 ++++----------------------------
 scrub/xfs_scrub_fail.in                |  2 ++
 scrub/xfs_scrub_media_fail@.service.in | 58 ++------------------------------
 24 files changed, 163 insertions(+), 173 deletions(-)

-- 
- Andrey
