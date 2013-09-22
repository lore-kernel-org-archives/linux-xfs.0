Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D76C27F37
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 01:46:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0E5F8F8050
	for <xfs@oss.sgi.com>; Sat, 21 Sep 2013 23:46:02 -0700 (PDT)
Received: from e28smtp03.in.ibm.com (e28smtp03.in.ibm.com [122.248.162.3]) by
	cuda.sgi.com with ESMTP id u3pDyoEo1YX6E8bB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Sep 2013 23:46:01 -0700 (PDT)
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Sun, 22 Sep 2013 12:15:58 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 2875C3940058
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 12:15:41 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8M6mBrZ38469832
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 12:18:11 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8M6jths021940 for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 12:15:55 +0530
Message-ID: <1379832353.4089.10.camel@ThinkPad-T5421>
Subject: [PATCH] xfsprogs: fix potential memory free issues in
	quota_group_type()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Sun, 22 Sep 2013 14:45:53 +0800
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

This patch tries to fix CID 997009 reported by Coverity scan, as 
suggested by sekharan

If getgroups() fails, gids might be malloced, and overwritten with &gid.
So the free() at the end of the function is trying to free a variable on
the stack, while the pointer to the allocated memory is lost. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 quota/quota.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/quota/quota.c b/quota/quota.c
index 7e52ad2..ae9b156 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -292,7 +292,8 @@ quota_group_type(
 	} else if ( ((ngroups = sysconf(_SC_NGROUPS_MAX)) < 0) ||
 		    ((gids = malloc(ngroups * sizeof(gid_t))) == NULL) ||
 		    ((ngroups = getgroups(ngroups, gids)) < 0)) {
-		dofree = (gids != NULL);
+		if (gids)
+			free(gids);
 		gid = getgid();
 		gids = &gid;
 		ngroups = 1;
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
