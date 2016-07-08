Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D07F27CEC
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 14:32:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A5BFAC001
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 12:32:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 70rEWbvCLsGFOO0x (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jul 2016 12:32:19 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 0ACB95277F
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 19:32:19 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u68JWHk8012288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 8 Jul 2016 15:32:18 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: fix xfs_error_get_cfg for negative errnos
Message-ID: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
Date: Fri, 8 Jul 2016 14:32:17 -0500
MIME-Version: 1.0
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
To: xfs-oss <xfs@oss.sgi.com>

xfs_error_get_cfg() is called with bp->b_error as an arg,
which is negative, so the switch statement won't ever find
any matches.

This results in only the default error handler having
any effect, as EIO/ENOSPC/ENODEV get ignored due to the
wrong sign.

It seems simplest to always flip the error sign to positive,
so that we can handle either negative errors in bp->b_error,
or possibly a positive errno via something like
xfs_error_get_cfg(EIO) - this future-proofs the function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I'm still chasing down some odd behaviors in the error handling
patches but this seems worth sending now :)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 4c2c550..79cfd3f 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -634,6 +634,9 @@ xfs_error_get_cfg(
 {
 	struct xfs_error_cfg	*cfg;
 
+	if (error < 0)
+		error = -error;
+
 	switch (error) {
 	case EIO:
 		cfg = &mp->m_error_cfg[error_class][XFS_ERR_EIO];

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
