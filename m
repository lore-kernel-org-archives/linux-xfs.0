Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 228B07F52
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 01:45:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9D9EAC001
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 23:45:45 -0700 (PDT)
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141]) by
	cuda.sgi.com with ESMTP id WU3L2Enw8Nc2A3V3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 23:45:44 -0700 (PDT)
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Thu, 26 Sep 2013 16:45:42 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 6DE952CE8051
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:45:36 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8Q6jPRg4129118
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:45:25 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r8Q6jZRq002585 for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:45:35 +1000
Message-ID: <1380177932.2983.11.camel@ThinkPad-T5421>
Subject: [PATCH v3 1/2] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 14:45:32 +0800
In-Reply-To: <5242F31B.4060902@sandeen.net>
References: <1379829679.4089.2.camel@ThinkPad-T5421>
	<5241E125.7010902@sgi.com> <1380094327.2526.5.camel@ThinkPad-T5421>
	<5242F31B.4060902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfsprogs <xfs@oss.sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>

If verify_set_primary_sb() completes the secondary sb scanning loop with
too few valid secondaries found (num_ok < num_sbs / 2), it will immediately
return without freeing any of the previously allocated memory (variables
sb, checked, and any items on the geo list).  This was reported by
the Coverity scanner as CID 997012, 997013 and 997014.

Fix this by using the out_free_list: goto target for this error case.

Earlier, if get_sb() fails in the secondary scan loop, it goes to
the out: target which does not free any items on the geo list.   Fix
this by using the out_free_list: target as well, and remove the now-unused
out: target.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
v2: as Mark pointed out, out in the for loop before also needs list to
 be freed. Also remove out lable as it is not referenced any more.
v3: use a meaningful changlog from Eric, and hide the patch changlogs below "---".

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
