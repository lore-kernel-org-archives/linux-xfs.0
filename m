Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 912647F3F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 02:32:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8053B8F804C
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 00:32:50 -0700 (PDT)
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145]) by
	cuda.sgi.com with ESMTP id y9cCkbb4WHB1nHu7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 00:32:32 -0700 (PDT)
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Wed, 25 Sep 2013 17:32:13 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 7A2FC3578052
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 17:32:11 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8P7FMNe53215366
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 17:15:22 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r8P7WA6J029119 for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 17:32:10 +1000
Message-ID: <1380094327.2526.5.camel@ThinkPad-T5421>
Subject: [PATCH v2] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Wed, 25 Sep 2013 15:32:07 +0800
In-Reply-To: <5241E125.7010902@sgi.com>
References: <1379829679.4089.2.camel@ThinkPad-T5421> <5241E125.7010902@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

This patch tries to fix CID 997012, 997013 and 997014 reported by Coverity scan,
as suggested by sekharan.

v2: as Mark pointed out, out in the for loop before also needs list to
be freed. Also remove out lable as it is not referenced any more.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 repair/sb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index aa550e3..d34d7a2 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -733,7 +733,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 
 			if (get_sb(sb, off, size, agno) == XR_EOF)  {
 				retval = 1;
-				goto out;
+				goto out_free_list;
 			}
 
 			if (verify_sb(sb, 0) == XR_OK)  {
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
 
@@ -841,7 +843,6 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 
 out_free_list:
 	free_geo(list);
-out:
 	free(sb);
 	free(checked);
 	return(retval);
-- 
1.8.1.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
