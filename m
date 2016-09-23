Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51310 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161434AbcIWTG6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 15:06:58 -0400
Date: Fri, 23 Sep 2016 20:06:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 08/11] cifs: don't use memcpy() to copy struct iov_iter
Message-ID: <20160923190655.GF2356@ZenIV.linux.org.uk>
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

it's not 70s anymore.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
[obviously should be separated; trivial cleanup almost unrelated to series]
 fs/cifs/file.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 579e41b..42b99af 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2478,7 +2478,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 	size_t cur_len;
 	unsigned long nr_pages, num_pages, i;
 	struct cifs_writedata *wdata;
-	struct iov_iter saved_from;
+	struct iov_iter saved_from = *from;
 	loff_t saved_offset = offset;
 	pid_t pid;
 	struct TCP_Server_Info *server;
@@ -2489,7 +2489,6 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		pid = current->tgid;
 
 	server = tlink_tcon(open_file->tlink)->ses->server;
-	memcpy(&saved_from, from, sizeof(struct iov_iter));
 
 	do {
 		unsigned int wsize, credits;
@@ -2551,8 +2550,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 			kref_put(&wdata->refcount,
 				 cifs_uncached_writedata_release);
 			if (rc == -EAGAIN) {
-				memcpy(from, &saved_from,
-				       sizeof(struct iov_iter));
+				*from = saved_from;
 				iov_iter_advance(from, offset - saved_offset);
 				continue;
 			}
@@ -2576,7 +2574,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_writedata *wdata, *tmp;
 	struct list_head wdata_list;
-	struct iov_iter saved_from;
+	struct iov_iter saved_from = *from;
 	int rc;
 
 	/*
@@ -2597,8 +2595,6 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (!tcon->ses->server->ops->async_writev)
 		return -ENOSYS;
 
-	memcpy(&saved_from, from, sizeof(struct iov_iter));
-
 	rc = cifs_write_from_iter(iocb->ki_pos, iov_iter_count(from), from,
 				  open_file, cifs_sb, &wdata_list);
 
@@ -2631,13 +2627,11 @@ restart_loop:
 			/* resend call if it's a retryable error */
 			if (rc == -EAGAIN) {
 				struct list_head tmp_list;
-				struct iov_iter tmp_from;
+				struct iov_iter tmp_from = saved_from;
 
 				INIT_LIST_HEAD(&tmp_list);
 				list_del_init(&wdata->list);
 
-				memcpy(&tmp_from, &saved_from,
-				       sizeof(struct iov_iter));
 				iov_iter_advance(&tmp_from,
 						 wdata->offset - iocb->ki_pos);
 
-- 
2.9.3

