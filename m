Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975ECC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Jul 2022 10:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiGQKF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jul 2022 06:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGQKF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jul 2022 06:05:27 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4335013EA3
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jul 2022 03:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=nOD1Lbw00hn7yUi85T
        TRt2sHmBn8uePC7RTdYvGWxq0=; b=KOUl+RMkpyxbMm/3yprd24qL8um7Q99r1c
        j+biP0xPvGQzcvxav8VPgucvwZZiCVgUUmeyFTA74RXeb4Cx/rqBtcUoWe9v2jXY
        pyjr1CiMiprlDhKstdBHZ+hM0Bro++EtO1qF2V7cX6B2tPYK22ewXWKop9YOFJgU
        tfxSsH1yM=
Received: from DESKTOP-AP0PFB7.localdomain (unknown [111.30.213.137])
        by smtp7 (Coremail) with SMTP id DsmowAD3OvrQ3tNiohOMFA--.20115S2;
        Sun, 17 Jul 2022 18:05:06 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        allison.henderson@oracle.com, hexiaole@kylinos.cn,
        Xiaole He <hexiaole1994@126.com>
Subject: [PATCH v1] xfs: fix comment for start time value of inode with bigtime enabled
Date:   Sun, 17 Jul 2022 18:04:31 +0800
Message-Id: <1658052271-522-1-git-send-email-hexiaole1994@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DsmowAD3OvrQ3tNiohOMFA--.20115S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur1UWrW5XryUXF1kXryDtrb_yoW5uFy7p3
        92k3ZY9rZ8WF1Svrn7Aw1qqa4xt393Jr429FykWw12yw1UGa18Zr1Ikr4Fg3ZrWF4vvry8
        ZFyfXr1UW398Z3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zEyxRQUUUUU=
X-Originating-IP: [111.30.213.137]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbijhNBBlpEGVl6wQAAs-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The 'ctime', 'mtime', and 'atime' for inode is the type of
'xfs_timestamp_t', which is a 64-bit type:

/* fs/xfs/libxfs/xfs_format.h begin */
typedef __be64 xfs_timestamp_t;
/* fs/xfs/libxfs/xfs_format.h end */

When the 'bigtime' feature is disabled, this 64-bit type is splitted
into two parts of 32-bit, one part is encoded for seconds since
1970-01-01 00:00:00 UTC, the other part is encoded for nanoseconds
above the seconds, this two parts are the type of
'xfs_legacy_timestamp' and the min and max time value of this type are
defined as macros 'XFS_LEGACY_TIME_MIN' and 'XFS_LEGACY_TIME_MAX':

/* fs/xfs/libxfs/xfs_format.h begin */
struct xfs_legacy_timestamp {
        __be32          t_sec;          /* timestamp seconds */
        __be32          t_nsec;         /* timestamp nanoseconds */
};
 #define XFS_LEGACY_TIME_MIN     ((int64_t)S32_MIN)
 #define XFS_LEGACY_TIME_MAX     ((int64_t)S32_MAX)
/* fs/xfs/libxfs/xfs_format.h end */
/* include/linux/limits.h begin */
 #define U32_MAX         ((u32)~0U)
 #define S32_MAX         ((s32)(U32_MAX >> 1))
 #define S32_MIN         ((s32)(-S32_MAX - 1))
/* include/linux/limits.h end */

'XFS_LEGACY_TIME_MIN' is the min time value of the
'xfs_legacy_timestamp', that is -(2^31) seconds relative to the
1970-01-01 00:00:00 UTC, it can be converted to human-friendly time
value by 'date' command:

/* command begin */
[root@~]# date --utc -d '@0' +'%Y-%m-%d %H:%M:%S'
1970-01-01 00:00:00
[root@~]# date --utc -d "@`echo '-(2^31)'|bc`" +'%Y-%m-%d %H:%M:%S'
1901-12-13 20:45:52
[root@~]#
/* command end */

When 'bigtime' feature is enabled, this 64-bit type becomes a 64-bit
nanoseconds counter, with the start time value is the min time value of
'xfs_legacy_timestamp'(start time means the value of 64-bit nanoseconds
counter is 0). We have already caculated the min time value of
'xfs_legacy_timestamp', that is 1901-12-13 20:45:52 UTC, but the comment
for the start time value of inode with 'bigtime' feature enabled writes
the value is 1901-12-31 20:45:52 UTC:

/* fs/xfs/libxfs/xfs_format.h begin */
/*
 * XFS Timestamps
 * ==============
 * When the bigtime feature is enabled, ondisk inode timestamps become an
 * unsigned 64-bit nanoseconds counter.  This means that the bigtime inode
 * timestamp epoch is the start of the classic timestamp range, which is
 * Dec 31 20:45:52 UTC 1901. ...
 ...
 */
/* fs/xfs/libxfs/xfs_format.h end */

That is a typo, and this patch corrects the typo, from 'Dec 31' to
'Dec 13'.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
---
 fs/xfs/libxfs/xfs_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index afdfc81..b55bdfa 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -704,7 +704,7 @@ struct xfs_agfl {
  * When the bigtime feature is enabled, ondisk inode timestamps become an
  * unsigned 64-bit nanoseconds counter.  This means that the bigtime inode
  * timestamp epoch is the start of the classic timestamp range, which is
- * Dec 31 20:45:52 UTC 1901.  Because the epochs are not the same, callers
+ * Dec 13 20:45:52 UTC 1901.  Because the epochs are not the same, callers
  * /must/ use the bigtime conversion functions when encoding and decoding raw
  * timestamps.
  */
-- 
1.8.3.1

