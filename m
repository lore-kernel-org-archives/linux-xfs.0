Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5673B0ADD
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 12:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777291776; cv=none; b=bItyqzUOvgdjc1MDfTGWwCO+fqbH0z5hUfUm6wkboeNc9Cmc/TAXPLbX9XXPs92PuZL6qLpgjD6Lr89hn/n2LmVZe0+tRnFn5XDKJ+mDU9J33F+ahvSnvh3AVCJ/ijBeIpIyurlF22Y7ai91rrTkSupqcMe3YNWQTcxWa0xIL5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777291776; c=relaxed/simple;
	bh=yOXRtehkSYBIHmV3r2b7b5IARsZtzlBhrsgrCoaNgCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j+x6NSdJImBjPNaNpiiqVqRs4Xv/0H1oR+g9C/Hhk5M9V34t2TURSzdlYiMiU6NEiykRZXIhfULX49Agve5aBQ3MWHLzfoZhldJUISdIbtvs0RFEjVyBJL74H4k1wHvlJONd9KdJM16qOL9mDqy1PBE8+3/5iaZnSc0BhAl1nOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pvgoDdp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvgoDdp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D867AC19425;
	Mon, 27 Apr 2026 12:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777291775;
	bh=yOXRtehkSYBIHmV3r2b7b5IARsZtzlBhrsgrCoaNgCs=;
	h=From:To:Cc:Subject:Date:From;
	b=pvgoDdp8+e3kbRFZ7o4Jh5ZYnvrh317emctdq/fMHmurnAu25C93Z7JUB+S6GSOgs
	 /Z8pWwtz45l5pgvM4t8prFdqBcGf7fUT1/LV2UxpTgPdQkQHCPwIBoH4HBvxBykGdl
	 fmERw0umkZCysGMSeB668NwICpUhk32+V5PkqWMA///8IUx1qMa2Upfs0rUK8iMzVW
	 nl4Ubb+B+WrJOinI1FtxKK7emYAE9xckAaZ5mf4SQ3qAQWhv9tz9cVk+VCoBsL2kJT
	 9wRaXJuy2YngWEcUYvx0RQDvVmkOZmgcEcjGrE95qqVIYE8Ds3AJDbD+SHy1nij7cK
	 9JDAQ8R/pemeQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	leo.lilong@huawei.com,
	morbo@google.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/3] xfsprogs: libxfs-v7.0-sync
Date: Mon, 27 Apr 2026 14:09:05 +0200
Message-ID: <20260427120908.52254-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is libxfs sync to v7.0 with a few missing patches. The most of the sync was
done by Darrick as part of his xfs_healer/health monitoring series.

The __counted_by_ptr is NOPed. This attribute existed before but without
pointer support, so this can not be easily wrapped by has_attribute. This will
require build checks to check compiler version which doesn't seem to be a
practice in xfsprogs.

Range-diff attached below.

Git Tag:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git tags/libxfs-v7.0-sync_2026-04-27

Bill Wendling (1):
  xfs: annotate struct xfs_attr_list_context with __counted_by_ptr

Long Li (2):
  xfs: factor out xfs_attr3_node_entry_remove
  xfs: factor out xfs_attr3_leaf_init

 include/platform_defs.h |  3 +++
 libxfs/xfs_attr.h       |  3 ++-
 libxfs/xfs_attr_leaf.c  | 22 +++++++++++++++++
 libxfs/xfs_attr_leaf.h  |  3 +++
 libxfs/xfs_da_btree.c   | 53 ++++++++++++++++++++++++++++++++---------
 libxfs/xfs_da_btree.h   |  2 ++
 6 files changed, 74 insertions(+), 12 deletions(-)

-- 
2.51.2

-- 
1:  d67701f62d9a ! 1:  df91bc3bdc9b xfs: annotate struct xfs_attr_list_context with __counted_by_ptr
    @@ Commit message
         Signed-off-by: Carlos Maiolino <cem@kernel.org>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
    + ## include/platform_defs.h ##
    +@@ include/platform_defs.h: struct kvec {
    + #define BLK_ZONE_COND_ACTIVE      0xff
    + #endif
    + 
    ++/* xfs_attr.h */
    ++#define __counted_by_ptr(member)
    ++
    + #endif    /* __XFS_PLATFORM_DEFS_H__ */
    +
      ## libxfs/xfs_attr.h ##
     @@ libxfs/xfs_attr.h: struct xfs_attr_list_context {
        struct xfs_trans        *tp;
2:  d3b48de1f7db = 2:  e7aab724c89a xfs: factor out xfs_attr3_node_entry_remove
3:  a0a6a995a5b5 = 3:  922f14a9b776 xfs: factor out xfs_attr3_leaf_init
