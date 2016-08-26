Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 148997CD8
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 03:30:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9B29304039
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 01:30:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MieUacdNmSiHCCev (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 01:30:33 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9E33C1634
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 08:30:32 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_quota: fix missing break after foreign_allowed option
Date: Fri, 26 Aug 2016 16:30:06 +0800
Message-Id: <1472200206-15728-1-git-send-email-zlang@redhat.com>
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

New quota "-f" has been brought in by:

  29647c8 xfs_quota: add capabilities for use on non-XFS filesystems

But Coverity Scan find a missing break in quota/init.c: init()
function.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 quota/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/quota/init.c b/quota/init.c
index 44be322..2c18c8b 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -153,6 +153,7 @@ init(
 			break;
 		case 'f':
 			foreign_allowed = true;
+			break;
 		case 't':
 			mtab_file = optarg;
 			break;
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
