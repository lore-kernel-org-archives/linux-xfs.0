Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3EFC433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Oct 2022 04:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJOEed (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Oct 2022 00:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJOEec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2022 00:34:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FB756B9C
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 21:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665808462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeCGS/aYinTJ5kb0lkjp4PQQd57rgNKx7Ntcyjwsjho=;
        b=UEPtPfMGd4xceo2J8jc3nGrUdeqGdoNAkk6YF9yvOLzCfsCCwdvwnS6eDVIReNzLK5a/Gd
        mpscaDM4yxGLjI0UQGpia6R3XCroDmq8uEFi18oaJSfwQPtib6hubGJGeLvam1cYFepd21
        KbIygMrSxxxineEvveau4hDipCrp3z0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-D8Jv1t2iP1alqFCM8CLV6A-1; Sat, 15 Oct 2022 00:34:21 -0400
X-MC-Unique: D8Jv1t2iP1alqFCM8CLV6A-1
Received: by mail-pl1-f200.google.com with SMTP id p3-20020a170902e74300b0018546b77dccso1261730plf.17
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 21:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QeCGS/aYinTJ5kb0lkjp4PQQd57rgNKx7Ntcyjwsjho=;
        b=bIFK8fFGPzA3M7f61DUyFPQ9eeWu52jbFQQGAhTdIXWzfM47mU/rXh65aEOTh7sWuR
         ksRBXtWP82EkQaLRmr+breyIBnHzBNgZ5KEcGFD3hnh6/gGc7JpKtyxyJTCWPufyV3qo
         87hwXqCGBGo9sWm5c/UCI9H67u8ltaOGwN7FVkKcLnO1IfVcO4wuBkJer/RFi9FXgPBM
         PuPQtc0O5zm54TUar4lo5XXzTSYEeZKzqbiwu228G7Kfx8akq1cy9mJUJUi9QS/GVAFG
         iMIWpl9IyPx5XjnBJHsQD3lvmsjsS/Vet/FGxSoK6W+Gdfshh9WueSUkppj0W3R+SUC6
         kmdA==
X-Gm-Message-State: ACrzQf3NfGgHNIB7J3AOsY3Hz+0S1rBqjB6r7e2PPPQ1w19LCxBsmg8i
        fRX8cyai84duR9GSG15ABPx5Ac3/0zdRBobpFdR0/QnyS0V/ejTgG5HggV2ifu/bcEwYM8rnvCK
        l0BYxyqIwri60wUxb9vK7
X-Received: by 2002:a17:902:ea82:b0:183:a85a:9b26 with SMTP id x2-20020a170902ea8200b00183a85a9b26mr1069297plb.166.1665808458521;
        Fri, 14 Oct 2022 21:34:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4ddgWnaVAmKno797+aXzJ49i2F3efhVsAtO2hoAfjSSLd6vyVrjy6mgi5bFj1Cna5wX6IrDQ==
X-Received: by 2002:a17:902:ea82:b0:183:a85a:9b26 with SMTP id x2-20020a170902ea8200b00183a85a9b26mr1069270plb.166.1665808458024;
        Fri, 14 Oct 2022 21:34:18 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c10600b001728ac8af94sm2425167pli.248.2022.10.14.21.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 21:34:17 -0700 (PDT)
Date:   Sat, 15 Oct 2022 12:34:12 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH V4] xfs: test for fixing wrong root inode number in dump
Message-ID: <20221015043412.2rup2kachj4blc7d@zlang-mailbox>
References: <20221014160907.128619-1-shiina.hironori@fujitsu.com>
 <20221015020400.182189-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221015020400.182189-1-shiina.hironori@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 10:04:00PM -0400, Hironori Shiina wrote:
> Test '-x' option of xfsrestore. With this option, a wrong root inode
> number in a dump file is corrected. A root inode number can be wrong
> in a dump created by problematic xfsdump (v3.1.7 - v3.1.9) with
> bulkstat misuse. In this test, a corrupted dump file is created by
> overwriting a root inode number in a header.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
> ---
> changes since v3:
>   - Flatten out nested pointer dereferencing and typecasting.
> changes since v2:
>   - Use glibc functions to convert endian.
>   - Copy the structure definitions from xfsdump source files.
> changes since RFC v1:
>   - Skip the test if xfsrestore does not support '-x' flag.
>   - Create a corrupted dump by overwriting a root inode number in a dump
>     file with a new tool instead of checking in a binary dump file.

