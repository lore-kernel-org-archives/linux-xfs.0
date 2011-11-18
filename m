Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAI8g1hT111038 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 02:42:02 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02549260486
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 00:41:59 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id GFP3Cnlzk4ukWjD1 for
	<xfs@oss.sgi.com>; Fri, 18 Nov 2011 00:41:59 -0800 (PST)
Message-ID: <4EC61AC3.6010806@cn.fujitsu.com>
Date: Fri, 18 Nov 2011 16:43:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] 254: disable space cache
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

I can't pass 254, and below is the output:

254 3s ... - output mismatch (see 254.out.bad)
...
 ID 256 top level 5 path snap
-ID 257 top level 5 path subvol
+ID 258 top level 5 path subvol

When space cache is enabled (and now mkfs.btrfs always enables it),
there will be some space cache inodes in the root tree, and they
consume some IDs, and that's why "subvol" has the ID 258 but not 257.

Just disable space cache for this test case.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 254 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/254 b/254
index 5216120..1cd4832 100755
--- a/254
+++ b/254
@@ -48,7 +48,7 @@ _supported_os Linux
 _require_scratch
 
 _scratch_mkfs > /dev/null 2>&1
-_scratch_mount
+_scratch_mount -o nospace_cache
 
 # First test basic snapshotting
 echo "Creating file foo in root dir"
-- 
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
