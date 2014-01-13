Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2EF9E7F52
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 07:07:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9BC48F8054
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 05:07:18 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GmNChBq05EZzAAB5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 05:07:17 -0800 (PST)
From: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/2] xfstests: make btrfs/001.out in line with subvol delete
	output
Date: Mon, 13 Jan 2014 21:16:29 +0800
Message-Id: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
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

btrfs/001 is failing as below btrfs-progs patch changed the
output during subvol delete.
Patch :
btrfs-progs: add options to set commit mode after subvol delete

so add it to the btrfs/001.out

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 tests/btrfs/001.out | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
index c782bde..a255614 100644
--- a/tests/btrfs/001.out
+++ b/tests/btrfs/001.out
@@ -33,6 +33,7 @@ subvol
 Listing subvolumes
 snap
 subvol
+Transaction commit: none (default)
 Delete subvolume 'SCRATCH_MNT/snap'
 List root dir
 subvol
-- 
1.8.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
