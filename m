Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E16C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Jul 2022 10:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiGQKIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jul 2022 06:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGQKIE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jul 2022 06:08:04 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9173413E89
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jul 2022 03:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=FG7tcR7jBpiA+XaruR
        yyfNjIPg0ef1Rv14/2qenuc2o=; b=Wkq/LVvXRAwBH2iTgCkPVGN005DpY/AKXH
        auNdC/cBfJNzQCBP7EnXAwD6MeucZMbtLXdVCYfbwHXRzQRF5NxicH8OGJSQg53T
        5Navlwh2mhvC6eE2N7ydZXWXKonPL4VgWClvjIBxwzRnAkmQn7kVTFw3pduuKO5N
        KQu69YFI4=
Received: from DESKTOP-AP0PFB7.localdomain (unknown [111.30.213.137])
        by smtp1 (Coremail) with SMTP id C8mowACXmydp39Ni3z6qGw--.44659S2;
        Sun, 17 Jul 2022 18:07:38 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, sandeen@redhat.com,
        Xiaole He <hexiaole1994@126.com>,
        Xiaole He <hexiaole@kylinos.cn>
Subject: [PATCH v2 1/2] xfsdocs: fix inode timestamps lower limit value
Date:   Sun, 17 Jul 2022 18:07:28 +0800
Message-Id: <1658052449-567-1-git-send-email-hexiaole1994@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: C8mowACXmydp39Ni3z6qGw--.44659S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr1rXw4kur4fuw1DCFy7Awb_yoW5ArWDp3
        929F109rZ8JF4xAwsrAF4DWrW3Kr1qyrnrKFy8u342vw1DGa1jvr1Skr4ak343WrZ3CFyU
        ZFsYqr4UuayUZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRHmhwUUUUU=
X-Originating-IP: [111.30.213.137]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbijhNBBlpEGVl6wgABs9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In kernel source tree 'fs/xfs/libxfs/xfs_format.h', there defined inode
timestamps as 'xfs_legacy_timestamp' if the 'bigtime' feature disabled,
and also defined the min and max time constants 'XFS_LEGACY_TIME_MIN'
and 'XFS_LEGACY_TIME_MAX' as below:

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

When the 't_sec' and 't_nsec' are 0, the time value it represents is
1970-01-01 00:00:00 UTC, the 'XFS_LEGACY_TIME_MIN', that is -(2^31),
represents the min second offset relative to the
1970-01-01 00:00:00 UTC, it can be converted to human-friendly time
value by 'date' command:

/* command begin */
[root@~]# date --utc -d '@0' +'%Y-%m-%d %H:%M:%S'
1970-01-01 00:00:00
[root@~]# date --utc -d "@`echo '-(2^31)'|bc`" +'%Y-%m-%d %H:%M:%S'
1901-12-13 20:45:52
[root@~]#
/* command end */

That is, the min time value is 1901-12-13 20:45:52 UTC, but the
'design/XFS_Filesystem_Structure/timestamps.asciidoc' write the min
time value as 'The smalle st date this format can represent is
20:45:52 UTC on December 31st', there should be a typo, and this patch
correct 2 places of wrong min time value, from '31st' to '13st'.

Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
---
V1 -> V2: Wrap line at 72 column, add Signed-off-by, add one more 
'date' command for explanation, remove the question section.

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
1.8.3.1

