Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A9987F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 14:37:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6CD3AC001
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 12:37:23 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id UpZFmC0NMMeVHYPw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 12:37:22 -0800 (PST)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CE201ACC8
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 20:37:20 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH xfstests] generic/300: Add missing requirements for fallocate
	& punch hole
Date: Tue,  4 Mar 2014 21:37:17 +0100
Message-Id: <1393965437-28787-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Test 300 requires support for fallocate and punch hole from the
filesystem. Add proper require checks.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/generic/300 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c6072815b40..8b80c14c6f4e 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -43,6 +43,8 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_xfs_io_falloc
+_require_xfs_io_falloc_punch
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
