Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C7C07F6F
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 18:44:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C999AAC003
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 16:44:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JsVl88TTj5RqwPe7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Oct 2014 16:44:51 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NNioid014944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 19:44:51 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com
	[10.11.146.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9NNinem027618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 19:44:50 -0400
Message-ID: <544992F1.8050803@redhat.com>
Date: Thu, 23 Oct 2014 18:44:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix harmless sparse endian nit
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

h_crc is __le32 but cpu_to_be32() is... __be32.  So sparse
complains, even though it's harmless.

Although sparse is smart about bare 0s, and we could
drop the swap, other places explicitly swap to keep
things clear (I guess?) so "swap" the 0 with the proper
routine.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9ee89d3..dd8baa6 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -187,7 +187,7 @@ libxfs_log_header(
 		head->h_len = cpu_to_be32(sunit - BBSIZE);
 	else
 		head->h_len = cpu_to_be32(20);
-	head->h_crc = cpu_to_be32(0);
+	head->h_crc = cpu_to_le32(0);
 	head->h_prev_block = cpu_to_be32(-1);
 	head->h_num_logops = cpu_to_be32(1);
 	head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
