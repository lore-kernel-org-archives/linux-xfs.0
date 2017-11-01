Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20051 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933631AbdKAVr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:28 -0400
Subject: [PATCH 09/14] xfs/348: dir->symlink corruption must not be allowed
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:23 -0700
Message-ID: <150957284389.18388.370732842906149356.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A directory corrupted into a symlink will be caught by the upcoming
local format ifork verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/348.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/348.out b/tests/xfs/348.out
index f4a7a71..17d9be2 100644
--- a/tests/xfs/348.out
+++ b/tests/xfs/348.out
@@ -239,7 +239,7 @@ would have junked entry "DATA" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
-stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
 stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
 stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
 stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link

