Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3187C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 15:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhLQPTc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 10:19:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238067AbhLQPTb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 10:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639754371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FBLdE8bsCqycR7of+qjPKj1NVmuyyCql81OV2j5bOUg=;
        b=jVdtHTN1/7lziMw7GjRFLhisZkbTBqcTcbk2VeHXw1+gDiG7QWUe/CISzwFKTsvuIiPeT5
        H4Yq34CK6ohm+yjnrVDJ+mg9uNqJBVKamfo74r61KlVnrNlwYrCORAYYQKrBr5G18lq/dZ
        64fS89m+NTuefe5bcNHcIP/bJyNLXlY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-qlTROAJFNBKgyjY-VQdjfg-1; Fri, 17 Dec 2021 10:19:30 -0500
X-MC-Unique: qlTROAJFNBKgyjY-VQdjfg-1
Received: by mail-qv1-f69.google.com with SMTP id 1-20020ad45ba1000000b003bdfcecfe10so2818698qvq.23
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 07:19:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FBLdE8bsCqycR7of+qjPKj1NVmuyyCql81OV2j5bOUg=;
        b=YObyVe7N3JFt1LT5ksMjjW0rxM0ymsvD+WHXzBe+zMTeXWrt2PMJBlcJ885tZT3aTz
         5dnm8TXgbONJs+NwsEo5x4IS0qxYP/BXFm0HlK86Kg31cg/shfYK1t0FxE/gGqqHy++w
         /S1NqsDhK9CwufnDCy+NDNayakk393Nl9Dm0cBZFPzDQ7ASFS2+aGhQCt+Ul5H10ic+E
         xcl1v9DGgrkwaI/ucjPdepOWRcdPHiuvoqBdeVgDk1uDFbIZoA6Bwnej8fBYyMI1hDAL
         n+ETw5cT0Wzn8t27iYIls6ju84/wr1lBrS4k/cv6RehP1MTRfmSYUDCoNGvykq8y5AT8
         p5bQ==
X-Gm-Message-State: AOAM533Fc+fIL8Uki01yIfzlXxAUM3BS3oflwPBlu9v5tdNuC++q548Z
        C5HOz6223J4Pf2nm+bwsie/W89SjJqPgmbts4lCe8pmI1ovtTIPgvm/ZfiBbEdwzvVpM+R4OdcM
        lqlX0Cte5rV14FmTVl4qz
X-Received: by 2002:a05:622a:43:: with SMTP id y3mr2725686qtw.192.1639754369438;
        Fri, 17 Dec 2021 07:19:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQf4GqqZEwIb0GxO71WMO3B14BoaDe3t1g7si9XJP1R4CwkGyHvLq4jlVJengxhWZgoDzjaQ==
X-Received: by 2002:a05:622a:43:: with SMTP id y3mr2725667qtw.192.1639754369165;
        Fri, 17 Dec 2021 07:19:29 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id x24sm4686630qkm.135.2021.12.17.07.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 07:19:28 -0800 (PST)
Date:   Fri, 17 Dec 2021 10:19:27 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] tests/xfs: test COW writeback failure when
 overlapping non-shared blocks
Message-ID: <Ybyqf6OPsFt/X73C@bfoster>
References: <20211025130053.8343-1-bfoster@redhat.com>
 <20211117180105.GP24282@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117180105.GP24282@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 17, 2021 at 10:01:05AM -0800, Darrick J. Wong wrote:
