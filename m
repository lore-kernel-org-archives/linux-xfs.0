Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8ECA7F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 05:14:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45DC1AC003
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 03:14:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SLYaw0hmdzNl89ZS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2015 03:14:27 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v3 07/11] xfsprogs: change nftw64 to nftw
Date: Wed,  9 Sep 2015 12:14:16 +0200
Message-Id: <1441793656-20260-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1441276784-23701-1-git-send-email-jtulak@redhat.com>
References: <1441276784-23701-1-git-send-email-jtulak@redhat.com>
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
 - changed ffn argument from stat64 to stat
 - Subject was "add nftw64 translation for OS X"
 - Changed from #define to renaming

There is only one usage of nftw64 in entire xfsprogs, but
multiple usages of nftw. It seems the 64 variant has no reason,
and causes difficulties with some other platforms which has
only nftw call.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 estimate/xfs_estimate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 65b7168..323137c 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -45,7 +45,7 @@ cvtnum(char *s)
 	return 0LL;
 }
 
-int ffn(const char *, const struct stat64 *, int, struct FTW *);
+int ffn(const char *, const struct stat *, int, struct FTW *);
 
 #define BLOCKSIZE	4096
 #define INODESIZE	256
@@ -168,7 +168,7 @@ main(int argc, char **argv)
 		ndirs=0LL;		/* number of directories */
 		nspecial=0LL;		/* number of special files */
 
-		nftw64(argv[optind], ffn, 40, FTW_PHYS | FTW_MOUNT);
+		nftw(argv[optind], ffn, 40, FTW_PHYS | FTW_MOUNT);
 
 		if (__debug) {
 			printf(_("dirsize=%llu\n"), dirsize);
@@ -214,7 +214,7 @@ main(int argc, char **argv)
 }
 
 int
-ffn(const char *path, const struct stat64 *stb, int flags, struct FTW *f)
+ffn(const char *path, const struct stat *stb, int flags, struct FTW *f)
 {
 	/* cases are in most-encountered to least-encountered order */
 	dirsize+=PERDIRENTRY+strlen(path);
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
