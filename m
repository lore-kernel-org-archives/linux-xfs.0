Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6282156225
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224120; cv=none; b=l45dG/+ty4BZGV1g8S7qeAd6nhirKdwjp0PyJv2KapXw2dglFN1fuqwhveNDdV6hMiKnelqyP7DiAb+83jhtQA7EIgMPizbC5GrmWzBJYKED1nv/+aGzEkEFAw/H7FFcreOh6ccueYEV3CjRQy785It8dOI2UYFfRA//tZx0hcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224120; c=relaxed/simple;
	bh=Y9Vyt3llAP5fzQnOAs/p9l0q0Ug4053allWF2Sj11ro=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFd3dCNmxE/sLktQUUfoywtEd8htOSHzNyV67a0sR0b7CRzVtjvzL6CRtoSlt5MteC0V7SpdCyT779OB10HncRiX7MamFKBUxeS1A9rLvNcyNLO2YzEYPHvu88QEgnoYVqdzjHfsdTviys248hU0WJTitLp9ILnBs43JdwGt21A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdVKj/TE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdVKj/TE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA4FC113CC;
	Mon, 15 Apr 2024 23:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224120;
	bh=Y9Vyt3llAP5fzQnOAs/p9l0q0Ug4053allWF2Sj11ro=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IdVKj/TEVgDfVor9qWyS2O5yFktIVxOpdNJSaXc6xAxyz+aq7n+Xv/i6a4weT9Bn9
	 QVRcDzzIHqBYnblx8jGjJuVaq69UUzApaxjXxb1zDcGp/EfE24y3Gy9hDedi51A4Z6
	 LweUeSdQURbW9NXdbWq8QBsg70iXYH9mgQEsMuKCRpSfkokAgX8yOPXGd8adfw8ReO
	 usmGvgXYtnniXxvjVH2zOqFctIGz6ocfHUn0ynRdGeOrm3MPDSSgP2Tf2dr+NvxTO3
	 vaxqSZrPLkrWleBdrXpZroajwZvtv78tEd3uLgAFwQAelpbW+x2albWutfMGcsm2VK
	 B4nZ8ZclHeWVQ==
Date: Mon, 15 Apr 2024 16:35:20 -0700
Subject: [PATCHSET v30.3 07/16] xfs: online repair of extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-xattrs-6.10
---
Commits in this patchset:
 * xfs: enable discarding of folios backing an xfile
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
 fs/xfs/scrub/attr_repair.c    | 1207 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/attr_repair.h    |   11 
 fs/xfs/scrub/dab_bitmap.h     |   37 +
 fs/xfs/scrub/dabtree.c        |   16 +
 fs/xfs/scrub/dabtree.h        |    3 
 fs/xfs/scrub/listxattr.c      |  312 +++++++++++
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
 30 files changed, 2284 insertions(+), 83 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/attr_repair.h
 create mode 100644 fs/xfs/scrub/dab_bitmap.h
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h

