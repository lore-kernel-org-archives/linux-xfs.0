Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D02F7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 17:00:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 356568F80DF
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 15:00:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P4dBiut92xxFEBHp for
	<xfs@oss.sgi.com>; Mon, 16 Sep 2013 15:00:40 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8GM0dgw020353
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 18:00:39 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8GM0b3R018660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 18:00:39 -0400
Message-ID: <52377F85.70104@redhat.com>
Date: Mon, 16 Sep 2013 17:00:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix fsstress usage() output
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

The show_ops() output should come as part of the -f option
help.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 711ea9a..ef7ecfe 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1499,8 +1499,8 @@ usage(void)
 	printf("   -e errtg         specifies error injection stuff\n");
 	printf("   -f op_name=freq  changes the frequency of option name to freq\n");
 	printf("                    the valid operation names are:\n");
-	printf("   -i filenum       get verbose output for this nth file object\n");
 	show_ops(-1, "                        ");
+	printf("   -i filenum       get verbose output for this nth file object\n");
 	printf("   -m modulo        uid/gid modulo for chown/chgrp (default 32)\n");
 	printf("   -n nops          specifies the no. of operations per process (default 1)\n");
 	printf("   -p nproc         specifies the no. of processes (default 1)\n");

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
