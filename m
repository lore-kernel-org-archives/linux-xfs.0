Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BA657F55
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 01:48:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5EE2AC001
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 23:48:21 -0700 (PDT)
Received: from e28smtp02.in.ibm.com (e28smtp02.in.ibm.com [122.248.162.2]) by
	cuda.sgi.com with ESMTP id jVb0Q1OjQH9GJC2F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 23:48:20 -0700 (PDT)
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Thu, 26 Sep 2013 12:18:17 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 166FE394003F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 12:17:59 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8Q6mCx049152088
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 12:18:12 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8Q6mExt001248 for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 12:18:14 +0530
Message-ID: <1380178092.2983.14.camel@ThinkPad-T5421>
Subject: [PATCH 2/2] xfsprogs: fix return value of verify_set_primary_sb()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 14:48:12 +0800
In-Reply-To: <1380177932.2983.11.camel@ThinkPad-T5421>
References: <1379829679.4089.2.camel@ThinkPad-T5421>
	<5241E125.7010902@sgi.com> <1380094327.2526.5.camel@ThinkPad-T5421>
	<5242F31B.4060902@sandeen.net>
	<1380177932.2983.11.camel@ThinkPad-T5421>
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

If get_sb() fails because of EOF, it will return with retval 1, which will
then be interpreted as XR_BAD_MAGIC("bad magic number") in phase1() when
warning the user.

This patch fix it by using XR_EOF here, so it would be interpreted correctly.
Also change the associated comments about the return value.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 repair/sb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index d34d7a2..2e35a4c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -665,7 +665,7 @@ get_sb_geometry(fs_geometry_t *geo, xfs_sb_t *sbp)
  * primary and compare the geometries in the secondaries against
  * the geometry indicated by the primary.
  *
- * returns 1 if bad, 0 if ok
+ * returns 0 if ok, else error code (XR_EOF, XR_INSUFF_SEC_SB, etc).
  */
 int
 verify_set_primary_sb(xfs_sb_t		*rsb,
@@ -732,7 +732,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 			checked[agno] = 1;
 
 			if (get_sb(sb, off, size, agno) == XR_EOF)  {
-				retval = 1;
+				retval = XR_EOF;
 				goto out_free_list;
 			}
 
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
