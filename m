Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D71E198A0C;
	Fri, 11 Oct 2024 00:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606243; cv=none; b=YJhPgksOf0cSNH1nFew+i8vOPgYZW40y3ubivdGwOhhg7wVMjpAcN9R0pGx9riw0R+JnfunJMcPEwgzc1pmJu1+xBq7JsETlg7lo8frynohZQC+aHWW9UXfSnT4laLDsYbe5MbxxONeNtaheMUK3HB97bgGizuLa3w4RL0USGSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606243; c=relaxed/simple;
	bh=DELmYecsq1E9KWWDDj9O7O0jbF4sqTL0kvNA5fibT+c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kD+1JSzbceeEGKGv9f4xCN3XXT62NztPZbA5c+xAeNqs0zWnyhvR1QaJySQ/7h4BCAc8sdrBIyAhXtemHKYpEIfIMWqVbttGJOUmlbrLhjnFejv5wAq0wrhFdB/1BwURFmPK4dscye0H0h/kOzabeg+YK8nz/hjMNItwoAGVuPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFW+WI1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFW+WI1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0A3C4CEC5;
	Fri, 11 Oct 2024 00:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606243;
	bh=DELmYecsq1E9KWWDDj9O7O0jbF4sqTL0kvNA5fibT+c=;
	h=Date:From:To:Cc:Subject:From;
	b=HFW+WI1sp28+gXi6j6csp6ppm/2gSdpguUZuLWLLbptaiOBAW6zMByge2sGfw0UrY
	 PHOEyqnyaC45OfA5XxcoIV9VFRzS17OdXUN9adun56k/zQHzvqDkZapg3sSj2qnZDN
	 VipQZgZDumhOPbhU0VPSl4OmaTZO+U8aM8lcS62G01bVFoQlUbM7HeEU2d4tfDqrw+
	 VRHpHyEGXZ7RhA/UbPE67yakxydnXfZkdLgjcmgbQsSTDHQ1RcVcs6tXAEhn3CrFwP
	 +vjTmjh0HwjpQlxZ81a7d19pTVNuVU3Ya2eWjefhXiXMBbZFlTVSDBkJ6RE5hBJW4V
	 JNVbP7lFa1+hg==
Date: Thu, 10 Oct 2024 17:24:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCHBOMB 6.13] xfs: metadata directories and realtime groups
Message-ID: <20241011002402.GB21877@frogsfrogsfrogs>
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
Dave requested during the 6.12 cycle.

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

I'm only sending the kernel patches to the list for now, but please have
a look at the git tree links for xfsprogs and fstests changes.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/tag/?h=metadir_2024-10-10
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/tag/?h=metadir_2024-10-10
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tag/?h=metadir-quotas_2024-10-10

This is a list of the kernel patches that remain unreviewed:

[PATCHSET v5.0 3/9] xfs: metadata inode directory trees
  [PATCH 01/28] xfs: constify the xfs_sb predicates
  [PATCH 02/28] xfs: constify the xfs_inode predicates
  [PATCH 04/28] xfs: undefine the sb_bad_features2 when metadir is
[PATCHSET v5.0 4/9] xfs: create incore rt allocation groups
  [PATCH 08/21] xfs: add a xfs_qm_unmount_rt helper
  [PATCH 09/21] xfs: factor out a xfs_growfs_rt_alloc_blocks helper
  [PATCH 10/21] xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
  [PATCH 11/21] xfs: split xfs_trim_rtdev_extents
[PATCHSET v5.0 5/9] xfs: preparation for realtime allocation groups
  [PATCH 1/2] xfs: fix rt device offset calculations for FITRIM
[PATCHSET v5.0 6/9] xfs: shard the realtime section
  [PATCH 15/36] xfs: store rtgroup information with a bmap intent
  [PATCH 27/36] xfs: create helpers to deal with rounding xfs_fileoff_t
  [PATCH 28/36] xfs: create helpers to deal with rounding xfs_filblks_t
  [PATCH 29/36] xfs: make xfs_rtblock_t a segmented address like
  [PATCH 32/36] xfs: fix minor bug in xfs_verify_agbno
  [PATCH 33/36] xfs: move the min and max group block numbers to
  [PATCH 34/36] xfs: port the perag discard code to handle generic
  [PATCH 35/36] xfs: implement busy extent tracking for rtgroups
  [PATCH 36/36] xfs: use rtgroup busy extent list for FITRIM
[PATCHSET v5.0 8/9] xfs: enable quota for realtime volumes
  [PATCH 1/6] xfs: fix chown with rt quota
  [PATCH 2/6] xfs: advertise realtime quota support in the xqm stat
  [PATCH 3/6] xfs: report realtime block quota limits on realtime
  [PATCH 4/6] xfs: create quota preallocation watermarks for realtime
  [PATCH 5/6] xfs: reserve quota for realtime files correctly
  [PATCH 6/6] xfs: enable realtime quota again

None of the userspace and fstests patches have been reviewed.

--D
