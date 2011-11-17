Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAH5G751008268 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 23:16:07 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51030154D26F
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 21:16:04 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 267qcEXvyraMIHte for
	<xfs@oss.sgi.com>; Wed, 16 Nov 2011 21:16:04 -0800 (PST)
Message-ID: <4EC4989D.9080107@cn.fujitsu.com>
Date: Thu, 17 Nov 2011 13:16:13 +0800
From: WuBo <wu.bo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] change fallocate to xfs_io falloc
References: <4EB20505.7070005@cn.fujitsu.com>
In-Reply-To: <4EB20505.7070005@cn.fujitsu.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>

Thanks to Ben for pointing it that the fallocate maybe uninstall 
without checking it, and change fallocate to xfs_io as Christoph
suggested.

Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
---
 274 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/274 b/274
index b658004..bcf5a11 100755
--- a/274
+++ b/274
@@ -46,6 +46,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 _require_scratch
+_require_xfs_io_falloc
 
 echo "------------------------------"
 echo "preallocation test"
@@ -67,7 +68,7 @@ then
 	exit
 fi
 
-fallocate -n -o 4K -l 1M test >/dev/null 2>&1
+$XFS_IO_PROG -F -f -c 'falloc 4096 1m' test >/dev/null
 if [ $? -ne 0 ]
 then
 	echo "fallocate file err"
-- 
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
