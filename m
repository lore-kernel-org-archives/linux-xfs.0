Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F15C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Oct 2022 02:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJOCEW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 22:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJOCEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 22:04:22 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C99A6C03;
        Fri, 14 Oct 2022 19:04:20 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id t25so3628634qkm.2;
        Fri, 14 Oct 2022 19:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqKDuXRYqNwtHW6XCWbTuJelslON8hEDPcP73AO88wM=;
        b=qDyXexZlPvYpUfFQPJhDR4tlKlq4zdPyjt7ZVUrkdOwIWedrRko9R2MfEkG81WDq7F
         13+tBzj96Xc6K0STAvWVTgSJHbnAjiWhJ+CNXxw12BhUV8Q6eMNWle/fboy1LIN8qzQT
         ISy32HT32IWYJx31EXA8bgkxgQTziflBookcOeJ+C73PvpPVYtMYaPLUfTUD7TVMp6cZ
         cidpcroUKEf2Q+VPJoq5r09yLhetwr+f9Im51zUpvAh4Yf9/7uDTar2ccZIaJWUe6EzG
         hRcZYf5j9Wvhie/zVpOfkXUVRQq8jub6rmCrdOl0sz1P0t1Z/lgdFpckgh2O8uz0SJJe
         spQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqKDuXRYqNwtHW6XCWbTuJelslON8hEDPcP73AO88wM=;
        b=epdXNj+0TW3cG8DItYg5t75uaHNtYZ6AB2ZleuHAyQ9WxW5TNtfGPPacIKQMfqbqS8
         RrQTlq/s2emvt+gbUxWjbfVUMTakcasw2Ooc6BybuZqBADFf8j9izosYqC6XueivwTT2
         cH9eFgDMJp1c5FFbXGolM+ptwTqOfVpUSbeHhtK3rjpdxlmVAopF/S6hX+ThCTTriZ2g
         ZuIoztvrj8+MYU5WqI5W1pbD/uBFOv2bZC0VkwLXHJVe1/G4CYgRpznpPUXYMVGl5R4E
         lhrSXHw2EiHQ51AfI1KnnXShkbgUGY5LHVawhIYM/EzeecaAJw3UbErXjjKEvbZ9Az51
         aJhg==
X-Gm-Message-State: ACrzQf3iYGOJF1r/PBYm7CZ+jHjmD2VLqgAIxMIp+yXZvHIm+tokbq9i
        OA/c64Gas1Jeg7h5IoLsyvR8imUIZrel1q9s
X-Google-Smtp-Source: AMsMyM4FY3vhZQtnsqja3pPNNSuQvq0bcuw7NRIl5ucxZBdrbhBqI6Rbf9SZhDeEluJsWxKFqd0lug==
X-Received: by 2002:a05:620a:12d5:b0:6ee:9a95:8c72 with SMTP id e21-20020a05620a12d500b006ee9a958c72mr526886qkl.362.1665799458387;
        Fri, 14 Oct 2022 19:04:18 -0700 (PDT)
Received: from shiina-laptop.hsd1.ma.comcast.net ([2601:18f:801:e210:abfc:537a:d62c:c353])
        by smtp.gmail.com with ESMTPSA id c23-20020a05620a269700b006ee79bb1f8asm3781001qkp.68.2022.10.14.19.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 19:04:17 -0700 (PDT)
From:   Hironori Shiina <shiina.hironori@gmail.com>
X-Google-Original-From: Hironori Shiina <shiina.hironori@fujitsu.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH V4] xfs: test for fixing wrong root inode number in dump
Date:   Fri, 14 Oct 2022 22:04:00 -0400
Message-Id: <20221015020400.182189-1-shiina.hironori@fujitsu.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014160907.128619-1-shiina.hironori@fujitsu.com>
References: <20221014160907.128619-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test '-x' option of xfsrestore. With this option, a wrong root inode
number in a dump file is corrected. A root inode number can be wrong
in a dump created by problematic xfsdump (v3.1.7 - v3.1.9) with
bulkstat misuse. In this test, a corrupted dump file is created by
overwriting a root inode number in a header.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
---
changes since v3:
  - Flatten out nested pointer dereferencing and typecasting.
changes since v2:
  - Use glibc functions to convert endian.
  - Copy the structure definitions from xfsdump source files.
changes since RFC v1:
  - Skip the test if xfsrestore does not support '-x' flag.
  - Create a corrupted dump by overwriting a root inode number in a dump
    file with a new tool instead of checking in a binary dump file.

 common/dump             |   2 +-
 common/xfs              |   6 ++
 src/Makefile            |   2 +-
 src/fake-dump-rootino.c | 224 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/554           |  73 +++++++++++++
 tests/xfs/554.out       |  40 +++++++
 6 files changed, 345 insertions(+), 2 deletions(-)
 create mode 100644 src/fake-dump-rootino.c
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out

diff --git a/common/dump b/common/dump
index 8e0446d9..50b2ba03 100644
--- a/common/dump
+++ b/common/dump
@@ -1003,7 +1003,7 @@ _parse_restore_args()
         --no-check-quota)
             do_quota_check=false
             ;;
-	-K|-R)
+	-K|-R|-x)
 	    restore_args="$restore_args $1"
             ;;
 	*)
diff --git a/common/xfs b/common/xfs
index e1c15d3d..8334880e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1402,3 +1402,9 @@ _xfs_filter_mkfs()
 		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
 	}'
 }
+
+_require_xfsrestore_xflag()
+{
+	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
+			_notrun 'xfsrestore does not support -x flag.'
+}
diff --git a/src/Makefile b/src/Makefile
index 5f565e73..afdf6b30 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	t_ofd_locks t_mmap_collision mmap-write-concurrent \
 	t_get_file_time t_create_short_dirs t_create_long_dirs t_enospc \
 	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale \
-	t_mmap_cow_memory_failure
+	t_mmap_cow_memory_failure fake-dump-rootino
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/fake-dump-rootino.c b/src/fake-dump-rootino.c
new file mode 100644
index 00000000..8a30dffd
--- /dev/null
+++ b/src/fake-dump-rootino.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Fujitsu Limited.  All Rights Reserved. */
+#define _LARGEFILE64_SOURCE
+#include <endian.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <uuid/uuid.h>
+
+// Definitions from xfsdump
+#define PGSZLOG2	12
+#define PGSZ		(1 << PGSZLOG2)
+#define GLOBAL_HDR_SZ		PGSZ
+#define GLOBAL_HDR_MAGIC_SZ	8
+#define GLOBAL_HDR_STRING_SZ	0x100
+#define GLOBAL_HDR_TIME_SZ	4
+#define GLOBAL_HDR_UUID_SZ	0x10
+typedef int32_t time32_t;
+struct global_hdr {
+	char gh_magic[GLOBAL_HDR_MAGIC_SZ];		/*   8    8 */
+		/* unique signature of xfsdump */
+	uint32_t gh_version;				/*   4    c */
+		/* header version */
+	uint32_t gh_checksum;				/*   4   10 */
+		/* 32-bit unsigned additive inverse of entire header */
+	time32_t gh_timestamp;				/*   4   14 */
+		/* time32_t of dump */
+	char gh_pad1[4];				/*   4   18 */
+		/* alignment */
+	uint64_t gh_ipaddr;				/*   8   20 */
+		/* from gethostid(2), room for expansion */
+	uuid_t gh_dumpid;				/*  10   30 */
+		/* ID of dump session	 */
+	char gh_pad2[0xd0];				/*  d0  100 */
+		/* alignment */
+	char gh_hostname[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
+		/* from gethostname(2) */
+	char gh_dumplabel[GLOBAL_HDR_STRING_SZ];	/* 100  300 */
+		/* label of dump session */
+	char gh_pad3[0x100];				/* 100  400 */
+		/* padding */
+	char gh_upper[GLOBAL_HDR_SZ - 0x400];		/* c00 1000 */
+		/* header info private to upper software layers */
+};
+typedef struct global_hdr global_hdr_t;
+
+#define sizeofmember( t, m )	sizeof( ( ( t * )0 )->m )
+
+#define DRIVE_HDR_SZ		sizeofmember(global_hdr_t, gh_upper)
+struct drive_hdr {
+	uint32_t dh_drivecnt;				/*   4    4 */
+		/* number of drives used to dump the fs */
+	uint32_t dh_driveix;				/*   4    8 */
+		/* 0-based index of the drive used to dump this stream */
+	int32_t dh_strategyid;				/*   4    c */
+		/* ID of the drive strategy used to produce this dump */
+	char dh_pad1[0x1f4];				/* 1f4  200 */
+		/* padding */
+	char dh_specific[0x200];			/* 200  400 */
+		/* drive strategy-specific info */
+	char dh_upper[DRIVE_HDR_SZ - 0x400];		/* 800  c00 */
+		/* header info private to upper software layers */
+};
+typedef struct drive_hdr drive_hdr_t;
+
+#define MEDIA_HDR_SZ		sizeofmember(drive_hdr_t, dh_upper)
+struct media_hdr {
+	char mh_medialabel[GLOBAL_HDR_STRING_SZ];	/* 100  100 */
+		/* label of media object containing file */
+	char mh_prevmedialabel[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
+		/* label of upstream media object */
+	char mh_pad1[GLOBAL_HDR_STRING_SZ];		/* 100  300 */
+		/* in case more labels needed */
+	uuid_t mh_mediaid;				/*  10  310 */
+		/* ID of media object 	*/
+	uuid_t mh_prevmediaid;				/*  10  320 */
+		/* ID of upstream media object */
+	char mh_pad2[GLOBAL_HDR_UUID_SZ];		/*  10  330 */
+		/* in case more IDs needed */
+	uint32_t mh_mediaix;				/*   4  334 */
+		/* 0-based index of this media object within the dump stream */
+	uint32_t mh_mediafileix;			/*   4  338 */
+		/* 0-based index of this file within this media object */
+	uint32_t mh_dumpfileix;			/*   4  33c */
+		/* 0-based index of this file within this dump stream */
+	uint32_t mh_dumpmediafileix;			/*   4  340 */
+		/* 0-based index of file within dump stream and media object */
+	uint32_t mh_dumpmediaix;			/*   4  344 */
+		/* 0-based index of this dump within the media object */
+	int32_t mh_strategyid;				/*   4  348 */
+		/* ID of the media strategy used to produce this dump */
+	char mh_pad3[0x38];				/*  38  380 */
+		/* padding */
+	char mh_specific[0x80];			/*  80  400 */
+		/* media strategy-specific info */
+	char mh_upper[MEDIA_HDR_SZ - 0x400];		/* 400  800 */
+		/* header info private to upper software layers */
+};
+typedef struct media_hdr media_hdr_t;
+
+#define CONTENT_HDR_SZ		sizeofmember(media_hdr_t, mh_upper)
+#define CONTENT_HDR_FSTYPE_SZ	16
+#define CONTENT_STATSZ		160 /* must match dlog.h DLOG_MULTI_STATSZ */
+struct content_hdr {
+	char ch_mntpnt[GLOBAL_HDR_STRING_SZ];		/* 100  100 */
+		/* full pathname of fs mount point */
+	char ch_fsdevice[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
+		/* full pathname of char device containing fs */
+	char  ch_pad1[GLOBAL_HDR_STRING_SZ];		/* 100  300 */
+		/* in case another label is needed */
+	char ch_fstype[CONTENT_HDR_FSTYPE_SZ];	/*  10  310 */
+		/* from fsid.h */
+	uuid_t ch_fsid;					/*  10  320 */
+		/* file system uuid */
+	char  ch_pad2[GLOBAL_HDR_UUID_SZ];		/*  10  330 */
+		/* in case another id is needed */
+	char ch_pad3[8];				/*   8  338 */
+		/* padding */
+	int32_t ch_strategyid;				/*   4  33c */
+		/* ID of the content strategy used to produce this dump */
+	char ch_pad4[4];				/*   4  340 */
+		/* alignment */
+	char ch_specific[0xc0];			/*  c0  400 */
+		/* content strategy-specific info */
+};
+typedef struct content_hdr content_hdr_t;
+
+typedef uint64_t xfs_ino_t;
+struct startpt {
+	xfs_ino_t sp_ino;		/* first inode to dump */
+	off64_t sp_offset;	/* bytes to skip in file data fork */
+	int32_t sp_flags;
+	int32_t sp_pad1;
+};
+typedef struct startpt startpt_t;
+
+#define CONTENT_INODE_HDR_SZ  sizeofmember(content_hdr_t, ch_specific)
+struct content_inode_hdr {
+	int32_t cih_mediafiletype;			/*   4   4 */
+		/* dump media file type: see #defines below */
+	int32_t cih_dumpattr;				/*   4   8 */
+		/* dump attributes: see #defines below */
+	int32_t cih_level;				/*   4   c */
+		/* dump level */
+	char pad1[4];					/*   4  10 */
+		/* alignment */
+	time32_t cih_last_time;				/*   4  14 */
+		/* if an incremental, time of previous dump at a lesser level */
+	time32_t cih_resume_time;			/*   4  18 */
+		/* if a resumed dump, time of interrupted dump */
+	xfs_ino_t cih_rootino;				/*   8  20 */
+		/* root inode number */
+	uuid_t cih_last_id;				/*  10  30 */
+		/* if an incremental, uuid of prev dump */
+	uuid_t cih_resume_id;				/*  10  40 */
+		/* if a resumed dump, uuid of interrupted dump */
+	startpt_t cih_startpt;				/*  18  58 */
+		/* starting point of media file contents */
+	startpt_t cih_endpt;				/*  18  70 */
+		/* starting point of next stream */
+	uint64_t cih_inomap_hnkcnt;			/*   8  78 */
+
+	uint64_t cih_inomap_segcnt;			/*   8  80 */
+
+	uint64_t cih_inomap_dircnt;			/*   8  88 */
+
+	uint64_t cih_inomap_nondircnt;			/*   8  90 */
+
+	xfs_ino_t cih_inomap_firstino;			/*   8  98 */
+
+	xfs_ino_t cih_inomap_lastino;			/*   8  a0 */
+
+	uint64_t cih_inomap_datasz;			/*   8  a8 */
+		/* bytes of non-metadata dumped */
+	char cih_pad2[CONTENT_INODE_HDR_SZ - 0xa8];	/*  18  c0 */
+		/* padding */
+};
+typedef struct content_inode_hdr content_inode_hdr_t;
+// End of definitions from xfsdump
+
+int main(int argc, char *argv[]) {
+
+	if (argc < 3) {
+		fprintf(stderr, "Usage: %s <path/to/dumpfile> <fake rootino>\n", argv[0]);
+		exit(1);
+	}
+
+	const char *filepath = argv[1];
+	const uint64_t fake_root_ino = (uint64_t)strtol(argv[2], NULL, 10);
+
+	int fd = open(filepath, O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		exit(1);
+	}
+	global_hdr_t *header = mmap(NULL, GLOBAL_HDR_SZ, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (header == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	drive_hdr_t *dh = (drive_hdr_t *)header->gh_upper;
+	media_hdr_t *mh = (media_hdr_t *)dh->dh_upper;
+	content_hdr_t *ch = (content_hdr_t *)mh->mh_upper;
+	content_inode_hdr_t *cih = (content_inode_hdr_t *)ch->ch_specific;
+	uint64_t *rootino_ptr = &cih->cih_rootino;
+
+	int32_t checksum = (int32_t)be32toh(header->gh_checksum);
+	uint64_t orig_rootino = be64toh(*rootino_ptr);
+
+	// Fake root inode number
+	*rootino_ptr = htobe64(fake_root_ino);
+
+	// Update checksum along with overwriting rootino.
+	uint64_t gap = orig_rootino - fake_root_ino;
+	checksum += (gap >> 32) + (gap & 0x00000000ffffffff);
+	header->gh_checksum = htobe32(checksum);
+
+	munmap(header, GLOBAL_HDR_SZ);
+	close(fd);
+}
diff --git a/tests/xfs/554 b/tests/xfs/554
new file mode 100755
index 00000000..fcfaa699
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
+#
+# FS QA Test No. 554
+#
+# Create a filesystem which contains an inode with a lower number
+# than the root inode. Set the lower number to a dump file as the root inode
+# and ensure that 'xfsrestore -x' handles this wrong inode.
+#
+. ./common/preamble
+_begin_fstest auto quick dump
+
+# Import common functions.
+. ./common/dump
+
+_supported_fs xfs
+_require_xfs_io_command "falloc"
+_require_scratch
+_require_xfsrestore_xflag
+
+# A large stripe unit will put the root inode out quite far
+# due to alignment, leaving free blocks ahead of it.
+_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full 2>&1
+
+# Mounting /without/ a stripe should allow inodes to be allocated
+# in lower free blocks, without the stripe alignment.
+_scratch_mount -o sunit=0,swidth=0
+
+root_inum=$(stat -c %i $SCRATCH_MNT)
+
+# Consume space after the root inode so that the blocks before
+# root look "close" for the next inode chunk allocation
+$XFS_IO_PROG -f -c "falloc 0 16m" $SCRATCH_MNT/fillfile
+
+# And make a bunch of inodes until we (hopefully) get one lower
+# than root, in a new inode chunk.
+echo "root_inum: $root_inum" >> $seqres.full
+for i in $(seq 0 4096) ; do
+	fname=$SCRATCH_MNT/$(printf "FILE_%03d" $i)
+	touch $fname
+	inum=$(stat -c "%i" $fname)
+	[[ $inum -lt $root_inum ]] && break
+done
+
+echo "created: $inum" >> $seqres.full
+
+[[ $inum -lt $root_inum ]] || _notrun "Could not set up test"
+
+# Now try a dump and restore. Cribbed from xfs/068
+_create_dumpdir_stress
+
+echo -n "Before: " >> $seqres.full
+_count_dumpdir_files | tee $tmp.before >> $seqres.full
+
+_do_dump_file
+
+# Set the wrong root inode number to the dump file
+# as problematic xfsdump used to do.
+$here/src/fake-dump-rootino $dump_file $inum
+
+_do_restore_file -x | \
+sed -e "s/rootino #${inum}/rootino #FAKENO/g" \
+	-e "s/# to ${root_inum}/# to ROOTNO/g" \
+	-e "/entries processed$/s/[0-9][0-9]*/NUM/g"
+
+echo -n "After: " >> $seqres.full
+_count_restoredir_files | tee $tmp.after >> $seqres.full
+diff -u $tmp.before $tmp.after
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/554.out b/tests/xfs/554.out
new file mode 100644
index 00000000..c5e8c4c5
--- /dev/null
+++ b/tests/xfs/554.out
@@ -0,0 +1,40 @@
+QA output created by 554
+Creating directory system to dump using fsstress.
+
+-----------------------------------------------
+fsstress : -f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10
+-----------------------------------------------
+Dumping to file...
+xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_554 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_554"
+xfsdump: ino map <PHASES>
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: /var/xfsdump/inventory created
+xfsdump: creating dump session media file 0 (media 0, file 0)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: dump size (non-dir files) : NUM bytes
+xfsdump: dump complete: SECS seconds elapsed
+xfsdump: Dump Status: SUCCESS
+Restoring from file...
+xfsrestore  -x -f DUMP_FILE  -L stress_554 RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: using online session inventory
+xfsrestore: searching media for directory dump
+xfsrestore: examining media file 0
+xfsrestore: reading directories
+xfsrestore: found fake rootino #FAKENO, will fix.
+xfsrestore: fix root # to ROOTNO (bind mount?)
+xfsrestore: NUM directories and NUM entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
-- 
2.37.3

