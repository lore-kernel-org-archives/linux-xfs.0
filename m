Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AE8248F73
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 09:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783848838; cv=none; b=NHlPo+Bh5U66i4XMsEioJn6lJVEnzE1Ka9f+w9dlfLiq11LqcEDUHHLeiEuK3Vf/ulG9nSuEuWuYswwuAIGsgNsHFGX5+J1jafxPCxSt3qiT82oMzVwDP4N3bTfA+aYY7/2d/HZiv06KBJcLJ2eVExKQpriSVKfzJLYVhyzxHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783848838; c=relaxed/simple;
	bh=Kzr0f7whU/0hLhvyl4zjXC7pBQgUb7oOdkV8zd+EVXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qmwyg+GD1a2B0LYVbsQI34gvxdpgmQHhB2q1NiRZ5Z0CscTpoB+ihU7+vWNAK14+LB0CJHyU69T2Ub5zGH2RMHTwSsygN6wvaHWxmW5R+SMHyY3CHbYzs4wcvnFsEEElxkKeK+ZVhxv/z4lSgbkVjvPm5I9sDoFTHJl2kwEYWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TcTJidyb; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TcTJidyb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783848838; x=1815384838;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Kzr0f7whU/0hLhvyl4zjXC7pBQgUb7oOdkV8zd+EVXs=;
  b=TcTJidybnXL5duO2fr8F5DNos6WNmihJCPLY/GQblDm4rpZGCCcd2axj
   IbBL1G6OncGaZwhJJnw3qsDc8mMljEUiU8wdEEb16e+sr57c/OwP5zWW+
   /KoJop6zDZx1/ZU3GAN+HBMe2U2s1ZQCFOwWdyLMCLim5e9/5X6xBg6j9
   0NkIl7yrC5+g3A0bwIgtn9lGT+zltEWLcPPWHknIu/Mfde8GaPgx8PUjc
   ZdWDlvPI9y9FHPcbass3yXj/O/94ScbWlf603MbUlEH3+VyiE7dD7oy4u
   3jUPfeKJiDqeYbSzduajO2vrP48xKdprTrsL8bh7D8ePdclg85yzju4vQ
   w==;
X-CSE-ConnectionGUID: GsuwV/PGQOW3YUs7QsRUIw==
X-CSE-MsgGUID: yVlB+ZGRROOMJ1afQNh65g==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150568562"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2026 17:33:52 +0800
X-CSE-ConnectionGUID: Hpm5n9YsSRSHWZI8+BnZrw==
X-CSE-MsgGUID: kpV5ORPhQyKNZ7D6Ig6LmA==
IronPort-SDR: 6a535f60_t7eroIOQ7QhouI6gcGHVgvomMnDlpdxtJI3gE9GmlFpj+Jf
 WwgIfefF+RcJO9TQDqylcKdEEiD3i0e8KWd8E6g==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2026 02:33:20 -0700
X-CSE-ConnectionGUID: BV/yG+YkQv2+Kol25Zqi2Q==
X-CSE-MsgGUID: DI3Qfj9ERKuYJTkdOkHkVg==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 12 Jul 2026 02:33:19 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/3] xfs: consolidate metadir creation code
Date: Sun, 12 Jul 2026 11:33:14 +0200
Message-ID: <20260712093317.782831-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XFS metadata directory tree has grown several nearly identical
open-coded copies of the "create a metadata inode" sequence: allocate the
creation transaction, create and link the inode, do a bit of type
specific inode setup, commit, and finish or tear down the inode on both
the success and error paths.

Factor that boilerplate into a single helper, xfs_metadir_create_file(),
which takes the file mode and an optional callback to finish initializing
the new inode inside the creation transaction, and convert the existing
users - xfs_metadir_mkdir(), the quota inodes and the rtgroup inodes -
over to it.

Having a single helper also makes it straightforward to add new metadata
inode types without copying the sequence yet again.

No functional change intended otherwise.

Johannes Thumshirn (3):
  xfs: add xfs_metadir_create_file helper
  xfs: create quota metadir inodes using xfs_metadir_create_file
  xfs: create rtgroup metadir inodes using xfs_metadir_create_file

 fs/xfs/libxfs/xfs_dquot_buf.c | 29 +++++++-----------
 fs/xfs/libxfs/xfs_metadir.c   | 58 ++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_metadir.h   |  6 ++++
 fs/xfs/libxfs/xfs_rtgroup.c   | 58 ++++++++++++++++-------------------
 4 files changed, 80 insertions(+), 71 deletions(-)

-- 
2.54.0

