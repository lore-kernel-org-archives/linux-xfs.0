Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B1997CBE
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 01:01:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4A2FC8F804B
	for <xfs@oss.sgi.com>; Sat, 21 Sep 2013 23:01:31 -0700 (PDT)
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142]) by
	cuda.sgi.com with ESMTP id LQ1PWXK1sd5jx1e4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Sep 2013 23:01:29 -0700 (PDT)
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Sun, 22 Sep 2013 16:01:26 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id B70D42CE8051
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 16:01:23 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8M61CE77471576
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 16:01:12 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8M61NFm009113 for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 16:01:23 +1000
Message-ID: <1379829679.4089.2.camel@ThinkPad-T5421>
Subject: [PATCH] xfsprogs: fix potential memory leak in verify_set_primary_sb()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Sun, 22 Sep 2013 14:01:19 +0800
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

This patch tries to fix CID 997012, 997013 and 997014 reported by Coverity scan,
as suggested by sekharan.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 repair/sb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index aa550e3..7abf47c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -756,8 +756,10 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 	/*
 	 * see if we have enough superblocks to bother with
 	 */
-	if (num_ok < num_sbs / 2)
-		return(XR_INSUFF_SEC_SB);
+	if (num_ok < num_sbs / 2) {
+		retval = XR_INSUFF_SEC_SB;
+		goto out_free_list;
+	}
 
 	current = get_best_geo(list);
 
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
