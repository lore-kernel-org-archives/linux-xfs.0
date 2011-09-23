Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NEFOaC107448 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 09:15:24 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2 v3] commit.rc: Add helper for math operation using bc
Date: Fri, 23 Sep 2011 16:15:10 +0200
Message-Id: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com

Sometimes using bash $(()) math might not be enough due to some
limitation (big numbers), so add helper using 'bc' program. For
now the results are only in perfect numbers (as in bash) since this is
all I need for now.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v3: Nothing has changed

 common.rc |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index 35f782b..b0e0c6a 100644
--- a/common.rc
+++ b/common.rc
@@ -20,6 +20,20 @@
 #  Mountain View, CA 94043, USA, or: http://www.sgi.com
 #-----------------------------------------------------------------------
 
+BC=$(which bc 2> /dev/null) || BC=
+
+_math() {
+	if [ $# -le 0 ]; then
+		return
+	fi
+	if [ "$BC" ]; then
+		result=$(LANG=C echo "scale=0; $@" | "$BC" -q 2> /dev/null)
+	else
+		result=$(($@))
+	fi
+	echo "$result"
+}
+
 dd()
 {
    if [ "$HOSTOS" == "Linux" ]
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
