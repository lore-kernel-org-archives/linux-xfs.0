Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6210CCA4B
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758890795; cv=none; b=BvNX+Qo6C7Mwh81CKDD3DBXMKk9LDUrGE7t2YvdsoOP4zutaAqtRf2WT5BW3GTR8Zi/lxLA3h3mMWnKXjfFV0ZhoYU0hNAhYDlhq9fXASmyTDOo8JDxS6Kk3+2tiL/WF+ZFQX797hbFz/666edt3E8y3VixI9qZ2LRm2XAYQ2Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758890795; c=relaxed/simple;
	bh=GOD96euFbaRMVOb/hya+/7gGysF7JttbDh1zPTDJEDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q6miHPEwAHJAknNivdly44CoWFuS69atqlxUT1SDkhj83BCNQHjPeZhpRKqg+RIntNpGzfKRlN4KwPbDQamCRwwPoHU3rNWF6pfC9d0wxnyNkantddHaO076bZczrrGCSMG6GRp6j9af/cSkriZF/xlwxlp9tB8t74joq2OEbVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id A4B2C180F2D8;
	Fri, 26 Sep 2025 14:39:13 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id UWx/JXGJ1mi68xQAKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 26 Sep 2025 14:39:13 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: aalbersh@redhat.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH] mkfs.xfs fix sunit size on 512e and 4kN disks.
Date: Fri, 26 Sep 2025 14:38:30 +0200
Message-ID: <20250926123829.2101207-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
and so we set lsu to blocksize. But we do not check the the size if
lsunit can be bigger to fit the disk geometry.

Before:
modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000; \
lsblk -tQ 'VENDOR == "XFS_TEST"'; \
mkfs.xfs -f $(lsblk -Q 'VENDOR == "XFS_TEST"' -no path) 2>/dev/null; sleep 1; \
modprobe -r scsi_debug
NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sda          0 262144 262144    4096     512    0 bfq       256 512    0B
meta-data=/dev/sda               isize=512    agcount=32, agsize=8192000 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0
data     =                       bsize=4096   blocks=262144000, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=128000, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

After:
modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000; \
lsblk -tQ 'VENDOR == "XFS_TEST"'; \
mkfs.xfs -f $(lsblk -Q 'VENDOR == "XFS_TEST"' -no path) 2>/dev/null; sleep 1; \
modprobe -r scsi_debug
NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sda          0 262144 262144    4096     512    0 bfq       256 512    0B
meta-data=/dev/sda               isize=512    agcount=32, agsize=8192000 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=262144000, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=128000, version=2
         =                       sectsz=4096  sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 mkfs/xfs_mkfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8cd4ccd7..05268cd9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3643,6 +3643,10 @@ check_lsunit:
 		lsu = getnum(cli->lsu, &lopts, L_SU);
 	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
 		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
+		if (cfg->dsunit){
+			cfg->lsunit = cfg->dsunit;
+			lsu = 0;
+		}
 
 	if (lsu) {
 		/* verify if lsu is a multiple block size */
-- 
2.51.0

