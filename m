Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F9B34B661
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 08:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773304637; cv=none; b=UJJCRlNn04fWyIsjAB28b6tavOP1mhRwQhLu0X4nCbyJbbI3T5N2ooVc+fy7oLNE8FcGyYdsGOOwh3+XE/xFt8i0JFM8Wq4YR4qPfM4Q9fuuLiI5K7+sspLs3WTCc2JYYr97D79UknuzVweO7G+hkaIO51sdvZS0szyd2mrtIls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773304637; c=relaxed/simple;
	bh=UvQZqj/T7F/eRO8zpDsAPTLIr2VnRqyjpe0Zw/RSyN4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CwpZpeAhSlTD0KIinT2wV4rBvZk2wV5bXGdDNopnR1Kf+wBAZ3HWRwWJ0yaX00JodZ1a7MzC5KAuxZCa1M7J9CK9TjPLciPwVyiaJHGlxwUHjzMX7bsuUW4OMjCPQRk8ZcTe/ox/ve0XB61YQ8Av0h8PChpmMivH9G5pNAL8+fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3FIND4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3FIND4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B1C4CEF7
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 08:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773304637;
	bh=UvQZqj/T7F/eRO8zpDsAPTLIr2VnRqyjpe0Zw/RSyN4=;
	h=Date:From:To:Subject:From;
	b=Q3FIND4y8tVqqIT58lwIsASuTO/tHQQXbcSRNEZ5g/TLXVaamCM6UVRapce8E3yej
	 uQFJRVRSuiC2ejOtbv1gqACnLwi1yUAVYvISB6rwsq10jj9Gma6nQ+36MvXGZlzDQu
	 Q1eoRqiuiiBjP3x9Il4cLkUd7k5gAdO07qXMjTkkUVXx4W0yfKQb20TOQAgktslbcV
	 otNas8JJsswsvimVVOLUrwefX46jpdTozPwgKNYB256qoeaUW9thSZpc8Lk15PHWDi
	 OsAJN56OwtmITVaFQ245J/tDzMrdGru4EjtgaaCkcgU6aWu2P0XYf1wQP+ae+Ei5fL
	 51dBHBgbrFeAA==
Date: Thu, 12 Mar 2026 09:37:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f8544b654f22
Message-ID: <abJ7AAHxksEKOltq@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

f8544b654f22 Merge branch 'xfs-7.1-merge' into for-next

10 new commits:

Carlos Maiolino (5):
      [db8367f63b30] xfs: factor out isize updates from xfs_dio_write_end_io
      [02a5d8993b09] xfs: factor out xfs_dio_write_zoned_end_io
      [3bdc20b005c2] xfs: factor out xfs_zone_inc_written
      [54514abb9891] xfs: opencode xfs_zone_record_blocks
      [f8544b654f22] Merge branch 'xfs-7.1-merge' into for-next

Darrick J. Wong (1):
      [52a8a1ba883d] xfs: fix undersized l_iclog_roundoff values

Long Li (3):
      [f1d77b863b41] xfs: remove redundant set null for ip->i_itemp
      [186ac39b8a7d] xfs: ensure dquot item is deleted from AIL only after log shutdown
      [362c49098086] xfs: fix integer overflow in bmap intent sort comparator

Wilfred Mallawa (1):
      [c6ce65cb17aa] xfs: add write pointer to xfs_rtgroup_geometry

Code Diffstat:

 fs/xfs/libxfs/xfs_fs.h  |  5 ++-
 fs/xfs/xfs_bmap_item.c  |  2 +-
 fs/xfs/xfs_dquot.c      |  8 ++++-
 fs/xfs/xfs_file.c       | 95 +++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_icache.c     |  1 -
 fs/xfs/xfs_ioctl.c      | 19 ++++++++++
 fs/xfs/xfs_log.c        |  2 ++
 fs/xfs/xfs_zone_alloc.c | 32 +++++++----------
 8 files changed, 115 insertions(+), 49 deletions(-)
