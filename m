Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2725236E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227353; cv=none; b=jN2qpKaX3MipAkaoTSDDjkFdvfSdrRHYoY02KFJ2F8YWwqfOBYfHfFvAmnKnId5brHrKQ0L0G7YZvHaLDh+1peCQghmyMDKvggHE5nnZW6Hj0zqNhW/dkzWGc8BNwxcnRcsB93MhjXz6KSffkqqk1CaQAlNE7sKajAcaS6TRR6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227353; c=relaxed/simple;
	bh=vtM452JKPgAJAyoLwqq54glhI1RCRU4xvs/DzMb58U0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=fT/ideXbaq/I5pGY42k/yEezxfKOMs8REiC7/3Xf5+BmI9Uww7zHjzLong8N6OlG9jrRvQWztwZj0GlfqKInQGLe83ddRN2t7iYvMrIYxGxnEZYY8X5qPbipRIUEuhJ2HZPG/7Rxa2O/DIRm1SadmcjT8kFsph4vE/Yrino7jRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9nUOxgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9nUOxgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BE9C113CC;
	Tue, 16 Apr 2024 00:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227353;
	bh=vtM452JKPgAJAyoLwqq54glhI1RCRU4xvs/DzMb58U0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S9nUOxguIX3W27Yh7NXgdp07lCskiSVvIpCJ32Sw+FBwL/HIU3d2ORsluZuCfGKkT
	 0i8Wr9ZJweYLgPw/LQBaRcOFNmGfrA5LC9sT7MAbOLaaEEQ2X2S6mW+WIE9U9DlzRn
	 9JDG2U9HdVU347LTwG8xbpQ4NonWF6nIagIITBwvR4VYsoIpzjWN4qvd13s58hrUqV
	 0x9/qVb15OLmscYYU7L097uTeEksO0172afSoHiXkbUdVErWzBeCo/WGkaMJtwBdXf
	 Tdt7fuaprLUksKzHOzcIfYAOOJblbz2jOS0Ra2hwvQGw4RtZ+or3ieHWsjoFWX1+Li
	 6EL3mxZvxXdog==
Date: Mon, 15 Apr 2024 17:29:12 -0700
Subject: [GIT PULL 07/16] xfs: online repair of extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322717007.141687.11748721901437827911.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit fe6c9f8e48e0dcbfc3dba17edd88490c8579b34b:

xfs: validate explicit directory free block owners (2024-04-15 14:58:52 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-xattrs-6.10_2024-04-15

for you to fetch changes up to 6c631e79e73c7122c890ef943f8ca9aab9e1dec8:

xfs: create an xattr iteration function for scrub (2024-04-15 14:58:54 -0700)

----------------------------------------------------------------
xfs: online repair of extended attributes [v30.3 07/16]

This series employs atomic extent swapping to enable safe reconstruction
of extended attribute data attached to a file.  Because xattrs do not
have any redundant information to draw off of, we can at best salvage
as much data as we can and build a new structure.

Rebuilding an extended attribute structure consists of these three
steps:

First, we walk the existing attributes to salvage as many of them as we
can, by adding them as new attributes attached to the repair tempfile.
We need to add a new xfile-based data structure to hold blobs of
arbitrary length to stage the xattr names and values.

Second, we write the salvaged attributes to a temporary file, and use
atomic extent swaps to exchange the entire attribute fork between the
two files.

Finally, we reap the old xattr blocks (which are now in the temporary
file) as carefully as we can.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
xfs: enable discarding of folios backing an xfile
xfs: create a blob array data structure
xfs: use atomic extent swapping to fix user file fork data
xfs: repair extended attributes
xfs: scrub should set preen if attr leaf has holes
xfs: flag empty xattr leaf blocks for optimization
xfs: create an xattr iteration function for scrub

fs/xfs/Makefile               |    3 +
fs/xfs/libxfs/xfs_attr.c      |    2 +-
fs/xfs/libxfs/xfs_attr.h      |    2 +
fs/xfs/libxfs/xfs_da_format.h |    5 +
fs/xfs/libxfs/xfs_exchmaps.c  |    2 +-
fs/xfs/libxfs/xfs_exchmaps.h  |    1 +
fs/xfs/scrub/attr.c           |  158 +++---
fs/xfs/scrub/attr.h           |    7 +
fs/xfs/scrub/attr_repair.c    | 1207 +++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/attr_repair.h    |   11 +
fs/xfs/scrub/dab_bitmap.h     |   37 ++
fs/xfs/scrub/dabtree.c        |   16 +
fs/xfs/scrub/dabtree.h        |    3 +
fs/xfs/scrub/listxattr.c      |  312 +++++++++++
fs/xfs/scrub/listxattr.h      |   17 +
fs/xfs/scrub/repair.c         |   46 ++
fs/xfs/scrub/repair.h         |    6 +
fs/xfs/scrub/scrub.c          |    2 +-
fs/xfs/scrub/tempexch.h       |    2 +
fs/xfs/scrub/tempfile.c       |  204 +++++++
fs/xfs/scrub/tempfile.h       |    3 +
fs/xfs/scrub/trace.h          |   85 +++
fs/xfs/scrub/xfarray.c        |   17 +
fs/xfs/scrub/xfarray.h        |    2 +
fs/xfs/scrub/xfblob.c         |  168 ++++++
fs/xfs/scrub/xfblob.h         |   26 +
fs/xfs/scrub/xfile.c          |   12 +
fs/xfs/scrub/xfile.h          |    6 +
fs/xfs/xfs_buf.c              |    3 +
fs/xfs/xfs_trace.h            |    2 +
30 files changed, 2284 insertions(+), 83 deletions(-)
create mode 100644 fs/xfs/scrub/attr_repair.c
create mode 100644 fs/xfs/scrub/attr_repair.h
create mode 100644 fs/xfs/scrub/dab_bitmap.h
create mode 100644 fs/xfs/scrub/listxattr.c
create mode 100644 fs/xfs/scrub/listxattr.h
create mode 100644 fs/xfs/scrub/xfblob.c
create mode 100644 fs/xfs/scrub/xfblob.h

