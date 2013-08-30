Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE4927F5D
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 12:10:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD8138F8049
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 10:09:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xe8YThHBbqhsKFCg for
	<xfs@oss.sgi.com>; Fri, 30 Aug 2013 10:09:56 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7UH9tAh026787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 13:09:55 -0400
Received: from orion.redhat.com (ovpn-113-170.phx2.redhat.com [10.3.113.170])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with
	ESMTP id r7UH9re0018355
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 13:09:54 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V3] mkfs: add noalign option to usage()
Date: Fri, 30 Aug 2013 14:09:50 -0300
Message-Id: <1377882590-22852-1-git-send-email-cmaiolino@redhat.com>
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
V3: Aligned the option together with another alignment options to make mutual
    exclusive options more visible


Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4bdacee..b0c3ce5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3032,7 +3032,7 @@ usage( void )
 /* blocksize */		[-b log=n|size=num]\n\
 /* metadata */		[-m crc=[0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
-			    (sunit=value,swidth=value|su=num,sw=num),\n\
+			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectlog=n|sectsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
