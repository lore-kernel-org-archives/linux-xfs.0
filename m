Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48951C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 05:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 214FB60241
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 05:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhHLF03 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 01:26:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233763AbhHLF03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 01:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628745964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fHgn4wJjnheeQXlyvh8YGanmrsc+0yREofzbnw+PWeA=;
        b=Ix3lNp1dY7sOQrRb/xmGljWO5zAMrL5ZUpXbiJ6kXNR4pHuy7gnMi6lvEa2aOPcNE1GvzO
        czB30QDkB6aup4VEeK1pvBc4x+7cPQEO3i/xZQrDT93HTI76g5Cv3Pl+M6XEdLrK3K3rI9
        L3hk0HiQu7SNZrPFeLRHCCYidCZCi5g=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-1eh9CqMLMGqtjudrxW51hg-1; Thu, 12 Aug 2021 01:25:59 -0400
X-MC-Unique: 1eh9CqMLMGqtjudrxW51hg-1
Received: by mail-pl1-f198.google.com with SMTP id 5-20020a170902ee45b029012d3a69c6c5so2990056plo.7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Aug 2021 22:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=fHgn4wJjnheeQXlyvh8YGanmrsc+0yREofzbnw+PWeA=;
        b=AAiWaMS6o8x9RbKo8UYpI8CdSAqL5oOKm+wGnBz+nj44QrVocwVsTiYh+X/NBCduBK
         xfLDsQe8gDtZsjA7ypgMFHJyMqpT0BJlQLITXIUZ8RT3I3PUpBUbgp26TnHednLTQfKY
         bw89vTTxsjUx1VZ/mxzKHTDnAymI1EsgCHU9XLD3kAC9CALc0aSFVZfP1meyDs40KuFx
         8Tg53WbYT70rC7Ti98/hPx9fZOyAVuX+kGWAQ9LBZiZOTOWdKVydNHlWqUmYdrT9Gt+l
         0JD8cbqSPIO16ysZQMnCC3xoJQM8mIDgiqqnMa4ZsNPNHqAbKv/yQv9xmQgAkcWUSKih
         FtoQ==
X-Gm-Message-State: AOAM5330hLy/5mm3QUmyYW81xYT4I/u928us7n90yy1C3DjxBSuvRcZZ
        ZRrkgHGd4D8j7MHV71gyRtx4m8pNLtLOV8kJR0j5RSPVPQLyXLyxyVYemaTzfIJGNJtrj8bNwT7
        uKCSQnhedcM8c6EXWdA/F
X-Received: by 2002:a63:f241:: with SMTP id d1mr2281682pgk.424.1628745958612;
        Wed, 11 Aug 2021 22:25:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZldd+hMyOD1H/UcdYg7Vtr4VX7hMsasreTFqb0lXH6vU81ZPC5USBjIf4JjRAGHBLMKBytQ==
X-Received: by 2002:a63:f241:: with SMTP id d1mr2281664pgk.424.1628745958364;
        Wed, 11 Aug 2021 22:25:58 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 20sm1766807pgg.36.2021.08.11.22.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 22:25:58 -0700 (PDT)
Date:   Thu, 12 Aug 2021 13:44:21 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] generic: test shutdowns of a nested filesystem
Message-ID: <20210812054421.gpeaoccgz26riwxz@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
 <162743103024.3428896.8525632218517299015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743103024.3428896.8525632218517299015.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:10:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> generic/475, but we're running fsstress on a disk image inside the
> scratch filesystem
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/725.out |    2 +
>  2 files changed, 138 insertions(+)
>  create mode 100755 tests/generic/725
>  create mode 100644 tests/generic/725.out
> 
> 
> diff --git a/tests/generic/725 b/tests/generic/725
> new file mode 100755
> index 00000000..f43bcb37
> --- /dev/null
> +++ b/tests/generic/725
> @@ -0,0 +1,136 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 725
> +#
> +# Test nested log recovery with repeated (simulated) disk failures.  We kick
> +# off fsstress on a loopback filesystem mounted on the scratch fs, then switch
> +# out the underlying scratch device with dm-error to see what happens when the
> +# disk goes down.  Having taken down both fses in this manner, remount them and
> +# repeat.  This test simulates VM hosts crashing to try to shake out CoW bugs
> +# in writeback on the host that cause VM guests to fail to recover.
> +#
> +. ./common/preamble
> +_begin_fstest shutdown auto log metadata eio
> +
> +_cleanup()
> +{
> +	cd /
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +	wait
> +	if [ -n "$loopmnt" ]; then
> +		umount $loopmnt 2>/dev/null
> +		rm -r -f $loopmnt
> +	fi
> +	rm -f $tmp.*
> +	_dmerror_unmount
> +	_dmerror_cleanup
> +}
> +
> +# Import common functions.
> +. ./common/dmerror
> +. ./common/reflink
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_dm_target error
> +_require_command "$KILLALL_PROG" "killall"
> +
> +echo "Silence is golden."
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +_dmerror_init
> +_dmerror_mount
> +
> +# Create a fs image consuming 1/3 of the scratch fs
> +scratch_freesp_bytes=$(stat -f -c '%a * %S' $SCRATCH_MNT | bc)
> +loopimg_bytes=$((scratch_freesp_bytes / 3))
> +
> +loopimg=$SCRATCH_MNT/testfs
> +truncate -s $loopimg_bytes $loopimg
> +_mkfs_dev $loopimg

