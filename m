Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EABF929E06
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 14:02:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E59C98F8049
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:45 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 4nGarKBgFzUdo6Ze (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:44 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 28E6420A88
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:43 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg2rM0C5jz5vMH
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:43 +0100 (CET)
Date: Tue, 12 Jan 2016 21:00:08 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 5/6] include/linux.h: Include <stdio.h> for fprintf and stderr
Message-ID: <20160112200008.GF568@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452627740.git.felix.janda@posteo.de>
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
 include/linux.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux.h b/include/linux.h
index 4872a1e..a4acedc 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -29,6 +29,7 @@
 #include <errno.h>
 #include <endian.h>
 #include <stdbool.h>
+#include <stdio.h>
 #include <asm/types.h>
 #include <mntent.h>
 
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
