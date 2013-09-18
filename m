Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20A387F50
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 04:40:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E979D8F8073
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 02:40:56 -0700 (PDT)
Received: from e28smtp03.in.ibm.com (e28smtp03.in.ibm.com [122.248.162.3]) by
	cuda.sgi.com with ESMTP id blI535EZD6ItKLWY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 02:40:55 -0700 (PDT)
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Wed, 18 Sep 2013 15:10:51 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id A8CCFE0056
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:11:44 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8I9ejoQ47710262
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:10:45 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8I9ekVF016110 for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:10:46 +0530
Message-ID: <1379497242.5874.7.camel@ThinkPad-T5421>
Subject: [PATCH] xfsprogs: fix potential memory leak in repare/sb.c
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Wed, 18 Sep 2013 17:40:42 +0800
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

Following Resource leak is reported by coverity:
  
CID 997011 (#1 of 1): Resource leak (RESOURCE_LEAK)6. leaked_storage:
Variable "buf" going out of scope leaks the storage it points to.
505                return(XR_EOF);

Add a free(buf) to solve it. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 repair/sb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/repair/sb.c b/repair/sb.c
index e2f5933..aa550e3 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -502,6 +502,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 		do_warn(
 	_("error reading superblock %u -- seek to offset %" PRId64 " failed\n"),
 			agno, off);
+		free(buf);
 		return(XR_EOF);
 	}
 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
