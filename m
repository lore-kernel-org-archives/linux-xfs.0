Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AC8C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 18:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiJMSlM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 14:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiJMSky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 14:40:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029564001F;
        Thu, 13 Oct 2022 11:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C95618B8;
        Thu, 13 Oct 2022 18:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12758C433D6;
        Thu, 13 Oct 2022 18:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665686225;
        bh=rWEWYqFeApPh5evcKGWYboSURGEGXz3vDTUbnY9BKRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qDkDcpUaJk5hM2p/VQQtlWDgIk1naEJ4xtYeuhnZZnQ/Cro8v4rGoGXrzbMqmaXFk
         GaQNgkREqxaMsbEdm1LHJ/TfxHXnFNHXb8Fpxe6klWBotagi457FlI6p/2oN3VY/fU
         yNhfgR5KBhnjoAvI+vNVymp0oFJWMXKB4x30hhPfOJrmLrqBqpIUBqtO0ERid5eZ6J
         jR+FWp4m2bqfHB4+uCyZNG5s6C9AUfkQ1ZwW/ebLSn68q2eNbR8j3cAvBQp/OufG27
         UlZjW4BAVkryi2pWNPzHU2vkVLOaah4EIdiUelaE23IbbrAUJn82YrCBYPtv9FYjGr
         8ie5zpMDnkJFw==
Date:   Thu, 13 Oct 2022 11:37:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [PATCH V2] xfs: test for fixing wrong root inode number in dump
Message-ID: <Y0ha0LTKCKpkag8y@magnolia>
References: <20220928210337.417054-1-shiina.hironori@fujitsu.com>
 <20221013160434.130152-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013160434.130152-1-shiina.hironori@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 12:04:34PM -0400, Hironori Shiina wrote:
> Test '-x' option of xfsrestore. With this option, a wrong root inode
> number in a dump file is corrected. A root inode number can be wrong
> in a dump created by problematic xfsdump (v3.1.7 - v3.1.9) with
> bulkstat misuse. In this test, a corrupted dump file is created by
> overwriting a root inode number in a header.
> 
> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
> ---
> changes since RFC v1:
>   - Skip the test if xfsrestore does not support '-x' flag.
>   - Create a corrupted dump by overwriting a root inode number in a dump
>     file with a new tool instead of checking in a binary dump file.
> 
>  common/dump             |  2 +-
>  common/xfs              |  6 +++
>  src/Makefile            |  2 +-
>  src/fake-dump-rootino.c | 85 +++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/554           | 73 +++++++++++++++++++++++++++++++++++
>  tests/xfs/554.out       | 40 +++++++++++++++++++
>  6 files changed, 206 insertions(+), 2 deletions(-)
>  create mode 100644 src/fake-dump-rootino.c
>  create mode 100755 tests/xfs/554
>  create mode 100644 tests/xfs/554.out
> 
> diff --git a/common/dump b/common/dump
> index 8e0446d9..50b2ba03 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -1003,7 +1003,7 @@ _parse_restore_args()
>          --no-check-quota)
>              do_quota_check=false
>              ;;
> -	-K|-R)
> +	-K|-R|-x)
>  	    restore_args="$restore_args $1"
>              ;;
>  	*)
> diff --git a/common/xfs b/common/xfs
> index e1c15d3d..8334880e 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1402,3 +1402,9 @@ _xfs_filter_mkfs()
>  		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
>  	}'
>  }
> +
> +_require_xfsrestore_xflag()
> +{
> +	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
> +			_notrun 'xfsrestore does not support -x flag.'
> +}
> diff --git a/src/Makefile b/src/Makefile
> index 5f565e73..afdf6b30 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -19,7 +19,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	t_ofd_locks t_mmap_collision mmap-write-concurrent \
>  	t_get_file_time t_create_short_dirs t_create_long_dirs t_enospc \
>  	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale \
> -	t_mmap_cow_memory_failure
> +	t_mmap_cow_memory_failure fake-dump-rootino
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> diff --git a/src/fake-dump-rootino.c b/src/fake-dump-rootino.c
> new file mode 100644
> index 00000000..b89351b8
> --- /dev/null
> +++ b/src/fake-dump-rootino.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Fujitsu Limited.  All Rights Reserved. */
> +#include <fcntl.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +
> +// Values for size of dump file header from xfsdump
> +#define PGSZLOG2	12
> +#define PGSZ		(1 << PGSZLOG2)
> +#define GLOBAL_HDR_SZ		PGSZ
> +
> +static inline uint32_t convert_endian_32(uint32_t val) {
> +#if __BYTE_ORDER == __BIG_ENDIAN
> +	return val;
> +#else
> +	return ((val & 0xff000000u) >> 24 |
> +			(val & 0x00ff0000u) >> 8  |
> +			(val & 0x0000ff00u) << 8  |
> +			(val & 0x000000ffu) << 24);
> +#endif
> +}

