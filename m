Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F561DF26E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497248; cv=none; b=nKg8j48zaW7mlRMPQ9wYbtbpb3IAkrIUDUcCkLtO7i2oolG6pKAmDw3zN3KuO3PjjxZCy7kAniCICQ1Ha7Y7a+M8uX2OhvIR5JYTKRVgqcSBzETqWFQem2niGVbnCJ2BIBrhBOym1P8WbuN7nft8yNI0pKddIZiq8JAA/G0kMoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497248; c=relaxed/simple;
	bh=UbAxQ6J481srAFOAY51spXpEJClMnnztsJGzqNkBENw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J4uT21j/KGBwm4OWzOa2Nvhymfo6N7SDpBKjrXeBeqnCc3uIcxGvAwX0rUz2M4DGONLpoSSpNJE0a8z1obhZ5SIYF6oxECTFYMn2Yz1FDkIYYZLJilvMpB5Vj+zkuPuhRTYHMuGrulE518mwWv5zFKiJJnC71j58knczzsbjAOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRyp6SF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRyp6SF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9E1C19423;
	Tue,  3 Mar 2026 00:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497247;
	bh=UbAxQ6J481srAFOAY51spXpEJClMnnztsJGzqNkBENw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hRyp6SF4aYE5xCHpu5N4nUaZ7m3AKWABHlE74RMYKbK+qUhcTRO3CKPIidfLZKT5e
	 iHZtRTzMctZ//j17jefr5BMZOO61uW5mG9nYkMYxJAfcbtSDwFowZJ1X/tnnxtPZ9L
	 BCS2yKlfooF5NIXdvdpdKTp27sI211/js2KRlqaG0Wi0KqLzzgIdD32E4GMkSxnZ23
	 5IJ7W+CX1+Ip12SymQaUXOBrz8ntNsAVcB31P4g/MHbM+OpEyJPDePuodHv0IK03cY
	 VCcqoDwOnounlihNOIj15nxq2NBpmUm+sP5aWbp2hPPRZVdx7ofF1Nf29wqqIgp1G2
	 LBG9sUAqQxIqg==
Date: Mon, 02 Mar 2026 16:20:47 -0800
Subject: [PATCH 33/36] xfs: remove metafile inodes from the active inode stat
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638385.457970.8057539261074430844.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 47553dd60b1da88df2354f841a4f71dd4de6478a

The active inode (or active vnode until recently) stat can get much larger
than expected on file systems with a lot of metafile inodes like zoned
file systems on SMR hard disks with 10.000s of rtg rmap inodes.

Remove all metafile inodes from the active counter to make it more useful
to track actual workloads and add a separate counter for active metafile
inodes.

This fixes xfs/177 on SMR hard drives.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_platform.h  |    2 +-
 libxfs/xfs_inode_buf.c |    4 ++++
 libxfs/xfs_metafile.c  |    5 +++++
 3 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index c2ad300169c6ec..5cddfbb82cc88c 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -177,7 +177,7 @@ extern char    *progname;
 #define XFS_ILOCK_SHARED		0
 #define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
-#define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
+#define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_TEST_ERROR(a,b)		(false)
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 0802bc376073d8..f56aef0dbb3db9 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -265,6 +265,10 @@ xfs_inode_from_disk(
 	}
 	if (xfs_is_reflink_inode(ip))
 		xfs_ifork_init_cow(ip);
+	if (xfs_is_metadir_inode(ip)) {
+		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
+		XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
+	}
 	return 0;
 
 out_destroy_data_fork:
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 8d98989349d086..bab5d7e29ae9a7 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -59,6 +59,9 @@ xfs_metafile_set_iflag(
 	ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 	ip->i_metatype = metafile_type;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
+	XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
 }
 
 /* Clear the metadata directory inode flag. */
@@ -72,6 +75,8 @@ xfs_metafile_clear_iflag(
 
 	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	XFS_STATS_INC(ip->i_mount, xs_inodes_active);
+	XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
 }
 
 /*

