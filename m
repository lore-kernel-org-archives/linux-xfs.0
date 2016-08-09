Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D49C57CA2
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 13:04:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95B958F8037
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 11:04:12 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id DZ3dXJg3SUebqygI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 11:04:10 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id A452620B3B
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 20:04:08 +0200 (CEST)
Date: Tue, 9 Aug 2016 20:03:20 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCHv2 xfsprogs 13/14] xfs.h: require transparent LFS
Message-ID: <20160809180320.GB4476@nyan>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<3be2b10b0037406374a415fda2318cbf95a67546.1470555003.git.felix.janda@posteo.de>
	<20160809074138.GO25647@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809074138.GO25647@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Since our interfaces depend on the consistent use of a 64bit offset
type, force downstreams to use transparent LFS (_FILE_OFFSET_BITS=64),
so that it becomes impossible for them to use 32bit interfaces.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
Christoph Hellwig wrote:
> > +extern int xfs_assert_largefile[sizeof(off_t)-8];
> 
> Please add a comment on why we have this declaration, otherwise this
> looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

A simple comment is added.
---
 include/xfs.h | 5 ++
 1 file changed, 5 insertions(+)

diff --git a/include/xfs.h b/include/xfs.h
index 7bed957..37c95fe 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -47,6 +47,11 @@
 # error unknown platform... have fun porting!
 #endif
 
+/*
+ * make sure that any user of the xfs headers has a 64bit off_t type
+ */
+extern int xfs_assert_largefile[sizeof(off_t)-8];
+
 /*
  * sparse kernel source annotations
  */
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
