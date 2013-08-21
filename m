Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0059B7FB4
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 17:40:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9792CAC005
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 15:40:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5vieoRv89Kc8C3mC for
	<xfs@oss.sgi.com>; Wed, 21 Aug 2013 15:40:49 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7LMemfJ020606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 18:40:48 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r7LMelVn024328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 18:40:48 -0400
Message-ID: <521541EF.1000604@redhat.com>
Date: Wed, 21 Aug 2013 17:40:47 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_db: add header to freesp -d output
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Today, xfs_db's freesp -d command dumps out a bunch of numbers:

# xfs_db -c "freesp -d" /dev/sdb1
       0        4        1
       0        5        1
       0        6        1
       0        7        1
       0       12   174772
...

which are not useful to the non-code-reading user.
Add some headers:

# xfs_db -c "freesp -d" /dev/sdb1
    agno    agbno      len
       0        4        1
       0        5        1
       0        6        1
       0        7        1
       0       12   174772
...

so there's at least some context.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. - If folks want different strings, I'm game.

diff --git a/db/freesp.c b/db/freesp.c
index 6f69eba..361fa96 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -96,6 +96,10 @@ freesp_f(
 
 	if (!init(argc, argv))
 		return 0;
+
+	if (dumpflag)
+		dbprintf("%8s %8s %8s\n", "agno", "agbno", "len");
+
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)  {
 		if (inaglist(agno))
 			scan_ag(agno);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
