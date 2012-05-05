Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q45F7XDI210984 for <xfs@oss.sgi.com>; Sat, 5 May 2012 10:07:33 -0500
Received: from oproxy5-pub.bluehost.com (oproxy5-pub.bluehost.com
	[67.222.38.55]) by cuda.sgi.com with SMTP id iHaVouYWaCerj3nT
	for <xfs@oss.sgi.com>; Sat, 05 May 2012 08:07:31 -0700 (PDT)
Received: from [221.217.53.106] (helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76) (envelope-from <tm@tao.ma>) id 1SQga1-0006WS-MW
	for xfs@oss.sgi.com; Sat, 05 May 2012 09:07:30 -0600
From: Tao Ma <tm@tao.ma>
Subject: [PATCH] xfstests: make 275 xfs specific.
Date: Sat,  5 May 2012 23:07:09 +0800
Message-Id: <1336230429-2939-1-git-send-email-tm@tao.ma>
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

From: Tao Ma <boyu.mt@taobao.com>

In my test with ext4, 275 can't pass because ext4
can create a 8k file in the end not like what xfs
does. So make this test case xfs only for now.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 275 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/275 b/275
index 214262e..3386a59 100755
--- a/275
+++ b/275
@@ -44,7 +44,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs generic
+_supported_fs xfs
 _supported_os IRIX Linux
 _require_scratch
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
