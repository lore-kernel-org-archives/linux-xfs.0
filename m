Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751592AbdKKRWE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Nov 2017 12:22:04 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 57DF27EBDB
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 17:22:04 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63D0E12A40
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 17:22:03 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH 2/3] xfsprogs: fix wrong do_pwritev definition
Date: Sun, 12 Nov 2017 01:21:54 +0800
Message-Id: <20171111172155.31941-2-zlang@redhat.com>
In-Reply-To: <20171111172155.31941-1-zlang@redhat.com>
References: <20171111172155.31941-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

In io/pwrite.c, if not define HAVE_PWRITEV, we will use:
  #define do_pwritev(fd, offset, count, buffer_size) (0)

But the real do_pwritev() function is:
  do_pwritev(fd, offset, count, buffer_size, pwritev2_flags);

There's one more 'pwritev2_flags' argument.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 io/pwrite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index 3df976a8..a89edfd0 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -102,7 +102,7 @@ do_pwritev(
 	return bytes;
 }
 #else
-#define do_pwritev(fd, offset, count, buffer_size) (0)
+#define do_pwritev(fd, offset, count, buffer_size, pwritev2_flags) (0)
 #endif
 
 static ssize_t
-- 
2.13.6

