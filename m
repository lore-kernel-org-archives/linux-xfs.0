Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBAEC2D0C2
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 20:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A87AE217F4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 20:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgABUlQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 15:41:16 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:37229 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgABUlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 15:41:15 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mhnnc-1jQpo31wJM-00dpmk; Thu, 02 Jan 2020 21:40:59 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>, y2038@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v3 1/2] xfs: rename compat_time_t to old_time32_t
Date:   Thu,  2 Jan 2020 21:40:45 +0100
Message-Id: <20200102204058.2005468-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Am5ZpQy974RBM1IMSacw41L4RnaQSGuNLcQlMxsJsyLcId6T1mY
 2kEgbyY3GdOOOo3/5wPngaqYQubNDl5xr4pieo9wsQDG/4qYpYkfLuVn6WHfRc3v8E4e+be
 tuC5WFzaXJtKDKdEwtXLINySy1ae1yvQFaRgvQZs2PCJld3/jBQxAT37Xhwk5tfI0cfrfYA
 ejlpXeFbTJqWHaKqDV1Pw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vDHbDrbHb6k=:iAjX+Np1HRh7wssxhbFJ+Z
 hRJSwbEO+6SR5o1kXVnUCvCKQ1i9DcALZeCqrcEVRP8MLHg1Rmgc/5+J+DKFwWMUi+t9y4J9V
 RwLysRwFd5CKFBoTBCpHRm6hfbJDQS15ZhXMucLh/f4Z+T3ngnn05VffaH0/as5pl9Bjm4NK6
 UQJmRWp2ae+ooeEZJrDKT9Ys8+ZpyEVoEcaN+CEU9/FCZ5BNud3d4dDzlzCSnwV5psvak88Sf
 bX48xFK1TjOonxazGTQlNNS7fZcqjcqgyXMRbwc19FtoXAgK9RDl9TmCGIM5V7krZdtOfWNtF
 uPKVbbIZBmvRLpO2hpcrDkeRUq1tf0mUgi6nCMPViT34xANvYqfWEuMyeW25xcMTbYYCRyjCZ
 fD/iRA3KXUzUU5PKzuPtLHIBw3/nesuasu5oE394FXleB8JTpZ6MRHvQDuyyGYNOU80R5a1r7
 jbSldkO9tM9Gfd8F6YNcu0Vw94a7bnflMtK/m/YbWSk//HeAWqnIOG3oqgSI+2GXz3HNp9LVr
 H+zkwljv2G0AJ5Lh2jsucDlljtrIl4pfI4HcziuNoUJHM1eSVpcyOzPsr5lsoLsmIfa1v0CPs
 Cqmr64JEgDZvhtnA37geR1nnLABfNlm8KmUIGIN4In7DhxNjrj0o7+tjZJsoGz9vfKyEW0yyW
 Cgm5wxBKebfQn63Uy8lXVC1ppMUT+RB9/JsfJg/Kk3EpgzPIxJYAeLaWUGxW1LDg0k2iWjy6k
 +70IorddsG8Sqq9Fd1vzSQNDTJy86021DKnitK2JnT0fM4IsYL8tDV5K/VMiy2g7WmGB0JB6N
 WrPQWOvO7boDy74yfBwFekjP8PjrHR58ReaNGG+TnfvLmh3Hy8TDjjhuGkCn/dJsEuvVe/wO8
 PW0uvtNCnbiunKr5YKHA==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The compat_time_t type has been removed everywhere else,
as most users rely on old_time32_t for both native and
compat mode handling of 32-bit time_t.

Remove the last one in xfs.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
As explained in https://www.spinics.net/lists/linux-xfs/msg35524.html
I've dropped the patch "xfs: disallow broken ioctls without
compat-32-bit-time" for this submission but will get to that later
when doing that as a treewide change.

Please apply these two for v5.6 in the meantime so we can kill off
compat_time_t, time_t and get_seconds() for good.

 fs/xfs/xfs_ioctl32.c | 2 +-
 fs/xfs/xfs_ioctl32.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index bd07a79ca3c0..9ab0263586da 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -108,7 +108,7 @@ xfs_ioctl32_bstime_copyin(
 	xfs_bstime_t		*bstime,
 	compat_xfs_bstime_t	__user *bstime32)
 {
-	compat_time_t		sec32;	/* tv_sec differs on 64 vs. 32 */
+	old_time32_t		sec32;	/* tv_sec differs on 64 vs. 32 */
 
 	if (get_user(sec32,		&bstime32->tv_sec)	||
 	    get_user(bstime->tv_nsec,	&bstime32->tv_nsec))
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index 8c7743cd490e..053de7d894cd 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -32,7 +32,7 @@
 #endif
 
 typedef struct compat_xfs_bstime {
-	compat_time_t	tv_sec;		/* seconds		*/
+	old_time32_t	tv_sec;		/* seconds		*/
 	__s32		tv_nsec;	/* and nanoseconds	*/
 } compat_xfs_bstime_t;
 
-- 
2.20.0

