Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203C8C432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 14:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E40610A5
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 14:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhHMOjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 10:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234515AbhHMOjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Aug 2021 10:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628865530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3OL71GpgNDDUpKcOqSGUvgCQzYz2oaQSWEHMvx/6VcQ=;
        b=aWqpZnDh3+y+iTso1uis+MpcpTgLn5ufgeNcEEFjGe4X6XOgP0aoTAKPsoOEY09G6mFlNa
        P3Uz5MU4yPXoEuM8CRnQ8Ja4NzZOvusXvz2GLGC02tNT72O4IxfRucGtp8lc0gHpcQLv2p
        njCpCqR2BXrwekYkstm8PIHuKwY7S8I=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-nRyTw-p7NMKrqiV4zhrGRQ-1; Fri, 13 Aug 2021 10:38:49 -0400
X-MC-Unique: nRyTw-p7NMKrqiV4zhrGRQ-1
Received: by mail-pj1-f71.google.com with SMTP id v9-20020a17090a7c09b02901778a2a8fd6so10830388pjf.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 07:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=3OL71GpgNDDUpKcOqSGUvgCQzYz2oaQSWEHMvx/6VcQ=;
        b=IiZX3j5BBgnnYIzB3ItDOSUM1iI9LmmiF6wdAjkG6PfLBnj9QHvlNDnCmZrOMmO8T7
         nolnlZVdAz39c1zxqByAV29tSQ8ItQROPURZCcOeFJO/w+uFP4L64aqqxoYvAtCwY7Rw
         NxTZw28ahOqhFhgna4KCONBWgxxIUFsH2IXejDOLRLLoyP9dbPauMy34umkvv/7J0F7v
         ccqw7m9apEg9rWS3yk8QGMZFvOKotdlvsy+EDvjZDAuSMHHRbdeKjh+wDJTUh75q6U0F
         tx+/C50G5g9VuNROGcPLdMwZz+di3dvJf3M9JKgkVp/feV+DIap8QlA1FGN1zmpxxQ9H
         OLeA==
X-Gm-Message-State: AOAM5317JwUqd/1GZ2HCHLPe6E0E653w0eb3PGOMFJ5qF4JLfkZ4ACVp
        cHYzQDLL1tKENKlSPthCxxdImWHKJGMdWJ26r5QNo19B+rnrY/uF1vNX+bDWDN310BJIth6Qs1k
        7Q9pezabK3kZ2icDQVDNL
X-Received: by 2002:a17:90a:150d:: with SMTP id l13mr2866073pja.93.1628865528268;
        Fri, 13 Aug 2021 07:38:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynNUPXLIhD+GsWINUggjHmSVyR9399eCO7JYIIJE8po+zKW9n0xLc6obRwrfgvaKAFq7pB7w==
X-Received: by 2002:a17:90a:150d:: with SMTP id l13mr2866048pja.93.1628865527981;
        Fri, 13 Aug 2021 07:38:47 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u27sm2588721pfg.83.2021.08.13.07.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 07:38:47 -0700 (PDT)
Date:   Fri, 13 Aug 2021 22:52:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] generic: test shutdowns of a nested filesystem
Message-ID: <20210813145200.vdzh2b452bxxrz2g@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
 <162743103024.3428896.8525632218517299015.stgit@magnolia>
 <20210812054421.gpeaoccgz26riwxz@fedora>
 <20210812170746.GQ3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812170746.GQ3601443@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 10:07:46AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 12, 2021 at 01:44:21PM +0800, Zorro Lang wrote:
> > On Tue, Jul 27, 2021 at 05:10:30PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > generic/475, but we're running fsstress on a disk image inside the
> > > scratch filesystem
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/725.out |    2 +
> > >  2 files changed, 138 insertions(+)
> > >  create mode 100755 tests/generic/725
> > >  create mode 100644 tests/generic/725.out
> > > 
> > > 
> > > diff --git a/tests/generic/725 b/tests/generic/725
> > > new file mode 100755
> > > index 00000000..f43bcb37
> > > --- /dev/null
> > > +++ b/tests/generic/725
> > > @@ -0,0 +1,136 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 725
> > > +#
> > > +# Test nested log recovery with repeated (simulated) disk failures.  We kick
> > > +# off fsstress on a loopback filesystem mounted on the scratch fs, then switch
> > > +# out the underlying scratch device with dm-error to see what happens when the
> > > +# disk goes down.  Having taken down both fses in this manner, remount them and
> > > +# repeat.  This test simulates VM hosts crashing to try to shake out CoW bugs
> > > +# in writeback on the host that cause VM guests to fail to recover.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest shutdown auto log metadata eio
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > > +	wait
> > > +	if [ -n "$loopmnt" ]; then
> > > +		umount $loopmnt 2>/dev/null
> > > +		rm -r -f $loopmnt
> > > +	fi
> > > +	rm -f $tmp.*
> > > +	_dmerror_unmount
> > > +	_dmerror_cleanup
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/dmerror
> > > +. ./common/reflink
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +
> > > +_require_scratch_reflink
> > > +_require_cp_reflink
> > > +_require_dm_target error
> > > +_require_command "$KILLALL_PROG" "killall"
> > > +
> > > +echo "Silence is golden."
> > > +
> > > +_scratch_mkfs >> $seqres.full 2>&1
> > > +_require_metadata_journaling $SCRATCH_DEV
> > > +_dmerror_init
> > > +_dmerror_mount
> > > +
> > > +# Create a fs image consuming 1/3 of the scratch fs
> > > +scratch_freesp_bytes=$(stat -f -c '%a * %S' $SCRATCH_MNT | bc)
> > > +loopimg_bytes=$((scratch_freesp_bytes / 3))
> > > +
> > > +loopimg=$SCRATCH_MNT/testfs
> > > +truncate -s $loopimg_bytes $loopimg
> > > +_mkfs_dev $loopimg
> > 
> > I must say this's a nice test as generic/475, I'd like to have it ASAP :)
> > Just one question: if the FSTYP is nfs, cifs or virtiofs and so on ... [see below]
> > 
> > > +
> > > +loopmnt=$tmp.mount
> > > +mkdir -p $loopmnt
> > > +
> > > +scratch_aliveflag=$tmp.runsnap
> > > +snap_aliveflag=$tmp.snapping
> > > +
> > > +snap_loop_fs() {
> > > +	touch "$snap_aliveflag"
> > > +	while [ -e "$scratch_aliveflag" ]; do
> > > +		rm -f $loopimg.a
> > > +		_cp_reflink $loopimg $loopimg.a
> > > +		sleep 1
> > > +	done
> > > +	rm -f "$snap_aliveflag"
> > > +}
> > > +
> > > +fsstress=($FSSTRESS_PROG $FSSTRESS_AVOID -d "$loopmnt" -n 999999 -p "$((LOAD_FACTOR * 4))")
> > > +
> > > +for i in $(seq 1 $((25 * TIME_FACTOR)) ); do
> > > +	touch $scratch_aliveflag
> > > +	snap_loop_fs >> $seqres.full 2>&1 &
> > > +
> > > +	if ! _mount $loopimg $loopmnt -o loop; then
> > 
> > ... This test will fail directly at here
> 
> It won't, because this test doesn't run if SCRATCH_DEV isn't a block
> device.  _require_dm_target calls _require_block_device, which should
> prevent that, right?

