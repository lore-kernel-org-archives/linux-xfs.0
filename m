Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 327658068
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:23:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECA1D8F80C7
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:23:14 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id y9QGhi8fY4dHft3A (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:23:13 -0800 (PST)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02YJVA8KUIC0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:21:56 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 03/11] xfsprogs: mkfs: fix unintentional integer overflow
Date: Wed, 02 Dec 2015 16:49:19 +0530
Message-id: <1449055167-19936-4-git-send-email-t.vivek@samsung.com>
In-reply-to: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
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
Cc: Vivek Trivedi <t.vivek@samsung.com>, a.sahrawat@samsung.com, pankaj.m@samsung.com

Fix unintentional integer overflow  in mkfs.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7cba41a..e540c48 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2033,7 +2033,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		/* check that rswidth is a multiple of fs blocksize */
 		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
 			rswidth = DTOBT(rswidth);
-			rtextbytes = rswidth << blocklog;
+			rtextbytes = (__uint64_t)rswidth << blocklog;
 			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
 			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
 				rtextblocks = rswidth;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
