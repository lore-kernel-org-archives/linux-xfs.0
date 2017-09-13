Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbdIMLar (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Sep 2017 07:30:47 -0400
From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2] xfs_repair: don't use do_warn for normal log message
Date: Wed, 13 Sep 2017 20:30:44 +0900
Message-Id: <20170913113044.23081-1-yamato@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: yamato@redhat.com

In some case, exit statuses of xfs_repair -n are different even for the
same file system when -v is specified or not. This patch fixes this
behavior.

If -v is specified, do_warn() is used in zero_log() for printing
a normal message. That makes the exit status to 1 though there
is no dirtiness in the file system.

The original zero_log():

	error = xlog_find_tail(log, &head_blk, &tail_blk);
	if (error) {...
	} else {
		if (verbose) {
			do_warn(
	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
				head_blk, tail_blkn);
		}

do_warn() is used for the message, "zero_log:...".  do_log
should be used instead because this log message is for just reporting the
values of head_blk, and tail_blk. do_log is for "just reporting".

Using do_warn unintentionally has an impact.
It causes the exit status of the command.
do_warn sets fs_is_dirty global variable.
That refers in main function to decide the exit status.

    void
    do_warn(char const *msg, ...)
    {
	    va_list args;

	    fs_is_dirty = 1;

    int
    main(int argc, char **argv)
    {
    ...

		    if (fs_is_dirty)
			    return(1);

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 Please, ignore the original patch I submitted a few minutes ago.
 The change is applied to wrong if/else block in the original patch.
 
 repair/phase2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/phase2.c b/repair/phase2.c
index c21778b8..850cd99e 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -86,7 +86,7 @@ zero_log(
 			exit(2);
 	} else {
 		if (verbose) {
-			do_warn(
+			do_log(
 	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
 				head_blk, tail_blk);
 		}
-- 
2.13.5

