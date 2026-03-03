Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83541379EEB
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 20:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772568049; cv=none; b=CzHi+QKmGBGsQxhMrNjsuaDo7A4ZAKgbMEqLvHWtNz2ZZj6RRG7r82H4Mqif1nb61uJiwrV07aPtbONsw9dFeiYEZKQZEdg50Xc0eWk3ooOvLJ6cL+DNQMNpkWAsV5ktr9SgCKeo72x3kGHiOeqOSj5agtlSHx0uYO5GNf8TMcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772568049; c=relaxed/simple;
	bh=dihT0M/4gM835hGqO6Ts3TcJG/1Y4PlrRjBlQo4Ikj4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YmXf8OkVB7ZZb3ehQ7AyHlURJlCTX+ejhl/CKFNMHEwdcrNrnimwQ4rVxiycQ62xIclN1/U7ovwsNosKfWI42U5dTna0mCm70n6leM4/TuYu+4gNzTiryBUpGI6K+ArLeZ8qIY4IoNghqHt6iu10zSVg9O3iKuXYBjB5g2Jf4do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2tQ9wZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2tQ9wZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8E1C116C6;
	Tue,  3 Mar 2026 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772568049;
	bh=dihT0M/4gM835hGqO6Ts3TcJG/1Y4PlrRjBlQo4Ikj4=;
	h=Date:From:To:Cc:Subject:From;
	b=S2tQ9wZzU0LAsPpdZbxOJ2MCE7jxyNWwQvVA+KR6sFUACgWTD43i8pJDTiDTI00UE
	 /6TeUiVPJWiQAlKccocFGpS2WhzF2UoE6O5+X0d2Q4ZBMj0/nGqytd0fkhuN0klvAz
	 6Sr2vynPfSrjv1JRBiBgzGepRGcX5CFAFqzFzBk4iIBlIWR/v3BMtNoey1DuJHYYwP
	 Fj3sTVLapliaE4g4146ptIS+0vQgVy6A0VdS365y5wid955xecWyiSJxlaLa8vG+0A
	 svBWRGyavLr++BJj2D7XX0FQQUXvYKr6zO2/1S2AU9EBrJgh+o1l7GphhFJVZM2oX4
	 0jJ5DduIH5org==
Date: Tue, 3 Mar 2026 21:00:44 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: bage@debian.org, bfoster@redhat.com, brauner@kernel.org, 
	cem@kernel.org, cmaiolino@redhat.com, djwong@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, lukas@herbolt.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to b56b8825a89b
Message-ID: <neyegstecb7gp6llexs6nglyidzeyq5h3ddkx3i462dueug7bv@olv256g3qsg5>
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

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

b56b8825a89b5e2a82ccf4ccee0aae11fe3428a2

New commits:

Bastian Germann (1):
      [b56b8825a89b] debian: Drop Uploader: Bastian Germann

Brian Foster (2):
      [bcbd49ae01ff] xfs: error tag to force zeroing on debug kernels
      [e5f4b834bb2f] xfs: set max_agbno to allow sparse alloc of last full inode chunk

Christoph Hellwig (8):
      [2fbd34e77b7f] xfs: add a xfs_groups_to_rfsbs helper
      [19a0fe73785d] xfs: use a lockref for the xfs_dquot reference count
      [222095f4c52a] xfs: add a XLOG_CYCLE_DATA_SIZE constant
      [d2b51c1cf4fd] xfs: remove xlog_in_core_2_t
      [ee001dba26ef] xfs: remove the xlog_rec_header_t typedef
      [6aa2b48a6b66] xfs: validate that zoned RT devices are zone aligned
      [c250d4da5191] xfs: mark __xfs_rtgroup_extents static
      [5756ae33c98b] xfs: fix an overly long line in xfs_rtgroup_calc_geometry

Hans Holmberg (1):
      [396517b382aa] xfs: remove xarray mark for reclaimable zones

Lukas Herbolt (1):
      [ca1eb448e116] mkfs.xfs fix sunit size on 512e and 4kN disks.

Code Diffstat:

 debian/control            |  2 +-
 include/libxlog.h         |  4 ++--
 libxfs/rdwr.c             |  2 +-
 libxfs/xfs_errortag.h     |  6 ++++--
 libxfs/xfs_group.h        |  9 ++++++++
 libxfs/xfs_ialloc.c       | 11 +++++-----
 libxfs/xfs_log_format.h   | 38 ++++++++++++++++-----------------
 libxfs/xfs_ondisk.h       |  6 ++++--
 libxfs/xfs_quota_defs.h   |  4 +---
 libxfs/xfs_rtgroup.c      | 53 ++++++++++++++++++++++++-----------------------
 libxfs/xfs_rtgroup.h      | 16 +++++++-------
 libxfs/xfs_sb.c           | 15 ++++++++++++++
 libxlog/util.c            |  6 +++---
 libxlog/xfs_log_recover.c | 52 ++++++++++++++++++++++++++--------------------
 logprint/log_dump.c       |  4 ++--
 mkfs/xfs_mkfs.c           |  2 +-
 16 files changed, 132 insertions(+), 98 deletions(-)

-- 
- Andrey
