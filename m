Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 70B607F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 01:13:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F5B58F804C
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 23:13:38 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	MLW6BlYwmfAjoHJ7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 23:13:37 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id k11so3085275iea.38
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 23:13:37 -0700 (PDT)
Message-ID: <514AA503.4060101@gmail.com>
Date: Thu, 21 Mar 2013 14:13:23 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 276: use _require_no_large_scratch_dev instead of
	the removed _require_nobigloopfs
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
To: Dave Chinner <david@fromorbit.com>, xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org

_require_nobigloopfs has been removed.
We should use _require_no_large_scratch_dev in the test script.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  276 |    3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/276 b/276
index 40b30cf..87363ca 100755
--- a/276
+++ b/276
@@ -58,8 +58,7 @@ _need_to_be_root
  _supported_fs btrfs
  _supported_os Linux
  _require_scratch
-
-_require_nobigloopfs
+_require_no_large_scratch_dev
  _require_btrfs inspect-internal
  _require_command "/usr/sbin/filefrag"

-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
