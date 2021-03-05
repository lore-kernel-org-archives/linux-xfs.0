Return-Path: <SRS0=x8pl=ID=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAD9C433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 14:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE2F26501B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 14:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhCEOnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhCEOm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 09:42:59 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52202C061574;
        Fri,  5 Mar 2021 06:42:59 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u18so1497762plc.12;
        Fri, 05 Mar 2021 06:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=anUc0SLDBzvuldIeSS6F5fFDqDjsDwDW7LGcqsK7mc4=;
        b=ld6/tT/i9HoqQ53eQxQJysjRCEm6eeJa2O/FCD6L0Y3aLuuQYfRweaqZUDTOWu9UTY
         OqfSwI46CkhygHEIydnTOfKMrO9Cg/ypdVS1nMMteBd5i1gJEa0D1VgBHg9htimY81KZ
         yqgvg/mK2zijw0rl0lvVK2zaPM/zb91K0Uzxf3vMqzlGLERS9BqUSdHUghbN5AlyVCXY
         IZlfGtqU/bWwSnF6sQj1j6s0QXAf18VAqrd0u9xIMtOA2SNzrCGCOnG+mtWj9UNqYmy8
         JVFdNwy+qN3U1APVrMrGQCfiNYvwqrayscESQv7y/5bywOUwzlxtt4cLPKOvziEd1QSR
         t76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=anUc0SLDBzvuldIeSS6F5fFDqDjsDwDW7LGcqsK7mc4=;
        b=ODziT2WKZ09jWtXcSNjylAPQTya6c4mL16MTzhoh7AcqVsVVIBbYBFSRU73iFxM/wu
         50ZK5d+DjbNYcqh4hAPIxVUUPstBT9VF9zGIJNX6yIaZnTsMSOkbthgNyiOIscQJFfms
         osRDe432+pPhhxFs+1OPiwStNCZZ2h3CNdfJGSXYxFmEhdM4+FA0QX5yZv0dT0db+mLR
         Q3TyTmVgnqGkff5mt81v6uKZIzDglrKASjKXIgNh+JpylKjp3l6vf2DJGs7qnEk8//wh
         FSMieuia+0VqOH36bdK3+OePKUUGnnO6Hjg11eXtXmIyfcyJ5jrmUIAJ6XJkTNq4OdS4
         yMYg==
X-Gm-Message-State: AOAM532jSKCLiujc9XtOs2mjp/h8+N+/aA9Iwp3kl09qfVSMIfLPTn01
        5nuFb7Z3LM3mGQkcVXZf3ks=
X-Google-Smtp-Source: ABdhPJykONWboz+Y/XYCJ3qZ3vXO0oaCWCNbcaw4XxujMZ+rXbUl3e3oPtIEoKLY0xKk/J5KX1gSdg==
X-Received: by 2002:a17:902:e54f:b029:e2:8f59:6fe0 with SMTP id n15-20020a170902e54fb02900e28f596fe0mr9094227plf.76.1614955378857;
        Fri, 05 Mar 2021 06:42:58 -0800 (PST)
Received: from garuda ([122.171.172.255])
        by smtp.gmail.com with ESMTPSA id 186sm2959593pfx.132.2021.03.05.06.42.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Mar 2021 06:42:58 -0800 (PST)
