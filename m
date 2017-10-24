Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751336AbdJXRp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 13:45:28 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C16AC7F7B0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 17:45:28 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9210C60A99
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 17:45:28 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: add a writepage delay error injection tag
Date: Tue, 24 Oct 2017 13:45:27 -0400
Message-Id: <20171024174527.58767-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The XFS ->writepage() cached mapping is racy in that the mapping can
change as a result of external factors after it has been looked up
and cached. If the current write_cache_pages() instance has to
handle subsequent pages over the affected mapping, writeback can
submit I/O to the wrong place, causing data loss and possibly
corruption in the process.

To support the ability to manufacture this problem and effectively
regression test it from userspace, introduce an error injection tag
that triggers a fixed delay during ->writepage(). The delay occurs
immediately after a mapping is cached. Once userspace triggers
writeback, the delay provides userspace with a five second window to
perform other operations on the file to attempt to invalidate the
mapping.

Note that this tag is intended to be used by xfstests rather than
for generic error handling testing. The lifetime of this tag should
be tethered to the existence of targeted regression tests for the
writepage mapping validity problem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

I'm posting this as an RFC for now because I'd like to try and see if
there's a reproducer for this that doesn't rely on error injection. I
need to think about that a bit more. In the meantime, I wanted to post
this as a POC for the associated problem. This does indeed confirm that
it's still possible to send I/O off to the wrong place outside the
eofblocks variant of the problem that was previously fixed (and more
easily reproduced).

I'll post the assocated xfstests test that demonstrates this problem in
reply to this patch. The test reproduces about 50% of the time on my
test vm.

Thoughts, reviews, flames appreciated.

Brian

 fs/xfs/xfs_aops.c  | 9 +++++++++
 fs/xfs/xfs_error.c | 3 +++
 fs/xfs/xfs_error.h | 4 +++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a3eeaba..802e030 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -967,6 +967,15 @@ xfs_writepage_map(
 				goto out;
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
 							 offset);
+			/*
+			 * The writepage delay injection tag is for userspace
+			 * imap validiation testing purposes. The delay allows
+			 * userspace some time to try and invalidate wpc->imap
+			 * immediately after it is cached.
+			 */
+			if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
+					   XFS_ERRTAG_WRITEPAGE_DELAY))
+				ssleep(5);
 		}
 		if (wpc->imap_valid) {
 			lock_buffer(bh);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index eaf86f5..36072e6 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_DROP_WRITES,
 	XFS_RANDOM_LOG_BAD_CRC,
 	XFS_RANDOM_LOG_ITEM_PIN,
+	XFS_RANDOM_WRITEPAGE_DELAY,
 };
 
 struct xfs_errortag_attr {
@@ -163,6 +164,7 @@ XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
 XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
+XFS_ERRORTAG_ATTR_RW(writepage_delay,	XFS_ERRTAG_WRITEPAGE_DELAY);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -196,6 +198,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(drop_writes),
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
 	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
+	XFS_ERRORTAG_ATTR_LIST(writepage_delay),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 7c4bef3..17556b3 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -107,7 +107,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
 #define XFS_ERRTAG_LOG_ITEM_PIN				30
-#define XFS_ERRTAG_MAX					31
+#define XFS_ERRTAG_WRITEPAGE_DELAY			31
+#define XFS_ERRTAG_MAX					32
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -143,6 +144,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_DROP_WRITES				1
 #define XFS_RANDOM_LOG_BAD_CRC				1
 #define XFS_RANDOM_LOG_ITEM_PIN				1
+#define XFS_RANDOM_WRITEPAGE_DELAY			1
 
 #ifdef DEBUG
 extern int xfs_errortag_init(struct xfs_mount *mp);
-- 
2.9.5

