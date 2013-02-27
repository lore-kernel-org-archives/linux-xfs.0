Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 748017CBF
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 00:48:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4519B8F8033
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 22:48:12 -0800 (PST)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id VeTV1A0nABTLtHH5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Feb 2013 22:48:11 -0800 (PST)
Received: by mail-pa0-f54.google.com with SMTP id fa10so235176pad.41
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 22:48:11 -0800 (PST)
Message-ID: <512DAC1A.2040601@gmail.com>
Date: Wed, 27 Feb 2013 14:47:54 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 273: fix a typo
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Make the porter log cp failure into $seq.full by appending, not overwriting,
which can help debug.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  273 |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/273 b/273
index 67f3d6b..639e280 100755
--- a/273
+++ b/273
@@ -92,7 +92,7 @@ _porter()
  		exit
  	fi

-	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
+	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seq.full 2>&1
  	if [ $? -ne 0 ]
  	then
  		echo "_porter $_suffix not complete"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
