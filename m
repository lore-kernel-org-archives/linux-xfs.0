Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S3jtuI245246 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 22:45:56 -0500
Received: from oproxy6-pub.bluehost.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D226E11A7165
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 20:49:28 -0700 (PDT)
Received: from oproxy6-pub.bluehost.com (oproxy6-pub.bluehost.com
	[67.222.54.6]) by cuda.sgi.com with SMTP id jKnAfRQr6B4MfC8S
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 20:49:28 -0700 (PDT)
From: Tao Ma <tm@tao.ma>
Subject: [PATCH] xfstests: fix error discard test output in 251.out.
Date: Thu, 28 Apr 2011 11:49:11 +0800
Message-Id: <1303962551-14893-1-git-send-email-tm@tao.ma>
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
Cc: Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>

From: Tao Ma <boyu.mt@taobao.com>

I don't know why, but discard tests is 251 in xfs,
but 251.out has number of 248 in it, So it fails.
Change it to 251 now.

Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 251.out |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/251.out b/251.out
index 880d9c7..3017b5e 100644
--- a/251.out
+++ b/251.out
@@ -1,3 +1,3 @@
-QA output created by 248
+QA output created by 251
 Checking FITRIM support: done.
 Running the test: done.
-- 
1.6.3.GIT

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