Oh, you're right[1], I forgot that. If so, this case is good to me.
Hope it get merged soon :)
Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

[1]
# ./check generic/725
FSTYP         -- nfs
PLATFORM      -- Linux/x86_64 xx-xxx-xx 4.18.0-xxx.el8.x86_64+debug #1 SMP Wed Jul 14 12:35:49 EDT 2021
MKFS_OPTIONS  -- xxx-xxx-xxx-xxxxxxx:/mnt/scratch/nfs-server
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 xx-xxxx-xxxx.xxxxx.xx:/mnt/scratch/nfs-server /mnt/nfs-scratch

generic/725     [not run] require xx-xxxx-xxxx.xxxxx.xx:/mnt/scratch/nfs-server to be valid block disk
Ran: generic/725
Not run: generic/725
Passed all 1 tests

# ./check generic/725
FSTYP         -- glusterfs
PLATFORM      -- Linux/x86_64 xx-xxx-xx 4.18.0-xxx.el8.x86_64+debug #1 SMP Wed Jul 14 12:35:49 EDT 2021
MKFS_OPTIONS  -- xxx-xxx-xxx-xxxxxxx:/SCRATCH_VOL
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 xx-xxxx-xxxx.xxxxx.xx:/SCRATCH_VOL /mnt/gluster-scratch

generic/725     [not run] Reflink not supported by scratch filesystem type: glusterfs
Ran: generic/725
Not run: generic/725
Passed all 1 tests

> 
> --D
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > +		rm -f $scratch_aliveflag
> > > +		_fail "loop mount failed"
> > > +		break
> > > +	fi
> > > +
> > > +	("${fsstress[@]}" >> $seqres.full &) > /dev/null 2>&1
> > > +
> > > +	# purposely include 0 second sleeps to test shutdown immediately after
> > > +	# recovery
> > > +	sleep $((RANDOM % (3 * TIME_FACTOR) ))
> > > +	rm -f $scratch_aliveflag
> > > +
> > > +	# This test aims to simulate sudden disk failure, which means that we
> > > +	# do not want to quiesce the filesystem or otherwise give it a chance
> > > +	# to flush its logs.  Therefore we want to call dmsetup with the
> > > +	# --nolockfs parameter; to make this happen we must call the load
> > > +	# error table helper *without* 'lockfs'.
> > > +	_dmerror_load_error_table
> > > +
> > > +	ps -e | grep fsstress > /dev/null 2>&1
> > > +	while [ $? -eq 0 ]; do
> > > +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > > +		wait > /dev/null 2>&1
> > > +		ps -e | grep fsstress > /dev/null 2>&1
> > > +	done
> > > +	for ((i = 0; i < 10; i++)); do
> > > +		test -e "$snap_aliveflag" || break
> > > +		sleep 1
> > > +	done
> > > +
> > > +	# Mount again to replay log after loading working table, so we have a
> > > +	# consistent XFS after test.
> > > +	$UMOUNT_PROG $loopmnt
> > > +	_dmerror_unmount || _fail "unmount failed"
> > > +	_dmerror_load_working_table
> > > +	if ! _dmerror_mount; then
> > > +		dmsetup table | tee -a /dev/ttyprintk
> > > +		lsblk | tee -a /dev/ttyprintk
> > > +		$XFS_METADUMP_PROG -a -g -o $DMERROR_DEV $seqres.dmfail.md
> > > +		_fail "mount failed"
> > > +	fi
> > > +done
> > > +
> > > +# Make sure the fs image file is ok
> > > +if [ -f "$loopimg" ]; then
> > > +	if _mount $loopimg $loopmnt -o loop; then
> > > +		$UMOUNT_PROG $loopmnt &> /dev/null
> > > +	else
> > > +		echo "final loop mount failed"
> > > +	fi
> > > +	_check_xfs_filesystem $loopimg none none
> > > +fi
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/725.out b/tests/generic/725.out
> > > new file mode 100644
> > > index 00000000..ed73a9fc
> > > --- /dev/null
> > > +++ b/tests/generic/725.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 725
> > > +Silence is golden.
> > > 
> > 
> 

