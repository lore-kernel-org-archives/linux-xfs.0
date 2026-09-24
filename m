Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE06C1A9FB7
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263006; cv=none; b=iZXuAo2Of2t8Msyf6tuxmZ3Z4NxrP/JtNAHVoJermFo69TxQDcdceJdqoL3sIwhShf+sTuxsH4WyUOdwt1K8vQuTI93v0YsdHvPbm0AY0++l5DhFKCOkpkpoAsN7bDWwEY/NcsNh9WLxjLGSvbPl/J9JdFl53dcZRNuDBBqanIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263006; c=relaxed/simple;
	bh=oExAsArz2pMdQvQFQv64GRtcGN01x+GrAdxktVuU3PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mEpQ/wOylf8k2L1eEUHWH4GmM1auJrJPcaynQAwgy71qBYZAmzg8LTAYfrN9eCD/ryL+eWHGBGalVYZYxJ1B9pneFI9q7Hk0UMzcNxRk0ee7FbbkEE7pMkXrTNPAvaltPV/Wn2+GgNncpeRfXcn6WMVhJUzZpgILuFTG3S51jTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iq99uhCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iq99uhCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F075B1F000FF;
	Thu, 24 Sep 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263005;
	bh=balLXLsbt40UBOQtctdlDaweD0crRDd0NaOXIr88jGw=;
	h=From:To:Cc:Subject:Date;
	b=iq99uhCOryKMcRryXBGDUH7Nr3Z+NAkakkJHZavxfcx4XLe88g7k9R562zv3mrDUZ
	 wusbCbqpYcKGqr0vygg0zihMdpAzv5WP3ZDQPjbRTyf6a7fsBqv6/m6ksQLWc0Nkq7
	 lgsR68gV22/AEC3StCMSYQquBUKRQEhcmsS8Yrc8G9wgygnB/JY1bl9iN6pjGCicFp
	 RduD2rsKN1kR3Nrklc4UVzBBtBfE3wd9e9NujgY1CKyTcX9SpgDXs/obzeZlFf0DR8
	 48/fD/eSpZwPhh7rydRL0MZ+xtgiIak+bF52WJfwZH8emhz55IADk9r8ovuG/fM3Mb
	 CKET0Yxw4JWMA==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	sandeen@sandeen.net
Subject: [PATCH v4 0/3] Enable xfs error reporting to print out error codes
Date: Thu, 24 Sep 2026 17:16:27 +0200
Message-ID: <20260924151638.38535-1-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This is the new version of the error code printing series.

The only modification here is on patch 2 which replaces the macros by
an inline function suggested by hch.

Darrick, I removed your RwB from patch 2 giving the way it implements
things now are considerable different


Carlos Maiolino (3):
  xfs: add xfs_error_report the ability to display an error code
  xfs: introduce xfs_trans_cancel_error()
  xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel

 fs/xfs/xfs_error.c         | 16 +++++++++++-----
 fs/xfs/xfs_error.h         |  9 +++++----
 fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
 fs/xfs/xfs_inode_item.c    |  3 ++-
 fs/xfs/xfs_iomap.c         |  2 +-
 fs/xfs/xfs_log_recover.c   |  3 ++-
 fs/xfs/xfs_trans.c         |  8 +++++---
 fs/xfs/xfs_trans.h         |  9 ++++++++-
 8 files changed, 40 insertions(+), 19 deletions(-)

-- 
2.55.0

