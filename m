Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FBAC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CCC061A25
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYQf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 12:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCYQfc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 12:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F279061A1E;
        Thu, 25 Mar 2021 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616690132;
        bh=ccVZkzPIlwL9g7NyYVNcqr30agjNkb0lEWxCHiMInJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hjnwxEHFWs4ASw1UT3ap/cGHdOdDwr8hI8IufjQuhSmW0QEUsdb2kqmPMKUvEjw4I
         +IweR5aEjNIPNqU8wsrQPCLjhBezYXo0j6EdSQ0H2CoLh8K98NA7hqVzxtva/iu+Nn
         C1vEaIfJbh/xZnWJusl5RO6zDjaP333grhAat7wuwPYctCaM2DRcn1Qm7Otr75QS3k
         SswMnczSjdi9Z36lDT5F0ArsKnvXtpSEsUAsJ0mFM1xhpf3P6eXiK/bH2kfHd4mjJZ
         wM1K/t8JKDKnFQGby+devRUTrljfNelAM1bsgVmSL0KEfHD8ZmgspSiY3nY6VXTMhq
         KzDYzMPatulfA==
Date:   Thu, 25 Mar 2021 09:35:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] xfs: test the xfs_db ls command
Message-ID: <20210325163531.GH4090233@magnolia>
References: <161647321880.3430916.13415014495565709258.stgit@magnolia>
 <161647322983.3430916.9402200604814364098.stgit@magnolia>
 <87lfabo893.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfabo893.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 03:38:56PM +0530, Chandan Babu R wrote:
> On 23 Mar 2021 at 09:50, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Make sure that the xfs_db ls command works the way the author thinks it
> > does.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/918     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/918.out |   27 +++++++++++++
> >  tests/xfs/group   |    1
> >  3 files changed, 137 insertions(+)
> >  create mode 100755 tests/xfs/918
> >  create mode 100644 tests/xfs/918.out
> >
> >
> > diff --git a/tests/xfs/918 b/tests/xfs/918
> > new file mode 100755
> > index 00000000..7211df92
> > --- /dev/null
> > +++ b/tests/xfs/918
> > @@ -0,0 +1,109 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 918
> > +#
> > +# Make sure the xfs_db ls command works the way the author thinks it does.
> > +# This means that we can list the current directory, list an arbitrary path,
> > +# and we can't list things that aren't directories.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_db_command "path"
> > +_require_xfs_db_command "ls"
> > +_require_scratch
> > +
> > +echo "Format filesystem and populate"
> > +_scratch_mkfs > $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +$XFS_INFO_PROG $SCRATCH_MNT | grep -q ftype=1 || \
> > +	_notrun "filesystem does not support ftype"
> > +
> > +filter_ls() {
> > +	awk '
> > +BEGIN { cookie = 0; }
> > +{
> > +	if (cookie == 0)
> > +		cookie = $1;
> > +	printf("+%d %s %s %s %s %s\n", $1 - cookie, $2, $3, $4, $5, $6);
> > +	cookie = $1;
> > +}' | \
> > +	sed	-e "s/ $root_ino directory / root directory /g" \
> > +		-e "s/ $a_ino directory / a_ino directory /g" \
> > +		-e "s/ $b_ino directory / b_ino directory /g" \
> > +		-e "s/ $c_ino regular / c_ino regular /g" \
> > +		-e "s/ $d_ino symlink / d_ino symlink /g" \
> > +		-e "s/ $e_ino blkdev / e_ino blkdev /g" \
> > +		-e "s/ $f_ino chardev / f_ino chardev /g" \
> > +		-e "s/ $g_ino fifo / g_ino fifo /g" \
> > +		-e "s/ $big0_ino regular / big0_ino regular /g" \
> > +		-e "s/ $big1_ino regular / big1_ino regular /g" \
> > +		-e "s/ $h_ino regular / g_ino regular /g"
> > +}
> > +
> > +mkdir $SCRATCH_MNT/a
> > +mkdir $SCRATCH_MNT/a/b
> > +$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
> > +ln -s -f b $SCRATCH_MNT/a/d
> 
> Similar to the previous patch, the symbolic link 'd' will refer to a
> non-existing file. However, it shouldn't matter w.r.t to correctness of this
> test.

Right.

> > +mknod $SCRATCH_MNT/a/e b 0 0
> > +mknod $SCRATCH_MNT/a/f c 0 0
> > +mknod $SCRATCH_MNT/a/g p
> > +touch $SCRATCH_MNT/a/averylongnameforadirectorysothatwecanpushthecookieforward
> > +touch $SCRATCH_MNT/a/andmakethefirstcolumnlookmoreinterestingtopeoplelolwtfbbq
> > +touch $SCRATCH_MNT/a/h
> > +
> > +root_ino=$(stat -c '%i' $SCRATCH_MNT)
> > +a_ino=$(stat -c '%i' $SCRATCH_MNT/a)
> > +b_ino=$(stat -c '%i' $SCRATCH_MNT/a/b)
> > +c_ino=$(stat -c '%i' $SCRATCH_MNT/a/c)
> > +d_ino=$(stat -c '%i' $SCRATCH_MNT/a/d)
> > +e_ino=$(stat -c '%i' $SCRATCH_MNT/a/e)
> > +f_ino=$(stat -c '%i' $SCRATCH_MNT/a/f)
> > +g_ino=$(stat -c '%i' $SCRATCH_MNT/a/g)
> > +big0_ino=$(stat -c '%i' $SCRATCH_MNT/a/avery*)
> > +big1_ino=$(stat -c '%i' $SCRATCH_MNT/a/andma*)
> > +h_ino=$(stat -c '%i' $SCRATCH_MNT/a/h)
> > +
> > +_scratch_unmount
> > +
> > +echo "Manually navigate to root dir then list"
> > +_scratch_xfs_db -c 'sb 0' -c 'addr rootino' -c ls > /tmp/fuck0
> > +cat /tmp/fuck0 | filter_ls > /tmp/fuck1
> 
> The two lines above are redundant.

Yikes, sorry about that, everyone.

--D

> > +_scratch_xfs_db -c 'sb 0' -c 'addr rootino' -c ls | filter_ls
> 
> --
> chandan
