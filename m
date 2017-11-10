Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755255AbdKJBRo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 20:17:44 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2BA6CC0587DE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2017 01:17:44 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-55.pek2.redhat.com [10.72.12.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5152D60F87
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2017 01:17:43 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfsprogs: fix wrong variable type in write_once function
Date: Fri, 10 Nov 2017 09:17:37 +0800
Message-Id: <20171110011737.4089-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The 'Coverity Scan' found a problem in new write_once() function:

272             size_t bytes;
273             bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
>>>     CID 1420710:  Control flow issues  (NO_EFFECT)
>>>     This less-than-zero comparison of an unsigned value is never true. "bytes < 0UL".
274             if (bytes < 0)
275                     return -1;

That's unreasonable. do_pwrite return 'ssize_t' type value, which can
be less than zero, but we use a 'size_t' to get the return value. So
change the size_t to ssize_t for it can store the return value
correctly.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 io/pwrite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index 26f79579..b28b6039 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -269,7 +269,7 @@ write_once(
 	long long	*total,
 	int		pwritev2_flags)
 {
-	size_t bytes;
+	ssize_t bytes;
 	bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
 	if (bytes < 0)
 		return -1;
-- 
2.13.6

