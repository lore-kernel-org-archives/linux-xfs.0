Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5CFC4D2C1
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C77CA246A9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfLMU5k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 15:57:40 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:55425 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMU5k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 15:57:40 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M2w0K-1ijAJy1eIO-003Mbu; Fri, 13 Dec 2019 21:57:30 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Nick Bowler <nbowler@draconx.ca>
Subject: [PATCH v2 19/24] xfs: rename compat_time_t to old_time32_t
Date:   Fri, 13 Dec 2019 21:53:47 +0100
Message-Id: <20191213205417.3871055-10-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zARXgYKok4zeFDeeiNI16bU/sUy4YFIaNYCQJhqKBzQvtO+A17j
 v4tP1EL/FypfHgRghMWum3GsKwt3bSsFh+LQlXfZ8b1QoXAeO/eXJeoUue+k/qwEXtW3KQt
 8CymFTBFACC8PMqkvogi/8JqezrnKFM7ZCyKZRi4H0KE11VQzGJsVCZgVf1eHP+T/QD+CG0
 QqYUBx+tj3Lzwj6dluayA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KuBqyk8mLpI=:DXXot5F8i3KR2QR2b5njA0
 C5sUb6IXLZGwy3iRjXzZtPcQ0bKQ98ph2rn+5bOAuE1WA2E+2DRWnJJwJBLnk7uF/5alcwxq4
 pw1I7k3cyzP0yWzHOgS58+gxZpIyQWP3bGUZZmYFdPuRnwOpIu/r2v8vUv5dNxfKiQwdi9cH0
 fjOQ0dEq8+9hs4nrEg1rfLtCebS0M6cjEiTK9Wrt3/1XHGqfDbFQTY3MUMMx1vhfBw/ya46HS
 8d55sKQU+FiWDcBt4fRWxUff/lKINLgvy3w49NzDtn1ZYAxMFYK0ExbRxoc9f/lsR++hpy/kM
 EzHD7K5n9vG2kY4S+oqQ+5Dbpo0JwcACUDE1GReG9NDvCoZvj7l2K3NSJjCCFHTh4mc875uvg
 2Z3ZPzuSPl8EFMO8SXyeuESMwXOVZCjqSY9YVkaBxJFPGg5Oq3N+3OWILmR44OvK/bioeHV/7
 cFeH0oJM0xLojwAFlNdyMi7s5bn7erLfG7ZzBfvKWxbxT4u+jZYvHS4E+Wof/p+yQOi+eKhEZ
 InFbWlGZu0VLsmLuu8Gbxtkz+dbyEegQ6pzqR3Dgp3boxgCVmksoKok2pTcahOlUXGxH+kUUa
 T1+NbB2FCuUBTv7ig9jXs1q11ukMR8Q0lOL3NaWSZXipJGyCIAE3kZloJ+P1Mch6AUh4DSuEt
 NgFYm0LS/edpWjeMa+I0kb6ujA0GaoeoIqc4ruiaB49lzL6HlHKoaAO/gCWIFg+2X6mf8E9ZE
 CaO9gEtvqhPOkkWKJM3kbSyN9/TssF0J8NS0KTjcdpuNPSALWSGojoK/MpKxCsC52LDfHOnlz
 fACIRYflX0kBmHe8Va1nfHfCblPXXBBPcFy8WX5anhd0ChMO8MavG4yqDO9KqJObrVIcJssKB
 csAnZVpQ8ahGdl4jO+Sg==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The compat_time_t type has been removed everywhere else,
as most users rely on old_time32_t for both native and
compat mode handling of 32-bit time_t.

Remove the last one in xfs.

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

