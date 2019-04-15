Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfDOBWl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 14 Apr 2019 21:22:41 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] nvme/012 & 013: avoid extremely slow xfs IO
Date: Mon, 15 Apr 2019 09:22:29 +0800
Message-Id: <20190415012229.20689-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@fb.com>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

It is observed that nvme/012 may take ~17 minutes to complete on aarch64,
even worse it may trigger IO timeout on nvme-loop.

Eric and Dave replied that it is because of too small log size on small
disk.

So pass '-l size=32m' to avoid the issue.

With this patch, nvme/012 can be completed in one minute.

Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tests/nvme/012 | 2 +-
 tests/nvme/013 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/nvme/012 b/tests/nvme/012
index 9a6801511df7..d7a8751ec752 100755
--- a/tests/nvme/012
+++ b/tests/nvme/012
@@ -46,7 +46,7 @@ test() {
 
 	umount ${mount_dir} > /dev/null 2>&1
 
-	mkfs.xfs -f /dev/"${nvmedev}n1" > /dev/null 2>&1
+	mkfs.xfs -l size=32m -f /dev/"${nvmedev}n1" > /dev/null 2>&1
 
 	mount /dev/"${nvmedev}n1" "${mount_dir}"
 
diff --git a/tests/nvme/013 b/tests/nvme/013
index e346cd4baa35..bc435f752dca 100755
--- a/tests/nvme/013
+++ b/tests/nvme/013
@@ -44,7 +44,7 @@ test() {
 
 	umount ${mount_dir} > /dev/null 2>&1
 
-	mkfs.xfs -f /dev/"${nvmedev}n1" > /dev/null 2>&1
+	mkfs.xfs -l size=32m  -f /dev/"${nvmedev}n1" > /dev/null 2>&1
 
 	mount /dev/"${nvmedev}n1" "${mount_dir}"
 
-- 
2.9.5
