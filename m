Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4B9C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFF220717
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLRQkJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:40:09 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:40215 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfLRQkJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 11:40:09 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MRTIx-1iMu9G3WSb-00NRZ9; Wed, 18 Dec 2019 17:39:55 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Allison Collins <allison.henderson@oracle.com>,
        Nick Bowler <nbowler@draconx.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] xfs: rename compat_time_t to old_time32_t
Date:   Wed, 18 Dec 2019 17:39:28 +0100
Message-Id: <20191218163954.296726-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:E9mF7OYDn9JyQwrHLT+pY4Y1q8BDrhiycRQ3Ygb25o5lMFAbgML
 r8VIN8pCIoF2EG1eS0sqGdFs16ROCCbwJCM4eSC/EYLBG0P6ZOPrM+WDns2LZkHEOt6dKVZ
 KigR86K6jd1IXB9Is8ld5PoRU9RZXPkHIF0Ikm07i5N+v7aolUwAq5o8tcWHEe2Aa88Ttmy
 llvpZ3Q1tHfVjtUL7sAfw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7cATP4CSdSk=:f9D6xz2FFGd7zqBrEqzNNr
 25DzUk6VbJWMouHADDk631BIoq1VL5PSh7hi6MN7wfep+gWhhjEucBFmXuR2bO/5OCMvY4mta
 vqgKF5AmsMkxvawUCqaQx9jqlJYt+V0c40DieoYHeHf9vAficZdjykAMQi1lEz7IsTNnfqKFC
 /TMI42qGT8keVFBCOH12cYI6rMio/a0LVhxBntLzfQbCqgPdqzc2+v0ZyE/PZ7kHc204eXCmH
 bVIMh9B04C8NF1hVACl+DoJt9N2f0tWqd7CqzDkzS+BMWZVzCzr09i4m55OonYvDPGoegMKBm
 ZS7rWzAqtE1AITyw5o6qk/cphSQaBc/7tQzq7UnsXkgCCo9kZsno4XJdeh5+hnkIlX2Ob4wJX
 RajGiL1S3Kv35a3gUDWFM8zdebH4mahgIsiZGUIkOKeiBHfbiL1G9VyGq0QSTbRnSHM5x+SQi
 mHVSlXEaCQ39FQVNDnBpUJRRlssjqUHB9ShEY3V8+j19mYM0hnRGqAShlC+fo3QJXfDe4CGlM
 TfhaUyhamZXOXWxHWrFajja0AaRBC3L0vLcbJE4hS5kn1BGLng2eLIdq3gLwR457YQKuZh04O
 D7x6Wbf7HocsfpQu2rOdNz9uV3KHehT/U7FnUHY7FcNNXKARfZgRf8GOHj/zc6teMnBwp1k9o
 Ngk6ivNWG315zPJL7eah7wniA6dIDSAQXeXMgf6p5/QOWfpB5l+vV6k/lp8gpQ6mLSXyIKiAS
 B0NPEgoYzzGoK1y+rI4p/pShuZcq0fMxeraEw/VyuYarTKmEP3YlNUnzzkYY2A37KPWbwOTBW
 v4KERGsd9uBcow2SO2fhq7ww64iL5AdyKwz7i1X0lQhBkxO8+1QRZjn7l5nQyxZFmQpH3fTxd
 fVGYeDs4N4d/GOxBRhYQ==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The compat_time_t type has been removed everywhere else,
as most users rely on old_time32_t for both native and
compat mode handling of 32-bit time_t.

Remove the last one in xfs.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_ioctl32.c | 2 +-
 fs/xfs/xfs_ioctl32.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c4c4f09113d3..a49bd80b2c3b 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -107,7 +107,7 @@ xfs_ioctl32_bstime_copyin(
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

