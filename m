Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7HoxdQ069543 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 11:50:59 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: fix permissions on non-executable tests
Date: Mon,  7 Nov 2011 11:50:53 -0600
Message-Id: <1320688253-2432-1-git-send-email-wkendall@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Tests that are not executable are made executable when they are
run, causing git to report them as modified. Fix this by
changing non-executable tests to have permissions of 0755.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 255
 mode change 100644 => 100755 256
 mode change 100644 => 100755 257
 mode change 100644 => 100755 258
 mode change 100644 => 100755 259
 mode change 100644 => 100755 260
 mode change 100644 => 100755 261
 mode change 100644 => 100755 262
 mode change 100644 => 100755 263
 mode change 100644 => 100755 266
 mode change 100644 => 100755 267
 mode change 100644 => 100755 268

diff --git a/255 b/255
old mode 100644
new mode 100755
diff --git a/256 b/256
old mode 100644
new mode 100755
diff --git a/257 b/257
old mode 100644
new mode 100755
diff --git a/258 b/258
old mode 100644
new mode 100755
diff --git a/259 b/259
old mode 100644
new mode 100755
diff --git a/260 b/260
old mode 100644
new mode 100755
diff --git a/261 b/261
old mode 100644
new mode 100755
diff --git a/262 b/262
old mode 100644
new mode 100755
diff --git a/263 b/263
old mode 100644
new mode 100755
diff --git a/266 b/266
old mode 100644
new mode 100755
diff --git a/267 b/267
old mode 100644
new mode 100755
diff --git a/268 b/268
old mode 100644
new mode 100755
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
