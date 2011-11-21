Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALBVmf8255484 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:31:48 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DECE162AF89
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 03:31:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Dp31e7svMWpzftUO for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 03:31:46 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfstests: use command line option for setting extra space
Date: Mon, 21 Nov 2011 22:31:25 +1100
Message-Id: <1321875088-30801-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Allow the extra free space to leave in large scratch filesystems to
be specified by a command line option rather than just via an
environment variable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/common b/common
index da86cd9..78ac654 100644
--- a/common
+++ b/common
@@ -247,6 +247,11 @@ s/ .*//p
 	    usage
 	    ;;
 
+	--extra-space=*)
+	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
+	    xpand=false
+	    ;;
+
 	*)
 	    start=$r
 	    end=$r
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
