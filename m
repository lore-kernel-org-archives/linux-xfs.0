Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB33D3D11
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783082201; cv=none; b=qEcTNIiL7s9E4KY0CDqKBoi+aeb2qXbAEbEb6SQbXuqR48+DA47RZmZhgHJnbYlrb1uQClzPtfz2clD/rWHZyaJf3qI9fXHvImwQAmzuVayVdR4mQpAyaaqBrCYP89UxGzMIqdeoSMyf5YVIkHbSF6Pf8w0xEBZKb9C2DMWfSqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783082201; c=relaxed/simple;
	bh=siOQsV5kM2W3gwsu4b8ojxGSmYhz4wVBm/77yVTVvKs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hcwwtIPWgFExnqYr49Njf/6qpa0LpT5QxORzwhzG9rL4+4ajNlRzgJlGUJ9hb7lNTj+WFKiqIuGwdZ2ubZlsNUH8nletpZZcN7KoLmWUL7KFyzDAZAJUiSiiPpyAURDjBPkNhbYg1/RhQYXnNtGl/+ZlwilI7A4Zk2ijpMpxnYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZRQyrXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZRQyrXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AD91F000E9;
	Fri,  3 Jul 2026 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783082200;
	bh=5tC7+LkqHNzeV6ormn3mYGRETeeaqSFsQl/r1WNbtts=;
	h=Date:From:To:Cc:Subject;
	b=GZRQyrXfPMbfFSk9jwQt1JaKz7beoRB/8q3oEdLemZdGmlGd8YtZCmHV2wNs9rMgE
	 Dee46TvJad4n9wYJuhFtP2u7RQKUhLDO1XIHzjWAv8zk5b/Lk+ikBq/uVD+R6s1FBS
	 n2amxJqQoTBiSFA81f8pY2ceDOWiJteRGxLv4GCHubb6K+esx9lgZlPbLl7v4dK88T
	 d58E3CKaLuUCsNMQXAMC7qDGKYvkMC+kvauVsOP1/sRGcoJYAQYqhqPYHRld5BEHs7
	 AR6wvj6glfSkAyhuDssziPKCn7ViMxpLa85jQtBGxWc6PJuP/xOUEYnYaU5Pc2dYKe
	 kskphBZa8e9ew==
Date: Fri, 3 Jul 2026 14:36:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.2-rc2
Message-ID: <akerZmyqyLw-ZBta@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

This contains is a collection of bugfixes and some small code refactoring.

An attempt merge against your current TOT has been successful.

Thanks,
Carlos

"The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc2

for you to fetch changes up to e4281086ae6caf006b6ef0670479eb5f96880fb9:

  xfs: simplify __xfs_buf_ioend (2026-07-01 12:29:50 +0200)

----------------------------------------------------------------
xfs: fixes for 7.2-rc2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (10):
      xfs: split up xfs_buf_alloc_backing_mem
      xfs: lift setting __GFP_NOFAIL from xfs_buf_alloc_kmem to the caller
      xfs: fix incorrect use of gfp flags in xfs_buf_alloc_backing_mem
      xfs: simplify the failure path in xfs_buf_alloc_vmalloc
      xfs: open code xfs_buf_ioend_fail in xfs_buf_submit
      xfs: also mark the buffer stale on verifier failure in xfs_buf_submit
      xfs: improve the xfs_buf_ioend_fail calling convention
      xfs: remove xfs_buf_ioend
      xfs: fix handling of synchronous errors in xfs_buf_submit
      xfs: simplify __xfs_buf_ioend

Dawei Feng (1):
      xfs: fix memory leak in xfs_dqinode_metadir_create()

Yingjie Gao (1):
      xfs: release dquot buffer after dqflush failure

Yousef Alhouseen (1):
      xfs: use null daddr for unset first bad log block

jiazhenyuan (1):
      xfs: fix AGFL extent count calculation in xrep_agfl_fill

 fs/xfs/libxfs/xfs_dquot_buf.c  |  14 ++-
 fs/xfs/scrub/agheader_repair.c |   2 +-
 fs/xfs/xfs_buf.c               | 192 ++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf.h               |   2 +-
 fs/xfs/xfs_buf_item.c          |   3 +-
 fs/xfs/xfs_inode.c             |   3 +-
 fs/xfs/xfs_log_recover.c       |   6 +-
 fs/xfs/xfs_qm.c                |   5 +-
 8 files changed, 125 insertions(+), 102 deletions(-)"