be32_to_cpu?

> +
> +static inline uint64_t convert_endian_64(uint64_t val) {
> +#if __BYTE_ORDER == __BIG_ENDIAN
> +	return val;
> +#else
> +	return (uint64_t) convert_endian_32(val >> 32) |
> +	       (uint64_t) convert_endian_32(val & 0x00000000ffffffff) << 32;
> +#endif
> +}

be64_to_cpu?

> +
> +/*
> + * Offset to checksum in dump file header
> + *   global_hdr_t.gh_checksum (0xc)
> + */
> +#define OFFSET_CHECKSUM	0xc
> +
> +/*
> + * Offset to root inode number in dump file header
> + *   global_hdr_t.gh_upper (0x400) + drive_hdr_t.dh_upper (0x400) +
> + *   media_hdr_t.mh_upper (0x400) + content_hdr_t.ch_specific (0x340) +
> + *   content_inode_hdr_t.cih_rootino (0x18)
> + */
> +#define OFFSET_ROOTINO	0xf58

Since you're now using a C program, I think it makes more sense to copy
the structure definitions directly into the C file.

> +
> +int main(int argc, char *argv[]) {
> +
> +	if (argc < 3) {
> +		fprintf(stderr, "Usage: %s <path/to/dumpfile> <fake rootino>\n", argv[0]);
> +		exit(1);
> +	}
> +
> +	const char *filepath = argv[1];
> +	const uint64_t fake_root_ino = (uint64_t) strtol(argv[2], NULL, 10);
> +
> +	int fd = open(filepath, O_RDWR);
> +	if (fd < 0) {
> +		perror("open");
> +		exit(1);
> +	}
> +	char *header = mmap(NULL, GLOBAL_HDR_SZ, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> +	if (header == MAP_FAILED) {
> +		perror("mmap");
> +		exit(1);
> +	}
> +
> +	uint32_t *checksum_ptr = (uint32_t *) (header + OFFSET_CHECKSUM);
> +	uint64_t *rootino_ptr = (uint64_t *) (header + OFFSET_ROOTINO);
> +	int32_t checksum = (int32_t) convert_endian_32(*checksum_ptr);
> +	uint64_t orig_rootino = convert_endian_64(*rootino_ptr);
> +
> +	// Fake root inode number
> +	*rootino_ptr = convert_endian_64(fake_root_ino);
> +
> +	// Update checksum along with overwriting rootino.
> +	uint64_t gap = orig_rootino - fake_root_ino;
> +	checksum += (gap >> 32) + (gap & 0x00000000ffffffff);
> +	*checksum_ptr = convert_endian_32(checksum);
> +
> +	munmap(header, GLOBAL_HDR_SZ);
> +	close(fd);
> +}
> diff --git a/tests/xfs/554 b/tests/xfs/554
> new file mode 100755
> index 00000000..fcfaa699
> --- /dev/null
> +++ b/tests/xfs/554
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
> +#
> +# FS QA Test No. 554
> +#
> +# Create a filesystem which contains an inode with a lower number
> +# than the root inode. Set the lower number to a dump file as the root inode
> +# and ensure that 'xfsrestore -x' handles this wrong inode.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick dump
> +
> +# Import common functions.
> +. ./common/dump
> +
> +_supported_fs xfs
> +_require_xfs_io_command "falloc"
> +_require_scratch
> +_require_xfsrestore_xflag

_require_test_program fake-dump-rootino

> +
> +# A large stripe unit will put the root inode out quite far
> +# due to alignment, leaving free blocks ahead of it.
> +_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full 2>&1
> +
> +# Mounting /without/ a stripe should allow inodes to be allocated
> +# in lower free blocks, without the stripe alignment.
> +_scratch_mount -o sunit=0,swidth=0
> +
> +root_inum=$(stat -c %i $SCRATCH_MNT)
> +
> +# Consume space after the root inode so that the blocks before
> +# root look "close" for the next inode chunk allocation
> +$XFS_IO_PROG -f -c "falloc 0 16m" $SCRATCH_MNT/fillfile
> +
> +# And make a bunch of inodes until we (hopefully) get one lower
> +# than root, in a new inode chunk.
> +echo "root_inum: $root_inum" >> $seqres.full
> +for i in $(seq 0 4096) ; do
> +	fname=$SCRATCH_MNT/$(printf "FILE_%03d" $i)
> +	touch $fname
> +	inum=$(stat -c "%i" $fname)
> +	[[ $inum -lt $root_inum ]] && break
> +done
> +
> +echo "created: $inum" >> $seqres.full
> +
> +[[ $inum -lt $root_inum ]] || _notrun "Could not set up test"
> +
> +# Now try a dump and restore. Cribbed from xfs/068
> +_create_dumpdir_stress
> +
> +echo -n "Before: " >> $seqres.full
> +_count_dumpdir_files | tee $tmp.before >> $seqres.full
> +
> +_do_dump_file
> +
> +# Set the wrong root inode number to the dump file
> +# as problematic xfsdump used to do.
> +$here/src/fake-dump-rootino $dump_file $inum
> +
> +_do_restore_file -x | \
> +sed -e "s/rootino #${inum}/rootino #FAKENO/g" \
> +	-e "s/# to ${root_inum}/# to ROOTNO/g" \
> +	-e "/entries processed$/s/[0-9][0-9]*/NUM/g"
> +
> +echo -n "After: " >> $seqres.full
> +_count_restoredir_files | tee $tmp.after >> $seqres.full
> +diff -u $tmp.before $tmp.after

The rest of this logic looks reasonable to me though. :)

