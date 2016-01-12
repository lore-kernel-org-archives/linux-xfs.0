Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA4BA29E00
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:11:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CC0AAC004
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:11:13 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id zBoB6uoTWQC3Cv38 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:11:12 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id DAAF4209B3
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:11:10 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg4ML55fgz5vN3
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:11:10 +0100 (CET)
Date: Tue, 12 Jan 2016 22:08:35 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 4/6] librmt/rmtopen: Prefer <signal.h> over <sys/signal.h>
Message-ID: <20160112210835.GE10044@nyan>
References: <cover.1452632647.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452632647.git.felix.janda@posteo.de>
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
 librmt/rmtopen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index 4bf9383..09ba3e4 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -27,7 +27,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
-#include <sys/signal.h>
+#include <signal.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
