Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E741D7F58
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 05:39:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D59EF8F8050
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 03:39:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0VBoLxevoqfuw7fU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 03:39:51 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 07/11] xfsprogs: change nftw64 to nftw
Date: Thu,  3 Sep 2015 12:39:44 +0200
Message-Id: <1441276784-23701-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-7-git-send-email-jtulak@redhat.com>
References: <1440590555-20463-7-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

Changelog:
 - Subject was "add nftw64 translation for OS X"
 - Changed from #define to renaming

There is only one usage of nftw64 in entire xfsprogs, but
multiple usages of nftw. It seems the 64 variant has no reason,
and causes difficulties with some other platforms which has
only nftw call.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 estimate/xfs_estimate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 65b7168..632e4ec 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -168,7 +168,7 @@ main(int argc, char **argv)
 		ndirs=0LL;		/* number of directories */
 		nspecial=0LL;		/* number of special files */
 
-		nftw64(argv[optind], ffn, 40, FTW_PHYS | FTW_MOUNT);
+		nftw(argv[optind], ffn, 40, FTW_PHYS | FTW_MOUNT);
 
 		if (__debug) {
 			printf(_("dirsize=%llu\n"), dirsize);
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
