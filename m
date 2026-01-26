Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8191C2BE037;
	Mon, 26 Jan 2026 07:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769412117; cv=none; b=gZDJWWU40ZrikN1G5wCHoSIUEljN/pmh34tUVVPiD5EB9IHDMUiM7EvmqXGKAzzQNx7UutlmbsC2SqMH8QODuC/u6+71t2+7PRiDF1pHN7/99IWJifcfKcH5LHVthqd7WhZMKRg+htYn64tAKPE5wSiUCMRSWycGDRkKsTtHoHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769412117; c=relaxed/simple;
	bh=+BpGaa3F6xruquZMOxYgiQh5kAwJ/zOsRfIOYUH6I7w=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=pZ4ds2/eNFC1i9/LuMT3bjn6lyBhRXItbGhM7LnFov3A6n4w/A0nvMp1UAxEER7qvXKG+rrC0on811teeb95E7T2XZJ2kdJfZpnVYg2OwenRmxYrokde5+ysSklecOZKgeH7z7LUTEfzQQtZ01wEaeZXgg06zPBhPDqwtRMfsCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlONpZ5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlONpZ5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADB0C116C6;
	Mon, 26 Jan 2026 07:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769412117;
	bh=+BpGaa3F6xruquZMOxYgiQh5kAwJ/zOsRfIOYUH6I7w=;
	h=Date:Subject:From:To:Cc:From;
	b=VlONpZ5vrJwV9Y/2HoPxwL5meeI2ySYVtpF1lxmXF916zu+vLc/dwn5IvjMg3IdvC
	 09lKui7tcwIpa9R+ozdXAbcU2SGFMDMU6wjukpzgZVEHN52czBN/dKjuCpMopsXaKU
	 H+5jQyRcQPkrISuon2i5Ptl7xy1/Hr7772pcZLHa5wsGREwjp+RANFTN3cJSsKBZ5K
	 UTmMxef0hF7hvBHLm9ZFueHGFfRRTSOHUYksQs34MtJ/5iEKD4Xlx2aCJx/ECvZ7I5
	 aWn6lPQiLh4RiOG6J/ODyOuC5FrlnXVY2Qgv24tZFmHx2GCKTJ6PP4qcqnAehmjg1N
	 ReCNjGHNxA39w==
Date: Sun, 25 Jan 2026 23:21:56 -0800
Subject: [GIT PULL 2/4] xfs: fix problems in the attr leaf freemap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <176939848160.2856414.18157451058012918573.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 7.0-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit a1ca658d649a4d8972e2e21ac2625b633217e327:

xfs: fix incorrect context handling in xfs_trans_roll (2026-01-21 12:59:10 +0100)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/attr-leaf-freemap-fixes-7.0_2026-01-25

for you to fetch changes up to bd3138e8912c9db182eac5fed1337645a98b7a4f:

xfs: fix remote xattr valuelblk check (2026-01-23 09:27:33 -0800)

----------------------------------------------------------------
xfs: fix problems in the attr leaf freemap code [1/3]

Running generic/753 for hours revealed data corruption problems in the
attr leaf block space management code.  Under certain circumstances,
freemap entries are left with zero size but a nonzero offset.  If that
offset happens to be the same offset as the end of the entries array
during an attr set operation, the leaf entry table expansion will push
the freemap record offset upwards without checking for overlap with any
other freemap entries.  If there happened to be a second freemap entry
overlapping with the newly allocated leaf entry space, then the next
attr set operation might find that space and overwrite the leaf entry,
thereby corrupting the leaf block.

Fix this by zeroing the freemap offset any time we set the size to zero.
If a subsequent attr set operation finds no space in the freemap, it
will compact the block and regenerate the freemaps.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: delete attr leaf freemap entries when empty
xfs: fix freemap adjustments when adding xattrs to leaf blocks
xfs: refactor attr3 leaf table size computation
xfs: strengthen attr leaf block freemap checking
xfs: fix the xattr scrub to detect freemap/entries array collisions
xfs: fix remote xattr valuelblk check

fs/xfs/libxfs/xfs_da_format.h |   2 +-
fs/xfs/libxfs/xfs_attr_leaf.c | 157 +++++++++++++++++++++++++++++++++---------
fs/xfs/scrub/attr.c           |  59 ++++++++--------
3 files changed, 155 insertions(+), 63 deletions(-)

