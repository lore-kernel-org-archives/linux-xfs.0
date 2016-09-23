Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51348 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161486AbcIWTII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 15:08:08 -0400
Date: Fri, 23 Sep 2016 20:08:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 09/11] fuse_ioctl_copy_user(): don't open-code
 copy_page_{to,from}_iter()
Message-ID: <20160923190806.GG2356@ZenIV.linux.org.uk>
References: <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160923190032.GA25771@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
[another cleanup, will be moved out of that branch]
 fs/fuse/file.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3988b43..4c1db6c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2339,31 +2339,15 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 
 	while (iov_iter_count(&ii)) {
 		struct page *page = pages[page_idx++];
-		size_t todo = min_t(size_t, PAGE_SIZE, iov_iter_count(&ii));
-		void *kaddr;
+		size_t copied;
 
-		kaddr = kmap(page);
-
-		while (todo) {
-			char __user *uaddr = ii.iov->iov_base + ii.iov_offset;
-			size_t iov_len = ii.iov->iov_len - ii.iov_offset;
-			size_t copy = min(todo, iov_len);
-			size_t left;
-
-			if (!to_user)
-				left = copy_from_user(kaddr, uaddr, copy);
-			else
-				left = copy_to_user(uaddr, kaddr, copy);
-
-			if (unlikely(left))
-				return -EFAULT;
-
-			iov_iter_advance(&ii, copy);
-			todo -= copy;
-			kaddr += copy;
-		}
+		if (!to_user)
+			copied = copy_page_from_iter(page, 0, PAGE_SIZE, &ii);
+		else
+			copied = copy_page_to_iter(page, 0, PAGE_SIZE, &ii);
 
-		kunmap(page);
+		if (unlikely(copied != PAGE_SIZE && iov_iter_count(&ii)))
+			return -EFAULT;
 	}
 
 	return 0;
-- 
2.9.3

