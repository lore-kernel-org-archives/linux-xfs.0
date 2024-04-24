Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E16513340B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929651; cv=none; b=a5hei4rFHDYhSvRGmS0Bw7I5650tOdGqn8fDDcTmde5fAVpnjml6v8rsXHr63cv22/GmaNP8qSv6o/ioLnnES3UURPkxAj7r+0WuLlkQyWEOjulkYYWuxwsesxPev79G8vfcC9x5lzxTfej122/liCQQ80X9cPWOfzP2QLCTIE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929651; c=relaxed/simple;
	bh=o9OZw06xLAozHMYR6wbHSkW33oziX3ra3evpo/Q8NOE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=r3uHpL9R4N4C0wtUXLAbH1FquNJ5pjwtwxVDGjuUGKaFbjK+vQNk4uS3Yu7uhqZR+NKmcFvTlwVsjTyDzKkXwea6jM1OCjdLuZtwll0zdKuWW0RtoqWFnpWw1CClg6W6siFdhCg15oyZM0ArnEnChrW8/qfgy9ZGHv8Ovni7wWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkV9F8ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkV9F8ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E6BC116B1;
	Wed, 24 Apr 2024 03:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929650;
	bh=o9OZw06xLAozHMYR6wbHSkW33oziX3ra3evpo/Q8NOE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EkV9F8eixbmkLejvVwhF+M3VP5BKxh/YHIuuKrrxZaOKr8wawMpIyyXuRT0T1fyYj
	 w1wZYztLTrYtX6vQ0ZM+29HeHvjNsJbchlTtRyw6IxZ4FFxJwkZfaWHKnGxjz1fJ6m
	 Y1GaCt5hN8eaWO21otLcRdRNrNADgrOW9qUQf0N6Qti57/qRZzdecyTjwrnNPJAMg8
	 lCaVCF3vYU8yDoeqnaBnoSpXFWCVJ1ReKEP7CWpfcAoARw/09ZlglzDj7qXo69NiNx
	 iKTtV7xNGSDXAr8e+/D9G4QwrCpziwWJe6fGgzNdKiOQ+aNwCAFsMeoiLuub1uxVuX
	 JV4JG757uNzKA==
Date: Tue, 23 Apr 2024 20:34:10 -0700
Subject: [GIT PULL 2/9] xfs: improve extended attribute validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392950368.1941278.17612824185696231303.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit cda60317ac57add7a0a2865aa29afbc6caad3e9a:

xfs: rearrange xfs_da_args a bit to use less space (2024-04-23 07:46:51 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/improve-attr-validation-6.10_2024-04-23

for you to fetch changes up to ea0b3e814741fb64e7785b564ea619578058e0b0:

xfs: enforce one namespace per attribute (2024-04-23 07:46:54 -0700)

----------------------------------------------------------------
xfs: improve extended attribute validation [v13.4 2/9]

Prior to introducing parent pointer extended attributes, let's spend
some time cleaning up the attr code and strengthening the validation
that it performs on attrs coming in from the disk.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (14):
xfs: attr fork iext must be loaded before calling xfs_attr_is_leaf
xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery
xfs: use an XFS_OPSTATE_ flag for detecting if logged xattrs are available
xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2
xfs: fix missing check for invalid attr flags
xfs: check shortform attr entry flags specifically
xfs: restructure xfs_attr_complete_op a bit
xfs: use helpers to extract xattr op from opflags
xfs: validate recovered name buffers when recovering xattr items
xfs: always set args->value in xfs_attri_item_recover
xfs: use local variables for name and value length in _attri_commit_pass2
xfs: refactor name/length checks in xfs_attri_validate
xfs: refactor name/value iovec validation in xlog_recover_attri_commit_pass2
xfs: enforce one namespace per attribute

fs/xfs/libxfs/xfs_attr.c      |  37 ++++++-
fs/xfs/libxfs/xfs_attr.h      |   9 +-
fs/xfs/libxfs/xfs_attr_leaf.c |   7 +-
fs/xfs/libxfs/xfs_da_format.h |   5 +
fs/xfs/scrub/attr.c           |  34 ++++--
fs/xfs/scrub/attr_repair.c    |   4 +-
fs/xfs/xfs_attr_item.c        | 242 +++++++++++++++++++++++++++++++++---------
fs/xfs/xfs_attr_list.c        |  18 +++-
fs/xfs/xfs_mount.c            |  16 +++
fs/xfs/xfs_mount.h            |   6 +-
fs/xfs/xfs_xattr.c            |   3 +-
11 files changed, 304 insertions(+), 77 deletions(-)

