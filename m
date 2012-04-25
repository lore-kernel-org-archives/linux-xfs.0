Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PArnP6182054 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 05:53:49 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jbSDJu4aiCDyTQnk for
	<xfs@oss.sgi.com>; Wed, 25 Apr 2012 03:53:47 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3PArlq9009901
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 06:53:47 -0400
From: Tom Marek <tmarek@redhat.com>
Subject: [PATCH 1/2] xfstests README: added 'make install' to building steps
Date: Wed, 25 Apr 2012 12:52:56 +0200
Message-Id: <1335351177-3014-1-git-send-email-tmarek@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, dchinner@redhat.com

There was no mention of 'make install' step in the README file.
Run make install added to section 'Building Linux'.

Signed-off-by: Tom Marek <tmarek@redhat.com>
---
 README |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/README b/README
index 0f52f02..d81ede9 100644
--- a/README
+++ b/README
@@ -3,7 +3,9 @@ BUILDING THE FSQA SUITE
 _______________________
 
 Building Linux:
-	- cd into the xfstests directory and run make.
+	- cd into the xfstests directory
+	- run make
+	- run make install
 	
 Building IRIX:
 	- cd into the xfstests directory 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