References: <20210118062022.15069-1-chandanrlinux@gmail.com> <20210118062022.15069-3-chandanrlinux@gmail.com> <20210303173823.GJ7269@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 02/11] xfs: Check for extent overflow when trivally adding a new extent
In-reply-to: <20210303173823.GJ7269@magnolia>
Date:   Fri, 05 Mar 2021 20:12:55 +0530
Message-ID: <87h7lpu0eo.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 23:08, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 11:50:13AM +0530, Chandan Babu R wrote:
>> This test verifies that XFS does not cause inode fork's extent count to
>> overflow when adding a single extent while there's no possibility of
>> splitting an existing mapping.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  tests/xfs/522     | 173 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/522.out |  20 ++++++
>>  tests/xfs/group   |   1 +
>>  3 files changed, 194 insertions(+)
>>  create mode 100755 tests/xfs/522
>>  create mode 100644 tests/xfs/522.out
>>
>> diff --git a/tests/xfs/522 b/tests/xfs/522
>> new file mode 100755
>> index 00000000..33f0591e
>> --- /dev/null
>> +++ b/tests/xfs/522
>> @@ -0,0 +1,173 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
>> +#
>> +# FS QA Test 522
>> +#
>> +# Verify that XFS does not cause inode fork's extent count to overflow when
>> +# adding a single extent while there's no possibility of splitting an existing
>> +# mapping.
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/quota
>> +. ./common/inject
>> +. ./common/populate
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs xfs
>> +_require_scratch
>> +_require_xfs_quota
>> +_require_xfs_debug
>> +_require_test_program "punch-alternating"
>> +_require_xfs_io_command "falloc"
>> +_require_xfs_io_error_injection "reduce_max_iextents"
>> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>> +
>> +echo "Format and mount fs"
>> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
>> +_scratch_mount -o uquota >> $seqres.full
>> +
>> +bsize=$(_get_file_block_size $SCRATCH_MNT)
>> +
>> +echo "* Delalloc to written extent conversion"
>
> What happens if delalloc is disabled?  e.g. the mkfs parameters have
> extent size hints set on the root directory?
>
> (I think it'll be fine since you write every other block...)

Yes, XFS ends up doing Direct IO and the file blocks are still fragmented
causing extent count to increase beyond the pseudo max limit of 10.

>
>> +testfile=$SCRATCH_MNT/testfile
>> +
>> +echo "Inject reduce_max_iextents error tag"
>> +_scratch_inject_error reduce_max_iextents 1
>> +
>> +nr_blks=$((15 * 2))
>> +
>> +echo "Create fragmented file"
>> +for i in $(seq 0 2 $((nr_blks - 1))); do
>> +	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $testfile \
>> +	       >> $seqres.full 2>&1
>> +	[[ $? != 0 ]] && break
>> +done
>> +
>> +echo "Verify \$testfile's extent count"
>> +
>> +nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
>> +nextents=${nextents##fsxattr.nextents = }
>
> /me wonders if it's time for a helper to extract these fields...

Thanks for the suggestion. I will include a helper function in the next
version of the patchset.

>
>> +if (( $nextents > 10 )); then
>> +	echo "Extent count overflow check failed: nextents = $nextents"
>> +	exit 1
>> +fi
>> +
>> +rm $testfile
>> +
>> +echo "* Fallocate unwritten extents"
>> +
>> +echo "Fallocate fragmented file"
>> +for i in $(seq 0 2 $((nr_blks - 1))); do
>> +	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
>> +	       >> $seqres.full 2>&1
>> +	[[ $? != 0 ]] && break
>> +done
>> +
>> +echo "Verify \$testfile's extent count"
>> +
>> +nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
>> +nextents=${nextents##fsxattr.nextents = }
>> +if (( $nextents > 10 )); then
>> +	echo "Extent count overflow check failed: nextents = $nextents"
>> +	exit 1
>> +fi
>> +
>> +rm $testfile
>> +
>> +echo "* Directio write"
>> +
>> +echo "Create fragmented file via directio writes"
>> +for i in $(seq 0 2 $((nr_blks - 1))); do
>> +	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
>> +	       >> $seqres.full 2>&1
>> +	[[ $? != 0 ]] && break
>> +done
>> +
>> +echo "Verify \$testfile's extent count"
>> +
>> +nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
>> +nextents=${nextents##fsxattr.nextents = }
>> +if (( $nextents > 10 )); then
>> +	echo "Extent count overflow check failed: nextents = $nextents"
>> +	exit 1
>> +fi
>> +
>> +rm $testfile
>> +
>> +echo "* Extend quota inodes"
>> +
>> +echo "Disable reduce_max_iextents error tag"
>> +_scratch_inject_error reduce_max_iextents 0
>> +
>> +echo "Consume free space"
>> +fillerdir=$SCRATCH_MNT/fillerdir
>> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
>> +nr_free_blks=$((nr_free_blks * 90 / 100))
>> +
>> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
>> +
>> +echo "Create fragmented filesystem"
>> +for dentry in $(ls -1 $fillerdir/); do
>> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
>> +done
>> +
>> +echo "Inject reduce_max_iextents error tag"
>> +_scratch_inject_error reduce_max_iextents 1
>> +
>> +echo "Inject bmap_alloc_minlen_extent error tag"
>> +_scratch_inject_error bmap_alloc_minlen_extent 1
>
> Are we testing to see if the fs blows up when the quota inodes hit max
> iext count?  If so, please put that in the comments for this section.

Sure, I will add a description.

>
>> +
>> +nr_blks=20
>> +
>> +# This is a rough calculation; It doesn't take block headers into
>> +# consideration.
>> +# gdb -batch vmlinux -ex 'print sizeof(struct xfs_dqblk)'
>> +# $1 = 136
>> +nr_quotas_per_block=$((bsize / 136))
>> +nr_quotas=$((nr_quotas_per_block * nr_blks))
>> +
>> +echo "Extend uquota file"
>> +for i in $(seq 0 $nr_quotas_per_block $nr_quotas); do
>> +	chown $i $testfile >> $seqres.full 2>&1
>> +	[[ $? != 0 ]] && break
>> +done
>> +
>> +_scratch_unmount >> $seqres.full
>> +
>> +echo "Verify uquota inode's extent count"
>> +uquotino=$(_scratch_xfs_db -c sb -c "print uquotino")
>> +uquotino=${uquotino##uquotino = }
>
> _scratch_xfs_get_metadata_field

I will fix this.

--
chandan
