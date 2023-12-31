Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FA4B65C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbLvAbC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FB0C433C8;
	Sun, 31 Dec 2023 19:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051034;
	bh=RXbZ1B1IowvKBJRI90Xt+1ffE/c9dz9y/K1N6deMmU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RbLvAbC0/CFKaDXT7uyeLaiyCpIgeSJfeFEHYIqGIEzcDhxXfT+E3DT1nvqb2TogK
	 yqdvx4BcW7oqr1DFjeFK3hi+Twfa+dJRn/9rz3xUw/mHEkbl4cBstqxIBICXs5Mi8e
	 CuHdWlbVyazAa2gafaoqmg4T+wP0tpX63QDVN9Pm77wm4HSq5Mm/X4KGrVaYGw9MTU
	 CtrWMO8yJbvq68glRpW4TsBSUhLEYJyZJpLMFUdPZNWih6W5i8oQQmGg1KYGpiMb6i
	 WF1xGytvbi3nlA5sn6DrGiRnp8y2K3bs+q5/D8fzOU2PXNGytyLCN6P7vDWjM50Dx0
	 Bf4dTTHagxXhg==
Date: Sun, 31 Dec 2023 11:30:34 -0800
Subject: [PATCHSET v29.0 20/28] xfs: online repair of extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 fs/xfs/Makefile               |    3 
 fs/xfs/libxfs/xfs_attr.c      |    2 
 fs/xfs/libxfs/xfs_attr.h      |    2 
 fs/xfs/libxfs/xfs_da_format.h |    5 
 fs/xfs/libxfs/xfs_swapext.c   |    2 
 fs/xfs/libxfs/xfs_swapext.h   |    1 
 fs/xfs/scrub/attr.c           |  158 +++--
 fs/xfs/scrub/attr.h           |    7 
 fs/xfs/scrub/attr_repair.c    | 1203 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/attr_repair.h    |   11 
 fs/xfs/scrub/dab_bitmap.h     |   37 +
 fs/xfs/scrub/dabtree.c        |   16 +
 fs/xfs/scrub/dabtree.h        |    3 
 fs/xfs/scrub/listxattr.c      |  310 +++++++++++
 fs/xfs/scrub/listxattr.h      |   17 +
 fs/xfs/scrub/repair.c         |   46 ++
 fs/xfs/scrub/repair.h         |    6 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/tempfile.c       |  203 +++++++
 fs/xfs/scrub/tempfile.h       |    3 
 fs/xfs/scrub/tempswap.h       |    2 
 fs/xfs/scrub/trace.h          |   84 +++
 fs/xfs/scrub/xfarray.c        |   17 +
 fs/xfs/scrub/xfarray.h        |    2 
 fs/xfs/scrub/xfblob.c         |  168 ++++++
 fs/xfs/scrub/xfblob.h         |   26 +
 fs/xfs/scrub/xfile.h          |   12 
 fs/xfs/xfs_buf.c              |    3 
 fs/xfs/xfs_trace.h            |    2 
 29 files changed, 2270 insertions(+), 83 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/attr_repair.h
 create mode 100644 fs/xfs/scrub/dab_bitmap.h
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h