--D

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> new file mode 100644
> index 00000000..c5e8c4c5
> --- /dev/null
> +++ b/tests/xfs/554.out
> @@ -0,0 +1,40 @@
> +QA output created by 554
> +Creating directory system to dump using fsstress.
> +
> +-----------------------------------------------
> +fsstress : -f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10
> +-----------------------------------------------
> +Dumping to file...
> +xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_554 SCRATCH_MNT
> +xfsdump: using file dump (drive_simple) strategy
> +xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
> +xfsdump: dump date: DATE
> +xfsdump: session id: ID
> +xfsdump: session label: "stress_554"
> +xfsdump: ino map <PHASES>
> +xfsdump: ino map construction complete
> +xfsdump: estimated dump size: NUM bytes
> +xfsdump: /var/xfsdump/inventory created
> +xfsdump: creating dump session media file 0 (media 0, file 0)
> +xfsdump: dumping ino map
> +xfsdump: dumping directories
> +xfsdump: dumping non-directory files
> +xfsdump: ending media file
> +xfsdump: media file size NUM bytes
> +xfsdump: dump size (non-dir files) : NUM bytes
> +xfsdump: dump complete: SECS seconds elapsed
> +xfsdump: Dump Status: SUCCESS
> +Restoring from file...
> +xfsrestore  -x -f DUMP_FILE  -L stress_554 RESTORE_DIR
> +xfsrestore: using file dump (drive_simple) strategy
> +xfsrestore: using online session inventory
> +xfsrestore: searching media for directory dump
> +xfsrestore: examining media file 0
> +xfsrestore: reading directories
> +xfsrestore: found fake rootino #FAKENO, will fix.
> +xfsrestore: fix root # to ROOTNO (bind mount?)
> +xfsrestore: NUM directories and NUM entries processed
> +xfsrestore: directory post-processing
> +xfsrestore: restoring non-directory files
> +xfsrestore: restore complete: SECS seconds elapsed
> +xfsrestore: Restore Status: SUCCESS
> -- 
> 2.37.3
> 
