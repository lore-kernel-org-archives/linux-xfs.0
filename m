Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D5847CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 10:39:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1FAF430407F
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 08:39:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Z91EKofPsSuQ8zvQ for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 08:39:10 -0700 (PDT)
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 07A55A4E82
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 16:39:09 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: remove unconditional setting of FSTYP
Date: Thu, 28 Mar 2013 16:39:07 +0100
Message-Id: <1364485147-27210-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

Commit 3345d2150e9e672 ("xfstests: clean up and simply check CLI option
parsing") hardcodes the FSTYP to xfs, testing other filesystems fails
with

common.rc: Error: $TEST_DEV (/dev/sda5) is not a MOUNTED xfs filesystem

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 check | 1 -
 1 file changed, 1 deletion(-)

diff --git a/check b/check
index 18cae75..8e5179a 100755
--- a/check
+++ b/check
@@ -33,7 +33,6 @@ showme=false
 have_test_arg=false
 randomize=false
 here=`pwd`
-FSTYP=xfs
 xfile=""
 
 # start the initialisation work now
-- 
1.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
