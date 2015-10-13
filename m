Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D687E7F37
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 23:17:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B9F918F8035
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 21:17:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4vUnhbNSGZCkUuuN for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 21:17:04 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zlr1J-0000wl-S7
	for xfs@oss.sgi.com; Tue, 13 Oct 2015 15:17:01 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zlr1J-0001JY-RA
	for xfs@oss.sgi.com; Tue, 13 Oct 2015 15:17:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] db: fix AGI ops definition in CRC type table
Date: Tue, 13 Oct 2015 15:17:01 +1100
Message-Id: <1444709821-5009-1-git-send-email-david@fromorbit.com>
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

The wrong buffer ops structure was added to the AGI field of the
type table when initially committed. This was not noticed because it
only affects manually setting the type of a buffer from xfs_db. e.g

xfs_db> agi 0
xfs_db> p
.....
crc = 0xbc58d757 (correct)
.....
xfs_db> fsb 2
xfs_db> type agi
Metadata CRC error detected at block 0x10/0x1000
xfs_db>

This is because (trimmed for clarity):

Breakpoint 1, xfs_verifier_error:
(gdb) bt
#0  xfs_verifier_error
#1  xfs_agfl_read_verify
#2  set_iocur_type
#3  type_f
#4  main

It's clear that the wrong verifier is being run (AGFL, not AGI).
The fix is simple.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/type.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/type.c b/db/type.c
index 955986b..1da7ee1 100644
--- a/db/type.c
+++ b/db/type.c
@@ -77,7 +77,7 @@ static const typ_t	__typtab[] = {
 static const typ_t	__typtab_crc[] = {
 	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
 	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
-	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agfl_buf_ops },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops },
 	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
 		&xfs_attr3_db_buf_ops },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
@@ -113,7 +113,7 @@ static const typ_t	__typtab_crc[] = {
 static const typ_t	__typtab_spcrc[] = {
 	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
 	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
-	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agfl_buf_ops },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops },
 	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
 		&xfs_attr3_db_buf_ops },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
