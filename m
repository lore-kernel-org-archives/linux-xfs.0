Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641EC19D081
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765296969; cv=none; b=mkdJGX6A7219dEHc2i51II/lH8Ux2Ztjc/l6MiwStArPXDN2vqkbRn79MbpDR1mmpIqw4vUAUJEttPa3bcRXB+O53n3cNKyzbc7uWJetPY90J6IWxpSQ2XV74pq0I/Pzx07mIUk+/yj4b2W5xncjW04/0CP1Gxvlhy7B248/uTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765296969; c=relaxed/simple;
	bh=PSnRYZHRmyd4SIpLHXaaoG9MpSJ9s3LhS8Eqr9fHgSY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2lmjF8ZXmgGz7RVrDXC5HTyr7r32C/VXFsSkSreSCeS6q93bot6JmAafUcaV4qSIxCuP8xGp2aEG+o0XXYLXkg1xKL50G7K33Z1kFe5XW+1gG90FGE49FmwOQv5oO3l0Ei3qZfY5A2gHzG2gmSUmBG5g86bCL0MhJUdRrasmec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mg7b99oH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mg7b99oH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1729C4CEF5;
	Tue,  9 Dec 2025 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765296968;
	bh=PSnRYZHRmyd4SIpLHXaaoG9MpSJ9s3LhS8Eqr9fHgSY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Mg7b99oHFtIC5BOy4IXPAvkWdD2gSM1zWWo9esIu7Lt+rbTO1My4jfGSW1FV1ImFH
	 u4S9Qwu0XWmsCLEaZh6cwJIt2pr3dzW9M6gFl/RhcVVyM3lvf/02yYBE3R3J/Lij8A
	 G/ZA3cuuaqj481xMmzk2BrapAtaf0KjPlxFXxYie1b/0Kihkq2SuJ5vwKX5SpZouAl
	 pYPfG7EK4xLIgu0J0CfIgq5OVvHRUaoJIMzdpBK1slWBdhyJzzZ5SvumVfSIfwTuw6
	 Bdmk/FkbzYmVlkt8wvznbKEGGI3OKwgxNsK9JANeB/55+IwcaBXxWNHzqsakWGUgUH
	 MO2KMBsQqhB6w==
Date: Tue, 09 Dec 2025 08:16:08 -0800
Subject: [PATCH 1/2] mkfs: enable new features by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>
In-Reply-To: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Since the LTS is coming up, enable parent pointers and exchange-range by
default for all users.  Also fix up an out of date comment.

I created a really stupid benchmarking script that does:

#!/bin/bash

# pptr overhead benchmark

umount /opt /mnt
rmmod xfs
for i in 1 0; do
	umount /opt
	mkfs.xfs -f /dev/sdb -n parent=$i | grep -i parent=
	mount /dev/sdb /opt
	mkdir -p /opt/foo
	for ((i=0;i<5;i++)); do
		time fsstress -n 100000 -p 4 -z -f creat=1 -d /opt/foo -s 1
	done
done

This is the result of creating an enormous number of empty files in a
single directory:

# ./dumb.sh
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
real    0m18.807s
user    0m2.169s
sys     0m54.013s

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
real    0m20.654s
user    0m2.374s
sys     1m4.441s

As you can see, there's a 10% increase in runtime here.  If I make the
workload a bit more representative by changing the -f argument to
include a directory tree workout:

-f creat=1,mkdir=1,mknod=1,rmdir=1,unlink=1,link=1,rename=1


naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
real    0m12.742s
user    0m28.074s
sys     0m10.839s

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
real    0m12.782s
user    0m28.892s
sys     0m8.897s

Almost no difference here.  If I then actually write to the regular
files by adding:

-f write=1

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
real    0m16.668s
user    0m21.709s
sys     0m15.425s

naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
real    0m15.562s
user    0m21.740s
sys     0m12.927s

So that's about a 2% difference.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8f5a6fa5676453..8db51217016eb0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1044,7 +1044,7 @@ struct sb_feat_args {
 	bool	inode_align;		/* XFS_SB_VERSION_ALIGNBIT */
 	bool	nci;			/* XFS_SB_VERSION_BORGBIT */
 	bool	lazy_sb_counters;	/* XFS_SB_VERSION2_LAZYSBCOUNTBIT */
-	bool	parent_pointers;	/* XFS_SB_VERSION2_PARENTBIT */
+	bool	parent_pointers;	/* XFS_SB_FEAT_INCOMPAT_PARENT */
 	bool	projid32bit;		/* XFS_SB_VERSION2_PROJID32BIT */
 	bool	crcs_enabled;		/* XFS_SB_VERSION2_CRCBIT */
 	bool	dirftype;		/* XFS_SB_VERSION2_FTYPE */
@@ -5984,11 +5984,12 @@ main(
 			.rmapbt = true,
 			.reflink = true,
 			.inobtcnt = true,
-			.parent_pointers = false,
+			.parent_pointers = true,
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,
 			.nrext64 = true,
+			.exchrange = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.

