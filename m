Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E888E7F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 10:41:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8762304039
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 08:41:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ba18qMg0M8nBKKue for
	<xfs@oss.sgi.com>; Wed, 29 May 2013 08:41:53 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4TFfqef021157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 11:41:52 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: add missing colon in _filter_ln
Date: Wed, 29 May 2013 23:41:46 +0800
Message-Id: <1369842106-9869-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

On distros with older coreutils(eg. RHEL5) generic/294 fails like

    -ln: creating symbolic link `SCRATCH_MNT/294.test/testlink': File exists
    +ln: creating symbolic link `SCRATCH_MNT/294.test/testlink'File exists

_filter_ln ate the ": ". xfs/103 has similar issue. Add ": " back.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/filter | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/filter b/common/filter
index bdd6427..dbb1674 100644
--- a/common/filter
+++ b/common/filter
@@ -243,7 +243,7 @@ _filter_spaces()
 # Account for different "ln" failure messages
 _filter_ln()
 {
-	sed -e "s,\(creating symbolic link .*\) to .*: ,\1," \
+	sed -e "s,\(creating symbolic link .*\) to .*: ,\1: ," \
 	    -e "s,failed to create,creating,"
 }
 
-- 
1.8.2.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
