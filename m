Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:48999 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfHNUoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 16:44:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 02/18] xfs: compat_ioctl: add missing conversions
Date: Wed, 14 Aug 2019 22:42:29 +0200
Message-Id: <20190814204259.120942-3-arnd@arndb.de>
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, Nick Bowler <nbowler@draconx.ca>, Allison Collins <allison.henderson@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>

FS_IOC_GETFSLABEL/FS_IOC_SETFSLABEL were added in linux-4.18
in xfs, but not in the compat_ioctl case, so add them here.

FITRIM was added earlier and also lacks a line the same function,
but this is ok because there is an entry in fs/compat_ioctl.c for
it.

Adding all three here to keep the native and compat ioctl handlers
in sync.

Cc: stable@vger.kernel.org
Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_ioctl32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index ad91e81a2fcf..63bdc4c1535b 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -576,6 +576,9 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SCRUB_METADATA:
 	case XFS_IOC_BULKSTAT:
 	case XFS_IOC_INUMBERS:
+	case FITRIM:
+	case FS_IOC_GETFSLABEL:
+	case FS_IOC_SETFSLABEL:
 		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
 #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
 	/*
-- 
2.20.0
