Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43B12DA74C
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 02:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967481; cv=none; b=WqT5P2QkQh5HPqNdkgHyevexb0Sn4p2R874DU3tVTC1SZiRRRb/ieMOTVJLOq3tyO5+QFvDUnQsE12Qt84cYgtV0xQbftK4S82B7NN6mz90b9lyKqheyCF5B4vA4kn5ujSnW62Gzxcd/e+vLDnxRXmXbp6ZZGqrClGIaE+jKVJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967481; c=relaxed/simple;
	bh=oHmI+Rz/ouG19lxfY13RQ9FS0B+6HKAr42tQSfKEs78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N47mxwKrWSUOgzTJj8or7+HegnsV2MEY2jyHpaEClhZdWMkFwvzOpzDknpAWCnle4gDqiGR9pqo6M0A8tvhEdueqzNpSSSwnxS/UGGM1JJJpKbfADC4aiLm/rYoL8pc56mik2judwKiNIKTWL3ZSgYQ0nk0HOaVQXokJ7ujR9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEBSaPt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEBSaPt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA598C4CEED;
	Tue, 12 Aug 2025 02:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754967481;
	bh=oHmI+Rz/ouG19lxfY13RQ9FS0B+6HKAr42tQSfKEs78=;
	h=From:To:Cc:Subject:Date:From;
	b=OEBSaPt2g3MuC+/gb3UyBUq3nm47yDYJNSMH+k4ByeI7Wd9tR6JmAxsIBhZtc+uPz
	 ZX7dL8dm/KFZfTGT7TjkyFj+2iOabCJE/nqJkLwo8Fi/vkKkKwOkbu0mM7mDXqT2Nj
	 7r3solto8Ads5yH6P/Es7I2Qyc+P1OojFV2vqhPrsX2KNI9RMaLPebK8aGl8ZyIcvw
	 DXeTIywwbsiWT5YFWSJGHsNwDx2thewK/rl5/YA+rYxzf3PnFcTNMq91DTLQ3/XJm9
	 48CTl2C6lP4+JTEDiOqz7RCF1TO8rQHUnYBD+YgZ2221Zpl+xsiZlpwHbATVeI08eL
	 tfkKd/G/FqB1w==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: Default XFS_RT to Y if CONFIG_BLK_DEV_ZONED is enabled
Date: Tue, 12 Aug 2025 11:55:19 +0900
Message-ID: <20250812025519.141486-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS support for zoned block devices requires the realtime subvolume
support (XFS_RT) to be enabled. Change the default configuration value
of XFS_RT from N to CONFIG_BLK_DEV_ZONED to align with this requirement.
This change still allows the user to disable XFS_RT if this feature is
not desired for the user use case.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 68724dec3d19..9367f60718dd 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -105,6 +105,7 @@ config XFS_POSIX_ACL
 config XFS_RT
 	bool "XFS Realtime subvolume support"
 	depends on XFS_FS
+	default BLK_DEV_ZONED
 	help
 	  If you say Y here you will be able to mount and use XFS filesystems
 	  which contain a realtime subvolume.  The realtime subvolume is a
-- 
2.50.1

