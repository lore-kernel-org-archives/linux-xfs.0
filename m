Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA21C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F71F60E78
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhHLRIQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234570AbhHLRIM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 13:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CA27610A4;
        Thu, 12 Aug 2021 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628788066;
        bh=r9gVOP3McD7Jouul5dypOYBEXPk56djOIJ/FkLQeO74=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=tvNblqBLCwD3DfqXYqSUHEYw2LGeWiOh1joOk7OPYzRlcRlRx2rmfbtszR/TTlGiY
         Nr1PDIoVGqMBr57C+vQ0Anhxhw1YbvqfZbTgGgT6CMWv7GXc0k6Kdew/iTLm3c3f5T
         AmjHMgBNqGbsSpbTM/p/2SE80w99brkEBrBevejxG2LBsyTr4YkfqDrnMbdHSGUAV2
         ugpWhqYlhoNvknPgH5z5p9RoxlLGcmGciuw1ZcPF9bKb2gZ7df58C0S+q4UmAnot2a
         LfLVOJ0kDVssEmpasfN7XmBSLcll3J0Jbaxu1Owit3e/J5fR+kYpf+Zt5EtpXqnGD0
         bIyOvn+15+x/w==
Date:   Thu, 12 Aug 2021 10:07:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] generic: test shutdowns of a nested filesystem
Message-ID: <20210812170746.GQ3601443@magnolia>
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
 <162743103024.3428896.8525632218517299015.stgit@magnolia>
 <20210812054421.gpeaoccgz26riwxz@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812054421.gpeaoccgz26riwxz@fedora>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 01:44:21PM +0800, Zorro Lang wrote:
> On Tue, Jul 27, 2021 at 05:10:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/475, but we're running fsstress on a disk image inside the
> > scratch filesystem
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/725.out |    2 +
> >  2 files changed, 138 insertions(+)
> >  create mode 100755 tests/generic/725
> >  create mode 100644 tests/generic/725.out
> > 
> > 
> > diff --git a/tests/generic/725 b/tests/generic/725
> > new file mode 100755
> > index 00000000..f43bcb37
> > --- /dev/null
> > +++ b/tests/generic/725
> > @@ -0,0 +1,136 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 725
> > +#
> > +# Test nested log recovery with repeated (simulated) disk failures.  We kick
> > +# off fsstress on a loopback filesystem mounted on the scratch fs, then switch
> > +# out the underlying scratch device with dm-error to see what happens when the
> > +# disk goes down.  Having taken down both fses in this manner, remount them and
> > +# repeat.  This test simulates VM hosts crashing to try to shake out CoW bugs
> > +# in writeback on the host that cause VM guests to fail to recover.
> > +#
> > +. ./common/preamble
> > +_begin_fstest shutdown auto log metadata eio
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +	wait
> > +	if [ -n "$loopmnt" ]; then
> > +		umount $loopmnt 2>/dev/null
> > +		rm -r -f $loopmnt
> > +	fi
> > +	rm -f $tmp.*
> > +	_dmerror_unmount
> > +	_dmerror_cleanup
> > +}
> > +
> > +# Import common functions.
> > +. ./common/dmerror
> > +. ./common/reflink
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +
> > +_require_scratch_reflink
> > +_require_cp_reflink
> > +_require_dm_target error
> > +_require_command "$KILLALL_PROG" "killall"
> > +
> > +echo "Silence is golden."
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_require_metadata_journaling $SCRATCH_DEV
> > +_dmerror_init
> > +_dmerror_mount
> > +
> > +# Create a fs image consuming 1/3 of the scratch fs
> > +scratch_freesp_bytes=$(stat -f -c '%a * %S' $SCRATCH_MNT | bc)
> > +loopimg_bytes=$((scratch_freesp_bytes / 3))
> > +
> > +loopimg=$SCRATCH_MNT/testfs
> > +truncate -s $loopimg_bytes $loopimg
> > +_mkfs_dev $loopimg
> 
> I must say this's a nice test as generic/475, I'd like to have it ASAP :)
> Just one question: if the FSTYP is nfs, cifs or virtiofs and so on ... [see below]
> 
> > +
> > +loopmnt=$tmp.mount
> > +mkdir -p $loopmnt
> > +
> > +scratch_aliveflag=$tmp.runsnap
> > +snap_aliveflag=$tmp.snapping
> > +
> > +snap_loop_fs() {
> > +	touch "$snap_aliveflag"
> > +	while [ -e "$scratch_aliveflag" ]; do
> > +		rm -f $loopimg.a
> > +		_cp_reflink $loopimg $loopimg.a
> > +		sleep 1
> > +	done
> > +	rm -f "$snap_aliveflag"
> > +}
> > +
> > +fsstress=($FSSTRESS_PROG $FSSTRESS_AVOID -d "$loopmnt" -n 999999 -p "$((LOAD_FACTOR * 4))")
> > +
> > +for i in $(seq 1 $((25 * TIME_FACTOR)) ); do
> > +	touch $scratch_aliveflag
> > +	snap_loop_fs >> $seqres.full 2>&1 &
> > +
> > +	if ! _mount $loopimg $loopmnt -o loop; then
> 
> ... This test will fail directly at here