> On Mon, Oct 25, 2021 at 09:00:53AM -0400, Brian Foster wrote:
> > Test that COW writeback that overlaps non-shared delalloc blocks
> > does not leave around stale delalloc blocks on I/O failure. This
> > triggers assert failures and free space accounting corruption on
> > XFS.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > v2:
> > - Explicitly set COW extent size hint.
> > - Move to tests/xfs.
> > - Various minor cleanups.
> > v1: https://lore.kernel.org/fstests/20211021163959.1887011-1-bfoster@redhat.com/
> > 
> >  tests/xfs/999     | 62 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/999.out |  2 ++
> >  2 files changed, 64 insertions(+)
> >  create mode 100755 tests/xfs/999
> >  create mode 100644 tests/xfs/999.out
> > 
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > new file mode 100755
> > index 00000000..f27972bc
> > --- /dev/null
> > +++ b/tests/xfs/999
> > @@ -0,0 +1,62 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 999
> > +#
> > +# Test that COW writeback that overlaps non-shared delalloc blocks does not
> > +# leave around stale delalloc blocks on I/O failure. This triggers assert
> > +# failures and free space accounting corruption on XFS.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick clone
> > +
> > +_cleanup()
> > +{
> > +	_cleanup_flakey
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +# Import common functions.
> > +. ./common/reflink
> > +. ./common/dmflakey
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch_reflink
> > +_require_cp_reflink
> > +_require_xfs_io_command "cowextsize"
> > +_require_flakey_with_error_writes
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_init_flakey
> > +_mount_flakey
> > +
> > +blksz=$(_get_file_block_size $SCRATCH_MNT)
> > +
> > +# Set the COW extent size hint to guarantee COW fork preallocation occurs over a
> > +# bordering block offset.
> > +$XFS_IO_PROG -c "cowextsize $((blksz * 2))" $SCRATCH_MNT >> $seqres.full
> > +
> > +# create two files that share a single block
> > +$XFS_IO_PROG -fc "pwrite $blksz $blksz" $SCRATCH_MNT/file1 >> $seqres.full
> > +_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
> > +
> > +# Perform a buffered write across the shared and non-shared blocks. On XFS, this
> > +# creates a COW fork extent that covers the shared block as well as the just
> > +# created non-shared delalloc block. Fail the writeback to verify that all
> > +# delayed allocation is cleaned up properly.
> > +_load_flakey_table $FLAKEY_ERROR_WRITES
> > +$XFS_IO_PROG -c "pwrite 0 $((blksz * 2))" \
> > +	-c fsync $SCRATCH_MNT/file2 >> $seqres.full
> > +_load_flakey_table $FLAKEY_ALLOW_WRITES
> 
> Hmm.  So I've been running this test in my djwong-dev tree and hit this
> last night:
> 
> --- xfs/999.out
> +++ xfs/999.out.bad
> @@ -1,2 +1,3 @@
>  QA output created by 999
> -fsync: Input/output error
> +stat: Input/output error
> +cp: failed to access '/opt/file3': Input/output error
> 
> Digging into the kernel log, I see this happen:
> 
> [10240.821719] XFS (dm-0): Mounting V5 Filesystem
> [10240.855461] XFS (dm-0): Ending clean mount
> [10240.857030] XFS (dm-0): Quotacheck needed: Please wait.
> [10240.860095] XFS (dm-0): Quotacheck: Done.
> [10240.977055] XFS (dm-0): log I/O error -5
> [10240.977459] XFS (dm-0): Log I/O Error (0x2) detected at xlog_ioend_work+0x5f/0xb0 [xfs] (fs/xfs/xfs_log.c:1377).  Shutting down filesystem.
> [10240.978682] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
> [10241.044886] XFS (dm-0): Unmounting Filesystem
> 
> I guess the log tried to checkpoint for the brief window where the
> flakey table was enabled, and shut down the whole fs?  I don't have any
> good ideas for how to solve this, though.
> 
> Hm.  What if you did something like:
> 
> $XFS_IO_PROG -c 'pwrite...' $SCRATCH_MNT/file2
> _load_flakey_table $FLAKEY_ERROR_WRITES
> $XFS_IO_PROG -c 'sync_range -wa' $SCRATCH_MNT/file2
> +_load_flakey_table $FLAKEY_ALLOW_WRITES
> 

I notice that sync_range doesn't combine options like that even though
the underlying flags can be combined for the syscall. That aside, I
suspect a combination of an fsync on the earlier reflink command and a
couple sync_range calls here (to achieve the intended behavior above) is
probably the best option to try and avoid this. That seems to preserve
the intended behavior of the test and I don't see any spurious failures
in a couple hundred or so iterations.. (granted I don't know how
reproducible that was in the first place).

Brian

> to constrain the window in which disk write will fail?  Seeing as s_f_r
> doesn't actually tell the fs to flush its own metadata or anything.
> 
> (Yikes, did I finally find a use for sync_file_range??)
> 
> --D
> 
> > +
> > +# Try a post-fail reflink and then unmount. Both of these are known to produce
> > +# errors and/or assert failures on XFS if we trip over a stale delalloc block.
> > +_cp_reflink $SCRATCH_MNT/file2 $SCRATCH_MNT/file3
> > +_unmount_flakey
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> > new file mode 100644
> > index 00000000..88b69c4c
> > --- /dev/null
> > +++ b/tests/xfs/999.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 999
> > +fsync: Input/output error
> > -- 
> > 2.31.1
> > 
> 

