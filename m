Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 60FD77F5A
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 07:36:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E16B8F809E
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 05:36:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NZT3Ir7hXyTqpacq for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 05:36:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UfUkZ-0007Z5-74
	for xfs@oss.sgi.com; Thu, 23 May 2013 22:36:07 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UfUkZ-0001dx-2G
	for xfs@oss.sgi.com; Thu, 23 May 2013 22:36:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs_db: add CRC information to dquot output
Date: Thu, 23 May 2013 22:36:04 +1000
Message-Id: <1369312565-6266-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1369312565-6266-1-git-send-email-david@fromorbit.com>
References: <1369032783-24973-1-git-send-email-david@fromorbit.com>
	<1369312565-6266-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When dumping a dqblk, also output the CRC related fields. For
non-CRC filesystems, these fields should always be zero.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/dquot.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/db/dquot.c b/db/dquot.c
index daa47a3..35eb0bd 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -48,6 +48,9 @@ const field_t	dqblk_flds[] = {
 	{ "diskdq", FLDT_DISK_DQUOT, OI(DDOFF(diskdq)), C1, 0, TYP_NONE },
 	{ "fill", FLDT_CHARS, OI(DDOFF(fill)), CI(DDSZC(fill)), FLD_SKIPALL,
 	  TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(DDOFF(crc)), C1, 0, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(DDOFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(DDOFF(uuid)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
