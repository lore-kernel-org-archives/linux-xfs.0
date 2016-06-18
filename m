Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FA657CA0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 09:54:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 91904AC001
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:53:58 -0700 (PDT)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id SXZM1tMChDWNmdM3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:53:54 -0700 (PDT)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id C452B209DB
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 16:53:52 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3rX0W44NDwz5vN5
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 16:53:52 +0200 (CEST)
Date: Sat, 18 Jun 2016 16:52:38 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 1/4] Remove off64_t from linux.h
Message-ID: <20160618145238.GA17768@nyan>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

The off64_t type is usually only conditionally exposed under the
feature test macro _LARGEFILE64_SOURCE (also defined by _GNU_SOURCE).
To make the public xfs headers more standalone therefore off64_t should
be avoided.

Enable transparent large file support via configure so that the
standard off_t is the same as off64_t. Make compilation of linux
programs using libxfs but without large file support fail. Now off64_t
can safely be replaced by off_t in linux.h.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 configure.ac    | 2 ++
 include/linux.h | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index a4a6cfa..2ea3e50 100644
--- a/configure.ac
+++ b/configure.ac
@@ -107,6 +107,8 @@ AC_PACKAGE_UTILITIES(xfsprogs)
 AC_MULTILIB($enable_lib64)
 AC_RT($enable_librt)
 
+AC_SYS_LARGEFILE
+
 AC_PACKAGE_NEED_UUID_H
 AC_PACKAGE_NEED_UUIDCOMPARE
 
diff --git a/include/linux.h b/include/linux.h
index cc0f70c..b94de81 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -142,7 +142,12 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
 
-typedef off64_t		xfs_off_t;
+/* Make compilation fail when off_t has 32 bits */
+struct __xfs_assert_64bit_off_t {
+	int assert_64bit_off_t[sizeof(off_t)-8];
+};
+
+typedef off_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
