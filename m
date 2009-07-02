Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n62H2r1b101436 for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 12:02:53 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A2A01AEB026
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2009 10:03:25 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 29i9vHKBECB75wOS for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2009 10:03:25 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n62H3Plp018097
	for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 13:03:25 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n62H3OMm005661
	for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 13:03:24 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n62H3NGc015500
	for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 13:03:23 -0400
Message-ID: <4A4CE85B.1030102@sandeen.net>
Date: Thu, 02 Jul 2009 12:03:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_metadump: agcount*agblocks overflow
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
To: xfs mailing list <xfs@oss.sgi.com>

Found another potential overflow in xfs_metadump,
similar to those just fixed in repair.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--

diff --git a/db/metadump.c b/db/metadump.c
index 19aed4f..ef6e571 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -222,7 +222,8 @@ valid_bno(
 		return 1;
 	if (agno == (mp->m_sb.sb_agcount - 1) && agbno > 0 &&
 			agbno <= (mp->m_sb.sb_dblocks -
-			 (mp->m_sb.sb_agcount - 1) * mp->m_sb.sb_agblocks))
+			 (xfs_drfsbno_t)(mp->m_sb.sb_agcount - 1) *
+			 mp->m_sb.sb_agblocks))
 		return 1;
 
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
