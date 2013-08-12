Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCD417F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 01:11:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A051AC004
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:11:16 -0700 (PDT)
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147]) by
	cuda.sgi.com with ESMTP id YcLiffgn9EAhxcaY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 23:11:11 -0700 (PDT)
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Mon, 12 Aug 2013 16:04:09 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 845D02BB0053
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 16:11:05 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7C6As0b62914646
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 16:10:54 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r7C6B4nO014424 for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 16:11:04 +1000
Message-ID: <1376287861.2822.13.camel@ThinkPad-T5421>
Subject: [PATCH] xfsprogs: fix Out-of-bounds access in repair/dinode.c
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Mon, 12 Aug 2013 14:11:01 +0800
Mime-Version: 1.0
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
To: xfsprogs <xfs@oss.sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Following is reported by coverity in bug 1061528:

187                        __dirty_no_modify_ret(dirty);

CID 1061528 (#1 of 1): Out-of-bounds access (OVERRUN)53. overrun-buffer-arg: Overrunning array "dinoc->di_pad" of 6 bytes by passing it to a function which accesses it at byte offset 15 using argument "16UL".
188                        memset(dinoc->di_pad, 0, 16);

It seems that di_pad here should be di_pad2, as sekharan pointed out.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 repair/dinode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index e607f0b..94bf2f8 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -183,9 +183,9 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 	}
 
 	for (i = 0; i < 16; i++) {
-		if (dinoc->di_pad[i] != 0) {
+		if (dinoc->di_pad2[i] != 0) {
 			__dirty_no_modify_ret(dirty);
-			memset(dinoc->di_pad, 0, 16);
+			memset(dinoc->di_pad2, 0, 16);
 			break;
 		}
 	}
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
