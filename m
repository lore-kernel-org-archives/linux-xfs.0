Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D17C33EB00
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931496; cv=none; b=mp9TbkBlmPYOe/8tpHL9wf60tVRia6mj6j6YanLP+SyUvge11nzsHSN+9XjUDZpZywkttdrhlwR9m0khdTObzlulRVZ1yC4U/M5WX10AXoEIK7cj/1Fuq8JvMzK+ulz5E7qh7+wDKUoFLkc/FSrvwwqzv6OZ+B5wz6ySPhFZnXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931496; c=relaxed/simple;
	bh=OOUpqs2qSIujfbdPBleri2xPPsD3OqjFqlopQJcyKyo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OkJsD917gViTIcST3HlXtFIBPXaZfzpDUkhj/lRiTQYpIdimQhcjfWMOs7wrwbgGkb8DkASjIjH6XEgGtF3Qn6lLprjHta6u2KfR8+OWqXkm1aTAti/4xXclLkyiZfrRFv0FJRT2ALF4nR9t+tCm6KEYXzXPainRHKLt3B9VYus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTT2f+om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTT2f+om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132DEC16AAE;
	Tue, 20 Jan 2026 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931496;
	bh=OOUpqs2qSIujfbdPBleri2xPPsD3OqjFqlopQJcyKyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RTT2f+omKBAYZ0clCIn7SedmInpve6XZx1Uj7uKpLwwdjn/xNu2i2pmQCYTCIkGQm
	 22FAAq5pF/IEkd+5jeWoWS8SEG/JshIGpOKzqafmRx5SI1G7FVszwhIeMkp9rcKfU2
	 caM3wOvhCmYqf/LGitssfXzTnzJB+vOUB0iwHJxqeQffcF7BDQoqqTdok0s+jT7VCq
	 Q58SAcCn/bRl+z5gcXSNRrjf5u9crcgWuIQWVBkom2qNrFrqRs7sGIXBbRKZ6C3+4n
	 jJN1xR8+caanclPOYh0QBJmHYxjR0nmtw1GhXJrn8wAzvasgJncm6VJqiC7z9v4luN
	 S7HWXMpSYR0qw==
Date: Tue, 20 Jan 2026 09:51:35 -0800
Subject: [PATCH 4/5] xfs_mdrestore: fix restoration on filesystems with 4k
 sectors
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176893137144.1079372.18089929345976968624.stgit@frogsfrogsfrogs>
In-Reply-To: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index b6e8a6196a795a..90908fe0ff6c2c 100644
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
+	if (len < BBTOB(1) || len > XFS_MAX_SECTORSIZE)
+		fatal("Invalid superblock disk length 0x%x\n",
+				be32_to_cpu(xme.xme_len));
+
 	if (fread(block_buffer, len, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 

