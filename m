Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o68FL8ig047933 for <xfs@oss.sgi.com>; Thu, 8 Jul 2010 10:21:08 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1290743453E
	for <xfs@oss.sgi.com>; Thu,  8 Jul 2010 08:24:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 34Sm3f5w7vHrnPAj for
	<xfs@oss.sgi.com>; Thu, 08 Jul 2010 08:24:00 -0700 (PDT)
Received: from int-mx04.intmail.prod.int.phx2.redhat.com
	(int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o68FNxxW001784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 8 Jul 2010 11:23:59 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] Show duration of current test
Date: Thu,  8 Jul 2010 17:23:52 +0200
Message-Id: <1278602632-12425-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1278602632-12425-1-git-send-email-lczerner@redhat.com>
References: <1278602632-12425-1-git-send-email-lczerner@redhat.com>
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
Cc: lczerner@redhat.com, esandeen@redhat.com

It may be useful to compare both times, last and current, in the
xfstests output.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/check b/check
index 560ac7b..f792009 100755
--- a/check
+++ b/check
@@ -275,13 +275,14 @@ do
 	    else
 		if diff $seq.out $tmp.out >/dev/null 2>&1
 		then
-		    echo ""
 		    if $err
 		    then
 			:
 		    else
 			echo "$seq `expr $stop - $start`" >>$tmp.time
+			echo -n " `expr $stop - $start`s"
 		    fi
+		    echo ""
 		else
 		    echo " - output mismatch (see $seq.out.bad)"
 		    mv $tmp.out $seq.out.bad
-- 
1.7.1.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
