Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C46113B584
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 12:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946680; cv=none; b=jYl2Ryh5saW0KIxOEBpcABQOsl/ncKmqJiLfdum/vfpnbrqjnckW6wECC/cmHE+5h46JNeRhG4G+tEm/GwvO4+IuLcR539NgAiWjFKoSVmaNX79KtSen5P/r6ABe6ktKnN1XAyX7DUHwgmwrKj315acR6BNSbqrhPto5tkif+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946680; c=relaxed/simple;
	bh=1em6IA/N8FphG+qiC6socMil3Ap6ECRCzWjeof+CisU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fRPaerUnpDhbloHuD127LNwNXhqCw3qPelxMi1AfRbTadw3mFNpk2oKcT17LhNlWtBEHdmc/hSINh2FB9X2zGxBBvecilYGRt3Bw0UKx00D9Mpus+CcFuCgJt+wdreqpH9zYM8RSRHsc8xZNAPHLSZd7UGDaSfwI2dq48ZA3nfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LuoQBzjr; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LuoQBzjr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783946679; x=1815482679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1em6IA/N8FphG+qiC6socMil3Ap6ECRCzWjeof+CisU=;
  b=LuoQBzjrLmtcsLR5STH/sJB0E65NIZwK+F6KUWey+oE3a4BsurZKW3Kb
   ArqsTjXnxZXkSTwuEdN7rAcRfUxGytj+mxhEGz6gtl0ZCd3YdUMgP76Ny
   25/LQno9gELB1Vf1hIk5H1eGvSHTtICCP8GExbWwFEXyuAExjpCQP7eRa
   s6u/b9vs4AU9krImdDIWAg9Z56SxKPX5PVpHuXEU4ViaywH5m0s8xu6PR
   /XivGcN5g9A1EjDzrxz7AGlB10SdlDuEX7ABfzGJpzM2RkPkdSjt6NvFr
   jOZ/fSTWdpPhnieM6lWMut/Te2pbvbJvGY3dy6QTpGVzQPEVGc778GoEp
   w==;
X-CSE-ConnectionGUID: lk6kKcCQSYK1G2x1d2urlA==
X-CSE-MsgGUID: 9vfYhOAnRG+9Kei3wbn20Q==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149971524"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2026 20:43:30 +0800
X-CSE-ConnectionGUID: xv9PfYF+RGWCaL9N0cZmhw==
X-CSE-MsgGUID: ROpSEQnlR5yAEIallwF0ZA==
IronPort-SDR: 6a54dd58_H4/oA09M2bNSh6G5GnTBnI9xWQaxHGeCqKjVYTSkP1fzZVC
 UrVBv+0dyQphEgR7wAeWoAvcirmUlMaqyzrHY2Q==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2026 05:43:04 -0700
X-CSE-ConnectionGUID: I4MdODrqTrSTdUuRPhWb6Q==
X-CSE-MsgGUID: Yh4DESV4TWqgFNp91dGjbg==
WDCIronportException: Internal
Received: from wdap-mdygpqeptg.ad.shared (HELO C02G55F6ML85.wdc.com) ([10.224.19.14])
  by uls-op-esai2-o.wdc.com with ESMTP; 13 Jul 2026 05:43:04 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/4] xfs: consolidate metadir creation code
Date: Mon, 13 Jul 2026 14:42:46 +0200
Message-ID: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.50.1
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

Changes to v1:
- Re-based onto xfs/for-next HEAD: f88caa121eac ("xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter")
- Added patch 4/4
- Added Christoph's review

Johannes Thumshirn (4):
  xfs: add xfs_metadir_create_file helper
  xfs: create quota metadir inodes using xfs_metadir_create_file
  xfs: create rtgroup metadir inodes using xfs_metadir_create_file
  xfs: mark internal metadir file creation helpers static

 fs/xfs/libxfs/xfs_dquot_buf.c | 39 ++++++---------------
 fs/xfs/libxfs/xfs_metadir.c   | 64 ++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_metadir.h   |  8 +++--
 fs/xfs/libxfs/xfs_rtgroup.c   | 58 ++++++++++++++-----------------
 4 files changed, 82 insertions(+), 87 deletions(-)

-- 
2.54.0

