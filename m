Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35750 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdH3Ovf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:35 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 10/14] log-writes: add replay-log program to replay dm-log-writes target
Date: Wed, 30 Aug 2017 17:51:42 +0300
Message-Id: <1504104706-11965-11-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Imported Josef Bacik's code from:
https://github.com/josefbacik/log-writes.git

Specialized program for replaying a write log that was recorded by
device mapper log-writes target.  The tools is used to perform
crash consistency tests, allowing to run an arbitrary check tool
(fsck) at specified checkpoints in the write log.

[Amir:]
- Add project Makefile and SOURCE files
- Document the replay-log auxiliary program

Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .gitignore                  |   1 +
 doc/auxiliary-programs.txt  |   8 +
 src/Makefile                |   2 +-
 src/log-writes/Makefile     |  23 +++
 src/log-writes/SOURCE       |   6 +
 src/log-writes/log-writes.c | 379 ++++++++++++++++++++++++++++++++++++++++++++
 src/log-writes/log-writes.h |  70 ++++++++
 src/log-writes/replay-log.c | 348 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 836 insertions(+), 1 deletion(-)
 create mode 100644 src/log-writes/Makefile
 create mode 100644 src/log-writes/SOURCE
 create mode 100644 src/log-writes/log-writes.c
 create mode 100644 src/log-writes/log-writes.h
 create mode 100644 src/log-writes/replay-log.c

diff --git a/.gitignore b/.gitignore
index fcbc0cd..c26c92f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -153,6 +153,7 @@
 /src/t_mmap_stale_pmd
 /src/t_mmap_cow_race
 /src/t_mmap_fallocate
+/src/log-writes/replay-log
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/doc/auxiliary-programs.txt b/doc/auxiliary-programs.txt
index bcab453..de15832 100644
--- a/doc/auxiliary-programs.txt
+++ b/doc/auxiliary-programs.txt
@@ -18,6 +18,7 @@ Contents:
  - af_unix		-- Create an AF_UNIX socket
  - dmerror		-- fault injection block device control
  - fsync-err		-- tests fsync error reporting after failed writeback
+ - log-writes/replay-log -- Replay log from device mapper log-writes target
  - open_by_handle	-- open_by_handle_at syscall exercise
  - stat_test		-- statx syscall exercise
  - t_dir_type		-- print directory entries and their file type
@@ -46,6 +47,13 @@ fsync-err
 	writeback and test that errors are reported during fsync and cleared
 	afterward.
 
+log-writes/replay-log
+
+	Specialized program for replaying a write log that was recorded by
+	device mapper log-writes target.  The tools is used to perform crash
+	consistency tests, allowing to run an arbitrary check tool (fsck) at
+	specified checkpoints in the write log.
+
 open_by_handle
 
 	The open_by_handle program exercises the open_by_handle_at() system
diff --git a/src/Makefile b/src/Makefile
index b8aff49..7d1306b 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -25,7 +25,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
 	dio-invalidate-cache stat_test t_encrypted_d_revalidate
 
-SUBDIRS =
+SUBDIRS = log-writes
 
 LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL) -lpthread
 
