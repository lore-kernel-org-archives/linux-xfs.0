Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1E53081C3
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 13:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758200652; cv=none; b=tO07CzMhzz4mCaNPTyu29aJI2D12KRFsbvkgzB7bHYODybk8YU6B2mFUPvYCaTv5joK+HHw+QdrFUOyKa6F0UNyGHnsTcRhlm2hXEh9Lz4j+q9ukY9UqmjQ9WLvLy73DLFXWVDqrQHO0W7BM89sO1lvMpe7e4cLjnlLyTWEeA6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758200652; c=relaxed/simple;
	bh=Yh0Q2QABSpOPz0+oxo4T6HSnHEWUkm+0qxWBILZEE2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VSoSHI16x1jT2nG8QetL+0FwU9wmQYfQYCu2RFmy5VORtfgKOsDtORFpw8BxxB36hgfSJl1KiPuvDm3h+nTTvy/LnIv+U+0UdzElSVQ+3oG+iHQQOHP2ggqTLqjo0qunmEFviZGfMC/G6ntOK9T6mDvNeoGojeu0SzvogGUaO/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVz/JTw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVz/JTw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089C4C4CEE7;
	Thu, 18 Sep 2025 13:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758200652;
	bh=Yh0Q2QABSpOPz0+oxo4T6HSnHEWUkm+0qxWBILZEE2Y=;
	h=From:To:Cc:Subject:Date:From;
	b=KVz/JTw9Mk6VRVjPTHmBak5EpQx+qt1S3tLE9lRa51KXu3p/yQAtwGRvmsWFQXq70
	 19Or1ceBIhADRq16FoJOhJJ+Q5mIiN+MG/4I2hW2hfNzvkEui+WjHC1nsbbVgpQjYA
	 BcPjvPUtTC8NvVW+KypZLlkqAIsR5d2L1HD708Nk3nkxuB6+n/8EdNJjKmyJPdxPFZ
	 0H7YW7zHSWpKEEBj089bdHw8wqiaU4ZMtuEfAX2yVxEEYP/KKcqk2i+ypuduMdpq3D
	 A9zzNsfyZpKJR39iOClU6t7fpiLlBB8gNs6aHm14X253vGrJEAf8e0Tlt2F/UA8BwC
	 Sbih/edrFsEMQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 0/2] Some minor improvements for zoned mode
Date: Thu, 18 Sep 2025 22:01:09 +0900
Message-ID: <20250918130111.324323-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple of patches to improve a mount meaasge and to improve (reduce)
the default maximum number of open zones for large capacity regular
devices using the zoned allocatror.

Changes from v1:
 - Improved XFS_DEFAULT_MAX_OPEN_ZONES description comment.
 - Removed capitalization from commit titles 
 - Added review tags

Damien Le Moal (2):
  xfs: improve zone statistics message
  xfs: improve default maximum number of open zones

 fs/xfs/libxfs/xfs_zones.h | 7 +++++++
 fs/xfs/xfs_zone_alloc.c   | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.51.0

