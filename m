Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9817C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924680; cv=none; b=mtOkg+H41cCrK6Yjbpp8C4kGxdk3ENMoH/7OAYXYEmiBihBDwZPfX3E+WQYIJGxBOtUTLi2LsYKYTJIbjQyduPQ0Azz0KlkN8DeBN5EstVBTO1mlZRi2Ld7SieLo0F/WlrZxYZbxv+jDdDNpUTSbcm8KYzg0le/A6jT/9ImcJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924680; c=relaxed/simple;
	bh=Jdx5Pof0QpUZzwBzRZIpyPHYnekiR0WJ97ylwZUG3bs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfPD/kBd+v1w+JeEwl3oqorWW4VIZ6gtUoY03W9cHEyF26/oAfIAr2Rypkk0FLHrRr8dyt4H2xkOVXgYqhVaI7xlCWoA45rOCCM+GzzDF98794E0DduZfliJRc+X9YkDADNXb5EYAocENZ467T8aIw6AU4IT0Qhdnkt+VBWcsT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OX7gIO5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OX7gIO5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103FBC2BD10;
	Thu, 20 Jun 2024 23:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924680;
	bh=Jdx5Pof0QpUZzwBzRZIpyPHYnekiR0WJ97ylwZUG3bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OX7gIO5/F4WyzHeBqv8seRPEhuoeBgehmq8Isd/WBdZCuEPXzzrJkDMqe1mOah+bl
	 Qr2LRL93utQYIcHmzBHh2G0XzDE4OQfPk+Cael2o8cLZUv6wpXLeGt7wPwuCt3Er1O
	 hCzGb8EckYN1RIuUHaVDj6ngEzcXWkd0C/KkS12hKwj2Ao8xg3ySyD+6vxMdvDVYfn
	 rj+TIWRiggHjZodx79RNpy/ybzp5MxMrnuoDQAv9HiDdEWB9Jraii6iuJ7GOAN/XAt
	 BtFRhv2ogQpnanTwhcVKiZZWtkcx135eQEQ/11stwXKYzIqTQEKVMoySl/1LRHRrzU
	 WzlGpI1zwkXJQ==
Date: Thu, 20 Jun 2024 16:04:39 -0700
Subject: [PATCH 24/24] xfs: don't use the incore struct xfs_sb for offsets
 into struct xfs_dsb
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418312.3183075.2680579805332636419.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, the XFS_SB_CRC_OFF macro uses the incore superblock struct
(xfs_sb) to compute the address of sb_crc within the ondisk superblock
struct (xfs_dsb).  This is a landmine if we ever change the layout of
the incore superblock (as we're about to do), so redefine the macro
to use xfs_dsb to compute the layout of xfs_dsb.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    9 ++++-----
 fs/xfs/libxfs/xfs_ondisk.h |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 61f51becff4f7..e1bfee0c3b1a8 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -90,8 +90,7 @@ struct xfs_ifork;
 #define XFSLABEL_MAX			12
 
 /*
- * Superblock - in core version.  Must match the ondisk version below.
- * Must be padded to 64 bit alignment.
+ * Superblock - in core version.  Must be padded to 64 bit alignment.
  */
 typedef struct xfs_sb {
 	uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
@@ -178,10 +177,8 @@ typedef struct xfs_sb {
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
-#define XFS_SB_CRC_OFF		offsetof(struct xfs_sb, sb_crc)
-
 /*
- * Superblock - on disk version.  Must match the in core version above.
+ * Superblock - on disk version.
  * Must be padded to 64 bit alignment.
  */
 struct xfs_dsb {
@@ -265,6 +262,8 @@ struct xfs_dsb {
 	/* must be padded to 64 bit alignment */
 };
 
+#define XFS_SB_CRC_OFF		offsetof(struct xfs_dsb, sb_crc)
+
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
  * a feature bit is set when the flag is used.
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index e8cdd77d03fa8..23c133fd36f5b 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -85,6 +85,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
 	 */
 
+	XFS_CHECK_OFFSET(struct xfs_dsb, sb_crc,		224);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);

