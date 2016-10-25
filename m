Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46056 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbcJYXDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:03:55 -0400
Subject: [PATCH 02/39] xfs_buflock: handling parsing errors more gracefully
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:03:50 -0700
Message-ID: <147743663033.11035.2295159817258375182.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Skip ftrace output lines that don't parse.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/xfsbuflock.py |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
index f307461..82b6e01 100755
--- a/tools/xfsbuflock.py
+++ b/tools/xfsbuflock.py
@@ -150,7 +150,10 @@ for line in fileinput.input():
 	if len(toks) < 4:
 		continue
 	pid = toks[0]
-	time = float(toks[2][:-1])
+	try:
+		time = float(toks[2][:-1])
+	except:
+		continue
 	fn = toks[3][:-1]
 
 	if pid in processes:

