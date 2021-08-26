Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F5BC4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 01:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF456108E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 01:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhHZBDm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 21:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234396AbhHZBDm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Aug 2021 21:03:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7398760524;
        Thu, 26 Aug 2021 01:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629939775;
        bh=gRlmxEx3urcyyFbDgYXqZWOYOIWMDNN26UUUxWLOiZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=maLx82hl/0Emg7oGQNxI+IDYhhgTxDXQTkgQiiPZg8SU7pX/fjWWqa5gJRUOquAVM
         VQVgzt7JEwAZ2SuN71O5NnSeZ6oMSeAwzlWfCgHgtyHLV7Exut8TDznPJU6BfojQBj
         SDeo6Ie2lzTZw8NtBipSYg3Sh7D+PMPM2SVVW0Wf1rs8HoK5jwRvuF+3nVeZzibuH8
         3uqlc/0a3TjkaPgctZbrgGULmji2Yuymqhg32lWMDuUcInGO3JqHJAQte6qYj7hqV+
         oGQF35RUtcOFDA+StkGJVL/oY5pcbXy66qrl3uy20DB8NjfJwC0sdxg6qIU2DuPJZf
         hCPTwYyCZ5i5Q==
Date:   Wed, 25 Aug 2021 18:02:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfstests: Add Log Attribute Replay test
Message-ID: <20210826010255.GJ12640@magnolia>
References: <20210825195144.2283-1-catherine.hoang@oracle.com>
 <20210825195144.2283-2-catherine.hoang@oracle.com>
 <20210825222807.GG12640@magnolia>
 <02e9685b-b6e3-2fc7-9233-e9e540c0d3a6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e9685b-b6e3-2fc7-9233-e9e540c0d3a6@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 25, 2021 at 05:58:14PM -0700, Allison Henderson wrote:
