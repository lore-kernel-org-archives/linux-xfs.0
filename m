Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13050C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jul 2022 10:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiGOKyM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jul 2022 06:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGOKyG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jul 2022 06:54:06 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C4DA1FCC5
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jul 2022 03:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=48KFT00s0AH1seBt2/
        M48Eyrdfe3wXifHTc2MJ94Grw=; b=klAQrj87IukaGQvgJMp5+oQswY3aESLBTx
        EJdggCjY+op6EkrZSqGl8KGToaHN/B1lVvz2QSub/9v08a/sE5syIENc+12uu1yn
        nSqnniYldo9D6/RH5xbVxNAQEjod4BQdztGxFsuOuPnZmW1oKDmhG/VvGQvjJhaL
        f4fC/lwAc=
Received: from DESKTOP-AP0PFB7.localdomain (unknown [111.32.104.70])
        by smtp2 (Coremail) with SMTP id DMmowAA3nflFR9FiLSmyEw--.56341S2;
        Fri, 15 Jul 2022 18:53:59 +0800 (CST)
From:   hexiaole <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     hexiaole@kylinos.cn
Subject: [PATCH v1 1/2] xfsdocs: fix inode timestamps lower limit value
Date:   Fri, 15 Jul 2022 18:53:46 +0800
Message-Id: <1657882427-96-1-git-send-email-hexiaole1994@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DMmowAA3nflFR9FiLSmyEw--.56341S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr17Zw1xGr1Dur4ftFyfCrg_yoW5ur17p3
        yv9F10gFZ5JFn2vwnrAF4DWrWakr1vyrnFkFy8C34a9w1UGF4Ikr1ftrWav345WrZ3uFy5
        ZF4vqr1UuayDZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U-IDcUUUUU=
X-Originating-IP: [111.32.104.70]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbiOwc-BlpEGzoQ+AAAsS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: hexiaole <hexiaole@kylinos.cn>

1. Fix description
In kernel source tree 'fs/xfs/libxfs/xfs_format.h', there defined inode timestamps as 'xfs_legacy_timestamp' if the 'bigtime' feature disabled, and also defined the min and max time constants 'XFS_LEGACY_TIME_MIN' and 'XFS_LEGACY_TIME_MAX':

/* fs/xfs/libxfs/xfs_format.h begin */
struct xfs_legacy_timestamp {
        __be32          t_sec;          /* timestamp seconds */
        __be32          t_nsec;         /* timestamp nanoseconds */
};
/* fs/xfs/libxfs/xfs_format.h end */
/* include/linux/limits.h begin */
/* include/linux/limits.h end */

When the 't_sec' and 't_nsec' are 0, the time value it represents is 1970-01-01 00:00:00 UTC, the 'XFS_LEGACY_TIME_MIN', that is -(2^31), represents the min
second offset relative to the 1970-01-01 00:00:00 UTC, it can be converted to human-friendly time value by 'date' command:

/* command begin */
[root@DESKTOP-G0RBR07 sources]# date --utc -d "@`echo '-(2^31)'|bc`" +'%Y-%m-%d %H:%M:%S'
1901-12-13 20:45:52
[root@DESKTOP-G0RBR07 sources]#
/* command end */

That is, the min time value is 1901-12-13 20:45:52 UTC, but the 'design/XFS_Filesystem_Structure/timestamps.asciidoc' write the min time value as 'The smalle
st date this format can represent is 20:45:52 UTC on December 31st', there should be a typo, and this patch correct 2 places of wrong min time value, from '3
1st' to '13st'.

2. Question
In the section 'Quota Timers' of 'design/XFS_Filesystem_Structure/timestamps.asciidoc':

/* timestamps.asciidoc begin */
With the introduction of the bigtime feature, the ondisk field now encodes the upper 32 bits of an unsigned 34-bit seconds counter.
...
The smallest quota expiration date is now 00:00:04 UTC on January 1st, 1970;
and the largest is 20:20:24 UTC on July 2nd, 2486.
/* timestamps.asciidoc end */

It seems hard to understand the the relationship among the '32 bits of an unsigned 34-bit seconds counter', '00:00:04 UTC on January 1st, 1970', and 00:00:04 UTC on January 1st, 1970', is it there a typo for '34-bit' and the expected one is '64-bit'?
---
 design/XFS_Filesystem_Structure/timestamps.asciidoc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/timestamps.asciidoc b/design/XFS_Filesystem_Structure/timestamps.asciidoc
index 08baa1e..56d4dc9 100644
--- a/design/XFS_Filesystem_Structure/timestamps.asciidoc
+++ b/design/XFS_Filesystem_Structure/timestamps.asciidoc
@@ -26,13 +26,13 @@ struct xfs_legacy_timestamp {
 };
 ----
 
-The smallest date this format can represent is 20:45:52 UTC on December 31st,
+The smallest date this format can represent is 20:45:52 UTC on December 13st,
 1901, and the largest date supported is 03:14:07 UTC on January 19, 2038.
 
 With the introduction of the bigtime feature, the format is changed to
 interpret the timestamp as a 64-bit count of nanoseconds since the smallest
 date supported by the old encoding.  This means that the smallest date
-supported is still 20:45:52 UTC on December 31st, 1901; but now the largest
+supported is still 20:45:52 UTC on December 13st, 1901; but now the largest
 date supported is 20:20:24 UTC on July 2nd, 2486.
 
 [[Quota_Timers]]
-- 
2.27.0

