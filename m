Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C128829DFE
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 05:58:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AD1C7304032
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 03:58:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nuDDyHwrREqXZ7iA for
	<xfs@oss.sgi.com>; Mon, 01 Apr 2013 03:58:24 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r31AwOJm012380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Apr 2013 06:58:24 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: set correct seqres variable in new when creating
	test template
Date: Mon,  1 Apr 2013 18:58:15 +0800
Message-Id: <1364813895-10883-1-git-send-email-eguan@redhat.com>
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

When setting seqres in the new script, '$' should be escaped,
otherwise seqres will be set to '/' not '$RESULT_DIR/$seq'

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 new | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/new b/new
index d9c38c8..2bc1e8f 100755
--- a/new
+++ b/new
@@ -106,7 +106,7 @@ cat <<End-of-File >$id
 #
 # creator
 seq=\`basename \$0\`
-seqres=$RESULT_DIR/$seq
+seqres=\$RESULT_DIR/\$seq
 echo "QA output created by \$seq"
 
 here=\`pwd\`
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
