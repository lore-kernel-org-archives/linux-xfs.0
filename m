Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7530D7F5D
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 05:39:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0309DAC001
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 03:39:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id whDNSTq93ZEhReE6 for
	<xfs@oss.sgi.com>; Sun, 07 Apr 2013 03:39:17 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37AdG5a002182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 7 Apr 2013 06:39:16 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/3] xfstests: remove comments about creator in new
Date: Sun,  7 Apr 2013 18:39:05 +0800
Message-Id: <1365331147-15179-1-git-send-email-eguan@redhat.com>
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

We have removed creator/owner info from each test case, remove the
'creator' comment in template too.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 new | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/new b/new
index 2bc1e8f..f712892 100755
--- a/new
+++ b/new
@@ -104,7 +104,7 @@ cat <<End-of-File >$id
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
+
 seq=\`basename \$0\`
 seqres=\$RESULT_DIR/\$seq
 echo "QA output created by \$seq"
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
