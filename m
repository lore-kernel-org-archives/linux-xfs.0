Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2A267F53
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:55:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDC6E304039
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:55:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ll9G0X5RHGqDtJWn for
	<xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:55:18 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7U3tHbk030925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 23:55:17 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r7U3tGb8022891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 23:55:17 -0400
Message-ID: <522017A4.8060400@redhat.com>
Date: Thu, 29 Aug 2013 22:55:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: avoid array overflow in pf_batch_read()
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

The while loop in pf_batch_read, and the code preceeding it, is really...
quite a thing.  I'd love to rewrite it, but I haven't yet found
a particularly cleaner way.

It cleverly hides the fact that we might increment "num" past the
last index of bplist[] and then assign to it.  This corrupts memory.

Rather than major surgery for now, just go for the simple fix,
and break out of the loop if we've increased "num" past the
last index.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 7529f5d..d3491da 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -429,6 +429,8 @@ pf_batch_read(
 			if (which != PF_META_ONLY ||
 			    !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
 				num++;
+			if (num == MAX_BUFS)
+				break;
 			bplist[num] = btree_lookup_next(args->io_queue, &fsbno);
 		}
 		if (!num)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
