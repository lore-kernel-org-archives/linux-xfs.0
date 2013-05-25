Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 885D97F37
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 18:15:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 453AF304039
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 16:15:52 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id GD1Cx0EwLYc0rE0J (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 May 2013 16:15:51 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Sat, 25 May 2013 19:15:49 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 30EEE6E8039
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 19:15:44 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r4PNFlrJ306328 for <xfs@oss.sgi.com>; Sat, 25 May 2013 19:15:47 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r4PNFlO4031526 for <xfs@oss.sgi.com>; Sat, 25 May 2013 20:15:47 -0300
From: zwu.kernel@gmail.com
Subject: [PATCH] xfstests: cleanup the codes related to h_chksum
Date: Sun, 26 May 2013 07:15:32 +0800
Message-Id: <1369523732-10649-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Since h_chksum field has gone away, we should cleanup the related codes

    [CC]    loggen
loggen.c: In function 'loggen_unmount':
loggen.c:137:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
loggen.c: In function 'loggen_empty':
loggen.c:205:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 src/loggen.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/src/loggen.c b/src/loggen.c
index 4b55667..522c917 100644
--- a/src/loggen.c
+++ b/src/loggen.c
@@ -134,7 +134,6 @@ loggen_unmount(int count)
     head->h_cycle = cpu_to_be32(param_cycle);
     head->h_version = cpu_to_be32(1);
     head->h_len = cpu_to_be32(20);
-    head->h_chksum = cpu_to_be32(0);
     head->h_prev_block = cpu_to_be32(-1);
     head->h_num_logops = cpu_to_be32(1);
     head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);
@@ -202,7 +201,6 @@ loggen_empty(int count)
                                                     sizeof(xfs_trans_header_t)+
                                                     sizeof(xfs_buf_log_format_t)+
                                                     sizeof(int));
-    head->h_chksum         = cpu_to_be32(0);
     head->h_prev_block     = cpu_to_be32(-1);
     head->h_num_logops     = cpu_to_be32(5);
     head->h_cycle_data[0]  = cpu_to_be32(0xb0c0d0d0);
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
