Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AAA1F0E44
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733953152; cv=none; b=cHZ0OXU2jiu3WcQZjGFX2fayi0cEg7x4ZA35k9hbDBuRDEoFWzT1ZigYe6agoskO1E5P5DYztx7W4Xo840eJNouqRmaUs9wn21wNRoGkilww0oKZNJSFNDeNwbWTDBpGR/B61+KA7ujUGYtu1pDESr/KI1qWJ8ij5nz2BWAjZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733953152; c=relaxed/simple;
	bh=LhyeSphB3RxIT3xxxUjKdJXT9dvq8ly71Fn3waCahvo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kuYFV2C15HB6fKaU2gqhqTS608/Sz4K6yvAAeDM+yifMEzE+zyYHzEhnTt/F8QMAlWdYPYvgwcP32W82KcGZo0J/+9dUs4le01vBdhG4hf+d/aLiea7L5H6rf17hq0IEBSbE3QQp73EQY3FkS1rFf+b+akHnV40LdF11+CYg8Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoEAZVWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoEAZVWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B05C4CED2
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733953151;
	bh=LhyeSphB3RxIT3xxxUjKdJXT9dvq8ly71Fn3waCahvo=;
	h=Date:From:To:Subject:From;
	b=HoEAZVWv8zjUXgUBdz5C6A0Y1kei+FAqKtXcq8np7tHqPkMxoooSY+V5Dpl8guWtN
	 zuXxUCraBWos7WO5OX9Cm/lvTYW6iQhD/UIs+81IpU3VAFRwQheCQ4kPx2b00KGccW
	 NrOVOGtb9LQt0C2kjuXn4fikRWipCaeujF/mweQ2RIVIaC2aDEZUwJ3d5JK18BKo9T
	 u5IwNlcrQxMw6F9UOjzDdbVQC+uYqMjsmhMisVmk6B0JUq4zFOPv+SgrAsZh5B+DJc
	 0SQsCZl++TJmmZS172Vr71ztEw0C/+n1I2osL6frupeXl7Y+erIS+TZCc2OFgMmjnc
	 SeemZ/qI7a/4w==
Date: Wed, 11 Dec 2024 22:39:08 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e2b718c00102
Message-ID: <v67tb43qbrzmqvb3xwl3oav6walexakrdxywlfb2dbjcg7mnne@vhkxkszggy74>
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

e2b718c00102 Merge tag 'fixes-6.13_2024-12-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc

8 new commits:

Carlos Maiolino (1):
      [e2b718c00102] Merge tag 'fixes-6.13_2024-12-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc

Christoph Hellwig (1):
      [13f3376dd82b] xfs: fix !quota build

Darrick J. Wong (6):
      [a550e2cc48fb] xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
      [cf00df0be43c] xfs: don't crash on corrupt /quotas dirent
      [3e1e596c2694] xfs: check pre-metadir fields correctly
      [6db6fa59a8e1] xfs: fix zero byte checking in the superblock scrubber
      [e6f431e6a3ef] xfs: return from xfs_symlink_verify early on V4 filesystems
      [bb77ec78c1ae] xfs: port xfs_ioc_start_commit to multigrain timestamps

Code Diffstat:

 fs/xfs/libxfs/xfs_symlink_remote.c |  4 ++-
 fs/xfs/scrub/agheader.c            | 71 ++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/tempfile.c            | 12 ++++++-
 fs/xfs/xfs_exchrange.c             | 14 ++++----
 fs/xfs/xfs_qm.c                    |  7 ++++
 fs/xfs/xfs_quota.h                 |  2 +-
 6 files changed, 85 insertions(+), 25 deletions(-)

