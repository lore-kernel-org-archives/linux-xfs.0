Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33347 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdH3Ovg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:36 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 11/14] replay-log: output log replay offset in verbose mode
Date: Wed, 30 Aug 2017 17:51:43 +0300
Message-Id: <1504104706-11965-12-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

This helps exporting the recorded log to an image file using dd.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/log-writes/log-writes.c | 8 +++++---
 src/log-writes/replay-log.c | 6 ++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
index fa4f3f3..ba66a5c 100644
--- a/src/log-writes/log-writes.c
+++ b/src/log-writes/log-writes.c
@@ -158,12 +158,14 @@ int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
 		}
 	}
 
-	if (log_writes_verbose)
-		printf("replaying %d: sector %llu, size %llu, flags %llu\n",
-		       (int)log->cur_entry - 1,
+	if (log_writes_verbose) {
+		offset = lseek(log->logfd, 0, SEEK_CUR);
+		printf("replaying %d@%llu: sector %llu, size %llu, flags %llu\n",
+		       (int)log->cur_entry - 1, offset / log->sectorsize,
 		       (unsigned long long)le64_to_cpu(entry->sector),
 		       (unsigned long long)size,
 		       (unsigned long long)le64_to_cpu(entry->flags));
+	}
 	if (!size)
 		return 0;
 
diff --git a/src/log-writes/replay-log.c b/src/log-writes/replay-log.c
index 759c3c7..87c03a2 100644
--- a/src/log-writes/replay-log.c
+++ b/src/log-writes/replay-log.c
@@ -284,8 +284,10 @@ int main(int argc, char **argv)
 			num_entries++;
 			if ((run_limit && num_entries == run_limit) ||
 			    should_stop(entry, stop_flags, end_mark)) {
-				printf("%llu\n",
-				       (unsigned long long)log->cur_entry - 1);
+				off_t offset = lseek(log->logfd, 0, SEEK_CUR);
+
+				printf("%llu@%llu\n",
+				       (unsigned long long)log->cur_entry - 1, offset / log->sectorsize);
 				log_free(log);
 				return 0;
 			}
-- 
2.7.4

