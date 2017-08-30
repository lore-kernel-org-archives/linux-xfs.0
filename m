Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37964 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbdH3Ovi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:38 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 12/14] replay-log: add support for replaying ops in target device sector range
Date: Wed, 30 Aug 2017 17:51:44 +0300
Message-Id: <1504104706-11965-13-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Using command line options --start-sector and --end-sector, only
operations acting on the specified target device range will be
replayed.

Single vebbose mode (-v) prints out only replayed operations.
Double verbose mode (-vv) prints out also skipped operations.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/log-writes/log-writes.c | 33 +++++++++++++++++++++++++++++++--
 src/log-writes/log-writes.h |  2 ++
 src/log-writes/replay-log.c | 31 +++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
index ba66a5c..d832c2a 100644
--- a/src/log-writes/log-writes.c
+++ b/src/log-writes/log-writes.c
@@ -119,6 +119,24 @@ int log_discard(struct log *log, struct log_write_entry *entry)
 
 /*
  * @log: the log we are replaying.
+ * @entry: entry to be replayed.
+ *
+ * @return: 0 if we should replay the entry, > 0 if we should skip it.
+ *
+ * Should we skip the entry in our log or replay onto the replay device.
+ */
+int log_should_skip(struct log *log, struct log_write_entry *entry)
+{
+	if (!entry->nr_sectors)
+		return 0;
+	if (entry->sector + entry->nr_sectors < log->start_sector ||
+	    entry->sector > log->end_sector)
+		return 1;
+	return 0;
+}
+
+/*
+ * @log: the log we are replaying.
  * @entry: where we put the entry.
  * @read_data: read the entry data as well, entry must be log->sectorsize sized
  * if this is set.
@@ -137,6 +155,7 @@ int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
 	char *buf;
 	ssize_t ret;
 	off_t offset;
+	u64 skip = 0;
 
 	if (log->cur_entry >= log->nr_entries)
 		return 1;
@@ -158,9 +177,11 @@ int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
 		}
 	}
 
-	if (log_writes_verbose) {
+	skip = log_should_skip(log, entry);
+	if (log_writes_verbose > 1 || (log_writes_verbose && !skip)) {
 		offset = lseek(log->logfd, 0, SEEK_CUR);
-		printf("replaying %d@%llu: sector %llu, size %llu, flags %llu\n",
+		printf("%s %d@%llu: sector %llu, size %llu, flags %llu\n",
+		       skip ? "skipping" : "replaying",
 		       (int)log->cur_entry - 1, offset / log->sectorsize,
 		       (unsigned long long)le64_to_cpu(entry->sector),
 		       (unsigned long long)size,
@@ -173,6 +194,14 @@ int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
 	if (flags & LOG_DISCARD_FLAG)
 		return log_discard(log, entry);
 
+	if (skip) {
+		if (lseek(log->logfd, size, SEEK_CUR) == (off_t)-1) {
+			fprintf(stderr, "Error seeking in log: %d\n", errno);
+			return -1;
+		}
+		return 0;
+	}
+
 	buf = malloc(size);
 	if (!buf) {
 		fprintf(stderr, "Error allocating buffer %llu entry %llu\n", (unsigned long long)size, (unsigned long long)log->cur_entry - 1);
diff --git a/src/log-writes/log-writes.h b/src/log-writes/log-writes.h
index 13f98ff..fc84acf 100644
--- a/src/log-writes/log-writes.h
+++ b/src/log-writes/log-writes.h
@@ -53,6 +53,8 @@ struct log {
 	int replayfd;
 	unsigned long flags;
 	u64 sectorsize;
+	u64 start_sector;
+	u64 end_sector;
 	u64 nr_entries;
 	u64 cur_entry;
 	u64 max_zero_size;
diff --git a/src/log-writes/replay-log.c b/src/log-writes/replay-log.c
index 87c03a2..971974b 100644
--- a/src/log-writes/replay-log.c
+++ b/src/log-writes/replay-log.c
@@ -20,6 +20,8 @@ enum option_indexes {
 	FSCK,
 	CHECK,
 	START_MARK,
+	START_SECTOR,
+	END_SECTOR,
 };
 
 static struct option long_options[] = {
@@ -37,6 +39,8 @@ static struct option long_options[] = {
 	{"fsck", required_argument, NULL, 0},
 	{"check", required_argument, NULL, 0},
 	{"start-mark", required_argument, NULL, 0},
+	{"start-sector", required_argument, NULL, 0},
+	{"end-sector", required_argument, NULL, 0},
 	{ NULL, 0, NULL, 0 },
 };
 
@@ -61,6 +65,12 @@ static void usage(void)
 		"--check\n");
 	fprintf(stderr, "\t--check [<number>|flush|fua] when to check the "
 		"file system, mush specify --fsck\n");
+	fprintf(stderr, "\t--start-sector <sector> - replay ops on region "
+		"from <sector> onto <device>\n");
+	fprintf(stderr, "\t--end-sector <sector> - replay ops on region "
+		"to <sector> onto <device>\n");
+	fprintf(stderr, "\t-v or --verbose - print replayed ops\n");
+	fprintf(stderr, "\t-vv - print also skipped ops\n");
 	exit(1);
 }
 
@@ -120,6 +130,8 @@ int main(int argc, char **argv)
 	struct log_write_entry *entry;
 	u64 stop_flags = 0;
 	u64 start_entry = 0;
+	u64 start_sector = 0;
+	u64 end_sector = -1ULL;
 	u64 run_limit = 0;
 	u64 num_entries = 0;
 	u64 check_number = 0;
@@ -240,6 +252,22 @@ int main(int argc, char **argv)
 				tmp = NULL;
 			}
 			break;
+		case START_SECTOR:
+			start_sector = strtoull(optarg, &tmp, 0);
+			if (tmp && *tmp != '\0') {
+				fprintf(stderr, "Invalid sector number\n");
+				exit(1);
+			}
+			tmp = NULL;
+			break;
+		case END_SECTOR:
+			end_sector = strtoull(optarg, &tmp, 0);
+			if (tmp && *tmp != '\0') {
+				fprintf(stderr, "Invalid sector number\n");
+				exit(1);
+			}
+			tmp = NULL;
+			break;
 		default:
 			usage();
 		}
@@ -257,6 +285,9 @@ int main(int argc, char **argv)
 	if (!discard)
 		log->flags |= LOG_IGNORE_DISCARD;
 
+	log->start_sector = start_sector;
+	log->end_sector = end_sector;
+
 	entry = malloc(log->sectorsize);
 	if (!entry) {
 		fprintf(stderr, "Couldn't allocate buffer\n");
-- 
2.7.4

