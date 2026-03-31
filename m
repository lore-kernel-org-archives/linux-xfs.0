Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4B745BD60;
	Tue, 31 Mar 2026 21:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992566; cv=none; b=AzvLr7N/SmbwF01PlW4wjuY6JibZVhwqp+XvT0ZNJEgNhbtPAyyDM6pEZfjU0B2mZhD08z2FPrCujzccnnTLXYjhMQ25JSdHwPvnC10auYo4Mn6AHwRVQZhevCTVmmdW54YOmBGN7GelhwdWECDGry50ehAZfCiGWqHn7aLXJe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992566; c=relaxed/simple;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDU0I6rvSwUIEZyUiGI2kE+BhwIxwZjj1ppmgS1jbeZ077y85ti8ntsMlhTty24hCmpioYnhiGiLSOMvz2CLmOuioZLR1BgDYJ4hulZwDlvRcAK8O0cfVsb+EGZOWPeqafwO22feGmVZsADRwPB7U8UIToa/1Dk/GsyArfHnYz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKh/DVRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKh/DVRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF6CC2BC9E;
	Tue, 31 Mar 2026 21:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992566;
	bh=Aq0ZUSqSUefcts6LfugDkZmOSMW+4m4ueZMlzDmeXr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKh/DVRt7gQNcfunpyXMgXUvNvj+xj/Hk5mlvNtq98JuEqFpwrVjSQuoqGCFbhTD1
	 vTT3xaW9CCctuk0K1OdWOrlIqH41qQHT7rvZZsvC1AvrX8eOQXkJefvTnaK7m+Z+o+
	 RvDhmFypNL7k55cwRn1a1IwJZD6uagUVac4VXhtCNXIDIvh5txCsRPdNX7XDuAL/j8
	 N/8NXEKd2GiVYEvPzHlt5uTAUkJ+TYZletsUAF8txIIL04Ypih7Umso1OCJ+AjH2vL
	 gmWXZWISTN5bTeKa3VyZY7FVEuSBl84sKV+JBmqS4c4ey4UCkODJflIQDGV1aF2xQU
	 hh6lnwKWs/7Iw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v6 17/22] xfs: add fs-verity ioctls
Date: Tue, 31 Mar 2026 23:28:18 +0200
Message-ID: <20260331212827.2631020-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

[djwong: remove unnecessary casting]

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index facffdc8dca8..e633d56cad00 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -46,6 +46,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1426,6 +1427,19 @@ xfs_file_ioctl(
 	case XFS_IOC_VERIFY_MEDIA:
 		return xfs_ioc_verify_media(filp, arg);
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, arg);
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, arg);
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.51.2

