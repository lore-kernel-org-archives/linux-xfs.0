Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDD6C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 15:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343977AbiFGPUZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 11:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiFGPUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 11:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FB4F5049;
        Tue,  7 Jun 2022 08:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B147B81FD1;
        Tue,  7 Jun 2022 15:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC0BC385A5;
        Tue,  7 Jun 2022 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654615219;
        bh=f+T8wKpMUYP+kTLpLknhwr/nxUQ0vSrraelpXdlIjDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQCafVypCjnjCLM5+gyGAGDh8rv54YudL9cRPt37pm5Lf0Qx2yBXOfxdzGPuxgd5o
         NFpNh81C+7PDIE4oMRcN23yvSR4tW7r54Rli5+QzOKPPDtDfIOo1r2I0z2J92KJVip
         PC+Nz4qeONzWCu29lDl0ZeupTvVe4wgvWKN0wmwY4ezkYxigI3sBI6oYKLydr565uE
         TbrNeDEwN6qprUatVzYPvTlWaupzR6b7kbwlegrAt1odMQ2upUCeIEiA6B4Of64lIP
         45dnrq9egqjzpLbGHcE+4tCfe5ZaodJby37hH1qWIlvH6Gj1xsiuzvC/Vf6M6vNHgJ
         EcfP97Bh/8Y5w==
Date:   Tue, 7 Jun 2022 08:20:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs/548: Verify correctness of upgrading an fs to
 support large extent counters
Message-ID: <Yp9ss8hzVRD7VYLR@magnolia>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-5-chandan.babu@oracle.com>
 <Yp4etwsUF/B6aSbe@magnolia>
 <874k0wol8x.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874k0wol8x.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 07, 2022 at 03:17:01PM +0530, Chandan Babu R wrote:
> On Mon, Jun 06, 2022 at 08:35:19 AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 06, 2022 at 06:11:01PM +0530, Chandan Babu R wrote:
> >> This commit adds a test to verify upgrade of an existing V5 filesystem to
> >> support large extent counters.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  tests/xfs/548     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/xfs/548.out |  12 +++++
> >>  2 files changed, 121 insertions(+)
> >>  create mode 100755 tests/xfs/548
> >>  create mode 100644 tests/xfs/548.out
> >> 
> >> diff --git a/tests/xfs/548 b/tests/xfs/548
> >> new file mode 100755
> >> index 00000000..6c577584
> >> --- /dev/null
> >> +++ b/tests/xfs/548
> >> @@ -0,0 +1,109 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 548
> >> +#
> >> +# Test to verify upgrade of an existing V5 filesystem to support large extent
> >> +# counters.
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto quick metadata
> >> +
> >> +# Import common functions.
> >> +. ./common/filter
> >> +. ./common/attr
> >> +. ./common/inject
> >> +. ./common/populate
> >> +
> >> +# real QA test starts here
> >> +_supported_fs xfs
> >> +_require_scratch
> >> +_require_scratch_xfs_nrext64
> >> +_require_attrs
> >> +_require_xfs_debug
> >> +_require_test_program "punch-alternating"
> >> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> >> +
> >> +_scratch_mkfs -d size=$((512 * 1024 * 1024)) >> $seqres.full
> >> +_scratch_mount >> $seqres.full
> >> +
> >> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> >> +
> >> +testfile=$SCRATCH_MNT/testfile
> >> +
> >> +nr_blks=20
> >> +
> >> +echo "Add blocks to file's data fork"
> >> +$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
> >> +	     >> $seqres.full
> >> +$here/src/punch-alternating $testfile
> >> +
> >> +echo "Consume free space"
> >> +fillerdir=$SCRATCH_MNT/fillerdir
> >> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> >> +nr_free_blks=$((nr_free_blks * 90 / 100))
> >> +
> >> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
> >> +	 >> $seqres.full 2>&1
> >> +
> >> +echo "Create fragmented filesystem"
> >> +for dentry in $(ls -1 $fillerdir/); do
> >> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> >> +done
> >> +
> >> +echo "Inject bmap_alloc_minlen_extent error tag"
> >> +_scratch_inject_error bmap_alloc_minlen_extent 1
> >> +
> >> +echo "Add blocks to file's attr fork"
> >> +nr_blks=10
> >> +attr_len=255
> >> +nr_attrs=$((nr_blks * bsize / attr_len))
> >> +for i in $(seq 1 $nr_attrs); do
> >> +	attr="$(printf "trusted.%0247d" $i)"
> >> +	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
> >> +	[[ $? != 0 ]] && break
> >> +done
> >> +
> >> +testino=$(stat -c '%i' $testfile)
> >> +
> >> +echo "Unmount filesystem"
> >> +_scratch_unmount >> $seqres.full
> >> +
> >> +orig_dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
> >> +orig_acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
> >> +
> >> +echo "Upgrade filesystem to support large extent counters"
> >> +_scratch_xfs_admin -O nrext64=1 >> $seqres.full 2>&1
> >> +if [[ $? != 0 ]]; then
> >> +	_notrun "Filesystem geometry is not suitable for upgrading"
> >> +fi
> >> +
> >> +
> >> +echo "Mount filesystem"
> >> +_scratch_mount >> $seqres.full
> >> +
> >> +echo "Modify inode core"
> >> +touch $testfile
> >> +
> >> +echo "Unmount filesystem"
> >> +_scratch_unmount >> $seqres.full
> >> +
> >> +dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
> >> +acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
> >> +
> >> +echo "Verify inode extent counter values after fs upgrade"
> >
> > Is there a scenario where the inode counters would become corrupt after
> > enabling the superblock feature bit?  IIRC repair doesn't rewrite the
> > inodes during the upgrade... so is this test merely being cautious?  Or
> > is this covering a failure you found somewhere while writing the feature?
> >
> 
> I was just being cautious w.r.t "Large extent counters" functionality working
> correctly. I used this test during my development to make sure that I was able
> to capture failures before I ran the entire xfstests suite.

Fair enough,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> -- 
> chandan
