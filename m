Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221021A3AAA
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302603; cv=none; b=KFetQQFA4KJnonLuQJcHEvukb8DUJqf7Gx54mwgu79gIvSrOr8oglwk8I6gB9RIPjGggsHPxw5QWrBl2s5+2ntUhTMlA0Hr77iX4zHbc2luUhPUlcQPQsV21eovKbrwy2Lrj3ZfoIS32xBBwzAVFjS9FN0pTOr1HTbLQjWuiOtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302603; c=relaxed/simple;
	bh=Ckq1jinAOObk4le8a06/7yfpjQ2YO4D4Rl8RwlL5H1Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=bFOfysbPYQy1H/8ZrYishZdvtCYd++m/7vjNhwaf1/0CiClSakS9zO3iqJ1p+J6Z81XfibWQj2ShAiV8KIi9AYQnA2q+Qpc1Ft+jxa9KTPuVx0HSsrol6LL7IOv8fQ51bRq8vin7v1MyO3ZUCMc0/ofe0tuLALdOWtpqeHfeefo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTkgnV60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTkgnV60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4C5C4CEC2;
	Mon,  2 Sep 2024 18:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302602;
	bh=Ckq1jinAOObk4le8a06/7yfpjQ2YO4D4Rl8RwlL5H1Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VTkgnV60YDrRxb6qNPRf1Oq2QF27aCKo3KOhMuF27WYURdalcjiyu+FMuKpAVXlLQ
	 4sFStJNkiTdo7+S1wYTSh4d7LFt++evTVQav3T1yqQV3lcPzNadEqwWovaYLTayeh/
	 Q3d4MrsNbmXL8lHY4ULV/x/4b4YZ+h9ufhjliQAoUvRVzW17uJY9nJJoXpzBXMTUQb
	 eoM2my41JCCP6UtejydF1UGZ4aOY9SrepInRmR3f+hITT0BWlTooY3io+DZEU0usI1
	 6hKuHJ8Mz54OWwV+P4mBF85inftCyPnRwoWT2446zfF6LZ53Ox12Ursu1b5vzCv5l7
	 VOlrMpa75+SCg==
Date: Mon, 02 Sep 2024 11:43:22 -0700
Subject: [GIT PULL 7/8] xfs: various bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, kernel@mattwhitlock.name, linux-xfs@vger.kernel.org, sam@gentoo.org
Message-ID: <172530248562.3348968.7217782771063673945.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902184002.GY6224@frogsfrogsfrogs>
References: <20240902184002.GY6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 2c4162be6c10d3bc4884c211ae4787fc84c4fe3c:

xfs: refactor loading quota inodes in the regular case (2024-09-01 08:58:20 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/xfs-fixes-6.12_2024-09-02

for you to fetch changes up to de55149b6639e903c4d06eb0474ab2c05060e61d:

xfs: fix a sloppy memory handling bug in xfs_iroot_realloc (2024-09-01 08:58:20 -0700)

----------------------------------------------------------------
xfs: various bug fixes for 6.12 [7/8]

Various bug fixes for 6.12.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: fix C++ compilation errors in xfs_fs.h
xfs: fix FITRIM reporting again
xfs: fix a sloppy memory handling bug in xfs_iroot_realloc

fs/xfs/libxfs/xfs_fs.h         |  5 +++--
fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++-----
fs/xfs/xfs_discard.c           |  2 +-
3 files changed, 9 insertions(+), 8 deletions(-)

