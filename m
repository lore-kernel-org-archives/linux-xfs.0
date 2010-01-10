Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0AJPen8039469 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 13:25:40 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3CB730405F
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 11:26:32 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH 2/2] xfstests: 219: ignore duplicates reported by repquota
Date: Sun, 10 Jan 2010 13:26:32 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6942@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

(Re-sending; I misaddressed it the first time.)

Arrange to ignore duplicate entries reported by the repquota command.
This can happen if an id is used more than once (such as when two user
names are assigned the same uid).

Do this here by simply dropping any reported entries whose id number
has already been seen in the output.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 219 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/219
===================================================================
--- a/219
+++ b/219
@@ -85,7 +85,8 @@ test_accounting()
 		$here/src/lstat64 $file | head -3 | filter_scratch
 	done
 
-	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch
+	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	awk '/^#/ { if (! seen[$1]) { seen[$1]++; next; } } { print }'
 }
 
 # real QA test starts here

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
