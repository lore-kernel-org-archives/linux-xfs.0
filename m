Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393F0621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710505; cv=none; b=BOOSJnl2Ap/hFONa4Kgc21pcxTcq4dGUCE2Icgv8HaCowU+X7ylELj50m2wNaKGgVHxDxSEGd/8pTiQySKa8yUeCw3yaeS6IOpoKJ5n8RHgrVpnNrbdKJ/lAUntQg/dmC2L9+jRTVAJhfFTi2b/IEvnYQMlKPlJVXCMSqUxYMyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710505; c=relaxed/simple;
	bh=0kAtjWm7heyS4Y6iSVcGaMLgjbtGTpobvd2kXX7eiFU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S792MUKOpPq3tQtH0cG22XC0AN5mWPcFcahBRYi8eIDuKnK3oUWQ8LOwO2FFUHiPNqiExpyaCe1hAl76AwDIiDvr/Ld+2HI1PH2TOwEQg5D4idfncqmJNvBYHlg/JETkHvw/0z9o9VgUZcBgfWKcnbpn7bsxtvVLrVCEWwlZ6o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvTslu6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvTslu6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE3FC433C7;
	Wed, 10 Apr 2024 00:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710505;
	bh=0kAtjWm7heyS4Y6iSVcGaMLgjbtGTpobvd2kXX7eiFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZvTslu6So8B4tiofa8tL8r81whxeMcRew3PKyjvnKX9aMXXqi3C/aO0dvPMlNBaKk
	 Q+UUKCD7YjuGGDsWjB/7fcdwJBpfzSJ/yfbQqhyeJPBFKlQOrSqN11itARP69rEb69
	 Jh7eOikaUHOJTaCoeldfs80UJRKrOtkOI1/SGaUXZgYX5hF1+DIhze6julg2xfGbKK
	 Yoy5nA+yekE2vBX43PTan/e1HMk2IfFrMgTuNqAKbhwy43nWPQGnvET7/s0Vfi7iIT
	 I8rox9YxityA4nCF0SFfy43RgzHKhIbwkowv8QpvKqG9xKFQKgrBfsIO/fEnkNTFxz
	 isaV05OEIwagg==
Date: Tue, 09 Apr 2024 17:55:04 -0700
Subject: [PATCH 06/32] xfs: define parent pointer ondisk extended attribute
 format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969657.3631889.9403759718168544689.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={dirent name}
        value={parent inumber, parent inode generation}
        hash=xfs_dir2_hashname(dirent name) ^ (parent_inumber)

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the name-value lookup mode in the extended attribute code to
match parent pointers using both the xattr name and value, we can
identify the exact parent pointer EA we need to modify/remove in
rename/unlink operations without searching the entire EA space.

By storing the dirent name, we have enough information to be able to
validate and reconstruct damaged directory trees.  Earlier iterations of
this patchset encoded the directory offset in the parent pointer key,
but this format required repair to keep that in sync across directory
rebuilds, which is unnecessary complexity.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |   13 +++++++++++++
 fs/xfs/libxfs/xfs_ondisk.h    |    1 +
 2 files changed, 14 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 0c80f7ab9475a..1395ad1937c53 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -890,4 +890,17 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * The xattr name contains the dirent name.
+ * The xattr value encodes the parent inode number and generation to ease
+ * opening parents by handle.
+ * The xattr hashval is xfs_dir2_namehash() ^ p_ino
+ */
+struct xfs_parent_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+} __packed;
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 81885a6a028ed..25952ef584eee 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -119,6 +119,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);

