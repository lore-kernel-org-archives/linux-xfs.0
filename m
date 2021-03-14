Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7989C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1FD064E76
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhCNSHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Mar 2021 14:07:10 -0400
Received: from out20-38.mail.aliyun.com ([115.124.20.38]:47682 "EHLO
        out20-38.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhCNSGi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Mar 2021 14:06:38 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07447457|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00837751-0.00358801-0.988034;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.Jl-ALM3_1615745196;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Jl-ALM3_1615745196)
          by smtp.aliyun-inc.com(10.147.44.118);
          Mon, 15 Mar 2021 02:06:36 +0800
Date:   Mon, 15 Mar 2021 02:06:35 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, wenli xie <wlxie7296@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/10] generic: test a deadlock in xfs_rename when
 whiteing out files
Message-ID: <YE5Qq83n0Yki47yH@desktop>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
 <161526485320.1214319.14486851135232825638.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161526485320.1214319.14486851135232825638.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 08:40:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> wenli xie reported a buffer cache deadlock when an overlayfs is mounted
> atop xfs and overlayfs tries to replace a single-nlink file with a
> whiteout file.  This test reproduces that deadlock.
> 
> Reported-by: wenli xie <wlxie7296@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/1300     |  109 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1300.out |    2 +
>  tests/generic/group    |    1 
>  3 files changed, 112 insertions(+)
>  create mode 100755 tests/generic/1300
>  create mode 100644 tests/generic/1300.out
> 
> 
> diff --git a/tests/generic/1300 b/tests/generic/1300
> new file mode 100755
> index 00000000..10df44e3
> --- /dev/null
> +++ b/tests/generic/1300
> @@ -0,0 +1,109 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1300
> +#
> +# Reproducer for a deadlock in xfs_rename reported by Wenli Xie.
> +#
> +# When overlayfs is running on top of xfs and the user unlinks a file in the
> +# overlay, overlayfs will create a whiteout inode and ask us to "rename" the
> +# whiteout file atop the one being unlinked.  If the file being unlinked loses
> +# its one nlink, we then have to put the inode on the unlinked list.
> +#
> +# This requires us to grab the AGI buffer of the whiteout inode to take it
> +# off the unlinked list (which is where whiteouts are created) and to grab
> +# the AGI buffer of the file being deleted.  If the whiteout was created in
> +# a higher numbered AG than the file being deleted, we'll lock the AGIs in
> +# the wrong order and deadlock.
> +#
> +# Note that this test doesn't do anything xfs-specific so it's a generic test.
> +# This is a regression test for commit 6da1b4b1ab36 ("xfs: fix an ABBA deadlock
> +# in xfs_rename").
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	stop_workers
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +test "$FSTYP" = "overlay" && _notrun "Test does not apply to overlayfs."
> +
> +modprobe -q overlay
> +grep -q overlay /proc/filesystems || _notrun "Test requires overlayfs."

We have _require_ext2() and _require_tmpfs(), I think it's time to
refactor them into a new _require_filesystem() helper?

> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount

Also, doing overlay mount requires the underlying to export d_type,
perhaps we should do '_supports_filetype $SCRATCH_MNT' here, otherwise
filesystems like nfs would fail the test.

> +
> +mkdir $SCRATCH_MNT/lowerdir
> +mkdir $SCRATCH_MNT/lowerdir1
> +mkdir $SCRATCH_MNT/lowerdir/etc
> +mkdir $SCRATCH_MNT/workers
> +echo salts > $SCRATCH_MNT/lowerdir/etc/access.conf
> +touch $SCRATCH_MNT/running
> +
> +stop_workers() {
> +	test -e $SCRATCH_MNT/running || return
> +	rm -f $SCRATCH_MNT/running
> +
> +	while [ "$(ls $SCRATCH_MNT/workers/ | wc -l)" -gt 0 ]; do
> +		wait
> +	done
> +}
> +
> +worker() {
> +	local tag="$1"
> +	local mergedir="$SCRATCH_MNT/merged$tag"
> +	local l="lowerdir=$SCRATCH_MNT/lowerdir:$SCRATCH_MNT/lowerdir1"
> +	local u="upperdir=$SCRATCH_MNT/upperdir$tag"
> +	local w="workdir=$SCRATCH_MNT/workdir$tag"
> +	local i="index=off,nfs_export=off"
> +
> +	touch $SCRATCH_MNT/workers/$tag
> +	while test -e $SCRATCH_MNT/running; do
> +		rm -rf $SCRATCH_MNT/merged$tag
> +		rm -rf $SCRATCH_MNT/upperdir$tag
> +		rm -rf $SCRATCH_MNT/workdir$tag
> +		mkdir $SCRATCH_MNT/merged$tag
> +		mkdir $SCRATCH_MNT/workdir$tag
> +		mkdir $SCRATCH_MNT/upperdir$tag
> +
> +		mount -t overlay overlay -o "$l,$u,$w,$i" $mergedir
> +		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
> +		touch $mergedir/etc/access.conf
> +		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
> +		touch $mergedir/etc/access.conf
> +		umount $mergedir
> +	done
> +	rm -f $SCRATCH_MNT/workers/$tag
> +}
> +
> +for i in $(seq 0 $((4 + LOAD_FACTOR)) ); do
> +	worker $i &
> +done
> +
> +sleep $((30 * TIME_FACTOR))
> +stop_workers
> +
> +echo Silence is golden.
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1300.out b/tests/generic/1300.out
> new file mode 100644
> index 00000000..5805d30d
> --- /dev/null
> +++ b/tests/generic/1300.out
> @@ -0,0 +1,2 @@
> +QA output created by 1300
> +Silence is golden.
> diff --git a/tests/generic/group b/tests/generic/group
> index 778aa8c4..2233a59d 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -631,3 +631,4 @@
>  947 auto quick rw clone
>  948 auto quick rw copy_range
>  949 auto quick rw dedupe clone
> +1300 auto rw overlay

Also add 'rename' group?

Thanks,
Eryu
