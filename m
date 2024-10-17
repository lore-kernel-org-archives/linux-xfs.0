Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA58E200111
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190410; cv=none; b=R8S+5FHvfH9gU984PXLTlvn33MePbfBPDwXOakMhY8AcSsdECqeRSiL2CdrxfyDyk5gxMABQfPQuy61nKrqtPy7E9mZ+7K8R8BdlPSyM7dglZjZBed+TLBZEhQGW67TXWxmebOrOA6LUBhoYH6DNMJ0bTupsFMZbf3afA99GU98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190410; c=relaxed/simple;
	bh=8uCm6ug666gtk4zAdYGYDUztXuW1AedJM+oXWH5U+TY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uh+cHYaLJSuZ5LRyw4b25m05tR1tZSASlXsM4IChuSeX7UkOqbr8sE66ETidTnB0Xhz1RxXs8gSxNONiWTJHCaRQU7AL/bBumrLZ2/kfQ+mPQ9MIWR/PQ2EOWeETD9C3gWzc6r905ZdC81Sd4wjedkilBoe+GnlIRMnzeuw+ap4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXlpZfRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXlpZfRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F29C4CEC3;
	Thu, 17 Oct 2024 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190410;
	bh=8uCm6ug666gtk4zAdYGYDUztXuW1AedJM+oXWH5U+TY=;
	h=Date:From:To:Cc:Subject:From;
	b=jXlpZfRnzCrpGtJmY/qlYpe9LUQ0sgi+rab7gQCnoApE0B33Sjt5C58qPUV5btBKQ
	 fKUllIo2joNVpxNyuu0d8NuwJ0lja5CWmQ4PQfIl7yYbiuSnAVwyhRu2juYFJnw/r/
	 XMd/ustC5T7xR+NR6EQurF1XeNZLe4VRzjdLfY6j4BIvU3xrhn6hBX7dvC2XNxLw3c
	 fifCcplot7eG7KAg9drt6X5FyqzVRGbfh6/TDNl2wPH5ym2TMZjoP4NJy7A3pq90Oj
	 7q5Oo/XUNocFoTZ6ltQCr1qxdwueBTg3i4kGVs0kSE2OjsVOvtLo33xBptFdliWVe+
	 uHtsSlvFH50cg==
Date: Thu, 17 Oct 2024 11:40:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHBOMB 6.13 v5.1] xfs: metadata directories and realtime groups
Message-ID: <20241017184009.GV21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph and I have been working on getting the long-delayed metadata
directory tree patchset into mergeable shape, and I think we're now
satisfied that we've gotten the code to where we want it for 6.13.
This time around we've included a ton of cleanups and refactorings that
Dave requested during the 6.12 cycle, as well as review suggestions from
the v5.0 series last week.  I'm jumping on a train in a couple of hours,
so I'm sending this out again.

The metadata directory tree sets us up for much more flexible metadata
within an XFS filesystem.  Instead of rooting inodes in the superblock
which has very limited space, we instead create a directory tree that
can contain arbitrary numbers of metadata files.

Having done that, we can now shard the realtime volume into multiple
allocation groups, much as we do with AGs for the data device.  However,
the realtime volume has a fun twist -- each rtgroup gets its own space
metadata files, and for that we need a metadata directory tree.
Note that we also implement busy free(d) extent tracking, which means
that we can do discards asynchronously.

Metadata directory trees and realtime groups also enable us to complete
the realtime modernization project, which will add reverse mapping
btrees, reflink, quota support, and zoned storage support for rt
volumes.

Finally, quota inodes now live in the metadata directory tree, which is
a pretty simple conversion.  However, we added yet another new feature,
which is that xfs will now remember the quota accounting and enforcement
state across unmounts.  You can still tweak them via mount options, but
not specifying any is no longer interpreted the same as 'noquota'.
Quotas for the realtime are now supported.

I'm only sending the kernel patches to the list for now (for real this
time!), but please have a look at the git tree links for xfsprogs and
fstests changes.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/tag/?h=metadir_2024-10-17
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/tag/?h=metadir_2024-10-17
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tag/?h=metadir-quotas_2024-10-17

This is a list of the kernel patches that remain unreviewed:

[PATCHSET v5.1 3/9] xfs: metadata inode directory trees
  [PATCH 03/29] xfs: rename metadata inode predicates
  [PATCH 04/29] xfs: standardize EXPERIMENTAL warning generation
[PATCHSET v5.1 6/9] xfs: shard the realtime section
  [PATCH 29/34] xfs: make xfs_rtblock_t a segmented address like
[PATCHSET v5.1 8/9] xfs: enable quota for realtime volumes
  [PATCH 2/6] xfs: advertise realtime quota support in the xqm stat

--D
