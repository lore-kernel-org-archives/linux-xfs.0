Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 443CE7F7D
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 16:54:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 292108F8050
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 14:54:00 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id fkfhjKb4HNGPhByH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Dec 2013 14:53:58 -0800 (PST)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 42F38ABB4
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 22:53:57 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] Fix output parsing in _check_udf_filesystem()
Date: Mon, 23 Dec 2013 23:53:50 +0100
Message-Id: <1387839231-8558-2-git-send-email-jack@suse.cz>
In-Reply-To: <1387839231-8558-1-git-send-email-jack@suse.cz>
References: <1387839231-8558-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>

Move of tests into separate subdirectories broke sed(1) expression in
_check_udf_filesystem(). Actually use of sed in that place was rather
stupid so just replace it with plain echo.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 common/rc | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index fe6bbfcbfc55..12f0196655a8 100644
--- a/common/rc
+++ b/common/rc
@@ -1582,9 +1582,8 @@ _check_udf_filesystem()
     sleep 1 # Due to a problem with time stamps in udf_test
     $here/src/udf_test $OPT_ARG $device | tee $seqres.checkfs | egrep "Error|Warning" | \
 	_udf_test_known_error_filter | \
-	egrep -iv "Error count:.*[0-9]+.*total occurrences:.*[0-9]+|Warning count:.*[0-9]+.*total occurrences:.*[0-9]+" | \
-	sed "s/^.*$/Warning UDF Verifier reported errors see $seqres.checkfs./g"
-
+	egrep -iv "Error count:.*[0-9]+.*total occurrences:.*[0-9]+|Warning count:.*[0-9]+.*total occurrences:.*[0-9]+" && \
+        echo "Warning UDF Verifier reported errors see $seqres.checkfs."
 }
 
 _check_xfs_test_fs()
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
