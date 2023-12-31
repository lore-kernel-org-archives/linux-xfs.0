Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E103B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODCVhj9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A04EC433C7;
	Sun, 31 Dec 2023 19:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051691;
	bh=afLmT90JMcc59XtrdTr+bJEsVcUCcSeHD/NDtEAq5VE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ODCVhj9ZXm0QxTF2GTUqCeR0igvwPaUF8ir1mAIS/PMPFe58j7gjy8nFIPEuSWT7l
	 o4BkOS1Og7UnGf3hH5LQl8Q7emf5YecxB/Fplp4Sq6yx+rHOo3j95j6Z3z0ROTcmAy
	 IIKXqcFIxbIcoRTcEp5St6iOuwYG2kdkNwHFrDzqyKbT+PjE+c07caJcpFng89lysL
	 rjpTv4hFKXcqWwM4K+NaLoDPW0FVvV7Xrovfc3wu+Sx3qQ9cuKhrE99LOyhPbj4cL5
	 ybBBykDJ4Tv1xYZwVn2kztfmwkgQ04k62kVRAAJn6tFuXgTZHQKd3hfK/Y20NHRyLJ
	 oVklpXUfMx5RQ==
Date: Sun, 31 Dec 2023 11:41:31 -0800
Subject: [PATCHSET 07/40] xfs_repair: support more than 4 billion records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
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

I started looking through all the places where XFS has to deal with the
rc_refcount attribute of refcount records, and noticed that offline
repair doesn't handle the situation where there are more than 2^32
reverse mappings in an AG, or that there are more than 2^32 owners of a
particular piece of AG space.  I've estimated that it would take several
months to produce a filesystem with this many records, but we really
ought to do better at handling them than crashing or (worse) not
crashing and writing out corrupt btrees due to integer truncation.

Once I started using the bmap_inflate debugger command to create extreme
reflink scenarios, I noticed that the memory usage of xfs_repair was
astronomical.  This I observed to be due to the fact that it allocates a
single huge block mapping array for all files on the system, even though
it only uses that array for data and attr forks that map metadata blocks
(e.g. directories, xattrs, symlinks) and does not use it for regular
data files.

So I got rid of the 2^31-1 limits on the block map array and turned off
the block mapping for regular data files.  This doesn't answer the
question of what to do if there are a lot of extents, but it kicks the
can down the road until someone creates a maximally sized xattr tree,
which so far nobody's ever stuck to long enough to complain about.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-support-4bn-records
---
 db/Makefile       |    4 
 db/bmap_inflate.c |  564 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c      |    1 
 db/command.h      |    1 
 man/man8/xfs_db.8 |   23 ++
 repair/bmap.c     |   26 +-
 repair/bmap.h     |    9 -
 repair/dinode.c   |   12 +
 repair/dir2.c     |    2 
 repair/incore.c   |    9 +
 repair/rmap.c     |   26 +-
 repair/rmap.h     |    4 
 repair/slab.c     |   36 ++-
 repair/slab.h     |   36 ++-
 14 files changed, 680 insertions(+), 73 deletions(-)
 create mode 100644 db/bmap_inflate.c

