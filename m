Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4479E7CAE
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 09:54:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16ABF30404E
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:54:25 -0700 (PDT)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 226YA186CyDFMJKc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:54:23 -0700 (PDT)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 6F5B9209F6
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 16:54:21 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3rX0Wd238Pz5vMs
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 16:54:21 +0200 (CEST)
Date: Sat, 18 Jun 2016 16:53:07 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 3/4] Make workaround for old glibc getsubopt() glibc-specific
Message-ID: <20160618145307.GC17768@nyan>
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

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux.h b/include/linux.h
index f6d0f80..873b682 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -132,7 +132,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
-#if (__GLIBC__ < 2) || ((__GLIBC__ == 2) && (__GLIBC_MINOR__ <= 1))
+#if defined(__GLIBC__) && ((__GLIBC__ < 2) || ((__GLIBC__ == 2) && (__GLIBC_MINOR__ <= 1)))
 # define getsubopt(p, s, v)	getsubopt(p, (const char * const *)s, v)
 #endif
 
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
