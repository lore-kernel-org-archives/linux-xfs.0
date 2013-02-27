Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BCAB7F37
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 01:15:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A4DC8F8033
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 23:15:33 -0800 (PST)
Received: from mail-pb0-f54.google.com (mail-pb0-f54.google.com
	[209.85.160.54]) by cuda.sgi.com with ESMTP id gFvvZogLJmtPCMZy
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Feb 2013 23:15:32 -0800 (PST)
Received: by mail-pb0-f54.google.com with SMTP id rr4so193832pbb.27
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 23:15:32 -0800 (PST)
Message-ID: <512DB284.1090806@gmail.com>
Date: Wed, 27 Feb 2013 15:15:16 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
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
To: xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org, list.btrfs@jan-o-sch.net

Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
-x option of filefrag, and will fail with
	'FIBMAP: Invalid argument'
for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
     'FIEMAP failed with unsupported flags 2'
Remove the '-x' option.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  276 |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/276 b/276
index 082f943..f2b17c9 100755
--- a/276
+++ b/276
@@ -75,7 +75,7 @@ _filter_extents()

  _check_file_extents()
  {
-	cmd="filefrag -vx $1"
+	cmd="filefrag -v $1"
  	echo "# $cmd" >> $seq.full
  	out=`$cmd | _filter_extents`
  	if [ -z "$out" ]; then
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
