Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B3918C31
	for <linux-xfs@vger.kernel.org>; Wed,  6 Aug 2025 04:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754455043; cv=none; b=J8gc1Tk26gVAMY7WaYvsWtRKvCRHJKxrXN2OnXREbuNepdHGb4pdmKAVoMO0k6cxHgho+DWUNjiP5zHzlQLh4ryYjDKCtvK2nV1sJJ5tmpww/CzA/1L+VolZQjflO1tCWZY33jZSx/Uj1nTdZY4rAZO/pWnr9K8L2KMCnMeKqcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754455043; c=relaxed/simple;
	bh=YO6nyX3YkPx9OocO80wlvkwC7lc3I0zk61TNQ11ReiM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N7UuJl9psCf6sQdbsdGrtT1P1a8b/EPpugu+BuC/xlotaZzhGv1E61RMVebOasgnwOA2ZqSoDlUnc3tbZR59hyQbplGBpkw/ROvpnWqwVZ0JqT8ZJcjZTA3DMEOE7fsnA8tQB0odwD9a0zzafmehjhgPqhhviPZFfTgfjMvMWoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i993ZhEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i993ZhEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528EAC4CEE7;
	Wed,  6 Aug 2025 04:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754455042;
	bh=YO6nyX3YkPx9OocO80wlvkwC7lc3I0zk61TNQ11ReiM=;
	h=From:To:Cc:Subject:Date:From;
	b=i993ZhEjRHwsVq/UXO3urJe4iaMwwA9XiaXWmlsqX7G6CqzRPm/eISkByiQq0slwm
	 3JyXTDUbt6rIwFRfUaarPIKyISxyGuLjrhaL9VKa9GydgKtDhEgSvgzx5SNvKm38Zf
	 Ih1SvnP64gG53aHTtXf1rE13S/7QCV9uAEZQ/jQxTjYIUObhOBeWfPO85bjxCT3mu/
	 x+Gh4cJ5EExL08y8rgxK3YxlQVPhFY6Mup+zZmxfhZtVbO8ccB/8FzSj8evePOkbzv
	 uy9ZxRbtPWcU1HhI9PwkInYKG8Q/36ihDkLXYY20yOZmq/oG8HUxRdEPd9LuAjnUZJ
	 obMHWlKQuqc0A==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
Date: Wed,  6 Aug 2025 13:34:49 +0900
Message-ID: <20250806043449.728373-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enabling XFS realtime subvolume (XFS_RT) is mandatory to support zoned
block devices. If CONFIG_BLK_DEV_ZONED is enabled, automatically select
CONFIG_XFS_RT to allow users to format zoned block devices using XFS.

Also improve the description of the XFS_RT configuration option to
document that it is reuired for zoned block devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ae0ca6858496..c77118e96b82 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -5,6 +5,7 @@ config XFS_FS
 	select EXPORTFS
 	select CRC32
 	select FS_IOMAP
+	select XFS_RT if BLK_DEV_ZONED
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
@@ -116,6 +117,15 @@ config XFS_RT
 	  from all other requests, and this can be done quite transparently
 	  to applications via the inherit-realtime directory inode flag.
 
+	  This option is mandatory to support zoned block devices. For these
+	  devices, the realtime subvolume must be backed by a zoned block
+	  device and a regular block device used as the main device (for
+	  metadata). If the zoned block device is a host-managed SMR hard-disk
+	  containing conventional zones at the beginning of its address space,
+	  XFS will use the disk conventional zones as the main device and the
+	  remaining sequential write required zones as the backing storage for
+	  the realtime subvolume.
+
 	  See the xfs man page in section 5 for additional information.
 
 	  If unsure, say N.
-- 
2.50.1

