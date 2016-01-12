Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B3817F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:10:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D83CA8F8040
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:10:50 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 6M5PXp0ciuEQtz6p (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:10:49 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id C72392097C
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:10:47 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg4Lv4YyDz5vND
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:10:47 +0100 (CET)
Date: Tue, 12 Jan 2016 22:08:10 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 1/6] invutil/invidx: include <fcntl.h> for O_CREAT
Message-ID: <20160112210810.GB10044@nyan>
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
 invutil/invidx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/invutil/invidx.c b/invutil/invidx.c
index 67efdf7..82d89d9 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -20,6 +20,7 @@
 #include <xfs/jdm.h>
 
 #include <stdio.h>
+#include <fcntl.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <ncurses.h>
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
