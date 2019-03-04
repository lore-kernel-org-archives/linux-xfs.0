Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41952 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDVTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 16:19:20 -0500
Subject: [PATCH 1/5] common/rc: fix get_max_lfs_filesize
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Mar 2019 13:19:08 -0800
Message-ID: <155173434839.767.14812800687954592485.stgit@magnolia>
In-Reply-To: <155173434205.767.15128498725168844621.stgit@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Helper functions are supposed to have a leading underscore ('_') in the
function name, but this one doesn't have it.  Unfortunately, the calling
test cases (generic/349-351) /do/ have the leading underscore, so now
they're broken.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index 8b40aabe..1c42515f 100644
--- a/common/rc
+++ b/common/rc
@@ -3834,7 +3834,7 @@ _get_max_file_size()
 }
 
 # get MAX_LFS_FILESIZE
-get_max_lfs_filesize()
+_get_max_lfs_filesize()
 {
 	case "$(getconf LONG_BIT)" in
 	"32")
