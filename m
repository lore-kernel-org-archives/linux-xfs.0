Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137EC18D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227605; cv=none; b=o0ccx1bGg25rpGP6fpCpODpjlH/WomHE+qCrHQW8HKRsewh3UAASU/ojrxwATeq60wWwdgtbztlw/vCqFieKPfD9uJBPxjSau4jfEPMF8pyV/SkNQGMDg3jZD/1zPVRi2s0N4K2/EKlbx7cNW1aGh5iazwQjAwyK2ol0ejOHpf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227605; c=relaxed/simple;
	bh=3ea9PgX+n34/iVYhPTeDt8to0M7GTPu7UYx1G47sWaE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=JAEc7EsrUbuXDs26yNRhtRwVURum+dNbV39sBNdaSxi2fODqrkTMzbZuV7/wJPrKYKTJ70vcrd+b5tKgkp7DRgUIoFMqdeRIEeDgNW3mJL/wFKcdVjTugqgoxc3w1RoPFk1dSBC0qkIDJG4Q+wsHJwzhw2JgxnAEbvxYWQro3FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGgBX8Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGgBX8Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6C4C113CC;
	Tue, 16 Apr 2024 00:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227604;
	bh=3ea9PgX+n34/iVYhPTeDt8to0M7GTPu7UYx1G47sWaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GGgBX8OlwygDj4ie9qvuoDDKL71tH789Y6rf2KD6fHzZJqoSmcwL0d0KFBMRnRdxs
	 ZFeFqrbPo56SU9/D/vKtUXWHAULWi6Ju25qlCX1Np2D6WvUHkfstqQeKRP+/PzSb7Q
	 M2YVqVAUrnAVlJWqa0p380VxcGl3ryRlm1gLaJQdgcSvO8rIOAtTN+PHlIf68sTp6l
	 6sPO9Gpuzv9ykFJlJGhuOspVgWbYYUXhAv0eT3jLvILHoB8vFr688cuMkdN5Cy6VdD
	 VTZ5lGOePx99ikkXcfV1yA4Za7OH8/utkGahzpz5ru9FN8FV/Tj5tiQ91Fd1QmBJbT
	 dQ+Yu4ueRB8gA==
Date: Mon, 15 Apr 2024 17:33:24 -0700
Subject: [GIT PULL 14/16] xfs: less heavy locks during fstrim
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171322719318.141687.811300841551086343.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 1a5f6e08d4e379a23da5be974aee50b26a20c5b0:

xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype (2024-04-15 14:59:00 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/discard-relax-locks-6.10_2024-04-15

for you to fetch changes up to b0ffe661fab4b939e4472ef96b8dac3c74e0e03e:

xfs: fix performance problems when fstrimming a subset of a fragmented AG (2024-04-15 14:59:00 -0700)

----------------------------------------------------------------
xfs: less heavy locks during fstrim [v30.3 14/16]

Congratulations!  You have made it to the final patchset of the main
online fsck feature!  This patchset fixes some stalling behavior that I
observed when running FITRIM against large flash-based filesystems with
very heavily fragmented free space data.  In summary -- the current
fstrim implementation optimizes for trimming the largest free extents
first, and holds the AGF lock for the duration of the operation.  This
is great if fstrim is being run as a foreground process by a sysadmin.

For xfs_scrub, however, this isn't so good -- we don't really want to
block on one huge kernel call while reporting no progress information.
We don't want to hold the AGF so long that background processes stall.
These problems are easily fixable by issuing smaller FITRIM calls, but
there's still the problem of walking the entire cntbt.  To solve that
second problem, we introduce a new sub-AG FITRIM implementation.  To
solve the first problem, make it relax the AGF periodically.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: fix performance problems when fstrimming a subset of a fragmented AG

fs/xfs/xfs_discard.c | 153 +++++++++++++++++++++++++++++++--------------------
1 file changed, 93 insertions(+), 60 deletions(-)

