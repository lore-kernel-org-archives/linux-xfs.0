Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFc85P009940 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:38:08 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E15061C9F344
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:38:07 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id i9dFFnH6D4Wi3Acx for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:38:07 -0700 (PDT)
From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 5/5] _populate_fs should use OPTIND when getopts is used
Date: Thu, 20 Oct 2011 23:41:22 +0800
Message-Id: <1319125282-17062-6-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
References: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
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
To: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Anand Jain <Anand.Jain@oracle.com>


Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 common.rc |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index e3c4e67..cab0b64 100644
--- a/common.rc
+++ b/common.rc
@@ -1547,6 +1547,7 @@ _populate_fs()
     root=root       # path of initial root of directory tree
     randomdata=false # -x data type urandom or zero
 
+    OPTIND=1
     while getopts "d:f:n:r:s:v:x" c
     do
         case $c in
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