I must say this's a nice test as generic/475, I'd like to have it ASAP :)
Just one question: if the FSTYP is nfs, cifs or virtiofs and so on ... [see below]

> +
> +loopmnt=$tmp.mount
> +mkdir -p $loopmnt
> +
> +scratch_aliveflag=$tmp.runsnap
> +snap_aliveflag=$tmp.snapping
> +
> +snap_loop_fs() {
> +	touch "$snap_aliveflag"
> +	while [ -e "$scratch_aliveflag" ]; do
> +		rm -f $loopimg.a
> +		_cp_reflink $loopimg $loopimg.a
> +		sleep 1
> +	done
> +	rm -f "$snap_aliveflag"
> +}
> +
> +fsstress=($FSSTRESS_PROG $FSSTRESS_AVOID -d "$loopmnt" -n 999999 -p "$((LOAD_FACTOR * 4))")
> +
> +for i in $(seq 1 $((25 * TIME_FACTOR)) ); do
> +	touch $scratch_aliveflag
> +	snap_loop_fs >> $seqres.full 2>&1 &
> +
> +	if ! _mount $loopimg $loopmnt -o loop; then

... This test will fail directly at here

Thanks,
Zorro

> +		rm -f $scratch_aliveflag
> +		_fail "loop mount failed"
> +		break
> +	fi
> +
> +	("${fsstress[@]}" >> $seqres.full &) > /dev/null 2>&1
> +
> +	# purposely include 0 second sleeps to test shutdown immediately after
> +	# recovery
> +	sleep $((RANDOM % (3 * TIME_FACTOR) ))
> +	rm -f $scratch_aliveflag
> +
> +	# This test aims to simulate sudden disk failure, which means that we
> +	# do not want to quiesce the filesystem or otherwise give it a chance
> +	# to flush its logs.  Therefore we want to call dmsetup with the
> +	# --nolockfs parameter; to make this happen we must call the load
> +	# error table helper *without* 'lockfs'.
> +	_dmerror_load_error_table
> +
> +	ps -e | grep fsstress > /dev/null 2>&1
> +	while [ $? -eq 0 ]; do
> +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +		wait > /dev/null 2>&1
> +		ps -e | grep fsstress > /dev/null 2>&1
> +	done
> +	for ((i = 0; i < 10; i++)); do
> +		test -e "$snap_aliveflag" || break
> +		sleep 1
> +	done
> +
> +	# Mount again to replay log after loading working table, so we have a
> +	# consistent XFS after test.
> +	$UMOUNT_PROG $loopmnt
> +	_dmerror_unmount || _fail "unmount failed"
> +	_dmerror_load_working_table
> +	if ! _dmerror_mount; then
> +		dmsetup table | tee -a /dev/ttyprintk
> +		lsblk | tee -a /dev/ttyprintk
> +		$XFS_METADUMP_PROG -a -g -o $DMERROR_DEV $seqres.dmfail.md
> +		_fail "mount failed"
> +	fi
> +done
> +
> +# Make sure the fs image file is ok
> +if [ -f "$loopimg" ]; then
> +	if _mount $loopimg $loopmnt -o loop; then
> +		$UMOUNT_PROG $loopmnt &> /dev/null
> +	else
> +		echo "final loop mount failed"
> +	fi
> +	_check_xfs_filesystem $loopimg none none
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/725.out b/tests/generic/725.out
> new file mode 100644
> index 00000000..ed73a9fc
> --- /dev/null
> +++ b/tests/generic/725.out
> @@ -0,0 +1,2 @@
> +QA output created by 725
> +Silence is golden.
> 

