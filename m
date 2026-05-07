Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8F388398;
	Thu,  7 May 2026 08:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778144063; cv=none; b=KVnqiI0Go7h1nx1VVBk9EuIfgCzaNlW8RmhkLgUStz/WM7EC6Utlr9MUFubJb9EJdoD2oWLbD88l0zrBinT3IhSLmEnp5mTyaZOEE51JpvSZiKj8kW7MMWZ87DjWPmSk7Hu2BM3Sag5eO8UFitJVe0kmAd/EiNeA4CQ0V1OG0M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778144063; c=relaxed/simple;
	bh=29KDob7D6wjAqke0cQHbkTiX/VafLuHXAnmywDOdkA0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eCxSgbwR9jfkiQ2dmvpb6e5YiL+uJr81V5mtsbIFPorxp6T9KH2A7IVw4+xBjWhcspky4Ni44vvneai/2i4lDRX484Pkf/1L0sMyPoYLkYDiNpm61zBAkiKOCiB5JHlaq5NAPYE6JZhlWk3KFq3w8wMrHwc04tOmYOahahVQPO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5OPAtZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5OPAtZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B19C2BCB8;
	Thu,  7 May 2026 08:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778144062;
	bh=29KDob7D6wjAqke0cQHbkTiX/VafLuHXAnmywDOdkA0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=F5OPAtZyEPiRob11r6mjsT73FtLF+Xt5ZI1INoILliI2QpRjl9qwD910bJ/hWej2q
	 5qOgMKJI5uvCXGOkJuLCWItwqKcrtktRRLmVz4stu1cquv0qDoRB7+dIuHqSwNmp4Q
	 cVP0dMX/KmylSyBzy4wcl1Fn+ow+iH2FIZmafc8WjoQXE2yolrma2YbtF+yqPUNdro
	 sLdBe20m4uUCakDTNw4U1GgA4YmbJNMRkLV/XGxLLV1aO61bHL1uWOslg1nL1em9sI
	 qMeG+rAxNAWC0PFJaOrFXyX5+ECuG/wOrWTrTwffLtC06zW071t1LsdsGMCfUVvzCk
	 yPfwCqVThIZ0Q==
From: Chuck Lever <cel@kernel.org>
Date: Thu, 07 May 2026 04:53:01 -0400
Subject: [PATCH v14 08/15] xfs: Report case sensitivity in fileattr_get
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-case-sensitivity-v14-8-e62cc8200435@oracle.com>
References: <20260507-case-sensitivity-v14-0-e62cc8200435@oracle.com>
In-Reply-To: <20260507-case-sensitivity-v14-0-e62cc8200435@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
 linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
 almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
 glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
 adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
 trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
 hansg@kernel.org, senozhatsky@chromium.org, 
 Chuck Lever <chuck.lever@oracle.com>, 
 Roland Mainz <roland.mainz@nrubsig.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2743;
 i=chuck.lever@oracle.com; h=from:subject:message-id;
 bh=5XtPWdQD9rNyvcNieFdC0PM+y6dNjGmJfHpo+ZOq7bw=;
 b=owEBbQKS/ZANAwAKATNqszNvZn+XAcsmYgBp/FL2jWmMonLIdv4jv4c9Pilh2ntipFp8Txt7s
 wyRNKYSIL+JAjMEAAEKAB0WIQQosuWwEobfJDzyPv4zarMzb2Z/lwUCafxS9gAKCRAzarMzb2Z/
 l3/SEACRIni+53l30d8QNO1GWehaiAG0xt92TB6hFrKf1Ho8s5nrt0Dl1634Z5/HpawKeZPc3+G
 0/KQRlETPfz14p0UU96eZNjODEFJyCd3tUouJlSVSWJalrQFEz1rAetcRbNX116/cvduq22g0+p
 CTrwYiCnjG8zT9DeEfsDfxYR2459bGcQhVC9ON+/h+KkSJrInBNIEESHMKxhSA8a3IvWcFQCYJs
 dh4Dl3KX4btkKxyavpKevYXn86Kyqy9Jt3OKUlWgghNgnL1RulYQkLq3cXd78PlEo3IKLEMM8Di
 3WjFL+QM/L+QXDQ2O9gn9BhnT/eK9pIP2cco8FZeogLm4nfMF+RcqPhf8uai08MdPoNJ+2L9qsn
 qZ5WISOEs2pl7VhLKLP5UQWQxGoVb9Rll3Az2SlSiF+R4L8USA5zv9Gwvc74eJYwTw/iY8cFV9a
 PhNuoQIEoJd8rVcXqguouQbVyn31HOkbRbmJbrKtH81MnLZKPOnRQirmI4l8BiMGScbuwLvh7GQ
 s1yKAl6DrreCESNhK80DiwnF+k7I5b13pRoQd4976TfZySbl+sbnRfd9AJeK3LgY7aRdYp2VVN6
 NnTxeBBQICpRtqDXi/j44Upj8CYYvyKx6McjG/wXilh4jkJwaNSIEpk3pXVUyVg+FqT8JGrMaDT
 TpLBMFUhE3QfnjA==
