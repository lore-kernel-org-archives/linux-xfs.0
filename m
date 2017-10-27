Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752346AbdJ0Mzq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 08:55:46 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/2] ltp/fsx: allow comments when reading operations from logs
Date: Fri, 27 Oct 2017 20:53:56 +0800
Message-Id: <20171027125357.25222-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

We use '--replay-ops' option to replay operations in the specified
operation log file, but we're not allowed to add comments for the
operations in the log, which might be useful when writing regression
tests that replay a given sequence of operations.

Now treat lines starting with '#' as comments and skip them when
reading operations.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 ltp/fsx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 863d536e5a7b..9c358f27bd92 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1391,7 +1391,7 @@ read_op(struct log_entry *log_entry)
 				goto fail;
 			}
 			str = strtok(line, " \t\n");
-		} while (!str);
+		} while (!str || str[0] == '#');
 
 		if (strcmp(str, "skip") == 0) {
 			log_entry->flags |= FL_SKIPPED;
-- 
2.13.6

