Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1BB87F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 07:07:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 964758F8054
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 05:07:20 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yVM1SGdqzeOhOeYf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 05:07:19 -0800 (PST)
From: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/2] xfstest: tests btrfs/006 fails with mixed-mode/small disks
Date: Mon, 13 Jan 2014 21:16:30 +0800
Message-Id: <1389618990-24544-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
References: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
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
Cc: linux-btrfs@vger.kernel.org

From: Anand Jain <Anand.Jain@oracle.com>

as of now the script does not filter 0.00 size  in the
filesystem show output, which is the case in multi-disk
mixed-mode (that is default group type for small disks)

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 common/filter       | 6 ++++++
 common/filter.btrfs | 1 +
 2 files changed, 7 insertions(+)

diff --git a/common/filter b/common/filter
index c872a27..04d12c4 100644
--- a/common/filter
+++ b/common/filter
@@ -277,6 +277,12 @@ _filter_uuid()
 	fi
 }
 
+# In mixed group the added disks may have zero used size
+_filter_zero_size()
+{
+	sed -e "s/0\.00/<SIZE>/g"
+}
+
 # Filter out sizes like 6.14MB etc
 _filter_size()
 {
diff --git a/common/filter.btrfs b/common/filter.btrfs
index 29512cd..75853f2 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -33,6 +33,7 @@ _filter_btrfs_filesystem_show()
 	# the uniq collapses all device lines into 1
 	_filter_uuid $UUID | _filter_scratch | _filter_scratch_pool | \
 	_filter_size | _filter_btrfs_version | _filter_devid | \
+	_filter_zero_size | \
 	sed -e "s/\(Total devices\) $NUMDEVS/\1 $NUM_SUBST/g" | \
 	uniq
 }
-- 
1.8.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