X-Developer-Key: i=chuck.lever@oracle.com; a=openpgp;
 fpr=28B2E5B01286DF243CF23EFE336AB3336F667F97

From: Chuck Lever <chuck.lever@oracle.com>

Upper layers such as NFSD need to query whether a filesystem
is case-sensitive. Add FS_XFLAG_CASEFOLD to xfs_ip2xflags()
when the filesystem is formatted with the ASCIICI feature
flag. This serves both FS_IOC_FSGETXATTR (via xfs_fill_fsxattr()
in xfs_fileattr_get()) and XFS_IOC_BULKSTAT (which populates
bs_xflags directly from xfs_ip2xflags()), so bulkstat consumers
and per-inode queries see a consistent view of the filesystem's
case-folding behavior.

FS_XFLAG_CASEFOLD is read-only: FS_XFLAG_RDONLY_MASK ensures
FS_IOC_FSSETXATTR strips it, and xfs_flags2diflags() has no
clause for CASEFOLD so the on-disk diflags are unaffected.
The legacy FS_IOC_SETFLAGS path in xfs_fileattr_set() also
allows FS_CASEFOLD_FL through its allowlist on ASCIICI
filesystems so that a chattr read-modify-write cycle does
not fail with EOPNOTSUPP.

XFS always preserves case. XFS is case-sensitive by default,
but supports ASCII case-insensitive lookups when formatted
with the ASCIICI feature flag.

Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  2 ++
 fs/xfs/xfs_ioctl.c             | 20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 551fa51befb6..82be54b6f8d3 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -130,6 +130,8 @@ xfs_ip2xflags(
 
 	if (xfs_inode_has_attr_fork(ip))
 		flags |= FS_XFLAG_HASATTR;
+	if (xfs_has_asciici(ip->i_mount))
+		flags |= FS_XFLAG_CASEFOLD;
 	return flags;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ed9b4846c05f..f8216f74679f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -755,9 +755,23 @@ xfs_fileattr_set(
 	trace_xfs_ioctl_setattr(ip);
 
 	if (!fa->fsx_valid) {
-		if (fa->flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
-				  FS_NOATIME_FL | FS_NODUMP_FL |
-				  FS_SYNC_FL | FS_DAX_FL | FS_PROJINHERIT_FL))
+		unsigned int allowed = FS_IMMUTABLE_FL | FS_APPEND_FL |
+				       FS_NOATIME_FL | FS_NODUMP_FL |
+				       FS_SYNC_FL | FS_DAX_FL |
+				       FS_PROJINHERIT_FL;
+
+		/*
+		 * FS_CASEFOLD_FL reflects the ASCIICI superblock feature,
+		 * a read-only property. Accept it as a no-op so chattr's
+		 * RMW round-trip succeeds; reject any attempt to enable
+		 * it on a non-ASCIICI filesystem. xfs_flags2diflags()
+		 * has no clause for CASEFOLD, so the bit is dropped from
+		 * the on-disk diflags regardless.
+		 */
+		if (xfs_has_asciici(mp))
+			allowed |= FS_CASEFOLD_FL;
+
+		if (fa->flags & ~allowed)
 			return -EOPNOTSUPP;
 	}
 

-- 
2.53.0

