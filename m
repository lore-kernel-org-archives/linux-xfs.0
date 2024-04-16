Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B09118D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227431; cv=none; b=GETqyFRXqsz5JUv0K0HVlgvqCZFi1iETN3nAE16NGWg2OoVhgnxUmHJuH856gTRPkqVGPxdnhBalcbtOXQkBvs6wpS7L5fYS4JgTpr6wDYYNA2lcFnuDEyp6X9Oo4/05LZ6hmuuG9NjCGk0EunLyQNCX182RVj1AmMmjlWBJUxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227431; c=relaxed/simple;
	bh=AI9hEIB/KYwfEboozZxfCMiYCum9QjkOm/IWMG1fY2c=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=f/2FC8r9/kL4wFjWm08SEsBqrDvvAQ5LQtz9noRJh9BsuL0oPYWy2ztYo/xTBQQqohmI0ghhDuGPR2ttI0xq2YWa5pM+YaKFt6oWDQHkwuB3h10Bm98Ps+DvrFjmF3u3VwhA2ZHxgukGrm231NwSZjKra9jXwMWzWHsm7EupegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ore3sXO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ore3sXO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568E2C2BD11;
	Tue, 16 Apr 2024 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227431;
	bh=AI9hEIB/KYwfEboozZxfCMiYCum9QjkOm/IWMG1fY2c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ore3sXO5hKUVrf1UseLyBnMfexpXAynmlmjdrhRYZ4p5fz5+hAq3RtA2fN5J+fGk5
	 tlmr31QSHE6BLIQI4HkL8xMvDW6o3HMD1RjKoaV+qPmC8fzfMtOVHWYTK+PTVcL4aO
	 KMqmS/Y8pjxZ1bvBmHBW8ryUG0L7a8UJyRAZshBVzFraBEEVEGxBp4xHcMto29Q1dm
	 YkB0aWSFlbyKAiFUs+XyvomkxAhwr82pZWFVjF2YVpUcBjQnvoI9aOxUmt00YPsr7i
	 21amgO3OGUD4j/edGt2KnIn0MBD2julb6RnBMVKzMj0M2g7DnUX3TojZXMn8UueTL5
	 a6L94DJkss3vQ==
Date: Mon, 15 Apr 2024 17:30:30 -0700
Subject: [GIT PULL 12/16] xfs: online fsck of iunlink buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322718679.141687.10654155003970611022.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 2651923d8d8db00a57665822f017fa7c76758044:

xfs: online repair of symbolic links (2024-04-15 14:58:58 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-iunlink-6.10_2024-04-15

for you to fetch changes up to ab97f4b1c030750f2475bf4da8a9554d02206640:

xfs: repair AGI unlinked inode bucket lists (2024-04-15 14:58:58 -0700)

----------------------------------------------------------------
xfs: online fsck of iunlink buckets [v30.3 12/16]

This series enhances the AGI scrub code to check the unlinked inode
bucket lists for errors, and fixes them if necessary.  Now that iunlink
pointer updates are virtual log items, we can batch updates pretty
efficiently in the logging code.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: check AGI unlinked inode buckets
xfs: hoist AGI repair context to a heap object
xfs: repair AGI unlinked inode bucket lists

fs/xfs/scrub/agheader.c        |  40 ++
fs/xfs/scrub/agheader_repair.c | 879 ++++++++++++++++++++++++++++++++++++++---
fs/xfs/scrub/agino_bitmap.h    |  49 +++
fs/xfs/scrub/trace.h           | 255 ++++++++++++
fs/xfs/xfs_inode.c             |   2 +-
fs/xfs/xfs_inode.h             |   1 +
6 files changed, 1179 insertions(+), 47 deletions(-)
create mode 100644 fs/xfs/scrub/agino_bitmap.h

