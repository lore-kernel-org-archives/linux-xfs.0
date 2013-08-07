Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7487B7F72
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 05:10:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 635D68F80BA
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 03:10:40 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id KQukKPdzBW1MLjSP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Aug 2013 03:10:39 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Wed, 7 Aug 2013 06:10:38 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id D48A938C8039
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 06:10:35 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r77AAbgK164266 for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 06:10:37 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r77AAarx021174 for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 06:10:37 -0400
From: zwu.kernel@gmail.com
Subject: [PATCH 09/12] xfs: remove two unused macro definitions in xfs_linux.h
Date: Wed,  7 Aug 2013 18:11:06 +0800
Message-Id: <1375870269-13157-10-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
References: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
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

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_linux.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 800f896..84063ad 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -114,8 +114,6 @@
 #define xfs_inherit_sync	xfs_params.inherit_sync.val
 #define xfs_inherit_nodump	xfs_params.inherit_nodump.val
 #define xfs_inherit_noatime	xfs_params.inherit_noatim.val
-#define xfs_buf_timer_centisecs	xfs_params.xfs_buf_timer.val
-#define xfs_buf_age_centisecs	xfs_params.xfs_buf_age.val
 #define xfs_inherit_nosymlinks	xfs_params.inherit_nosym.val
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
