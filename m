Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0157B7FAD
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82A73AC00B
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kUkYVEjjh4rbblUm for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkW9-0003wC-BJ
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkW9-0001MU-8H
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 37/48] xfs_db: add CRC information to dquot output
Date: Fri,  7 Jun 2013 10:26:00 +1000
Message-Id: <1370564771-4929-38-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
