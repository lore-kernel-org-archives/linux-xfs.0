Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96215168BE
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000303; cv=none; b=CTEyXZMDMBysuhvbowBke8pN2NXQgoryoEakjcEEGpfAQwtlbaqTSgvd8jx2YWP1jnIeul1TmNWgvipC3YbFzlB93OXJ5jSopmk+elaP64PmynEHp6x2PuUMz3Ni18Rry6zs+CiY8UYGX006cAi2nrS6xuW8vfJeqBdd7QZUmYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000303; c=relaxed/simple;
	bh=ll2Oer/ZnuDoKrv9afLmz4+mWzi5Du2Mn718ECYU79s=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=hhDACJcCgKFB0RX5tXH2F1pEHtHpSzjUPFh6SAoEs4gRSfF0xnGb/WHd5ORS0MvwT6Sk1IlJmvTXMsumX1QdnFnMnCWHN38hWFATwS1BqrkE+ueX8mDAn9mapJz68UfF33xUddZx1K54JaIcoBr5J1piwFl6tFVPPfpUWLyYmYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOrO3arc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOrO3arc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F369C433F1;
	Tue, 27 Feb 2024 02:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000303;
	bh=ll2Oer/ZnuDoKrv9afLmz4+mWzi5Du2Mn718ECYU79s=;
	h=Date:Subject:From:To:Cc:From;
	b=KOrO3arcTr8imJbuRWHvrfjXcuHIEl1pbqczPvyvT9fvb4Wcb2hYLSax5hyhpjnz1
	 oEuPYeBxJQ6mmj9lP8ILGp1QFii1Hu6etSS4ZMimvLtjNbyLvg0fIbFSumqfiJrhvW
	 pTnA7oa863qXuW51G5rh0GGvrr+d4mgJX3/PDoHK9x9jZUAH0WpvqsYm61DV9ZUJxx
	 vBYfhHvkb/At+WSboie5qn5stWSNhX6thuL9CRcDsFoJRUFJOLIxRXZnWY+BmP5aKe
	 PdJMQj5ed8w79QGXkv6hg3WR81eI9+3DSoYZzFa57UiwsUfP5P6Cz0qzTMwhwBJ9nt
	 kSoGXZEgDYUjw==
Date: Mon, 26 Feb 2024 18:18:23 -0800
Subject: [PATCHSET v29.4 07/13] xfs: online repair of extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-xattrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-xattrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-xattrs
---
Commits in this patchset:
 * xfs: create a blob array data structure
 * xfs: use atomic extent swapping to fix user file fork data
 * xfs: repair extended attributes
 * xfs: scrub should set preen if attr leaf has holes
 * xfs: flag empty xattr leaf blocks for optimization
 * xfs: create an xattr iteration function for scrub
---
 fs/xfs/Makefile               |    3 
 fs/xfs/libxfs/xfs_attr.c      |    2 
 fs/xfs/libxfs/xfs_attr.h      |    2 
 fs/xfs/libxfs/xfs_da_format.h |    5 
 fs/xfs/libxfs/xfs_exchmaps.c  |    2 
 fs/xfs/libxfs/xfs_exchmaps.h  |    1 
 fs/xfs/scrub/attr.c           |  158 +++--
 fs/xfs/scrub/attr.h           |    7 
 fs/xfs/scrub/attr_repair.c    | 1205 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/attr_repair.h    |   11 
 fs/xfs/scrub/dab_bitmap.h     |   37 +
 fs/xfs/scrub/dabtree.c        |   16 +
 fs/xfs/scrub/dabtree.h        |    3 
 fs/xfs/scrub/listxattr.c      |  310 +++++++++++
 fs/xfs/scrub/listxattr.h      |   17 +
 fs/xfs/scrub/repair.c         |   46 ++
 fs/xfs/scrub/repair.h         |    6 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/tempexch.h       |    2 
 fs/xfs/scrub/tempfile.c       |  204 +++++++
 fs/xfs/scrub/tempfile.h       |    3 
 fs/xfs/scrub/trace.h          |   85 +++
 fs/xfs/scrub/xfarray.c        |   17 +
 fs/xfs/scrub/xfarray.h        |    2 
 fs/xfs/scrub/xfblob.c         |  168 ++++++
 fs/xfs/scrub/xfblob.h         |   26 +
 fs/xfs/scrub/xfile.c          |   12 
 fs/xfs/scrub/xfile.h          |    6 
 fs/xfs/xfs_buf.c              |    3 
 fs/xfs/xfs_trace.h            |    2 
 30 files changed, 2280 insertions(+), 83 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/attr_repair.h
 create mode 100644 fs/xfs/scrub/dab_bitmap.h
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h

