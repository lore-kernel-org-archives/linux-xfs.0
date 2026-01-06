Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF1D28DB49
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 18:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725308; cv=none; b=X+MrU/Rh3u9IzWNHXQyNzWsuqFQ9NygWH8SFEcZksvu/Sw7+1JdQxWn29voisqHGIDjJgSSCf+0oNXaksDXbhk5bXuV+MvNy5HTA271nbosLBY2VLgxSXU/DkbbvItNvbYrRjeU7a/szNFZcB9LspbikI4jtkiDnvezePfE03/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725308; c=relaxed/simple;
	bh=YjgAONlx2wA6mhrkkMSx8p4+ivKOOLPEElRd3OoQyv4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PPLsbN4pZDLTrdPN0+X2ba2bn2DrBzub+HJqbbFfzVonnRvtKMB3A5x+rn8/4n8zCDSURIFwgJw8dS50XdqBf3mHjsrpbZCVPO1+Kk5TLeyqf/NxPQfyvRSkGDjBcK9Mfr7B+Gd3/17BvgfCarM97AMr2j0Zh8lzccIXd6fhiro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjqYCSCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjqYCSCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB202C116C6;
	Tue,  6 Jan 2026 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767725307;
	bh=YjgAONlx2wA6mhrkkMSx8p4+ivKOOLPEElRd3OoQyv4=;
	h=Date:From:To:Cc:Subject:From;
	b=gjqYCSCKxcWHFXbf16q9whULjVQINIEXHM14v8zEmvdgXr4n6brNYioffFgYABCC5
	 Ghd8eSycXTGD82Hxph6cqv8LdzB2Fq1sVyRo84zQrJrUYnWF8HZu224qhiq/DSnoIG
	 krtLCbh2VPEyxQ6nmnCbszrDfD4RXSFkD/ubtIy0YP4TRSvUYDnnqIoLkSwrVyYA0h
	 ZXokRtjfj88t05BulyA9FFpCncn7La1fm4xHFl2C+XMCmV6Dt1HRhY+LrRVgamBEs0
	 f4SXgJ7x4yh95mo0ENWvzDnyOMKmN0bY8RHL5LCY7Y7PREZBsVjxYELPgGG+7jeiFs
	 RCRhWgWkMSi+g==
Date: Tue, 6 Jan 2026 10:48:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_mdrestore: fix restoration on filesystems with 4k sectors
Message-ID: <20260106184827.GI191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Running xfs/129 on a disk with 4k LBAs produces the following failure:

 --- /run/fstests/bin/tests/xfs/129.out	2025-07-15 14:41:40.210489431 -0700
 +++ /run/fstests/logs/xfs/129.out.bad	2026-01-05 21:43:08.814485633 -0800
 @@ -2,3 +2,8 @@ QA output created by 129
  Create the original file blocks
  Reflink every other block
  Create metadump file, restore it and check restored fs
 +xfs_mdrestore: Invalid superblock disk address/length
 +mount: /opt: can't read superblock on /dev/loop0.
 +       dmesg(1) may have more information after failed mount system call.
 +mount /dev/loop0 /opt failed
 +(see /run/fstests/logs/xfs/129.full for details)

This is a failure to restore a v2 metadump to /dev/loop0.  Looking at
the metadump itself, the first xfs_meta_extent contains:

{
	.xme_addr = 0,
	.xme_len = 8,
}

Hrm.  This is the primary superblock on the data device, with a length
of 8x512B = 4K.  The original filesystem has this geometry:

# xfs_info /dev/sda4
meta-data=/dev/sda4              isize=512    agcount=4, agsize=2183680 blks
         =                       sectsz=4096  attr=2, projid32bit=1

In other words, a sector size of 4k because the device's LBA size is 4k.
Regrettably, the metadump validation in mdrestore assumes that the
primary superblock is only 512 bytes long, which is not correct for this
scenario.

Fix this by allowing an xme_len value of up to the maximum sector size
for xfs, which is 32k.  Also remove a redundant and confusing mask check
for the xme_addr.

Note that this error was masked (at least on little-endian platforms
that most of us test on) until recent commit 98f05de13e7815 ("mdrestore:
fix restore_v2() superblock length check") which is why I didn't spot it
earlier.

Cc: <linux-xfs@vger.kernel.org> # v6.6.0
Fixes: fa9f484b79123c ("mdrestore: Define mdrestore ops for v2 format")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index b6e8a6196a795a..525fa68e6d23a6 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -437,13 +437,21 @@ restore_v2(
 	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
-	if (xme.xme_addr != 0 || be32_to_cpu(xme.xme_len) != 1 ||
-	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
-			XME_ADDR_DATA_DEVICE)
-		fatal("Invalid superblock disk address/length\n");
+	/*
+	 * The first block must be the primary super, which is at the start of
+	 * the data device, which is device 0.
+	 */
+	if (xme.xme_addr != 0)
+		fatal("Invalid superblock disk address 0x%llx\n",
+				be64_to_cpu(xme.xme_addr));
 
 	len = BBTOB(be32_to_cpu(xme.xme_len));
 
+	/* The primary superblock is always a single filesystem sector. */
+	if (len < BBTOB(1) || len > 1U << XFS_MAX_SECTORSIZE_LOG)
+		fatal("Invalid superblock disk length 0x%x\n",
+				be32_to_cpu(xme.xme_len));
+
 	if (fread(block_buffer, len, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
