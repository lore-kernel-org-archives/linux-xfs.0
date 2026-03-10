Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA232DB78B;
	Tue, 10 Mar 2026 18:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167932; cv=none; b=lEEQLqpXzlbBuN9l6HGU44F2Oa6txrIXBT43GE6/TbAqFF/vUCsloXmMip/X2z5pmSLMbk77CpXICCer+gsTESsftsDQMiuhuFnsOyh9tEij+KDYKQEiv8RjsbVUTN0QYpVYYypFt26ws3cmH0+372XJcwmfCj7XNsXkzx/yhoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167932; c=relaxed/simple;
	bh=Z8bymAiTawJ3Pen8fiT9SedU9TetaBrJAouahCKBsiQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A7kd+Zs5dFYHdf5o9Z6lpDeRus2dkz4ZIFacOGOCf86fIchNvY0h8l3OJAfsOwQ+2RXg+T+gt4GOJjN+riZU6D8NyQewwr7cpDQFOXogaB0O5kzxXBej5Golrbj/D/BZU222UyTnoP6wCHmbSU9cQmpgAl81Wiv79QukrHCFKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=belVaCXe; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="belVaCXe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773167931; x=1804703931;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vhme4BgJWKhLCHDH3rslfPKs5BykGET2hI3Ao91Aftc=;
  b=belVaCXeZEnlFsBsSVWPUuBd2EU1ANMf6QawOPCq4gslbqYnO4z5GMFj
   NyNmFmRHMNIgwUXL5XM3aJHAygzScjHWkXdmfWHQTPBLeSrDXjiUtbCvG
   6aCq4I4sd9ZAPRVmJapG9dO4YWvWHoDtf0GMhd8+ujnYufMC5vYnkEPw5
   llbp0RyA1dEkIIuMMgM5aYhGnSuSgOo4my84FyjXsorX9ezDiDoe31p+2
   tPXwFTiwZq3zVQBtUtdVF526mi4kfOdOy3FejHHWDvES5oKKVTsOUmD3F
   4QvwtU+rIUF1NFn7NqY6rlMUW3M3scqaHHDHPg+iReG84aiYMuvHofvDs
   g==;
X-CSE-ConnectionGUID: Ts5k0FhRQtKl5SPLEBEkGw==
X-CSE-MsgGUID: CirMUBegToK5FVCSQ0oNIw==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14514977"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 18:38:48 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:8842]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.26.67:2525] with esmtp (Farcaster)
 id 82c13a67-b64e-4929-8d98-1fb87bd1ac68; Tue, 10 Mar 2026 18:38:48 +0000 (UTC)
X-Farcaster-Flow-ID: 82c13a67-b64e-4929-8d98-1fb87bd1ac68
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:38:46 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:38:44 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH v4 0/4] xfs: fix AIL push use-after-free during shutdown
Date: Tue, 10 Mar 2026 18:38:36 +0000
Message-ID: <20260310183835.89827-6-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When a filesystem is shut down, background inode reclaim and the xfsaild
can race to abort and free dirty inodes. Since commit 90c60e164012
("xfs: xfs_iflush() is no longer necessary"), xfs_inode_item_push() no
longer holds ILOCK_SHARED while flushing, removing the protection that
prevented the inode from being reclaimed during the flush.

This results in use-after-free when dereferencing log items after
iop_push() returns, or when reacquiring the AIL lock via lip->li_ailp.

This series fixes the issue by:
1. Reordering unmount to stop reclaim and inodegc before pushing the AIL
2. Capturing log item fields before push callbacks for tracepoints
3. Saving the ailp pointer before dropping the AIL lock
4. Factoring the push loop into a helper for readability (non-bugfix)

Changes in v4:
- Fixed unmount ordering: xfs_inodegc_stop before cancel_delayed_work_sync
  to prevent inodegc from re-queuing m_reclaim_work as suggested by
  Darrick J. Wong
- Updated xfs_unmount_flush_inodes function comment to reflect new ordering
- Reworked patch ordering so bugfix patches (1-3) do not depend on the
  refactoring patch, reducing stable backport burden
- Added comment at xfsaild_push_item call site documenting that the log
  item must not be dereferenced after the call
- Moved refactoring to patch 4 without Cc: stable
- Link to v3: https://lore.kernel.org/all/20260308182804.33127-6-ytohnuki@amazon.com/

Changes in v3:
- Split into 4 patches as suggested by Dave Chinner
- Moved UAF-unsafe point comments to after xfs_buf_relse()
- Passed ailp instead of dev to tracepoints
- Moved xfs_ail_push_class definition after xfs_log_item_class events
- Factored xfsaild_push() loop body into xfsaild_process_logitem()
- Added xfsaild_push_item() header comment describing post-return lifetime
- Link to v2: https://lore.kernel.org/all/20260305185836.56478-2-ytohnuki@amazon.com/

Changes in v2:
- Reordered xfs_unmount_flush_inodes() to stop reclaim before pushing
  AIL suggested by Dave Chinner
- Introduced xfs_ail_push_class trace event to avoid dereferencing
  freed log items in tracepoints
- Added comments documenting that log items must not be referenced
  after iop_push() returns
- Saved ailp pointer in local variables in push functions
- Link to v1: https://lore.kernel.org/all/20260304162405.58017-2-ytohnuki@amazon.com/

Yuto Ohnuki (4):
  xfs: stop reclaim before pushing AIL during unmount
  xfs: avoid dereferencing log items after push callbacks
  xfs: save ailp before dropping the AIL lock in push callbacks
  xfs: refactor xfsaild_push loop into helper

 fs/xfs/xfs_dquot_item.c |   9 ++-
 fs/xfs/xfs_inode_item.c |   9 ++-
 fs/xfs/xfs_mount.c      |   7 ++-
 fs/xfs/xfs_trace.h      |  36 ++++++++++--
 fs/xfs/xfs_trans_ail.c  | 127 ++++++++++++++++++++++++----------------
 5 files changed, 125 insertions(+), 63 deletions(-)

-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



