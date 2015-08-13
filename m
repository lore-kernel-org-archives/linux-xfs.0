Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1DA97F7C
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 10:07:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9062430405F
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 08:07:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Be6o8xY3bKDnDp4m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 08:07:49 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id D07D24C67C
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 15:07:48 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH][RFC] xfs_copy: don't use DIRECT IO to copy 4k sector device
Date: Thu, 13 Aug 2015 23:07:45 +0800
Message-Id: <1439478465-14072-1-git-send-email-zlang@redhat.com>
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
Cc: Zorro Lang <zlang@redhat.com>

When I run xfstests xfs/032 in ppc64le, I hit a failure:

     xfs_copy: read failed: Invalid argument
     xfs_copy: size check failed
     xfs_copy: /dev/sda5 filesystem failed to initialize
     xfs_copy: Aborting.
     Copy failed for Sector size 4096 Block size 4096

I try to use gdb trace xfs_copy. I find it try to open the
source device with DIRECT flag, then read the device with
((1<<BBSHIFT))=512 bytes length. If the source device is
4k sector, directly read 512 bytes will be failed.

xfs_copy '-b' option only work for target file/device, to
sure it will open the target without DIRECT flag. But useless
for source device open.

So I make DIRECT flag only be enabled when source device
sector size equal BBSIZE.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

I'm not so familiar for xfsprogs, so I'm not sure this's the best
idea to fix this problem. Please help to check, and maybe give me
better suggestions.

Thanks very much,
Zorro Lang

 copy/xfs_copy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index e13f468..1cd6253 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -666,7 +666,6 @@ main(int argc, char **argv)
 	/* prepare the libxfs_init structure */
 
 	memset(&xargs, 0, sizeof(xargs));
-	xargs.isdirect = LIBXFS_DIRECT;
 	xargs.isreadonly = LIBXFS_ISREADONLY;
 
 	if (source_is_file)  {
@@ -689,6 +688,8 @@ main(int argc, char **argv)
 			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
+	if (sb->sb_sectsize == BBSIZE)
+		xargs.isdirect = LIBXFS_DIRECT;
 
 	/* Do it again, now with proper length and verifier */
 	libxfs_putbuf(sbp);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
