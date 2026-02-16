Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8C52DB7BA
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 16:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260095; cv=none; b=C7WZjzkVnLnjZ5HZ3cLqDRHpzWmOtco8+p71ULSXHmdmSJlxV+WxG92qNd1zSyjdPtEdnEAwJGdqDdAUH6BElq4eFReJq4oBBxYbWSqjY8ur7DPdanfgUnshnvQoDON/jfU33O/eh4xTOsCiRUcsiHbxCENZgzwSG3R+H9FsCv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260095; c=relaxed/simple;
	bh=hB1BMqOI8XNHHJLZW1zD74AB6GwhqNdP2y8DOAtglkM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HteAA2ZIkZYs9pxgbGdNNsAYeiNlK2Vua/TTcLiHaiHJPMizI+qrDJd5wzhuuJbk2m/lodUkMw0/ZHY8RUordKl5ZsF4i2nSMO6pFbzZucjvV4xvLw+9B+bgn6FSQLHTQwhhIxFCabnBbNDKx4VSkS3+Icw7ilWX9cUbGN1i8zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOZYvo5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOZYvo5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611FFC116C6
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 16:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771260095;
	bh=hB1BMqOI8XNHHJLZW1zD74AB6GwhqNdP2y8DOAtglkM=;
	h=Date:From:To:Subject:From;
	b=SOZYvo5Rt2aDlcHurFjuN6s8Jika7Q/ISYT6dtPKMyOYa9oje/e8IDXDGcahM/Zyn
	 OqSUpM6cWgNjooH9aU4C1lIhmVWw/69Q39uCo2h9K5cJH7vLNi2A0l1BkvtgkYyG6Q
	 deskLGwTlSVxGyNZsxlrm5XyWaw7QQDXzVc8ppXHiuLU855Ki5++RX6j+gHrk1aPKE
	 xB9sJS/kmiZGidFiwpRPC0Az0KFfYTngK9NL/f+sXCegxWiKmaac3l52uMC8468sUd
	 glvgEQAJOAn+7m+qvNPuml2igvsr8x4gylHeEjtViG6HuCt7VppjYPzdqRbk/TO1zU
	 78mw+9wnurbGQ==
Date: Mon, 16 Feb 2026 17:41:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e920893f56ef
Message-ID: <aZNIWeCCJu6DzqBQ@nidhogg.toxiclabs.cc>
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

This is a initial pull after 6.19 release, I expect to be rebasing it
soon on top of the next -rc, but I wanted to push these patches this
week yet.

The new head of the for-next branch is commit:

e920893f56ef xfs: fix code alignment issues in xfs_ondisk.c

5 new commits:

Nirjhar Roy (IBM) (4):
      [ce95c72c7f95] xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
      [60cb35d383aa] xfs: Fix in xfs_rtalloc_query_range()
      [c656834e964d] xfs: Refactoring the nagcount and delta calculation
      [f0d0d93e22e5] xfs: Replace &rtg->rtg_group with rtg_group()

Wilfred Mallawa (1):
      [e920893f56ef] xfs: fix code alignment issues in xfs_ondisk.c

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c       | 28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h       |  3 +++
 fs/xfs/libxfs/xfs_ondisk.h   |  4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c |  2 +-
 fs/xfs/xfs_fsops.c           | 17 ++---------------
 fs/xfs/xfs_rtalloc.c         |  5 ++++-
 fs/xfs/xfs_zone_alloc.c      |  6 +++---
 fs/xfs/xfs_zone_gc.c         | 10 +++++-----
 8 files changed, 48 insertions(+), 27 deletions(-)
