Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F6BC7F59
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 05:38:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D55C0AC002
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id omoI4sHQJ7JHIKsD for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:14 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6BAcE7k028954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 06:38:14 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 02/10 v2] xfstests: Export all important variables in
	common/config
Date: Thu, 11 Jul 2013 12:37:57 +0200
Message-Id: <1373539085-8577-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
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
Cc: lczerner@redhat.com

Currently we do not export some of the important variables in
common/config. Fix this.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/config | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/common/config b/common/config
index 67c1498..1679acf 100644
--- a/common/config
+++ b/common/config
@@ -56,19 +56,19 @@ export LANG=C
 [ -d /usr/freeware/bin ] && PATH=$PATH:/usr/freeware/bin
 PATH=".:$PATH"
 
-HOST=`hostname -s`
-HOSTOS=`uname -s`
-[ "$HOSTOS" = "IRIX64" ] && HOSTOS="IRIX"
+export HOST=`hostname -s`
+export HOSTOS=`uname -s`
+[ "$HOSTOS" = "IRIX64" ] && export HOSTOS="IRIX"
 
-MODULAR=0               # using XFS as a module or not
-BOOT="/boot"            # install target for kernels
+export MODULAR=0               # using XFS as a module or not
+export BOOT="/boot"            # install target for kernels
 export EXTRA=${EXTRA:=xfs-qa}
 
 # general parameters (mainly for auto-qa)
-SOAK_PROC=3             # -p option to fsstress
-SOAK_STRESS=10000       # -n option to fsstress
-SOAK_PASSES=-1          # count of repetitions of fsstress (while soaking)
-EMAIL=root@localhost    # where auto-qa will send its status messages
+export SOAK_PROC=3             # -p option to fsstress
+export SOAK_STRESS=10000       # -n option to fsstress
+export SOAK_PASSES=-1          # count of repetitions of fsstress (while soaking)
+export EMAIL=root@localhost    # where auto-qa will send its status messages
 export HOST_OPTIONS=${HOST_OPTIONS:=local.config}
 export CHECK_OPTIONS=${CHECK_OPTIONS:="-g auto"}
 export BENCH_PASSES=${BENCH_PASSES:=5}
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
