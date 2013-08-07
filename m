Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C57B7F5A
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 05:10:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA96CAC009
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 03:10:52 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id a0PkOky8VwoOnznQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Aug 2013 03:10:51 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Wed, 7 Aug 2013 06:10:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 4F5F938C8039
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 06:10:47 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r77AAmcZ152222 for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 06:10:48 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r77AAlwm001946 for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 07:10:48 -0300
From: zwu.kernel@gmail.com
Subject: [PATCH 12/12] xfs: rename bio_add_buffer() to xfs_bio_add_buffer()
Date: Wed,  7 Aug 2013 18:11:09 +0800
Message-Id: <1375870269-13157-13-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
References: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Follow up with xfs naming style.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 596ec71..b724002 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -451,7 +451,7 @@ xfs_start_page_writeback(
 		end_page_writeback(page);
 }
 
-static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)
+static inline int xfs_bio_add_buffer(struct bio *bio, struct buffer_head *bh)
 {
 	return bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
 }
@@ -525,7 +525,7 @@ xfs_submit_ioend(
 				goto retry;
 			}
 
-			if (bio_add_buffer(bio, bh) != bh->b_size) {
+			if (xfs_bio_add_buffer(bio, bh) != bh->b_size) {
 				xfs_submit_ioend_bio(wbc, ioend, bio);
 				goto retry;
 			}
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
