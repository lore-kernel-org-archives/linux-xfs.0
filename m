Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBEE97F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 10:23:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A95FA8F8557
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 08:23:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id itnypFYua1Qj9fkY for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 08:23:16 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1PGNFvM005111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:23:15 -0500
Message-ID: <530CC371.8030005@redhat.com>
Date: Tue, 25 Feb 2014 10:23:13 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_metadump: include F in getopts string
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Boris Ranto <branto@redhat.com>

I added an F case, but didn't add it to the bash
getopts string last go-round.

/usr/sbin/xfs_metadump: illegal option -- F

I sure thought I tested this, I'm not sure how it got lost.

Reported-by: Boris Ranto <branto@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 7ce7a6d..71f579d 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -7,7 +7,7 @@ OPTS=" "
 DBOPTS=" "
 USAGE="Usage: xfs_metadump [-efFogwV] [-m max_extents] [-l logdev] source target"
 
-while getopts "efgl:m:owV" c
+while getopts "efgl:m:owFV" c
 do
 	case $c in
 	e)	OPTS=$OPTS"-e ";;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