It won't, because this test doesn't run if SCRATCH_DEV isn't a block
device.  _require_dm_target calls _require_block_device, which should
prevent that, right?

--D

> 
> Thanks,
> Zorro
> 
> > +		rm -f $scratch_aliveflag
> > +		_fail "loop mount failed"
> > +		break
> > +	fi
> > +
> > +	("${fsstress[@]}" >> $seqres.full &) > /dev/null 2>&1
> > +
> > +	# purposely include 0 second sleeps to test shutdown immediately after
> > +	# recovery
> > +	sleep $((RANDOM % (3 * TIME_FACTOR) ))
> > +	rm -f $scratch_aliveflag
> > +
> > +	# This test aims to simulate sudden disk failure, which means that we
> > +	# do not want to quiesce the filesystem or otherwise give it a chance
> > +	# to flush its logs.  Therefore we want to call dmsetup with the
> > +	# --nolockfs parameter; to make this happen we must call the load
> > +	# error table helper *without* 'lockfs'.
> > +	_dmerror_load_error_table
> > +
> > +	ps -e | grep fsstress > /dev/null 2>&1
> > +	while [ $? -eq 0 ]; do
> > +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +		wait > /dev/null 2>&1
> > +		ps -e | grep fsstress > /dev/null 2>&1
> > +	done
> > +	for ((i = 0; i < 10; i++)); do
> > +		test -e "$snap_aliveflag" || break
> > +		sleep 1
> > +	done
> > +
> > +	# Mount again to replay log after loading working table, so we have a
> > +	# consistent XFS after test.
> > +	$UMOUNT_PROG $loopmnt
> > +	_dmerror_unmount || _fail "unmount failed"
> > +	_dmerror_load_working_table
> > +	if ! _dmerror_mount; then
> > +		dmsetup table | tee -a /dev/ttyprintk
> > +		lsblk | tee -a /dev/ttyprintk
> > +		$XFS_METADUMP_PROG -a -g -o $DMERROR_DEV $seqres.dmfail.md
> > +		_fail "mount failed"
> > +	fi
> > +done
> > +
> > +# Make sure the fs image file is ok
> > +if [ -f "$loopimg" ]; then
> > +	if _mount $loopimg $loopmnt -o loop; then
> > +		$UMOUNT_PROG $loopmnt &> /dev/null
> > +	else
> > +		echo "final loop mount failed"
> > +	fi
> > +	_check_xfs_filesystem $loopimg none none
> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/725.out b/tests/generic/725.out
> > new file mode 100644
> > index 00000000..ed73a9fc
> > --- /dev/null
> > +++ b/tests/generic/725.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 725
> > +Silence is golden.
> > 
> 
