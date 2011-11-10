Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZeuO126978 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:40 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 1/8] xfsprogs: Fix setbitval() bug when nbits is byte-aligned
Date: Thu, 10 Nov 2011 14:35:11 -0600
Message-Id: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
In-Reply-To: <1320957318-16269-1-git-send-email-aelder@sgi.com>
References: <1320957318-16269-1-git-send-email-aelder@sgi.com>
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
Cc: Kevan Rehm <kfr@sgi.com>, Alex Elder <aelder@sgi.com>

From: Kevan Rehm <kfr@sgi.com>

If a field whose size is not an even multiple of 8 bits happens to
be aligned on a byte boundary and the machine is little-endian,
routine setbitval() would do a byte copy of zero bytes, effectively
doing nothing.

Catch this case, and arrange for doing the bit setting "the hard
way" (i.e., without using memcpy()) to avoid this problem.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 db/bit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/db/bit.c b/db/bit.c
index ca57d31..36de0a1 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -153,7 +153,7 @@ setbitval(
 		 */
 
 		/* byte aligned ? */
-		if (bitoff%NBBY) {
+		if (bitoff % NBBY || nbits % NBBY) {
 			/* no - bit copy */
 			for (bit=0; bit<nbits; bit++)
 				setbit(out, bit+bitoff, getbit(in, bit));
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
