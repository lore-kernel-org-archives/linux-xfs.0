Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 204A07F50
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 081028F8033
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:28 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id dctGAyINEC6mmvWA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:27 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 02/10] xfstest: add configurable load factors
Date: Wed, 20 Feb 2013 14:42:07 +0400
Message-Id: <1361356935-29153-3-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

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
 common.config |    2 ++
 group         |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/common.config b/common.config
index 7681812..8efc7f8 100644
--- a/common.config
+++ b/common.config
@@ -73,6 +73,8 @@ export HOST_OPTIONS=${HOST_OPTIONS:=local.config}
 export CHECK_OPTIONS=${CHECK_OPTIONS:="-g auto"}
 export BENCH_PASSES=${BENCH_PASSES:=5}
 export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
+export TIME_FACTOR=${TIME_FACTOR:=1}
+export LOAD_FACTOR=${LOAD_FACTOR:=1}
 
 export PWD=`pwd`
 #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
diff --git a/group b/group
index eb4f375..5504557 100644
--- a/group
+++ b/group
@@ -113,7 +113,12 @@ dangerous
 # on current systems
 deprecated
 
-#
+# Stress test with probable behaviour, the longer test run the
+# larger corner cases will be covered. Configurable variables:
+# LOAD_FACTOR: Usually means factor number of running tasks
+# TIME_FACTOR: Usually means factor of run time, or number of operations
+stress
+
 # test-group association ... one line per test
 #
 001 rw dir udf auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
