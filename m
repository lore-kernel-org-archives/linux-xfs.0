Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48886 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754220AbdDGHtU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 03:49:20 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v377nJI7018319
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 07:49:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v377nIo9031099
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 07:49:19 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v377nI86011969
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 07:49:18 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH 1/1] xfsprogs/db: fix a segfault by bailing out the print on a corrupted block
Date: Fri,  7 Apr 2017 15:49:04 +0800
Message-Id: <1491551344-5236-2-git-send-email-shan.hai@oracle.com>
In-Reply-To: <1491551344-5236-1-git-send-email-shan.hai@oracle.com>
References: <1491551344-5236-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

The print command of the xfs_db would cause segfault on a corrupted
or CRC error block, fix it by bailing out the print when encountered
a corrupted or CRC error block, below is an example to reproduce the
segfault:

mkfs.xfs -f /dev/sda1
xfs_db -r -c "agf 0" -c "addr rmaproot" -c "p" /dev/sda1
Metadata CRC error detected at xfs_rmapbt block 0x0/0x1000
Segmentation fault (core dumped)

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 db/print.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/db/print.c b/db/print.c
index e31372f..08bb39a 100644
--- a/db/print.c
+++ b/db/print.c
@@ -69,11 +69,19 @@ print_f(
 	char	**argv)
 {
 	pfunc_t	pf;
+	int err;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
 		return 0;
 	}
+
+	err = iocur_top->bp->b_error;
+	if ((err == -EFSCORRUPTED) || (err == -EFSBADCRC)) {
+		dbprintf(_("data corrupted or CRC error\n"));
+		return 0;
+	}
+
 	pf = cur_typ->pfunc;
 	if (pf == NULL) {
 		dbprintf(_("no print function for type %s\n"), cur_typ->name);
-- 
2.7.4