> 
> 
> On 8/25/21 3:28 PM, Darrick J. Wong wrote:
> > On Wed, Aug 25, 2021 at 12:51:44PM -0700, Catherine Hoang wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > This patch adds a test to exercise the log attribute error
> > > inject and log replay.  Attributes are added in increaseing
> > > sizes up to 64k, and the error inject is used to replay them
> > > from the log
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > 
> > Yay, [your] first post! :D
> > 
> > > ---
> > >   tests/xfs/540     |  96 ++++++++++++++++++++++++++++++++++
> > >   tests/xfs/540.out | 130 ++++++++++++++++++++++++++++++++++++++++++++++
> > >   2 files changed, 226 insertions(+)
> > >   create mode 100755 tests/xfs/540
> > >   create mode 100644 tests/xfs/540.out
> > > 
> > > diff --git a/tests/xfs/540 b/tests/xfs/540
> > > new file mode 100755
> > > index 00000000..3b05b38b
> > > --- /dev/null
> > > +++ b/tests/xfs/540
> > > @@ -0,0 +1,96 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 540
> > > +#
> > > +# Log attribute replay test
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick attr
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/filter
> > > +. ./common/attr
> > > +. ./common/inject
> > > +
> > > +_cleanup()
> > > +{
> > > +	echo "*** unmount"
> > > +	_scratch_unmount 2>/dev/null
> > > +	rm -f $tmp.*
> > > +	echo 0 > /sys/fs/xfs/debug/larp
> > > +}
> > > +
> > > +_test_attr_replay()
> > > +{
> > > +	attr_name=$1
> > > +	attr_value=$2
> > > +	touch $testfile.1
> > > +
> > > +	echo "Inject error"
> > > +	_scratch_inject_error "larp"
> > > +
> > > +	echo "Set attribute"
> > > +	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 | \
> > > +			    _filter_scratch
> > > +
> > > +	echo "FS should be shut down, touch will fail"
> > > +	touch $testfile.1
> > > +
> > > +	echo "Remount to replay log"
> > > +	_scratch_inject_logprint >> $seqres.full
> > > +
> > > +	echo "FS should be online, touch should succeed"
> > > +	touch $testfile.1
> > > +
> > > +	echo "Verify attr recovery"
> > > +	_getfattr --absolute-names $testfile.1 | _filter_scratch
> > 
> > Shouldn't we check the value of the extended attrs too?
> I think the first time I did this years ago, I questioned if people would
> really want to see a 110k .out file, and stopped with just the names.
> 
> Looking back at it now, maybe we could drop the value and the expected value
> in separate files, and diff the files, and then the test case could just
> check to make sure the diff output comes back clean?

$ATTR_PROG -g attr_nameX fubar.1 | md5sum

would be a more compact way of encoding exact byte sequence output in
the .out file.

--D

> > 
> > > +}
> > > +
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +
> > > +_require_scratch
> > > +_require_attrs
> > > +_require_xfs_io_error_injection "larp"
> > > +_require_xfs_sysfs debug/larp
> > > +
> > > +# turn on log attributes
> > > +echo 1 > /sys/fs/xfs/debug/larp
> > > +
> > > +rm -f $seqres.full
> > 
> > No need to do this anymore; _begin_fstest takes care of this now.
> > 
> > > +_scratch_unmount >/dev/null 2>&1
> > > +
> > > +#attributes of increaseing sizes
> > > +attr16="0123456789ABCDEFG"
> Yes, we need to drop the G off this line :-)
> 
> > 
> > "attr16" is seventeen bytes long.
> > 
> > > +attr64="$attr16$attr16$attr16$attr16"
> > > +attr256="$attr64$attr64$attr64$attr64"
> > > +attr1k="$attr256$attr256$attr256$attr256"
> > > +attr4k="$attr1k$attr1k$attr1k$attr1k"
> > > +attr8k="$attr4k$attr4k$attr4k$attr4k"
> I think I must have meant to do a 16k in here. Lets replace attr8k and
> attr32k with:
> 
> attr8k="$attr4k$attr4k"
> attr16k="$attr8k$attr8k"
> attr32k="$attr16k$attr16k"
> 
> I think that's easier to look at too.  Then we can add another replay test
> for the attr16k as well.
> 
> > 
> > This is 17k long...
> > 
> > > +attr32k="$attr8k$attr8k$attr8k$attr8k"
> > 
> > ...which makes this 68k long...
> > 
> > > +attr64k="$attr32k$attr32k"
> > 
> > ...and this 136K long?
> > 
> > I'm curious, what are the contents of user.attr_name8?
> > 
> > OH, I see, attr clamps the value length to 64k, so I guess the oversize
> > buffers don't matter.
> > 
> > --D
> > 
> > > +
> > > +echo "*** mkfs"
> > > +_scratch_mkfs_xfs >/dev/null
> > > +
> > > +echo "*** mount FS"
> > > +_scratch_mount
> > > +
> > > +testfile=$SCRATCH_MNT/testfile
> > > +echo "*** make test file 1"
> > > +
> > > +_test_attr_replay "attr_name1" $attr16
> > > +_test_attr_replay "attr_name2" $attr64
> > > +_test_attr_replay "attr_name3" $attr256
> > > +_test_attr_replay "attr_name4" $attr1k
> > > +_test_attr_replay "attr_name5" $attr4k
> > > +_test_attr_replay "attr_name6" $attr8k
> > > +_test_attr_replay "attr_name7" $attr32k
> > > +_test_attr_replay "attr_name8" $attr64k
> > > +
> > > +echo "*** done"
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/540.out b/tests/xfs/540.out
> > > new file mode 100644
> > > index 00000000..c1b178a0
> > > --- /dev/null
> > > +++ b/tests/xfs/540.out
> > > @@ -0,0 +1,130 @@
> > > +QA output created by 540
> > > +*** mkfs
> > > +*** mount FS
> > > +*** make test file 1
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name1" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > 
> > The error messages need to be filtered too, because SCRATCH_MNT is
> > definitely not /mnt/scratch here. ;)
> Ok, so we need to add "| _filter_scratch" to all the touch commands in
> _test_attr_replay
> 
> Thanks for the reviews!
> Allison
> 
> > 
> > --D
> > 
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name2" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +user.attr_name2
> > > +
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name3" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +user.attr_name2
> > > +user.attr_name3
> > > +
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name4" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +user.attr_name2
> > > +user.attr_name3
> > > +user.attr_name4
> > > +
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name5" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +user.attr_name2
> > > +user.attr_name3
> > > +user.attr_name4
> > > +user.attr_name5
> > > +
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name6" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +user.attr_name2
> > > +user.attr_name3
> > > +user.attr_name4
> > > +user.attr_name5
> > > +user.attr_name6
> > > +
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name7" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +user.attr_name2
> > > +user.attr_name3
> > > +user.attr_name4
> > > +user.attr_name5
> > > +user.attr_name6
> > > +user.attr_name7
> > > +
> > > +Inject error
> > > +Set attribute
> > > +attr_set: Input/output error
> > > +Could not set "attr_name8" for /mnt/scratch/testfile.1
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Verify attr recovery
> > > +# file: SCRATCH_MNT/testfile.1
> > > +user.attr_name1
> > > +user.attr_name2
> > > +user.attr_name3
> > > +user.attr_name4
> > > +user.attr_name5
> > > +user.attr_name6
> > > +user.attr_name7
> > > +user.attr_name8
> > > +
> > > +*** done
> > > +*** unmount
> > > -- 
> > > 2.25.1
> > > 
