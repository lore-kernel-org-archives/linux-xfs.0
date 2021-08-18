Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6480C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 17:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A41BD60C40
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 17:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhHRRGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 13:06:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhHRRGo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 13:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629306369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6zMYbqrH9XfBTnMAFqOkBm7ntXqgwxK8x8YmffvuEM8=;
        b=Fv5dleXFLdF/dsTXsld9lqfw+KcZyXNc0ls7BP43tF75lI29CAYQd+vNjw24SP4IciymOC
        9uMDwjZ1FwHpTrBN35OVekjp4ZAemTNJ/1CFyFKdkWYXL9/8+XWxdKRG8fwmQ2eq3iSR8X
        JapRplaSb5QdSis03CXK3oAhndZjSIE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-5jbkqRr5PfeHbKaoMu71TA-1; Wed, 18 Aug 2021 13:06:07 -0400
X-MC-Unique: 5jbkqRr5PfeHbKaoMu71TA-1
Received: by mail-pf1-f198.google.com with SMTP id p40-20020a056a0026e8b02903e08239ba3cso1639110pfw.18
        for <linux-xfs@vger.kernel.org>; Wed, 18 Aug 2021 10:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=6zMYbqrH9XfBTnMAFqOkBm7ntXqgwxK8x8YmffvuEM8=;
        b=c31pzU8xJAv+rw3hcRxrt4PNtRrgTa2Eyq8UK1/LmmVgMTKxs2L0Thj/g03y6S9jNB
         yIPORZ4FHfEh7YIWLLL4zNv1cgO5kdWurIMhVYVnO0QefnfDeEPUwHQBGgAugAP31BTf
         bGpBbZw2znv5KVESoZx32MzM5ywaNgzfYFP2ICBVM/6OF7vM+saAMwu2lKGA2B3pbZ6L
         4RjgsjPuc99z30m8KZJspEOTcUz/TaJJ9R0SQT0XkmakkeredTruNUgFzE/3/8tqD2Md
         3XUJoizZ5L45vIBSbARxvm4wm9dm1X4kzWOdR4knYbHMkZ6BwEpB0lQI0co0/99VQB81
         EHAA==
X-Gm-Message-State: AOAM531JMItQ3GYw1lV2xa4/TTeg20VV7MRqzvXS82w5r1TtHoqZUwRm
        bA4+JFigAq7tOXbN+xZnf/to0Vxlfxi2bGRIX1EOh1QnLtmucVvh91di0PXpp0yKnJ577JJDa3a
        HrD7khZxSIqKyKBNWd3Cs
X-Received: by 2002:a17:902:b593:b0:12d:7aa5:de2d with SMTP id a19-20020a170902b59300b0012d7aa5de2dmr8164764pls.31.1629306366758;
        Wed, 18 Aug 2021 10:06:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2GF2JspdCJ9qA7UgzPjj1gvn8JSxW9suaApaJ3Bmh6GDaVQNwOaebKgyHxuPcH9NqERCH9w==
X-Received: by 2002:a17:902:b593:b0:12d:7aa5:de2d with SMTP id a19-20020a170902b59300b0012d7aa5de2dmr8164743pls.31.1629306366517;
        Wed, 18 Aug 2021 10:06:06 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p3sm323144pfw.152.2021.08.18.10.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:06:06 -0700 (PDT)
Date:   Thu, 19 Aug 2021 01:18:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] generic: test shutdowns of a nested filesystem
Message-ID: <20210818171844.zkuwc7etsyd342oo@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
 <162924440518.779465.6907507760500586987.stgit@magnolia>
 <20210818070654.hmhq7g5t4u3xueaj@fedora>
 <20210818155526.GH12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818155526.GH12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 08:55:26AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 18, 2021 at 03:06:54PM +0800, Zorro Lang wrote:
> > On Tue, Aug 17, 2021 at 04:53:25PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > generic/475, but we're running fsstress on a disk image inside the
> > > scratch filesystem
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Good to me, thanks for this helpful test case. Just one question,
> > is it better to use xfs_metadump with "-o" option by default?
> 
> _xfs_metadump already passes -a and -o.

Oh, sorry, I didn't notice this line:

test -z "$options" && options="-a -o".

> 
> --D
> 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > >  common/rc             |   20 +++++++
> > >  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/725.out |    2 +
> > >  3 files changed, 158 insertions(+)
> > >  create mode 100755 tests/generic/725
> > >  create mode 100644 tests/generic/725.out
> > > 
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 84757fc1..473bfb0a 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -631,6 +631,26 @@ _ext4_metadump()
> > >  		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
> > >  }
> > >  
> > > +# Capture the metadata of a filesystem in a dump file for offline analysis
> > > +_metadump_dev() {
> > > +	local device="$1"
> > > +	local dumpfile="$2"
> > > +	local compressopt="$3"
> > > +
> > > +	case "$FSTYP" in
> > > +	ext*)
> > > +		_ext4_metadump $device $dumpfile $compressopt
> > > +		;;
> > > +	xfs)
> > > +		_xfs_metadump $dumpfile $device none $compressopt
> > > +		;;
> > > +	*)
> > > +		echo "Don't know how to metadump $FSTYP"
> > > +		return 1
> > > +		;;
> > > +	esac
> > > +}
> > > +
> > >  _test_mkfs()
> > >  {
> > >      case $FSTYP in
> > > diff --git a/tests/generic/725 b/tests/generic/725
> > > new file mode 100755
> > > index 00000000..ac008fdb
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
> > > +_begin_fstest shutdown auto log metadata eio recoveryloop
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > > +	wait
> > > +	if [ -n "$loopmnt" ]; then
> > > +		$UMOUNT_PROG $loopmnt 2>/dev/null
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
> > > +scratch_freesp_bytes=$(_get_available_space $SCRATCH_MNT)
> > > +loopimg_bytes=$((scratch_freesp_bytes / 3))
> > > +
> > > +loopimg=$SCRATCH_MNT/testfs
> > > +truncate -s $loopimg_bytes $loopimg
> > > +_mkfs_dev $loopimg
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
> > > +		rm -f $scratch_aliveflag
> > > +		_metadump_dev $loopimg $seqres.loop.$i.md
> > > +		_fail "iteration $i loopimg mount failed"
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
> > > +	# consistent fs after test.
> > > +	$UMOUNT_PROG $loopmnt
> > > +	_dmerror_unmount || _fail "iteration $i scratch unmount failed"
> > > +	_dmerror_load_working_table
> > > +	if ! _dmerror_mount; then
> > > +		_metadump_dev $DMERROR_DEV $seqres.scratch.$i.md
> > > +		_fail "iteration $i scratch mount failed"
> > > +	fi
> > > +done
> > > +
> > > +# Make sure the fs image file is ok
> > > +if [ -f "$loopimg" ]; then
> > > +	if _mount $loopimg $loopmnt -o loop; then
> > > +		$UMOUNT_PROG $loopmnt &> /dev/null
> > > +	else
> > > +		_metadump_dev $DMERROR_DEV $seqres.scratch.final.md
> > > +		echo "final scratch mount failed"
> > > +	fi
> > > +	SCRATCH_RTDEV= SCRATCH_LOGDEV= _check_scratch_fs $loopimg
> > > +fi
> > > +
> > > +# success, all done; let the test harness check the scratch fs
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

