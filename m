Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE87918C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504104; cv=none; b=XtzU6vQdUoIquhdV6TqOB71mugO/i/uPg0UEeuPdkIPkH/EJBPO2SLKHx6UPTMHBivVjXyQgNkQ09CAcpmPjXmrE2/coQGk6NI9See8tFHfCYQpE2V49hCahM2q9cWXPxeheVEWuDx9qBXPuKpUbfDLWa0ChQnObnlUHIyhFrH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504104; c=relaxed/simple;
	bh=h72zF1Q0RuZEAgCoeXCo3ygkLae/jkZia4Q6yNSMrBM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=joy9/rfAfhEqg09QvmHEdfaAIMh9ZolBmsKtVoX7GKQmX3Ei0hR33Uhx0pRdTNnCssCW+EBywgOdoxxHJM+5WKNn7pREkYaPwWg37SQkor+xfGTRLteG8jrcTJiD5nX2dJkECu/DW306Bo4yi5/NgGNmqDvtRqP5Ssjz7KMf8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqa4B4nR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqa4B4nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECBFC433F1;
	Wed, 27 Mar 2024 01:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504104;
	bh=h72zF1Q0RuZEAgCoeXCo3ygkLae/jkZia4Q6yNSMrBM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lqa4B4nRvs4byBaPZRyh3zwZHjwYc4kQYOhfcmVv1YBKmPvXvQu9O0iQsYMtsz3t7
	 vgegFfdRBlZhemWiW5O28N+yWS75aRpyyOWA60sYZEfuiNjBeG1+dzOd5/EbGkchZn
	 DWLS51qjY1VXzKfkClHtg5QLrtbc2mc+ElF0IH+evu+1SBi4c4sxfm859TSG4BWbHR
	 i9t6QFyOMxWc+Tu75qwvw/GoYYV1LFm2KxqRZm9vx4f1UC3A0UeCtVOSsPSlTkva4Y
	 pKbuBM6xui2Q5ZLDVcHkmO+0B8OYGdyCczqsNrIUvqsFI1hlClXCDwiu9l6DvwBglo
	 gkHjawbWPHeDA==
Date: Tue, 26 Mar 2024 18:48:23 -0700
Subject: [PATCHSET v30.1 08/15] xfs: online repair of extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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
 fs/xfs/scrub/attr_repair.c    | 1206 +++++++++++++++++++++++++++++++++++++++++
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
 30 files changed, 2283 insertions(+), 83 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/attr_repair.h
 create mode 100644 fs/xfs/scrub/dab_bitmap.h
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h

