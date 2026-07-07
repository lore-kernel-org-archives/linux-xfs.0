Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2ED3F88B5
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424124; cv=none; b=b7MCu+aVZ84j1uzXWbbnWimZ7yMvyOwALOZ8snm6nTG8TuK82v3kTHOoJkkJvJBXPl2gDr9biqZ0NxiItuMsU0yHRWhkWJiU9NItTw9d3l8/ckt7+NRGFhbpUTKu5b+xaHhAhQJCABBN6gJvoaJM8YQxXR2pppz3Vg1NTsTxCFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424124; c=relaxed/simple;
	bh=d7NWPE0VB0H5ODLnSnXfhZS+HsHV3j0ffNgP6H0E7dI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IMitNl5JtM6ZEuUBdPG213YGOBSvsLZWq3xZVpbagJRQysKPqcP1N34Xitn76WNWlC5vtG716b40TuvY/WGLG5hH4lx9rxyteL0MsrQJCYTrF+7JXPEhYNkM13kOdz2Raki5UKxAo8UI9Z9pTJoWGHU5CTi9l2vpcZiE+RiM+Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZsvOSqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZsvOSqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541221F000E9
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 11:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783424123;
	bh=dReXE+GoGHxb07ogKExQNNcq3X+YLJp/ZKbSu4wen4o=;
	h=Date:From:To:Subject;
	b=aZsvOSqGm/kjKUjHAil4i31IBsXJrcR+CAon7iJeHjBgelZJqsuTyQ2EwE+URh17J
	 9Jr/TPxL1B3Rg/FmkHPokEn2UKWQ1TnkGM+IcpjME75/lucabwC5+rgr9uvD7/3USa
	 K2RoU/uBfh4J0Zo+wdRp2MqREdUZP7RdcG3ytLQeqYW1ftElOkOAN4MU2gxNQ/V17D
	 MWn89ZpMrpV1oUV8s3psS2DLF+TJIUqsZfYLf3IMETxFS+ISbs77x4QjRnXfTmO9PV
	 U8QGJxOnfntG+Qo9oumw4nqPZrupQ9u9yIaeheNU0+85Yqn1CbPy/sjehntYe3QsPA
	 rrqlMYPxPw4ew==
Date: Tue, 7 Jul 2026 13:35:19 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to de7400fc098b
Message-ID: <akzkUvX8EZre8Xru@nidhogg.toxiclabs.cc>
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

de7400fc098b xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter

5 new commits:

Cen Zhang (1):
      [befe3d2705df] xfs: tie zoned sysfs lifetime to zone info

Jinliang Zheng (1):
      [de7400fc098b] xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter

Weiming Shi (3):
      [5b4396e12cb1] xfs: drop ASSERT(0) on unrecognized log item type
      [34dd2253414d] xfs: splice unsorted log items back to the transaction after the loop
      [92d2d133c6cb] xfs: fail recovery on a committed log item with no regions

Code Diffstat:

 fs/xfs/xfs_log_cil.c     |  2 +-
 fs/xfs/xfs_log_recover.c | 26 ++++++++++++++++++--------
 fs/xfs/xfs_sysfs.c       | 28 +++++++++++++++++-----------
 fs/xfs/xfs_sysfs.h       |  2 ++
 fs/xfs/xfs_zone_alloc.c  |  8 ++++++++
 5 files changed, 46 insertions(+), 20 deletions(-)
