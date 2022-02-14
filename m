Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81048C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Feb 2022 05:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiBNFZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Feb 2022 00:25:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiBNFZh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Feb 2022 00:25:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2989A4E395
        for <linux-xfs@vger.kernel.org>; Sun, 13 Feb 2022 21:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644816329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kEEclPPTGW24yM/9beA7UxY5afGC/ppzkZfaV5b/wNY=;
        b=abLfvskph9qz5KU9G14u3SUtqibjC4iFhtqXDbnlNXrX+/Q70p/Lm4FGCE+QDrI/tslsoO
        LdO6eFZuuqHoYjnJ8VAQh3eZvRVvGoRL/8leynlI4erpHx5L5Ids72/UOl8ZhZKkJvvB2b
        jfC0X5xnTGK71fFRKqXmcmD30AQhFhY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-n8AdYQhOMlmVES4u6h_6JA-1; Mon, 14 Feb 2022 00:25:26 -0500
X-MC-Unique: n8AdYQhOMlmVES4u6h_6JA-1
Received: by mail-pj1-f72.google.com with SMTP id n4-20020a17090ade8400b001b8bb511c3bso10109946pjv.7
        for <linux-xfs@vger.kernel.org>; Sun, 13 Feb 2022 21:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=kEEclPPTGW24yM/9beA7UxY5afGC/ppzkZfaV5b/wNY=;
        b=d1md4GV4xIEvoyCdcPAeZYIU0zU5q7cZGedsveHo5uyiOOfgb5GLPSGPqTptCWqDSf
         O/upLqPluVrdRGNjqbSdCNlIDOhwj0YmjU1Rg7dSZVKvvs9AEKjiOMCun0otwcCnyy01
         zl9Rnlav3/3iZPDfDD1fDELyUZAEHdbVrC1NGEko8n0f8AzIgxuCtKG1TANq7ZhKQWfd
         U3wTzrnR+k95ETO9pwpwZrWL6zU5Hw++zoL40zBOjDj2qd726WwgbspkKvRGTnU/FwhY
         7PUqG6SWpwfeceHas0yOTz4yLmV6eW8xSYonun0nFOqhWr2/GxUquDU7FPxwa49LKOln
         PjsA==
X-Gm-Message-State: AOAM532E7GlijSqOXZdGRGnDjLWqcwinxF/nGSxxx2/dsFfArTOHdvEu
        CCSYLS0gOq3/wGHUqLTAJ+1JhY+3CUeYUmjleAQhBLqVpEOIDg0DuOnEnjR/wfZw5NGPp8ebSyK
        /k+awb40eh4Q5chrev9Tj
X-Received: by 2002:a17:902:a9c2:: with SMTP id b2mr12674473plr.168.1644816325602;
        Sun, 13 Feb 2022 21:25:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwaJxU8p3llHpbropd+XEkVXoyEJWyRclTvlyym7sKDijzVo1NR0QqGqV+aM+FnD5QYm0BlEg==
X-Received: by 2002:a17:902:a9c2:: with SMTP id b2mr12674444plr.168.1644816325084;
        Sun, 13 Feb 2022 21:25:25 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n2sm12991813pjp.56.2022.02.13.21.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 21:25:24 -0800 (PST)
Date:   Mon, 14 Feb 2022 13:25:19 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfsdump when an inode < root inode is present
Message-ID: <20220214052519.xsmxb4d7mjcv2xod@zlang-mailbox>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <1644522177-8908-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644522177-8908-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 10, 2022 at 01:42:57PM -0600, Eric Sandeen wrote:
> This tests a longstanding bug where xfsdumps are not properly
> created when an inode is present on the filesytsem which has
> a lower number than the root inode.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Hi Eric,

Thanks for this patch! That's a good idea to get a inode number less than
root inode, at least I don't know a better one :)

The source code looks good to me, just two problems as below:
1) The mkfs might output some warning as [0], so better to filter them all.
2) After merging this patch (got a warning [1], that's fine:), build xfstests
   failed as [2]. By debuging, I found that your xfs/543 file miss executable
   bit [3]. By giving it '+x' permission, `make` passed.

Thanks,
Zorro



[0]
# diff -u /home/xfstests-dev/tests/xfs/543.out /home/xfstests-dev/results//xfs/543.out.bad
@@ -1,4 +1,8 @@
 QA output created by 543
+mkfs.xfs: Specified data stripe unit 1024 is not the same as the volume stripe unit 512
+mkfs.xfs: Specified data stripe width 1024 is not the same as the volume stripe width 512
+log stripe unit (524288 bytes) is too large (maximum is 256KiB)
+log stripe unit adjusted to 32KiB
...

[1]
# git am /tmp/1.patch
Applying: xfs: test xfsdump when an inode < root inode is present
.git/rebase-apply/patch:107: trailing whitespace.
xfsrestore: dump description:
warning: 1 line adds whitespace errors.

[2]
# make
...
Building xfs
 [GROUP] /home/xfstests-dev/tests/xfs/group.list
gmake[3]: *** [../../include/buildgrouplist:8: group.list] Error 1
gmake[2]: *** [../include/buildrules:31: xfs] Error 2
gmake[1]: *** [include/buildrules:31: tests] Error 2
make: *** [Makefile:51: default] Error 2

[3]
# git ls-files -s tests/xfs/54*
100755 55484dd3310cde1e7b26e01d0e6b97e492e14fb5 0       tests/xfs/540
100644 094f0f63dd6ce685ec2c467f3f0eea0f9532124e 0       tests/xfs/540.out
100755 ae2fd819d5f089cfa64ff9fee299bb59b0ea6c71 0       tests/xfs/541
100644 d056f0532b7c5734488c84ad6f8e1592e1c794dc 0       tests/xfs/541.out
100755 5c45eed7cdabfcb42ce1e797ac47f5f0cee55146 0       tests/xfs/542
100644 0a0fbd524b9f699267816775b1cb2bb53ae309e9 0       tests/xfs/542.out
100644 f75f8da3ad7ad8971dade88eb8e7bcecb2a62125 0       tests/xfs/543      <===
100644 a5224aaf082dbdfb6c92050a25aa0ca09c045b89 0       tests/xfs/543.out

>  common/dump       |  1 +
>  tests/xfs/543     | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/543.out | 47 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 111 insertions(+)
>  create mode 100644 tests/xfs/543
>  create mode 100644 tests/xfs/543.out
> 
> diff --git a/common/dump b/common/dump
> index 3c4029f..09a0ebc 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -214,6 +214,7 @@ _require_tape()
>  
>  _wipe_fs()
>  {
> +    [[ "$WIPE_FS" = "no" ]] && return
>      _require_scratch
>  
>      _scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> diff --git a/tests/xfs/543 b/tests/xfs/543
> new file mode 100644
> index 0000000..f75f8da
> --- /dev/null
> +++ b/tests/xfs/543
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test 543
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
> +_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full
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
> +WIPE_FS="no"
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
> diff --git a/tests/xfs/543.out b/tests/xfs/543.out
> new file mode 100644
> index 0000000..a5224aa
> --- /dev/null
> +++ b/tests/xfs/543.out
> @@ -0,0 +1,47 @@
> +QA output created by 543
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
> 1.8.3.1
> 

