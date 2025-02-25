Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413F519AD48
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 17:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504495; cv=none; b=Pd+tEGYg8sKa07oFzbEXr4DoM6cdF9pzefKQHFkFg5LC85AZyKP9qkPBogtIK5H1cYDFqW1WowBJcphwqNc5GBna3hdOMtcQSC+HUEhJJ4kSC4F2yA2q/1islZDdVEsBhUl9ZPCh7Lcby5UTCb5HAh4is+UwIhuQHIpHdkQpMaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504495; c=relaxed/simple;
	bh=7bnT+z0uT6lSdIREMS0TT0YBVul+4eiYbfCawQcFARM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=sOMbZWwh7SNNbrm7ErxMIKJORR4M2oCWyrO+m0bopZk8cXL2Rr5xKJ2giMm9+m9NgmZLFXk53wuo1ZPABCVL8NGoTBqTGBowX6NfEebi2soZqlooD75XztBG3DBSntcxoWbnNc0WFpCYdZosET9/jXAiWUWVhuXMiTMsKl4T0Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZt6Hu6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZt6Hu6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95C3C4CEDD;
	Tue, 25 Feb 2025 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504493;
	bh=7bnT+z0uT6lSdIREMS0TT0YBVul+4eiYbfCawQcFARM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OZt6Hu6s/CdTxmYPEAMz3X8gZD9wXwce7ZvCRN+8ZewpMmjERJgDBG9De+gpYEpFH
	 ELxhDCxyc3bqgyUSeVpjj6gsqb9NSaqeDH5F9sS76KGDvBZj4GuFErALbcPsDNnWLD
	 +2iZIG+6yTH2n3uQsQgInJKUi5Pis9dL0l3HqtNBn9bVmvvd19ji6pNJMziLQH+hcr
	 wMxYilTmqXLNME+buA+JHH3K6iiHQgJYjFMrjC1psxpv248R3AFX+hwkbg+u/cqhQA
	 +ejqvbOsZLLT4ttHgkYkAb+XV9lL3ew1YuaicpaiS13albPT4S0FOjkEOapi2n5ImX
	 qVX8g9DZW8Ccg==
Date: Tue, 25 Feb 2025 09:28:13 -0800
Subject: [GIT PULL 7/7] xfs_scrub: handle emoji filenames better
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174050433042.404908.7493960383315715384.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225172123.GB6242@frogsfrogsfrogs>
References: <20250225172123.GB6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.14-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 8c4e704f370e0361c3e3dae5f8751ff580fa95a4:

xfs_db: add command to copy directory trees out of filesystems (2025-02-25 09:16:03 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-emoji-fixes-6.14_2025-02-25

for you to fetch changes up to 195777d3d64f3a567da56f2e63f073448b8995d0:

xfs_scrub: use the display mountpoint for reporting file corruptions (2025-02-25 09:16:03 -0800)

----------------------------------------------------------------
xfs_scrub: handle emoji filenames better [7/7]

Ted told me about some bugs that the ext4 Unicode casefolding code has
suffered over the past year -- they tried stripping out zero width
joiner (ZWJ) codepoints to try to eliminate casefolded lookup comparison
issues, but doing so corrupts compound emoji handling in filenames.

XFS of course persists names with byte accuracy (aka it doesn't do
casefolding or normalization) so it's not affected by those problems.
However, xfs_scrub has the ability to warn about confusing names and
other utf8 shenanigans so I decided to expand fstests.

I wired up Ted's confusing names into generic/453 in fstests and it
promptly crashed when trying to warn about filenames that consist
entirely of compound emoji (e.g. heart + zwj + bandaid render as a heart
with a bandaid over it).  So there's a patch to fix that buffer
overflow.  There's a second patch to avoid complaining about ZWJ unless
it results in confusing names in the same namespace.  The third patch
fixes a minor reporting problem when parent pointers are enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs_scrub: fix buffer overflow in string_escape
xfs_scrub: don't warn about zero width joiner control characters
xfs_scrub: use the display mountpoint for reporting file corruptions

scrub/common.c   | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
scrub/unicrash.c | 10 ++++++++--
2 files changed, 58 insertions(+), 4 deletions(-)

