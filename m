Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10DE57F3F
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2014 11:10:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7BF1304084
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2014 09:10:29 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 1qPiOHUGaOGBDkPE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Mar 2014 09:10:24 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 81FF8ACD9
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2014 16:10:23 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfsprogs: add a missing QA header file to install-qa target
Date: Wed, 26 Mar 2014 17:10:21 +0100
Message-Id: <1395850221-7295-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

Included from "include/libxfs.h".

Signed-off-by: David Sterba <dsterba@suse.cz>
---

branch: master

 include/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/Makefile b/include/Makefile
index 6682b9dbc23e..a867516c8a6d 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -23,6 +23,7 @@ QAHFILES = libxfs.h libxlog.h \
 	swab.h \
 	xfs_ag.h xfs_alloc.h xfs_alloc_btree.h xfs_arch.h xfs_attr_leaf.h \
 	xfs_attr_sf.h xfs_bit.h xfs_bmap.h xfs_bmap_btree.h xfs_btree.h \
+	xfs_attr_remote.h \
 	xfs_btree_trace.h \
 	xfs_cksum.h \
 	xfs_da_btree.h \
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