Thanks for this patch, hope the src/fake-dump-rootino.c can keep working
well for long time. And Thanks Darrick help to review this patch. I don't
have objection on this patch, just a few small review points as below ...

> 
>  common/dump             |   2 +-
>  common/xfs              |   6 ++
>  src/Makefile            |   2 +-
>  src/fake-dump-rootino.c | 224 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/554           |  73 +++++++++++++
>  tests/xfs/554.out       |  40 +++++++
>  6 files changed, 345 insertions(+), 2 deletions(-)
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
> index 00000000..8a30dffd
> --- /dev/null
> +++ b/src/fake-dump-rootino.c
> @@ -0,0 +1,224 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Fujitsu Limited.  All Rights Reserved. */
> +#define _LARGEFILE64_SOURCE
> +#include <endian.h>
> +#include <fcntl.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +#include <uuid/uuid.h>
> +
> +// Definitions from xfsdump
> +#define PGSZLOG2	12
> +#define PGSZ		(1 << PGSZLOG2)
> +#define GLOBAL_HDR_SZ		PGSZ
> +#define GLOBAL_HDR_MAGIC_SZ	8
> +#define GLOBAL_HDR_STRING_SZ	0x100
> +#define GLOBAL_HDR_TIME_SZ	4
> +#define GLOBAL_HDR_UUID_SZ	0x10
> +typedef int32_t time32_t;
> +struct global_hdr {
> +	char gh_magic[GLOBAL_HDR_MAGIC_SZ];		/*   8    8 */
> +		/* unique signature of xfsdump */
> +	uint32_t gh_version;				/*   4    c */
> +		/* header version */
> +	uint32_t gh_checksum;				/*   4   10 */
> +		/* 32-bit unsigned additive inverse of entire header */
> +	time32_t gh_timestamp;				/*   4   14 */
> +		/* time32_t of dump */
> +	char gh_pad1[4];				/*   4   18 */
> +		/* alignment */
> +	uint64_t gh_ipaddr;				/*   8   20 */
> +		/* from gethostid(2), room for expansion */
> +	uuid_t gh_dumpid;				/*  10   30 */
> +		/* ID of dump session	 */
> +	char gh_pad2[0xd0];				/*  d0  100 */
> +		/* alignment */
> +	char gh_hostname[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
> +		/* from gethostname(2) */
> +	char gh_dumplabel[GLOBAL_HDR_STRING_SZ];	/* 100  300 */
> +		/* label of dump session */
> +	char gh_pad3[0x100];				/* 100  400 */
> +		/* padding */
> +	char gh_upper[GLOBAL_HDR_SZ - 0x400];		/* c00 1000 */
> +		/* header info private to upper software layers */
> +};
> +typedef struct global_hdr global_hdr_t;
> +
> +#define sizeofmember( t, m )	sizeof( ( ( t * )0 )->m )
> +
> +#define DRIVE_HDR_SZ		sizeofmember(global_hdr_t, gh_upper)
> +struct drive_hdr {
> +	uint32_t dh_drivecnt;				/*   4    4 */
> +		/* number of drives used to dump the fs */
> +	uint32_t dh_driveix;				/*   4    8 */
> +		/* 0-based index of the drive used to dump this stream */
> +	int32_t dh_strategyid;				/*   4    c */
> +		/* ID of the drive strategy used to produce this dump */
> +	char dh_pad1[0x1f4];				/* 1f4  200 */
> +		/* padding */
> +	char dh_specific[0x200];			/* 200  400 */
> +		/* drive strategy-specific info */
> +	char dh_upper[DRIVE_HDR_SZ - 0x400];		/* 800  c00 */
> +		/* header info private to upper software layers */
> +};
> +typedef struct drive_hdr drive_hdr_t;
> +
> +#define MEDIA_HDR_SZ		sizeofmember(drive_hdr_t, dh_upper)
> +struct media_hdr {
> +	char mh_medialabel[GLOBAL_HDR_STRING_SZ];	/* 100  100 */
> +		/* label of media object containing file */
> +	char mh_prevmedialabel[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
> +		/* label of upstream media object */
> +	char mh_pad1[GLOBAL_HDR_STRING_SZ];		/* 100  300 */
> +		/* in case more labels needed */
> +	uuid_t mh_mediaid;				/*  10  310 */
> +		/* ID of media object 	*/
> +	uuid_t mh_prevmediaid;				/*  10  320 */
> +		/* ID of upstream media object */
> +	char mh_pad2[GLOBAL_HDR_UUID_SZ];		/*  10  330 */
> +		/* in case more IDs needed */
> +	uint32_t mh_mediaix;				/*   4  334 */
> +		/* 0-based index of this media object within the dump stream */
> +	uint32_t mh_mediafileix;			/*   4  338 */
> +		/* 0-based index of this file within this media object */
> +	uint32_t mh_dumpfileix;			/*   4  33c */
> +		/* 0-based index of this file within this dump stream */
> +	uint32_t mh_dumpmediafileix;			/*   4  340 */
> +		/* 0-based index of file within dump stream and media object */
> +	uint32_t mh_dumpmediaix;			/*   4  344 */
> +		/* 0-based index of this dump within the media object */
> +	int32_t mh_strategyid;				/*   4  348 */
> +		/* ID of the media strategy used to produce this dump */
> +	char mh_pad3[0x38];				/*  38  380 */
> +		/* padding */
> +	char mh_specific[0x80];			/*  80  400 */
> +		/* media strategy-specific info */
> +	char mh_upper[MEDIA_HDR_SZ - 0x400];		/* 400  800 */
> +		/* header info private to upper software layers */
> +};
> +typedef struct media_hdr media_hdr_t;
> +
> +#define CONTENT_HDR_SZ		sizeofmember(media_hdr_t, mh_upper)
> +#define CONTENT_HDR_FSTYPE_SZ	16
> +#define CONTENT_STATSZ		160 /* must match dlog.h DLOG_MULTI_STATSZ */
> +struct content_hdr {
> +	char ch_mntpnt[GLOBAL_HDR_STRING_SZ];		/* 100  100 */
> +		/* full pathname of fs mount point */
> +	char ch_fsdevice[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
> +		/* full pathname of char device containing fs */
> +	char  ch_pad1[GLOBAL_HDR_STRING_SZ];		/* 100  300 */
> +		/* in case another label is needed */
> +	char ch_fstype[CONTENT_HDR_FSTYPE_SZ];	/*  10  310 */
> +		/* from fsid.h */
> +	uuid_t ch_fsid;					/*  10  320 */
> +		/* file system uuid */
> +	char  ch_pad2[GLOBAL_HDR_UUID_SZ];		/*  10  330 */
> +		/* in case another id is needed */
> +	char ch_pad3[8];				/*   8  338 */
> +		/* padding */
> +	int32_t ch_strategyid;				/*   4  33c */
> +		/* ID of the content strategy used to produce this dump */
> +	char ch_pad4[4];				/*   4  340 */
> +		/* alignment */
> +	char ch_specific[0xc0];			/*  c0  400 */
> +		/* content strategy-specific info */
> +};
> +typedef struct content_hdr content_hdr_t;
> +
> +typedef uint64_t xfs_ino_t;
> +struct startpt {
> +	xfs_ino_t sp_ino;		/* first inode to dump */
> +	off64_t sp_offset;	/* bytes to skip in file data fork */
> +	int32_t sp_flags;
> +	int32_t sp_pad1;
> +};
> +typedef struct startpt startpt_t;
> +
> +#define CONTENT_INODE_HDR_SZ  sizeofmember(content_hdr_t, ch_specific)
> +struct content_inode_hdr {
> +	int32_t cih_mediafiletype;			/*   4   4 */
> +		/* dump media file type: see #defines below */
> +	int32_t cih_dumpattr;				/*   4   8 */
> +		/* dump attributes: see #defines below */
> +	int32_t cih_level;				/*   4   c */
> +		/* dump level */
> +	char pad1[4];					/*   4  10 */
> +		/* alignment */
> +	time32_t cih_last_time;				/*   4  14 */
> +		/* if an incremental, time of previous dump at a lesser level */
> +	time32_t cih_resume_time;			/*   4  18 */
> +		/* if a resumed dump, time of interrupted dump */
> +	xfs_ino_t cih_rootino;				/*   8  20 */
> +		/* root inode number */
> +	uuid_t cih_last_id;				/*  10  30 */
> +		/* if an incremental, uuid of prev dump */
> +	uuid_t cih_resume_id;				/*  10  40 */
> +		/* if a resumed dump, uuid of interrupted dump */
> +	startpt_t cih_startpt;				/*  18  58 */
> +		/* starting point of media file contents */
> +	startpt_t cih_endpt;				/*  18  70 */
> +		/* starting point of next stream */
> +	uint64_t cih_inomap_hnkcnt;			/*   8  78 */
> +
> +	uint64_t cih_inomap_segcnt;			/*   8  80 */
> +
> +	uint64_t cih_inomap_dircnt;			/*   8  88 */
> +
> +	uint64_t cih_inomap_nondircnt;			/*   8  90 */
> +
> +	xfs_ino_t cih_inomap_firstino;			/*   8  98 */
> +
> +	xfs_ino_t cih_inomap_lastino;			/*   8  a0 */
> +
> +	uint64_t cih_inomap_datasz;			/*   8  a8 */
> +		/* bytes of non-metadata dumped */
> +	char cih_pad2[CONTENT_INODE_HDR_SZ - 0xa8];	/*  18  c0 */
> +		/* padding */
> +};
> +typedef struct content_inode_hdr content_inode_hdr_t;
> +// End of definitions from xfsdump
> +
> +int main(int argc, char *argv[]) {
> +
> +	if (argc < 3) {
> +		fprintf(stderr, "Usage: %s <path/to/dumpfile> <fake rootino>\n", argv[0]);
> +		exit(1);
> +	}
> +
> +	const char *filepath = argv[1];
> +	const uint64_t fake_root_ino = (uint64_t)strtol(argv[2], NULL, 10);
> +
> +	int fd = open(filepath, O_RDWR);
> +	if (fd < 0) {
> +		perror("open");
> +		exit(1);
> +	}
> +	global_hdr_t *header = mmap(NULL, GLOBAL_HDR_SZ, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> +	if (header == MAP_FAILED) {
> +		perror("mmap");
> +		exit(1);
> +	}
> +
> +	drive_hdr_t *dh = (drive_hdr_t *)header->gh_upper;
> +	media_hdr_t *mh = (media_hdr_t *)dh->dh_upper;
> +	content_hdr_t *ch = (content_hdr_t *)mh->mh_upper;
> +	content_inode_hdr_t *cih = (content_inode_hdr_t *)ch->ch_specific;
> +	uint64_t *rootino_ptr = &cih->cih_rootino;
> +
> +	int32_t checksum = (int32_t)be32toh(header->gh_checksum);
> +	uint64_t orig_rootino = be64toh(*rootino_ptr);
> +
> +	// Fake root inode number
> +	*rootino_ptr = htobe64(fake_root_ino);
> +
> +	// Update checksum along with overwriting rootino.
> +	uint64_t gap = orig_rootino - fake_root_ino;
> +	checksum += (gap >> 32) + (gap & 0x00000000ffffffff);
> +	header->gh_checksum = htobe32(checksum);
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

_fixed_by_git_commit xfsdump \
	XXXXXXXXXXXX xfsrestore: fix rootdir due to xfsdump bulkstat misuse

As this patch hasn't been merged by xfsdump(but acked), so I don't mind using
"XXXX..." to instead the commit id. We can change all these XXXX.... later in
one patch, for now we know its subject name at first.

> +_require_xfs_io_command "falloc"
> +_require_scratch
> +_require_xfsrestore_xflag
> +
> +# A large stripe unit will put the root inode out quite far
> +# due to alignment, leaving free blocks ahead of it.
> +_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full 2>&1

I think most cases write as this:
  _scratch_mkfs... $some_specific_options || _fail ...

if you use some specific mkfs options to mkfs. Due to if mkfs fails, this
case will keep running on old fs in SCRATCH_DEV without any warning/error.

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
> +
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

