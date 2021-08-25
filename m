Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EA6C4320E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 22:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 451786109D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 22:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhHYW2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 18:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhHYW2y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Aug 2021 18:28:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33EB0610A6;
        Wed, 25 Aug 2021 22:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629930488;
        bh=juH3IcJXivtrExzFBZKv8TjfhpGQ2ljLQuIgqM1wx4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RoFyPJKNY30cexViUCBqyt21a6Jl8jfQnBQKJdgtv02Sy3cdsdWUySRKAOiLki53E
         1MfY+fwgnZALaLmSydybJpFYkvCJAcnMywldiDFYe8znT5Mj5a9aQ8yOtQ1AO0wRoA
         eslyfuHKYLJvOUDwWFogoZFAF81ZND8pzi7lZsyGnQ61RX0ArEUN4H3Gv8phpywmPS
         UCsJjEwK69twMupYoa/TKFkwVDg6jbPuC2LL5aIOcneY56nKjpNDVXqKiFb6XIKK6y
         fmyFMoxD5ztKzy8E+TAV4533DebRTk9hOiheJh/EqF0llHU2vaWIy0ADAfV+V3g5HW
         KTm6w315Jb5EQ==
Date:   Wed, 25 Aug 2021 15:28:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfstests: Add Log Attribute Replay test
Message-ID: <20210825222807.GG12640@magnolia>
References: <20210825195144.2283-1-catherine.hoang@oracle.com>
 <20210825195144.2283-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825195144.2283-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 25, 2021 at 12:51:44PM -0700, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a test to exercise the log attribute error
> inject and log replay.  Attributes are added in increaseing
> sizes up to 64k, and the error inject is used to replay them
> from the log
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Yay, [your] first post! :D

> ---
>  tests/xfs/540     |  96 ++++++++++++++++++++++++++++++++++
>  tests/xfs/540.out | 130 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 226 insertions(+)
>  create mode 100755 tests/xfs/540
>  create mode 100644 tests/xfs/540.out
> 
> diff --git a/tests/xfs/540 b/tests/xfs/540
> new file mode 100755
> index 00000000..3b05b38b
> --- /dev/null
> +++ b/tests/xfs/540
> @@ -0,0 +1,96 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 540
> +#
> +# Log attribute replay test
> +#
> +. ./common/preamble
> +_begin_fstest auto quick attr
> +
> +# get standard environment, filters and checks
> +. ./common/filter
> +. ./common/attr
> +. ./common/inject
> +
> +_cleanup()
> +{
> +	echo "*** unmount"
> +	_scratch_unmount 2>/dev/null
> +	rm -f $tmp.*
> +	echo 0 > /sys/fs/xfs/debug/larp
> +}
> +
> +_test_attr_replay()
> +{
> +	attr_name=$1
> +	attr_value=$2
> +	touch $testfile.1
> +
> +	echo "Inject error"
> +	_scratch_inject_error "larp"
> +
> +	echo "Set attribute"
> +	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 | \
> +			    _filter_scratch
> +
> +	echo "FS should be shut down, touch will fail"
> +	touch $testfile.1
> +
> +	echo "Remount to replay log"
> +	_scratch_inject_logprint >> $seqres.full
> +
> +	echo "FS should be online, touch should succeed"
> +	touch $testfile.1
> +
> +	echo "Verify attr recovery"
> +	_getfattr --absolute-names $testfile.1 | _filter_scratch

Shouldn't we check the value of the extended attrs too?

> +}
> +
> +
> +# real QA test starts here
> +_supported_fs xfs
> +
> +_require_scratch
> +_require_attrs
> +_require_xfs_io_error_injection "larp"
> +_require_xfs_sysfs debug/larp
> +
> +# turn on log attributes
> +echo 1 > /sys/fs/xfs/debug/larp
> +
> +rm -f $seqres.full

No need to do this anymore; _begin_fstest takes care of this now.

> +_scratch_unmount >/dev/null 2>&1
> +
> +#attributes of increaseing sizes
> +attr16="0123456789ABCDEFG"

"attr16" is seventeen bytes long.

> +attr64="$attr16$attr16$attr16$attr16"
> +attr256="$attr64$attr64$attr64$attr64"
> +attr1k="$attr256$attr256$attr256$attr256"
> +attr4k="$attr1k$attr1k$attr1k$attr1k"
> +attr8k="$attr4k$attr4k$attr4k$attr4k"

This is 17k long...

> +attr32k="$attr8k$attr8k$attr8k$attr8k"

...which makes this 68k long...

> +attr64k="$attr32k$attr32k"

...and this 136K long?

I'm curious, what are the contents of user.attr_name8?

OH, I see, attr clamps the value length to 64k, so I guess the oversize
buffers don't matter.

--D

> +
> +echo "*** mkfs"
> +_scratch_mkfs_xfs >/dev/null
> +
> +echo "*** mount FS"
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +echo "*** make test file 1"
> +
> +_test_attr_replay "attr_name1" $attr16
> +_test_attr_replay "attr_name2" $attr64
> +_test_attr_replay "attr_name3" $attr256
> +_test_attr_replay "attr_name4" $attr1k
> +_test_attr_replay "attr_name5" $attr4k
> +_test_attr_replay "attr_name6" $attr8k
> +_test_attr_replay "attr_name7" $attr32k
> +_test_attr_replay "attr_name8" $attr64k
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/xfs/540.out b/tests/xfs/540.out
> new file mode 100644
> index 00000000..c1b178a0
> --- /dev/null
> +++ b/tests/xfs/540.out
> @@ -0,0 +1,130 @@
> +QA output created by 540
> +*** mkfs
> +*** mount FS
> +*** make test file 1
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name1" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error

The error messages need to be filtered too, because SCRATCH_MNT is
definitely not /mnt/scratch here. ;)

--D

> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name2" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +user.attr_name2
> +
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name3" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +user.attr_name2
> +user.attr_name3
> +
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name4" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +user.attr_name2
> +user.attr_name3
> +user.attr_name4
> +
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name5" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +user.attr_name2
> +user.attr_name3
> +user.attr_name4
> +user.attr_name5
> +
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name6" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +user.attr_name2
> +user.attr_name3
> +user.attr_name4
> +user.attr_name5
> +user.attr_name6
> +
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name7" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +user.attr_name2
> +user.attr_name3
> +user.attr_name4
> +user.attr_name5
> +user.attr_name6
> +user.attr_name7
> +
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name8" for /mnt/scratch/testfile.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: SCRATCH_MNT/testfile.1
> +user.attr_name1
> +user.attr_name2
> +user.attr_name3
> +user.attr_name4
> +user.attr_name5
> +user.attr_name6
> +user.attr_name7
> +user.attr_name8
> +
> +*** done
> +*** unmount
> -- 
> 2.25.1
> 
