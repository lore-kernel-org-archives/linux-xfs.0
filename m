Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C18C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Oct 2021 22:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A834361177
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Oct 2021 22:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJEWen (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Oct 2021 18:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhJEWen (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Oct 2021 18:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5599B61152;
        Tue,  5 Oct 2021 22:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633473172;
        bh=90TKLCQ9v/sdYs/JGtOVT7aCqNvgy6PaA9iK33m8a3k=;
        h=Date:From:To:Cc:Subject:From;
        b=T5AjYFBJ4yLaRbheQiqZbODTUXOm8pV4hhUHq9ziB5a9tHa+YxsOHs6CZSI3tY/kd
         /lOThOsdn027fw9GvCAlOOQ/nugWR5d8x2Wqj7//hEZW1i+QJUCZhkLASidN9tvSpQ
         B/oPez+BFd3ukBb0XYf/nfQi1PyQM4swf4UguIpbm/yuaZUm9Y+ucj1/SimEzyIHRm
         SmTWeZn2Vmxf1NDUNuZEKL0hv+vfCd5VLpHm2yv/fuIey1rYZ7pPlJoW5XPrewYmDd
         pSxcPJocktcA+LpfINeFxxVzBeao14kkkh7qR8m18Y0B4CWVFdPMhLpzKeBMzisRvd
         Pt5rjCVlNRe5g==
Date:   Tue, 5 Oct 2021 15:32:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: fix crash on second attempt to initialize library
Message-ID: <20211005223252.GF24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs_repair crashes when it tries to initialize the libxfs library but
the initialization fails because the fs is already mounted:

# xfs_repair /dev/sdd
xfs_repair: /dev/sdd contains a mounted filesystem
xfs_repair: urcu.c:553: urcu_memb_register_thread: Assertion `!URCU_TLS(rcu_reader).registered' failed.
Aborted

This is because libxfs_init() registers the main thread with liburcu,
but doesn't unregister the thread if libxfs library initialization
fails.  When repair sets more dangerous options and tries again, the
second initialization attempt causes liburcu to abort.  Fix this by
unregistering the thread with liburcu if libxfs initialization fails.

Observed by running xfs/284.

Fixes: e4da1b16 ("xfsprogs: introduce liburcu support")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index d0753ce5..14911596 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -407,8 +407,10 @@ libxfs_init(libxfs_init_t *a)
 		unlink(rtpath);
 	if (fd >= 0)
 		close(fd);
-	if (!rval)
+	if (!rval) {
 		libxfs_close_devices(a);
+		rcu_unregister_thread();
+	}
 
 	return rval;
 }
