Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E7D3F1040;
	Tue,  6 Oct 2026 08:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277007; cv=none; b=hbxWZz3BqAoC6reC+ZvwFH3LozCn8y3jeTLz76oQ2VchexWsOYAplLVg58TA8HreLvaPbjoFqSSHtyex1WUelzYpGAfnLnQkCpzVZW8bLxGispvPi710z2awomsNzmx/APn8XrfYXE3EN9NMj6Jmp3x6ravugtlso8WmDkahMts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277007; c=relaxed/simple;
	bh=Jy0alT68znEJv/BOXPlYbiFmMAnCn6jWlYRcAddDnuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6nRYDlgsHXB+mm1VQiox4PcfAsvmvLUNbDA5VBunZXV9saOozazh6ykNbbg+rv05MEUSJrjLu3fBv1DulXmBh7DCw7Mx9kn3QzgN9kDuHy4W7Y7QV+fce9nXBNB5Ggjiqmn1Dxe/w19TrJWho6V0swgILLGz2Jd1Dijwl/HBcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+G+FRX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+G+FRX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC541F000FF;
	Tue,  6 Oct 2026 08:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277006;
	bh=g3NivwYtKychBBE/sjOAVqN6lB06fYWUGYDB0w33HwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+G+FRX5Sv0gykhSgkc8ayhUjpBkjBQeuz/3F4oupNm6H+8k3EZQSulQupdV2nqyS
	 EU3qzWciagLGbbTYuVUJ/oe8dljDus0Pf/9VeBzrydMgGJ29aY78Xm6MNE443y5rXj
	 ObtrElfMzN+ZtE2+v3wh9FNn2/ZwuIrjhgDJe9OTeveGwp59xKx/NP0mYXEb96D57E
	 WdqKmeRH/+LIikAvTPaV6xkz6ui1sDUJtKngQIHAuoKJQSWKU6HGtlrwD/+f1/Dsbw
	 TGhrtvjzZbhq4rA37tUC1zb7TOD20ZqVJKPW6z7pACN35nxX7cHHjiWeP6aV1vJasL
	 R8cdjwju37lvQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 16/21] fstests: introduce _require_metadata_uuid() helper
Date: Tue,  6 Oct 2026 16:55:42 +0800
Message-ID: <2d4f4228bd376e234425fd2b23692820593486a4.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add _require_metadata_uuid() to common/rc to check for the required
userspace tools (xfs_admin and btrfstune) on XFS and Btrfs, and verify
kernel metadata_uuid feature support on Btrfs before testing filesystem
UUID changes.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/common/rc b/common/rc
index 4ae3c74a52cf..bc0522dbcdd3 100644
--- a/common/rc
+++ b/common/rc
@@ -6527,6 +6527,24 @@ _require_unique_f_fsid()
 	esac
 }
 
+_require_metadata_uuid()
+{
+	case $FSTYP in
+	xfs)
+		# The xfs_admin utility is required to modify the filesystem UUID.
+		# Kernel support for metadata_uuid has been present since 4.16, so
+		# it is assumed to be available.
+		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+		;;
+	btrfs)
+		_require_btrfs_fs_feature "metadata_uuid"
+		_require_command "$BTRFS_TUNE_PROG" "btrfstune"
+		;;
+	*)
+		_notrun "Require filesystem with metadata_uuid feature"
+		;;
+	esac
+}
 
 # Computes a percentage of the available space in a filesystem and
 # returns that quantity in MB. The percentage must not contain a percent
-- 
2.43.0

