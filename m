Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA1CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 15:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354166AbiDSQAV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 12:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354168AbiDSQAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 12:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067C224957;
        Tue, 19 Apr 2022 08:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 974F66179A;
        Tue, 19 Apr 2022 15:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F0FC385AA;
        Tue, 19 Apr 2022 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650383852;
        bh=SC7FlWcwrwuxxYzmzwyfZ6rHjCjx9tvQ4rhTNhOnFZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DUtUbTj89AWR3Lyzj6VNRYNjZV18L6sS27Hvou8p1+YleaOgNea5eWu8tOkOcA0XQ
         lHXWVQRNWUlpGt1ZEe6kNw5dB3kG7lY9mMdirPpzalmdiBkKG8i4LRgtp3bZ6wsaYO
         Z//0fqMdTmj/Vyf7ROVrVHusNvwv9J0U/R7fZaoOdkvhW6aTOhiznA0QGZRHXlbHFt
         CAmOzaqyImc8ChDm9qdWK3IxnevpRfwzannFPWMitjHrPWvgi1Vp3OEqK3GGpSrS0/
         CMF4ckkKizF/nFsp6XWHsiCHzRtJXYppqAuC9e8KrYImz6MVIxI5p1pco7uGzVks5P
         2AhtCZRk1LtYw==
Date:   Tue, 19 Apr 2022 08:57:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, sandeen@redhat.com
Subject: Re: [PATCH v3 2/2] xfs: test xfsdump when an inode < root inode is
 present
Message-ID: <20220419155731.GK17025@magnolia>
References: <20220418170326.425762-1-zlang@redhat.com>
 <20220418170326.425762-3-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418170326.425762-3-zlang@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 01:03:26AM +0800, Zorro Lang wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> This tests a longstanding bug where xfsdumps are not properly
> created when an inode is present on the filesytsem which has
> a lower number than the root inode.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Zorro Lang <zlang@redhat.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/999     | 62 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out | 47 +++++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..9b1f7f5b
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test No. 999
> +#
> +# Create a filesystem which contains an inode with a lower number
> +# than the root inode. Ensure that xfsdump/xfsrestore handles this.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick dump
> +
> +# Import common functions.
> +. ./common/dump
> +
> +_supported_fs xfs
> +_require_scratch
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
> +# filter out the file count, it changes as fsstress adds new operations
> +_do_dump_restore | sed -e "/entries processed$/s/[0-9][0-9]*/NUM/g"
> +
> +echo -n "After: " >> $seqres.full
> +_count_restoredir_files | tee $tmp.after >> $seqres.full
> +diff -u $tmp.before $tmp.after
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..f6ab75d2
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,47 @@
> +QA output created by 999
> +Creating directory system to dump using fsstress.
> +
> +-----------------------------------------------
> +fsstress : -f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10
> +-----------------------------------------------
> +xfsdump|xfsrestore ...
> +xfsdump  -s DUMP_SUBDIR - SCRATCH_MNT | xfsrestore  - RESTORE_DIR
> +xfsrestore: using file dump (drive_simple) strategy
> +xfsrestore: searching media for dump
> +xfsrestore: examining media file 0
> +xfsrestore: dump description: 
> +xfsrestore: hostname: HOSTNAME
> +xfsrestore: mount point: SCRATCH_MNT
> +xfsrestore: volume: SCRATCH_DEV
> +xfsrestore: session time: TIME
> +xfsrestore: level: 0
> +xfsrestore: session label: ""
> +xfsrestore: media label: ""
> +xfsrestore: file system ID: ID
> +xfsrestore: session id: ID
> +xfsrestore: media ID: ID
> +xfsrestore: searching media for directory dump
> +xfsrestore: reading directories
> +xfsrestore: NUM directories and NUM entries processed
> +xfsrestore: directory post-processing
> +xfsrestore: restoring non-directory files
> +xfsrestore: restore complete: SECS seconds elapsed
> +xfsrestore: Restore Status: SUCCESS
> +xfsdump: using file dump (drive_simple) strategy
> +xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
> +xfsdump: dump date: DATE
> +xfsdump: session id: ID
> +xfsdump: session label: ""
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
> -- 
> 2.31.1
> 
