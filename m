Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D16A7CC7
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 01:13:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D8D68F8040
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:13:03 -0700 (PDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
	[209.85.192.194]) by cuda.sgi.com with ESMTP id
	FaFqXeYsNUd3z7yV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:13:01 -0700 (PDT)
Received: by mail-pf0-f194.google.com with SMTP id u190so34030692pfb.2
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:13:01 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 6/8] block: bio: remove BIO_MAX_SECTORS
Date: Tue, 22 Mar 2016 14:12:27 +0800
Message-Id: <1458627149-12988-7-git-send-email-ming.lei@canonical.com>
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

No one need this macro, so remove it. The motivation is
for supporting multipage bvecs, in which we only know
what the max count of bvecs is supported in the bio,
instead of max size or max sectors.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/bvec_iter.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/bvec_iter.h b/include/linux/bvec_iter.h
index 5798c21..a979690 100644
--- a/include/linux/bvec_iter.h
+++ b/include/linux/bvec_iter.h
@@ -24,7 +24,6 @@
 
 #define BIO_MAX_PAGES		256
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
-#define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
 /*
  * various member access, note that bio_data should of course not be used
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
