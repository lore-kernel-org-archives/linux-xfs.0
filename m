Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48480 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfBYRlv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 12:41:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1PHceup121214
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:49 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxtrfh4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1PHfhDZ026130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:43 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1PHfhOB014780
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:43 GMT
Subject: [PATCH 2/2] xfs: fix backwards endian conversion in scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 25 Feb 2019 09:41:41 -0800
Message-ID: <155111650186.15126.5896442701967175896.stgit@magnolia>
In-Reply-To: <155111649548.15126.8995811550165658297.stgit@magnolia>
References: <155111649548.15126.8995811550165658297.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a backwards endian conversion of a constant.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 9d4e8293d37e..ddf06bfaa29d 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -399,7 +399,7 @@ xchk_agf_xref_cntbt(
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.cnt_cur))
 		return;
 	if (!have) {
-		if (agf->agf_freeblks != be32_to_cpu(0))
+		if (agf->agf_freeblks != cpu_to_be32(0))
 			xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 		return;
 	}
