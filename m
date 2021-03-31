Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDC6C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 17:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96C460BD3
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 17:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhCaRhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 13:37:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234472AbhCaRg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 13:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617212217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CI5kGYi9DpIHlDXlgTlQ9DczlzDRgj/V5t2chH0UbRg=;
        b=gSJovTEL4gFEYWLI2ikvuE3akB6325Xlx/woPdJwmxlwSpDl+cQeKtpDO8X3tsvTFeT9bT
        F72Ouk44dmVv7OQajF3OJHbxIxXaBnyCFjBO2nQCcZBC7Y43IDRa2BEqsz7JCPpr4P1ihk
        nC0YiswI/sRbPOL5+CqUlQkyKFLpx3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-nK9oD-plMke6JmxT_5O0Qg-1; Wed, 31 Mar 2021 13:36:54 -0400
X-MC-Unique: nK9oD-plMke6JmxT_5O0Qg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC2AA1083E81;
        Wed, 31 Mar 2021 17:36:52 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A69C419C44;
        Wed, 31 Mar 2021 17:36:50 +0000 (UTC)
Date:   Wed, 31 Mar 2021 13:36:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] xfs: test inobtcount upgrade
Message-ID: <YGSzLxelZoG7IGA9@bfoster>
References: <161715290311.2703879.6182444659830603450.stgit@magnolia>
 <161715291407.2703879.12588572306371939752.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161715291407.2703879.12588572306371939752.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 06:08:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we can actually upgrade filesystems to support inode btree
> counters.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/910     |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/910.out |   23 +++++++++++
>  tests/xfs/group   |    1 
>  3 files changed, 136 insertions(+)
>  create mode 100755 tests/xfs/910
>  create mode 100644 tests/xfs/910.out
> 
> 
> diff --git a/tests/xfs/910 b/tests/xfs/910
> new file mode 100755
> index 00000000..5f095324
> --- /dev/null
> +++ b/tests/xfs/910
> @@ -0,0 +1,112 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 910
> +#
> +# Check that we can upgrade a filesystem to support inobtcount and that
> +# everything works properly after the upgrade.
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
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_scratch_inobtcount
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_xfs_repair_upgrade inobtcount
> +
> +rm -f $seqres.full
> +
> +# Make sure we can't format a filesystem with inobtcount and not finobt.
> +_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
> +	echo "Should not be able to format with inobtcount but not finobt."
> +
> +# Make sure we can't upgrade a V4 filesystem
> +_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_check_scratch_xfs_features INOBTCNT
> +
> +# Make sure we can't upgrade a filesystem to inobtcount without finobt.
> +_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_check_scratch_xfs_features INOBTCNT
> +
> +# Format V5 filesystem without inode btree counter support and upgrade it.
> +# Inject failure into repair and make sure that the only path forward is
> +# to re-run repair on the filesystem.
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +echo "Fail partway through upgrading"
> +XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
> +test $? -eq 137 || echo "repair should have been killed??"
> +_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
> +_try_scratch_mount &> $tmp.mount
> +res=$?
> +_filter_scratch < $tmp.mount
> +if [ $res -eq 0 ]; then
> +	echo "needsrepair should have prevented mount"
> +	_scratch_unmount
> +fi
> +
> +echo "Re-run repair to finish upgrade"
> +_scratch_xfs_repair 2>> $seqres.full
> +_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
> +
> +echo "Filesystem should be usable again"
> +_try_scratch_mount &> $tmp.mount
> +res=$?
> +_filter_scratch < $tmp.mount
> +if [ $res -eq 0 ]; then
> +	_scratch_unmount
> +else
> +	echo "mount should succeed after second repair"
> +fi
> +_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
> +

As you're probably aware I'm not a huge fan of sprinkling these kind of
repair/mount checks throughout the feature level tests. I don't think
it's reasonable to expect this to become a consistent pattern, so over
time this will likely just obfuscate the purpose of some of these tests.
That said, it seems to be harmless here so I'll just note that as my
.02.

> +# Format V5 filesystem without inode btree counter support and upgrade it.
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +echo moo > $SCRATCH_MNT/urk
> +
> +_scratch_unmount
> +_check_scratch_fs
> +
> +# Now upgrade to inobtcount support
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_check_scratch_xfs_features INOBTCNT
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
> +

This looks nearly the same as the previous test with the exception of
not doing repair failure injection and instead creating a file and
checking the resulting counters. Could we combine these two sequences
and simultaneously run a slightly more randomized test? E.g., a logical
sequence along the lines of:

mkfs inobtcount=0
mount
run fsstress -n 500 or otherwise (quickly) populate w/ some randomized content
umount
repair w/ fail injection
repair w/o fail injection
check resulting counters

Hm?

Brian

> +# Make sure we have nonzero counters
> +_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
> +	sed -e 's/= [1-9]*/= NONZERO/g'
> +
> +# Mount again, look at our files
> +_scratch_mount >> $seqres.full
> +cat $SCRATCH_MNT/urk
> +
> +# Make sure we can't re-add inobtcount
> +_scratch_unmount
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +status=0
> +exit
> diff --git a/tests/xfs/910.out b/tests/xfs/910.out
> new file mode 100644
> index 00000000..ed78d88f
> --- /dev/null
> +++ b/tests/xfs/910.out
> @@ -0,0 +1,23 @@
> +QA output created by 910
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature only supported on V5 filesystems.
> +FEATURES: INOBTCNT:NO
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature requires free inode btree.
> +FEATURES: INOBTCNT:NO
> +Fail partway through upgrading
> +Adding inode btree counts to filesystem.
> +FEATURES: NEEDSREPAIR:YES INOBTCNT:YES
> +mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
> +Re-run repair to finish upgrade
> +FEATURES: NEEDSREPAIR:NO INOBTCNT:YES
> +Filesystem should be usable again
> +FEATURES: NEEDSREPAIR:NO INOBTCNT:YES
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +FEATURES: INOBTCNT:YES
> +ino_blocks = NONZERO
> +fino_blocks = NONZERO
> +moo
> +Running xfs_repair to upgrade filesystem.
> +Filesystem already has inode btree counts.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 5801471b..0dc8038a 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -524,3 +524,4 @@
>  768 auto quick repair
>  770 auto repair
>  773 auto quick repair
> +910 auto quick inobtcount
> 

