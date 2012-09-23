Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8NJNR1t026975 for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 14:23:27 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	81CAfNx0kM6GNbHK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Sep 2012 12:24:43 -0700 (PDT)
Received: by lbbgg6 with SMTP id gg6so1076250lbb.26
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 12:24:41 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/6] xfstest: add configurable load factors
Date: Sun, 23 Sep 2012 23:24:32 +0400
Message-Id: <1348428276-13161-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
References: <a>
 <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de, xfs@oss.sgi.com

Most stress test has probable behaviour, the longer test run the
larger corner cases will be cover. It is reasonable to allow
user to provide some sort of system load factor.
This patch introduce two global variables
LOAD_FACTOR: Usually means factor number of running tasks
TIME_FACTOR: Usually means factor of run time, or number of operations
If not speficied both variables defined to 1, so original behaviour
preserved.

TODO: Change all stress tests to use this variables

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common.config |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/common.config b/common.config
index 25cddb4..a24b915 100644
--- a/common.config
+++ b/common.config
@@ -255,5 +255,13 @@ if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
     exit 1
 fi
 
+if [ -z "$LOAD_FACTOR" ]; then
+    LOAD_FACTOR=1
+fi
+
+if [ -z "$TIME_FACTOR" ]; then
+    TIME_FACTOR=1
+fi
+
 # make sure this script returns success
 /bin/true
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
