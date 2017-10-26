Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:9507 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdJZHcR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 03:32:17 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 1/2] dmflakey: support multiple dm targets for a dm-flakey device
Date: Thu, 26 Oct 2017 15:37:51 +0800
Message-ID: <1509003472-24191-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

dm-flakey is used to emulate IO error, however, when we also
need to prevent the IO error for a specific range of the block
device (eg., the log region of a XFS), we need to specify
multiple dm targets for the dm device.

Option --table can not accommodate the multiple dm targets case,
so let dmsetup get the possible-multiple-targets table from
standard input.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 common/dmflakey | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/dmflakey b/common/dmflakey
index 4434307..16b82d2 100644
--- a/common/dmflakey
+++ b/common/dmflakey
@@ -77,7 +77,7 @@ _load_flakey_table()
 	$DMSETUP_PROG suspend $suspend_opt flakey-test
 	[ $? -ne 0 ] && _fatal "failed to suspend flakey-test"
 
-	$DMSETUP_PROG load flakey-test --table "$table"
+	echo -e "$table" | $DMSETUP_PROG load flakey-test
 	[ $? -ne 0 ] && _fatal "failed to load table into flakey-test"
 
 	$DMSETUP_PROG resume flakey-test
-- 
2.7.5

