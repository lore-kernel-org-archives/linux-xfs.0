Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 42C4D7F55
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 11:03:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 31DF68F8035
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 09:03:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bGmAvZdeZU4azjCk for
	<xfs@oss.sgi.com>; Thu, 29 Aug 2013 09:03:15 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7TG3E8G021807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 12:03:14 -0400
Received: from orion.redhat.com (ovpn-113-170.phx2.redhat.com [10.3.113.170])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id r7TG3DtF021624
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 12:03:14 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] mkfs: add noalign option to usage()
Date: Thu, 29 Aug 2013 13:03:10 -0300
Message-Id: <1377792190-21220-1-git-send-email-cmaiolino@redhat.com>
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

Although it has been added to manpage, there is no information about the
existence of noalign option into the usage().

Changelog:

V2: Remove space in comma separated options

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4bdacee..ef1d758 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3033,7 +3033,7 @@ usage( void )
 /* metadata */		[-m crc=[0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num),\n\
-			    sectlog=n|sectsize=num\n\
+			    noalign,sectlog=n|sectsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1]\n\
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
