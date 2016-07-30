Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46F7C7CA1
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 08:37:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A29F304053
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 06:37:53 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id hhIND0YXmemxnHCH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 30 Jul 2016 06:37:52 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id F364220CA5
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 15:37:50 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s1mqy40B9z104t
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 15:37:50 +0200 (CEST)
Date: Sat, 30 Jul 2016 15:37:37 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160730133737.GB5895@nyan>
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

int64_t is guaranteed to have the correct size and signedness and is
always avaible because linux.h has a <inttypes.h> include.

Fixes compilation error "unkown type name 'off64_t'" on linux when the
public header <xfs.h> is included without _LARGEFILE64_SOURCE or
_GNU_SOURCE defined. This bug was introduced in commit
cb898f157f8410a03cf5f3400baa1df9e5eecd33.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux.h b/include/linux.h
index 5614719..7653cac 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -137,7 +137,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
 
-typedef off64_t		xfs_off_t;
+typedef int64_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
