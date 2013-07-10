Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B55DA7F66
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 09:00:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A83E88F8049
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 07:00:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CyoKDaR5eV8VSqYb for
	<xfs@oss.sgi.com>; Wed, 10 Jul 2013 07:00:53 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6AE0pDt010783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 10:00:52 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 06/10] xfstests: Allow to specify RESULT_BASE directory
Date: Wed, 10 Jul 2013 16:00:35 +0200
Message-Id: <1373464839-31535-7-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373464839-31535-1-git-send-email-lczerner@redhat.com>
References: <1373464839-31535-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

This commit adds the possibility to specify RESULT_BASE directory from
the config file, or with environment variable. The default remains the
same "$here/results/".

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check         | 1 -
 common/config | 5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/check b/check
index 2c003ae..1f41336 100755
--- a/check
+++ b/check
@@ -66,7 +66,6 @@ export FSTYP
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 SRC_GROUPS="generic shared"
 export SRC_DIR="tests"
-export RESULT_BASE=${RESULT_BASE:="$here/results"}
 
 usage()
 {
diff --git a/common/config b/common/config
index 34c99e1..39dd469 100644
--- a/common/config
+++ b/common/config
@@ -230,6 +230,11 @@ if [ -f "$HOST_OPTIONS" ]; then
 fi
 
 get_next_config() {
+	# set default RESULT_BASE
+	if [ -z "$RESULT_BASE" ]; then
+		export RESULT_BASE="$here/results/"
+	fi
+
 	#  Mandatory Config values.
 	MC=""
 	[ -z "$EMAIL" ]          && MC="$MC EMAIL"
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
