Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E8477F61
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 02:39:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 18A838F8033
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:38:58 -0700 (PDT)
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	G62ESBI6fEjWeiIu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 00:38:57 -0700 (PDT)
Received: by mail-ie0-f181.google.com with SMTP id x12so12474926ief.40
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:38:57 -0700 (PDT)
Message-ID: <51C15FFC.4010303@gmail.com>
Date: Wed, 19 Jun 2013 15:38:36 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add 'check -btrfs' support
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
To: xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Rich Johnston <rjohnston@sgi.com>

Currently we can specify the testing filesytems like 'check -xfs', but
btrfs is not support in this kind of command option. Add the option
'check -btrfs' support.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  check |    2 ++
  1 file changed, 2 insertions(+)

diff --git a/check b/check
index ff8fbcf..9c40615 100755
--- a/check
+++ b/check
@@ -74,6 +74,7 @@ usage()

  check options
      -xfs                test XFS (default)
+    -btrfs              test Btrfs
      -udf                test UDF
      -nfs                test NFS
      -l			line mode diff
@@ -162,6 +163,7 @@ while [ $# -gt 0 ]; do
  	-udf)	FSTYP=udf ;;
  	-xfs)	FSTYP=xfs ;;
  	-nfs)	FSTYP=nfs ;;
+	-btrfs) FSTYP=btrfs ;;

  	-g)	group=$2 ; shift ;
  		group_list=$(get_group_list $group)
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
