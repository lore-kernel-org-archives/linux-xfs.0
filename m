Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B06189BBB
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735687987; cv=none; b=n8UMGnMVJAQIbaGg7tHci6GrDnw6YIzy25NYZmZAqhybgvmEZfuub400pGkBzdKLBMeNtfRKx69VTDGnuARXiQoX70yFpKzPKVsSAl11FP4nsFYBgQUQ4Y5ehPTRKDLkJczgcvdUiKhx0OXEFt/cSu11ZJiZoZLwmIFutXEOBbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735687987; c=relaxed/simple;
	bh=4FJBvVMnwQRmsrn1P+IOIkWE7UGr8WItoQd1wVHLqgA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEpDXVS4XvfdlBcyKQdeWUMDxHTkQl4MQJPQY3rLMSrz5gSIR0Bmc3YBf1q0HvVBynJaOy0jD4DnvDw277M/52AJAIbPEQUNznmepqio5EYjOS/LXNheru1FNuO61GM5fri600mNoOfxGrZHX6g7RouKSL5WFcrHQpuJs/3+Iqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwWdbcFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwWdbcFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52001C4CED2;
	Tue, 31 Dec 2024 23:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735687987;
	bh=4FJBvVMnwQRmsrn1P+IOIkWE7UGr8WItoQd1wVHLqgA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uwWdbcFU9NJCz6LbJKekVme3QXjiIEYyksDeIt6aWNO+srKLBD5/v0L+ybeJYLBWr
	 Hrm8I7w8XvVmt0auT0yV9km9jQgu22+qaiLx+/KeQSa5hLChxK/bvGjjMY8xqTUvX/
	 sg2DhfiuxGhPyXckd1pZobCKl6U84vJ31V2ZLSxZGF1FL+LAQDTrD9j+brP7GCV9u2
	 PLnUjhaBevIrvJPaV2gUy8ypdkigy42E9Z0IBvBNhMSl60ErAIK/lesnNf7TUKRRyb
	 /s3WrXkp7jUUSnI3rp9JJJ3MqCHgIWcK4tmvoyZj56BPIrn9xCNBOZPCpA83V46Oli
	 fXTiNmnhItdbw==
Date: Tue, 31 Dec 2024 15:33:06 -0800
Subject: [PATCHSET 4/5] xfs: defragment free space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

These patches contain experimental code to enable userspace to defragment
the free space in a filesystem.  Two purposes are imagined for this
functionality: clearing space at the end of a filesystem before
shrinking it, and clearing free space in anticipation of making a large
allocation.

The first patch adds a new fallocate mode that allows userspace to
allocate free space from the filesystem into a file.  The goal here is
to allow the filesystem shrink process to prevent allocation from a
certain part of the filesystem while a free space defragmenter evacuates
all the files from the doomed part of the filesystem.

The second patch amends the online repair system to allow the sysadmin
to forcibly rebuild metadata structures, even if they're not corrupt.
Without adding an ioctl to move metadata btree blocks, this is the only
way to dislodge metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defrag-freespace

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=defrag-freespace
---
Commits in this patchset:
 * xfs: export realtime refcount information
 * xfs: capture the offset and length in fallocate tracepoints
 * xfs: add an ioctl to map free space into a file
 * xfs: implement FALLOC_FL_MAP_FREE for realtime files
---
 fs/xfs/libxfs/xfs_alloc.c |   88 ++++++++
 fs/xfs/libxfs/xfs_alloc.h |    3 
 fs/xfs/libxfs/xfs_bmap.c  |    1 
 fs/xfs/libxfs/xfs_fs.h    |   14 +
 fs/xfs/xfs_bmap_util.c    |  513 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h    |    3 
 fs/xfs/xfs_file.c         |  143 ++++++++++++-
 fs/xfs/xfs_file.h         |    2 
 fs/xfs/xfs_fsrefs.c       |  405 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c        |    5 
 fs/xfs/xfs_rtalloc.c      |  108 +++++++++
 fs/xfs/xfs_rtalloc.h      |    7 +
 fs/xfs/xfs_trace.h        |   86 +++++++-
 13 files changed, 1368 insertions(+), 10 deletions(-)

