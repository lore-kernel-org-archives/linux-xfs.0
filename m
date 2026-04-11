Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FCB1DC985;
	Sat, 11 Apr 2026 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775917467; cv=none; b=Hzm6LEFVyaizMGgSCge3kXBXmcR/FuYD3YRK+pNnSAjOdTyMM5p92kuMYzCmsKI6EMB69N4quSbKwBmuKS2CGSjTXu/LNcKNqBNlTMLEkVLP4rAJW+wuvsWkqPb1TPT/OPE73I/HS/g7Tu1nXPArIO6hesIlXp6njppL1mATc+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775917467; c=relaxed/simple;
	bh=mZxUkyqTS2AHOwOENf67tsOZjEQY6usYjM924pZ+nK4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aWsrHaVuWNZXX6SurvkCmrMSolEfKHoPHcTplA5QuoAyGmbpQdin2UdFAvYEZX0e5IQ33pE0cXfPIimqERIJUzEaPEn9sKMhPDaI6m0vzOQL9Y4OdFWmhQ41PmX7++oxT1qXbJpricg7rdjNhSCzzfeSy4hrXlMhlltwweZ7NjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=KYzH8bWt; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="KYzH8bWt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775917466; x=1807453466;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bA6mOO+C9omfi1ZOvzz75mifvmcOyCxtnpzyLMzKZlU=;
  b=KYzH8bWt3cbRpiZtTFu4A4MAmKrTb1Gh4kDbMITL84585Coo9C2apJxe
   xHGEQdANgCXs3aDigIrm/YsAUy574QueAphkxyWq+1xVt24pUIeGLPcVc
   BhinGUqyTHJn1SYkVoJIYu8knRcrkPnWxmEG0NxhL0VDTwUSYABoFYZRV
   UDIYcpaoRT5el8SeO3wcv+wPH/N+86ReG8QFzQlnHoj6AtETlCcgDpmWC
   5foJeDacwy9M311woFZUaDR3ba6zTU66iU84cbrB1pxUwQaZJdV4OGCjY
   E+HiDmKizEUC5u+oB/V/pbkYjpA/Lkjgqcqc8SVI0lnp9fKdaH2zdggEF
   A==;
X-CSE-ConnectionGUID: QwG5EdBATC2L3i7DYN/3yw==
X-CSE-MsgGUID: Lrqm7Uv7QruMzRmIzVrO3A==
X-IronPort-AV: E=Sophos;i="6.23,173,1770595200"; 
   d="scan'208";a="17091855"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 14:24:23 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:23662]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.68:2525] with esmtp (Farcaster)
 id 8cda6007-46c3-4a79-8909-9a141f326195; Sat, 11 Apr 2026 14:24:23 +0000 (UTC)
X-Farcaster-Flow-ID: 8cda6007-46c3-4a79-8909-9a141f326195
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:22 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.32) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:21 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH v3 0/3] xfs: clean up directory data block header padding
Date: Sat, 11 Apr 2026 15:24:12 +0100
Message-ID: <20260411142411.72194-5-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pad field in xfs_dir3_data_hdr exists for 64-bit alignment and 
should always be zero. Old kernels zeroed only the xfs_dir3_blk_hdr 
portion of the header during initialization and initialized the 
remaining header contents separately.

This series takes a broader approach as suggested by Dave Chinner:
zero the entire header region unconditionally, self-heal stale non-zero
padding during writes, and report remaining non-zero padding in scrub.

Patch 1 zeroes the entire directory data block header region in
xfs_dir3_data_init instead of just the xfs_dir3_blk_hdr.
Patch 2 zeroes the pad field in xfs_dir3_data_write_verify so that
existing directories self-heal when modified.
Patch 3 checks the pad field in scrub and adds xchk_fblock_set_preen.

Changes in v3:
- Zero the entire header region (geo->data_entry_offset bytes)
  unconditionally instead of changing the memset type to
  xfs_dir3_data_hdr.
- Remove the now-unnecessary bestfree manual zeroing loop.
- Zero pad in xfs_dir3_data_write_verify for runtime self-healing
  of old metadata.
- Drop unnecessary cpu_to_be32() on comparison to zero.
- Split into a 3-patch series for easier review.
- Link to v2: https://lore.kernel.org/all/20260408172749.99216-2-ytohnuki@amazon.com/#t

Changes in v2:
- Fix xfs_dir3_data_init to zero the full xfs_dir3_data_hdr instead of
  just xfs_dir3_blk_hdr so that the pad field is covered by the memset.
- Use xchk_fblock_set_preen instead of xchk_fblock_set_corrupt since
  old kernels may have written non-zero padding without issues.
- Add xchk_fblock_set_preen helper function.
- Link to v1: https://lore.kernel.org/all/20260404125032.37693-2-ytohnuki@amazon.com/#t

Yuto Ohnuki (3):
  xfs: zero entire directory data block header region at init
  xfs: zero directory data block padding on write verification
  xfs: check directory data block header padding in scrub

 fs/xfs/libxfs/xfs_dir2_data.c | 18 +++++++++++-------
 fs/xfs/scrub/common.c         | 11 +++++++++++
 fs/xfs/scrub/common.h         |  2 ++
 fs/xfs/scrub/dir.c            |  7 ++++++-
 4 files changed, 30 insertions(+), 8 deletions(-)

-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



