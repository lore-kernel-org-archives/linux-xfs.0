Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E1787CAE
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 11:18:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00B998F8054
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:18:03 -0700 (PDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
	[209.85.192.194]) by cuda.sgi.com with ESMTP id
	LgruQ0cocMiQNhxi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:18:01 -0700 (PDT)
Received: by mail-pf0-f194.google.com with SMTP id q129so7983634pfb.3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:18:01 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 8/8] block: bio: remove BIO_MAX_SIZE
Date: Thu, 31 Mar 2016 00:17:17 +0800
Message-Id: <1459354637-17415-9-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
References: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
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
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <ming.lei@canonical.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

No one need this macro now, so remove it. The motivation is
for supporting multipage bvecs, in which we only know
what the max count of bvecs is supported in the bio,
instead of max bio size.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/bio.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4f76252..c6d13db 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -42,7 +42,6 @@
 #endif
 
 #define BIO_MAX_PAGES		256
-#define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 
 /*
  * upper 16 bits of bi_rw define the io priority of this bio
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