diff --git a/src/log-writes/Makefile b/src/log-writes/Makefile
new file mode 100644
index 0000000..d114177
--- /dev/null
+++ b/src/log-writes/Makefile
@@ -0,0 +1,23 @@
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+TARGETS = replay-log
+
+CFILES = replay-log.c log-writes.c
+LDIRT = $(TARGETS)
+
+default: depend $(TARGETS)
+
+depend: .dep
+
+include $(BUILDRULES)
+
+$(TARGETS): $(CFILES)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $(CFILES) -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+
+install:
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src/log-writes
+	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src/log-writes
+
+-include .dep
diff --git a/src/log-writes/SOURCE b/src/log-writes/SOURCE
new file mode 100644
index 0000000..d6d143c
--- /dev/null
+++ b/src/log-writes/SOURCE
@@ -0,0 +1,6 @@
+From:
+https://github.com/josefbacik/log-writes.git
+
+description	Helper code for dm-log-writes target
+owner	Josef Bacik <jbacik@fb.com>
+URL	https://github.com/josefbacik/log-writes.git
diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
new file mode 100644
index 0000000..fa4f3f3
--- /dev/null
+++ b/src/log-writes/log-writes.c
@@ -0,0 +1,379 @@
+#include <linux/fs.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+#include "log-writes.h"
+
+int log_writes_verbose = 0;
+
+/*
+ * @log: the log to free.
+ *
+ * This will close any open fd's the log has and free up its memory.
+ */
+void log_free(struct log *log)
+{
+	if (log->replayfd >= 0)
+		close(log->replayfd);
+	if (log->logfd >= 0)
+		close(log->logfd);
+	free(log);
+}
+
+static int discard_range(struct log *log, u64 start, u64 len)
+{
+	u64 range[2] = { start, len };
+
+	if (ioctl(log->replayfd, BLKDISCARD, &range) < 0) {
+		if (log_writes_verbose)
+			printf("replay device doesn't support discard, "
+			       "switching to writing zeros\n");
+		log->flags |= LOG_DISCARD_NOT_SUPP;
+	}
+	return 0;
+}
+
+static int zero_range(struct log *log, u64 start, u64 len)
+{
+	u64 bufsize = len;
+	ssize_t ret;
+	char *buf = NULL;
+
+	if (log->max_zero_size < len) {
+		if (log_writes_verbose)
+			printf("discard len %llu larger than max %llu\n",
+			       (unsigned long long)len,
+			       (unsigned long long)log->max_zero_size);
+		return 0;
+	}
+
+	while (!buf) {
+		buf = malloc(sizeof(char) * len);
+		if (!buf)
+			bufsize >>= 1;
+		if (!bufsize) {
+			fprintf(stderr, "Couldn't allocate zero buffer");
+			return -1;
+		}
+	}
+
+	memset(buf, 0, bufsize);
+	while (len) {
+		ret = pwrite(log->replayfd, buf, bufsize, start);
+		if (ret != bufsize) {
+			fprintf(stderr, "Error zeroing file: %d\n", errno);
+			free(buf);
+			return -1;
+		}
+		len -= ret;
+		start += ret;
+	}
+	free(buf);
+	return 0;
+}
+
+/*
+ * @log: the log we are replaying.
+ * @entry: the discard entry.
+ *
+ * Discard the given length.  If the device supports discard we will call that
+ * ioctl, otherwise we will write 0's to emulate discard.  If the discard size
+ * is larger than log->max_zero_size then we will simply skip the zero'ing if
+ * the drive doesn't support discard.
+ */
+int log_discard(struct log *log, struct log_write_entry *entry)
+{
+	u64 start = le64_to_cpu(entry->sector) * log->sectorsize;
+	u64 size = le64_to_cpu(entry->nr_sectors) * log->sectorsize;
+	u64 max_chunk = 1 * 1024 * 1024 * 1024;
+
+	if (log->flags & LOG_IGNORE_DISCARD)
+		return 0;
+
+	while (size) {
+		u64 len = size > max_chunk ? max_chunk : size;
+		int ret;
+
+		/*
+		 * Do this check first in case it is our first discard, that way
+		 * if we return EOPNOTSUPP we will fall back to the 0 method
+		 * automatically.
+		 */
+		if (!(log->flags & LOG_DISCARD_NOT_SUPP))
+			ret = discard_range(log, start, len);
+		if (log->flags & LOG_DISCARD_NOT_SUPP)
+			ret = zero_range(log, start, len);
+		if (ret)
+			return -1;
+		size -= len;
+		start += len;
+	}
+	return 0;
+}
+
+/*
+ * @log: the log we are replaying.
+ * @entry: where we put the entry.
+ * @read_data: read the entry data as well, entry must be log->sectorsize sized
+ * if this is set.
+ *
+ * @return: 0 if we replayed, 1 if we are at the end, -1 if there was an error.
+ *
+ * Replay the next entry in our log onto the replay device.
+ */
+int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
+			  int read_data)
+{
+	u64 size;
+	u64 flags;
+	size_t read_size = read_data ? log->sectorsize :
+		sizeof(struct log_write_entry);
+	char *buf;
+	ssize_t ret;
+	off_t offset;
+
+	if (log->cur_entry >= log->nr_entries)
+		return 1;
+
+	ret = read(log->logfd, entry, read_size);
+	if (ret != read_size) {
+		fprintf(stderr, "Error reading entry: %d\n", errno);
+		return -1;
+	}
+	log->cur_entry++;
+
+	size = le64_to_cpu(entry->nr_sectors) * log->sectorsize;
+	if (read_size < log->sectorsize) {
+		if (lseek(log->logfd,
+			  log->sectorsize - sizeof(struct log_write_entry),
+			  SEEK_CUR) == (off_t)-1) {
+			fprintf(stderr, "Error seeking in log: %d\n", errno);
+			return -1;
+		}
+	}
+
+	if (log_writes_verbose)
+		printf("replaying %d: sector %llu, size %llu, flags %llu\n",
+		       (int)log->cur_entry - 1,
+		       (unsigned long long)le64_to_cpu(entry->sector),
+		       (unsigned long long)size,
+		       (unsigned long long)le64_to_cpu(entry->flags));
+	if (!size)
+		return 0;
+
+	flags = le64_to_cpu(entry->flags);
+	if (flags & LOG_DISCARD_FLAG)
+		return log_discard(log, entry);
+
+	buf = malloc(size);
+	if (!buf) {
+		fprintf(stderr, "Error allocating buffer %llu entry %llu\n", (unsigned long long)size, (unsigned long long)log->cur_entry - 1);
+		return -1;
+	}
+
+	ret = read(log->logfd, buf, size);
+	if (ret != size) {
+		fprintf(stderr, "Erro reading data: %d\n", errno);
+		free(buf);
+		return -1;
+	}
+
+	offset = le64_to_cpu(entry->sector) * log->sectorsize;
+	ret = pwrite(log->replayfd, buf, size, offset);
+	free(buf);
+	if (ret != size) {
+		fprintf(stderr, "Error writing data: %d\n", errno);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * @log: the log we are manipulating.
+ * @entry_num: the entry we want.
+ *
+ * Seek to the given entry in the log, starting at 0 and ending at
+ * log->nr_entries - 1.
+ */
+int log_seek_entry(struct log *log, u64 entry_num)
+{
+	u64 i = 0;
+
+	if (entry_num >= log->nr_entries) {
+		fprintf(stderr, "Invalid entry number\n");
+		return -1;
+	}
+
+	if (lseek(log->logfd, log->sectorsize, SEEK_SET) == (off_t)-1) {
+		fprintf(stderr, "Error seeking in file: %d\n", errno);
+		return -1;
+	}
+
+	for (i = log->cur_entry; i < entry_num; i++) {
+		struct log_write_entry entry;
+		ssize_t ret;
+		off_t seek_size;
+		u64 flags;
+
+		ret = read(log->logfd, &entry, sizeof(entry));
+		if (ret != sizeof(entry)) {
+			fprintf(stderr, "Error reading entry: %d\n", errno);
+			return -1;
+		}
+		if (log_writes_verbose > 1)
+			printf("seek entry %d: %llu, size %llu, flags %llu\n",
+			       (int)i,
+			       (unsigned long long)le64_to_cpu(entry.sector),
+			       (unsigned long long)le64_to_cpu(entry.nr_sectors),
+			       (unsigned long long)le64_to_cpu(entry.flags));
+		flags = le64_to_cpu(entry.flags);
+		seek_size = log->sectorsize - sizeof(entry);
+		if (!(flags & LOG_DISCARD_FLAG))
+			seek_size += le64_to_cpu(entry.nr_sectors) *
+				log->sectorsize;
+		if (lseek(log->logfd, seek_size, SEEK_CUR) == (off_t)-1) {
+			fprintf(stderr, "Error seeking in file: %d\n", errno);
+			return -1;
+		}
+		log->cur_entry++;
+	}
+
+	return 0;
+}
+
+/*
+ * @log: the log we are manipulating.
+ * @entry: the entry we read.
+ * @read_data: read the extra data for the entry, your entry must be
+ * log->sectorsize large.
+ *
+ * @return: 1 if we hit the end of the log, 0 we got the next entry, < 0 if
+ * there was an error.
+ *
+ * Seek to the next entry in the log.
+ */
+int log_seek_next_entry(struct log *log, struct log_write_entry *entry,
+			int read_data)
+{
+	size_t read_size = read_data ? log->sectorsize :
+		sizeof(struct log_write_entry);
+	u64 flags;
+	ssize_t ret;
+
+	if (log->cur_entry >= log->nr_entries)
+		return 1;
+
+	ret = read(log->logfd, entry, read_size);
+	if (ret != read_size) {
+		fprintf(stderr, "Error reading entry: %d\n", errno);
+		return -1;
+	}
+	log->cur_entry++;
+
+	if (read_size < log->sectorsize) {
+		if (lseek(log->logfd,
+			  log->sectorsize - sizeof(struct log_write_entry),
+			  SEEK_CUR) == (off_t)-1) {
+			fprintf(stderr, "Error seeking in log: %d\n", errno);
+			return -1;
+		}
+	}
+	if (log_writes_verbose > 1)
+		printf("seek entry %d: %llu, size %llu, flags %llu\n",
+		       (int)log->cur_entry - 1,
+		       (unsigned long long)le64_to_cpu(entry->sector),
+		       (unsigned long long)le64_to_cpu(entry->nr_sectors),
+		       (unsigned long long)le64_to_cpu(entry->flags));
+
+	flags = le32_to_cpu(entry->flags);
+	read_size = le32_to_cpu(entry->nr_sectors) * log->sectorsize;
+	if (!read_size || (flags & LOG_DISCARD_FLAG))
+		return 0;
+
+	if (lseek(log->logfd, read_size, SEEK_CUR) == (off_t)-1) {
+		fprintf(stderr, "Error seeking in log: %d\n", errno);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * @logfile: the file that contains the write log.
+ * @replayfile: the file/device to replay onto, can be NULL.
+ *
+ * Opens a logfile and makes sure it is valid and returns a struct log.
+ */
+struct log *log_open(char *logfile, char *replayfile)
+{
+	struct log *log;
+	struct log_write_super super;
+	ssize_t ret;
+
+	log = malloc(sizeof(struct log));
+	if (!log) {
+		fprintf(stderr, "Couldn't alloc log\n");
+		return NULL;
+	}
+
+	log->replayfd = -1;
+
+	log->logfd = open(logfile, O_RDONLY);
+	if (log->logfd < 0) {
+		fprintf(stderr, "Couldn't open log %s: %d\n", logfile,
+			errno);
+		log_free(log);
+		return NULL;
+	}
+
+	if (replayfile) {
+		log->replayfd = open(replayfile, O_WRONLY);
+		if (log->replayfd < 0) {
+			fprintf(stderr, "Couldn't open replay file %s: %d\n",
+				replayfile, errno);
+			log_free(log);
+			return NULL;
+		}
+	}
+
+	ret = read(log->logfd, &super, sizeof(struct log_write_super));
+	if (ret < sizeof(struct log_write_super)) {
+		fprintf(stderr, "Error reading super: %d\n", errno);
+		log_free(log);
+		return NULL;
+	}
+
+	if (le64_to_cpu(super.magic) != WRITE_LOG_MAGIC) {
+		fprintf(stderr, "Magic doesn't match\n");
+		log_free(log);
+		return NULL;
+	}
+
+	if (le64_to_cpu(super.version) != WRITE_LOG_VERSION) {
+		fprintf(stderr, "Version mismatch, wanted %d, have %d\n",
+			WRITE_LOG_VERSION, (int)le64_to_cpu(super.version));
+		log_free(log);
+		return NULL;
+	}
+
+	log->sectorsize = le32_to_cpu(super.sectorsize);
+	log->nr_entries = le64_to_cpu(super.nr_entries);
+	log->max_zero_size = 128 * 1024 * 1024;
+
+	if (lseek(log->logfd, log->sectorsize - sizeof(super), SEEK_CUR) ==
+	    (off_t) -1) {
+		fprintf(stderr, "Error seeking to first entry: %d\n", errno);
+		log_free(log);
+		return NULL;
+	}
+	log->cur_entry = 0;
+
+	return log;
+}
diff --git a/src/log-writes/log-writes.h b/src/log-writes/log-writes.h
new file mode 100644
index 0000000..13f98ff
--- /dev/null
+++ b/src/log-writes/log-writes.h
@@ -0,0 +1,70 @@
+#ifndef _LOG_WRITES_H_
+#define _LOG_WRITES_H_
+
+#include <linux/types.h>
+#include <linux/byteorder/little_endian.h>
+
+extern int log_writes_verbose;
+
+#define le64_to_cpu __le64_to_cpu
+#define le32_to_cpu __le32_to_cpu
+
+typedef __u64 u64;
+typedef __u32 u32;
+
+#define LOG_FLUSH_FLAG (1 << 0)
+#define LOG_FUA_FLAG (1 << 1)
+#define LOG_DISCARD_FLAG (1 << 2)
+#define LOG_MARK_FLAG (1 << 3)
+
+#define WRITE_LOG_VERSION 1
+#define WRITE_LOG_MAGIC 0x6a736677736872
+
+
+/*
+ * Basic info about the log for userspace.
+ */
+struct log_write_super {
+	__le64 magic;
+	__le64 version;
+	__le64 nr_entries;
+	__le32 sectorsize;
+};
+
+/*
+ * sector - the sector we wrote.
+ * nr_sectors - the number of sectors we wrote.
+ * flags - flags for this log entry.
+ * data_len - the size of the data in this log entry, this is for private log
+ * entry stuff, the MARK data provided by userspace for example.
+ */
+struct log_write_entry {
+	__le64 sector;
+	__le64 nr_sectors;
+	__le64 flags;
+	__le64 data_len;
+};
+
+#define LOG_IGNORE_DISCARD (1 << 0)
+#define LOG_DISCARD_NOT_SUPP (1 << 1)
+
+struct log {
+	int logfd;
+	int replayfd;
+	unsigned long flags;
+	u64 sectorsize;
+	u64 nr_entries;
+	u64 cur_entry;
+	u64 max_zero_size;
+	off_t cur_pos;
+};
+
+struct log *log_open(char *logfile, char *replayfile);
+int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
+			  int read_data);
+int log_seek_entry(struct log *log, u64 entry_num);
+int log_seek_next_entry(struct log *log, struct log_write_entry *entry,
+			int read_data);
+void log_free(struct log *log);
+
+#endif
diff --git a/src/log-writes/replay-log.c b/src/log-writes/replay-log.c
new file mode 100644
index 0000000..759c3c7
--- /dev/null
+++ b/src/log-writes/replay-log.c
@@ -0,0 +1,348 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <stdlib.h>
+#include <string.h>
+#include "log-writes.h"
+
+enum option_indexes {
+	NEXT_FLUSH,
+	NEXT_FUA,
+	START_ENTRY,
+	END_MARK,
+	LOG,
+	REPLAY,
+	LIMIT,
+	VERBOSE,
+	FIND,
+	NUM_ENTRIES,
+	NO_DISCARD,
+	FSCK,
+	CHECK,
+	START_MARK,
+};
+
+static struct option long_options[] = {
+	{"next-flush", no_argument, NULL, 0},
+	{"next-fua", no_argument, NULL, 0},
+	{"start-entry", required_argument, NULL, 0},
+	{"end-mark", required_argument, NULL, 0},
+	{"log", required_argument, NULL, 0},
+	{"replay", required_argument, NULL, 0},
+	{"limit", required_argument, NULL, 0},
+	{"verbose", no_argument, NULL, 'v'},
+	{"find", no_argument, NULL, 0},
+	{"num-entries", no_argument, NULL, 0},
+	{"no-discard", no_argument, NULL, 0},
+	{"fsck", required_argument, NULL, 0},
+	{"check", required_argument, NULL, 0},
+	{"start-mark", required_argument, NULL, 0},
+	{ NULL, 0, NULL, 0 },
+};
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: replay-log --log <logfile> [options]\n");
+	fprintf(stderr, "\t--replay <device> - replay onto a specific "
+		"device\n");
+	fprintf(stderr, "\t--limit <number> - number of entries to replay\n");
+	fprintf(stderr, "\t--next-flush - replay to/find the next flush\n");
+	fprintf(stderr, "\t--next-fua - replay to/find the next fua\n");
+	fprintf(stderr, "\t--start-entry <entry> - start at the given "
+		"entry #\n");
+	fprintf(stderr, "\t--start-mark <mark> - mark to start from\n");
+	fprintf(stderr, "\t--end-mark <mark> - replay to/find the given mark\n");
+	fprintf(stderr, "\t--find - put replay-log in find mode, will search "
+		"based on the other options\n");
+	fprintf(stderr, "\t--number-entries - print the number of entries in "
+		"the log\n");
+	fprintf(stderr, "\t--no-discard - don't process discard entries\n");
+	fprintf(stderr, "\t--fsck - the fsck command to run, must specify "
+		"--check\n");
+	fprintf(stderr, "\t--check [<number>|flush|fua] when to check the "
+		"file system, mush specify --fsck\n");
+	exit(1);
+}
+
+static int should_stop(struct log_write_entry *entry, u64 stop_flags,
+		       char *mark)
+{
+	u64 flags = le64_to_cpu(entry->flags);
+	int check_mark = (stop_flags & LOG_MARK_FLAG);
+	char *buf = (char *)(entry + 1);
+
+	if (flags & stop_flags) {
+		if (!check_mark)
+			return 1;
+		if ((flags & LOG_MARK_FLAG) && !strcmp(mark, buf))
+			return 1;
+	}
+	return 0;
+}
+
+static int run_fsck(struct log *log, char *fsck_command)
+{
+	int ret = fsync(log->replayfd);
+	if (ret)
+		return ret;
+	ret = system(fsck_command);
+	if (ret >= 0)
+		ret = WEXITSTATUS(ret);
+	return ret ? -1 : 0;
+}
+
+enum log_replay_check_mode {
+	CHECK_NUMBER = 1,
+	CHECK_FUA = 2,
+	CHECK_FLUSH = 3,
+};
+
+static int seek_to_mark(struct log *log, struct log_write_entry *entry,
+			char *mark)
+{
+	int ret;
+
+	while ((ret = log_seek_next_entry(log, entry, 1)) == 0) {
+		if (should_stop(entry, LOG_MARK_FLAG, mark))
+			break;
+	}
+	if (ret == 1) {
+		fprintf(stderr, "Couldn't find starting mark\n");
+		ret = -1;
+	}
+
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	char *logfile = NULL, *replayfile = NULL, *fsck_command = NULL;
+	struct log_write_entry *entry;
+	u64 stop_flags = 0;
+	u64 start_entry = 0;
+	u64 run_limit = 0;
+	u64 num_entries = 0;
+	u64 check_number = 0;
+	char *end_mark = NULL, *start_mark = NULL;
+	char *tmp = NULL;
+	struct log *log;
+	int find_mode = 0;
+	int c;
+	int opt_index;
+	int ret;
+	int print_num_entries = 0;
+	int discard = 1;
+	enum log_replay_check_mode check_mode = 0;
+
+	while ((c = getopt_long(argc, argv, "v", long_options,
+				&opt_index)) >= 0) {
+		switch(c) {
+		case 'v':
+			log_writes_verbose++;
+			continue;
+		default:
+			break;
+		}
+
+		switch(opt_index) {
+		case NEXT_FLUSH:
+			stop_flags |= LOG_FLUSH_FLAG;
+			break;
+		case NEXT_FUA:
+			stop_flags |= LOG_FUA_FLAG;
+			break;
+		case START_ENTRY:
+			start_entry = strtoull(optarg, &tmp, 0);
+			if (tmp && *tmp != '\0') {
+				fprintf(stderr, "Invalid entry number\n");
+				exit(1);
+			}
+			tmp = NULL;
+			break;
+		case START_MARK:
+			/*
+			 * Biggest sectorsize is 4k atm, so limit the mark to 4k
+			 * minus the size of the entry.  Say 4097 since we want
+			 * an extra slot for \0.
+			 */
+			start_mark = strndup(optarg, 4097 -
+					     sizeof(struct log_write_entry));
+			if (!start_mark) {
+				fprintf(stderr, "Couldn't allocate memory\n");
+				exit(1);
+			}
+			break;
+		case END_MARK:
+			/*
+			 * Biggest sectorsize is 4k atm, so limit the mark to 4k
+			 * minus the size of the entry.  Say 4097 since we want
+			 * an extra slot for \0.
+			 */
+			end_mark = strndup(optarg, 4097 -
+					   sizeof(struct log_write_entry));
+			if (!end_mark) {
+				fprintf(stderr, "Couldn't allocate memory\n");
+				exit(1);
+			}
+			stop_flags |= LOG_MARK_FLAG;
+			break;
+		case LOG:
+			logfile = strdup(optarg);
+			if (!logfile) {
+				fprintf(stderr, "Couldn't allocate memory\n");
+				exit(1);
+			}
+			break;
+		case REPLAY:
+			replayfile = strdup(optarg);
+			if (!replayfile) {
+				fprintf(stderr, "Couldn't allocate memory\n");
+				exit(1);
+			}
+			break;
+		case LIMIT:
+			run_limit = strtoull(optarg, &tmp, 0);
+			if (tmp && *tmp != '\0') {
+				fprintf(stderr, "Invalid entry number\n");
+				exit(1);
+			}
+			tmp = NULL;
+			break;
+		case FIND:
+			find_mode = 1;
+			break;
+		case NUM_ENTRIES:
+			print_num_entries = 1;
+			break;
+		case NO_DISCARD:
+			discard = 0;
+			break;
+		case FSCK:
+			fsck_command = strdup(optarg);
+			if (!fsck_command) {
+				fprintf(stderr, "Couldn't allocate memory\n");
+				exit(1);
+			}
+			break;
+		case CHECK:
+			if (!strcmp(optarg, "flush")) {
+				check_mode = CHECK_FLUSH;
+			} else if (!strcmp(optarg, "fua")) {
+				check_mode = CHECK_FUA;
+			} else {
+				check_mode = CHECK_NUMBER;
+				check_number = strtoull(optarg, &tmp, 0);
+				if (!check_number || (tmp && *tmp != '\0')) {
+					fprintf(stderr,
+						"Invalid entry number\n");
+					exit(1);
+				}
+				tmp = NULL;
+			}
+			break;
+		default:
+			usage();
+		}
+	}
+
+	if (!logfile)
+		usage();
+
+	log = log_open(logfile, replayfile);
+	if (!log)
+		exit(1);
+	free(logfile);
+	free(replayfile);
+
+	if (!discard)
+		log->flags |= LOG_IGNORE_DISCARD;
+
+	entry = malloc(log->sectorsize);
+	if (!entry) {
+		fprintf(stderr, "Couldn't allocate buffer\n");
+		log_free(log);
+		exit(1);
+	}
+
+	if (start_mark) {
+		ret = seek_to_mark(log, entry, start_mark);
+		if (ret)
+			exit(1);
+		free(start_mark);
+	} else {
+		ret = log_seek_entry(log, start_entry);
+		if (ret)
+			exit(1);
+	}
+
+	if ((fsck_command && !check_mode) || (!fsck_command && check_mode))
+		usage();
+
+	/* We just want to find a given entry */
+	if (find_mode) {
+		while ((ret = log_seek_next_entry(log, entry, 1)) == 0) {
+			num_entries++;
+			if ((run_limit && num_entries == run_limit) ||
+			    should_stop(entry, stop_flags, end_mark)) {
+				printf("%llu\n",
+				       (unsigned long long)log->cur_entry - 1);
+				log_free(log);
+				return 0;
+			}
+		}
+		log_free(log);
+		if (ret < 0)
+			return ret;
+		fprintf(stderr, "Couldn't find entry\n");
+		return 1;
+	}
+
+	/* Used for scripts, just print the number of entries in the log */
+	if (print_num_entries) {
+		printf("%llu\n", (unsigned long long)log->nr_entries);
+		log_free(log);
+		return 0;
+	}
+
+	/* No replay, just spit out the log info. */
+	if (!replayfile) {
+		printf("Log version=%d, sectorsize=%lu, entries=%llu\n",
+		       WRITE_LOG_VERSION, (unsigned long)log->sectorsize,
+		       (unsigned long long)log->nr_entries);
+		log_free(log);
+		return 0;
+	}
+
+	while ((ret = log_replay_next_entry(log, entry, 1)) == 0) {
+		num_entries++;
+		if (fsck_command) {
+			if ((check_mode == CHECK_NUMBER) &&
+			    !(num_entries % check_number))
+				ret = run_fsck(log, fsck_command);
+			else if ((check_mode == CHECK_FUA) &&
+				 should_stop(entry, LOG_FUA_FLAG, NULL))
+				ret = run_fsck(log, fsck_command);
+			else if ((check_mode == CHECK_FLUSH) &&
+				 should_stop(entry, LOG_FLUSH_FLAG, NULL))
+				ret = run_fsck(log, fsck_command);
+			else
+				ret = 0;
+			if (ret) {
+				fprintf(stderr, "Fsck errored out on entry "
+					"%llu\n",
+					(unsigned long long)log->cur_entry - 1);
+				break;
+			}
+		}
+
+		if ((run_limit && num_entries == run_limit) ||
+		    should_stop(entry, stop_flags, end_mark))
+			break;
+	}
+	fsync(log->replayfd);
+	log_free(log);
+	free(end_mark);
+	if (ret < 0)
+		exit(1);
+	return 0;
+}
-- 
2.7.4

