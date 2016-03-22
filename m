Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10A197CD1
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 01:13:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7D088F8039
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:13:10 -0700 (PDT)
Received: from mail-pf0-f195.google.com (mail-pf0-f195.google.com
	[209.85.192.195]) by cuda.sgi.com with ESMTP id
	pEiueVTyk2Etf4qh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:13:08 -0700 (PDT)
Received: by mail-pf0-f195.google.com with SMTP id x3so33963220pfb.0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:13:08 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 8/8] block: bio: remove BIO_MAX_SIZE
Date: Tue, 22 Mar 2016 14:12:29 +0800
Message-Id: <1458627149-12988-9-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
References: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
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
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <ming.lei@canonical.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

No one need this macro now, so remove it. The motivation is
for supporting multipage bvecs, in which we only know
what the max count of bvecs is supported in the bio,
instead of max bio size.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/bvec_iter.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/bvec_iter.h b/include/linux/bvec_iter.h
index a979690..8ddaacf 100644
--- a/include/linux/bvec_iter.h
+++ b/include/linux/bvec_iter.h
@@ -23,7 +23,6 @@
 #include <linux/blk_types.h>
 
 #define BIO_MAX_PAGES		256
-#define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 
 /*
  * various member access, note that bio_data should of course not be used
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
