Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30903C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 18:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0270A61430
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 18:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbhDUSBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 14:01:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240515AbhDUSBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 14:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619028060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P/j3Jn2F3cytz8jZfkGavAZSEU0oy0+zTiePiuHd9YI=;
        b=ArRjshrwbHH1vNq2OK7qKASBWAjqUlM88JyDdJXh8VIYlGOCJwdauP7m137WiaxIQHmb1G
        bxCKud62vHngvAf3ek3zTvOYXz6TnHgVRuizXnlhaNG7TFhTS6qyOdMR1qy/gkCnHtYUug
        PO9wFUaCQuqtMa4ORjgLckqtxzUtqLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-Hs71L27JPPCwngpcOqIjCA-1; Wed, 21 Apr 2021 14:00:41 -0400
X-MC-Unique: Hs71L27JPPCwngpcOqIjCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BFD91008060;
        Wed, 21 Apr 2021 18:00:40 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5F605D9C0;
        Wed, 21 Apr 2021 18:00:39 +0000 (UTC)
Date:   Wed, 21 Apr 2021 14:00:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: functional testing of V5-relevant options
Message-ID: <YIBoRixSehw0C+Km@bfoster>
References: <161896456467.776366.1514131340097986327.stgit@magnolia>
 <161896457076.776366.1740320523459442249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161896457076.776366.1740320523459442249.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 05:22:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the only functional testing for xfs_admin is xfs/287, which
> checks that one can add 32-bit project ids to a V4 filesystem.  This
> obviously isn't an exhaustive test of all the CLI arguments, and
> historically there have been xfs configurations that don't even work.
> 
> Therefore, introduce a couple of new tests -- one that will test the
> simple options with the default configuration, and a second test that
> steps a bit outside of the test run configuration to make sure that we
> do the right thing for external devices.  The second test already caught
> a nasty bug in xfsprogs 5.11.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs        |   21 ++++++++++
>  tests/xfs/764     |   93 +++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/764.out |   17 ++++++++
>  tests/xfs/773     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/773.out |   19 +++++++++
>  tests/xfs/group   |    2 +
>  6 files changed, 266 insertions(+)
>  create mode 100755 tests/xfs/764
>  create mode 100644 tests/xfs/764.out
>  create mode 100755 tests/xfs/773
>  create mode 100644 tests/xfs/773.out
> 
> 
...
> diff --git a/tests/xfs/773 b/tests/xfs/773
> new file mode 100755
> index 00000000..f184962a
> --- /dev/null
> +++ b/tests/xfs/773
> @@ -0,0 +1,114 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 773
> +#
> +# Functional testing for xfs_admin to ensure that it parses arguments correctly
> +# with regards to data devices that are files, external logs, and realtime
> +# devices.
> +#
> +# Because this test synthesizes log and rt devices (by modifying the test run
> +# configuration), it does /not/ require the ability to mount the scratch
> +# filesystem.  This increases test coverage while isolating the weird bits to a
> +# single test.
> +#
> +# This is partially a regression test for "xfs_admin: pick up log arguments
> +# correctly", insofar as the issue fixed by that patch was discovered with an
> +# earlier revision of this test.
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
> +	rm -f $tmp.* $fake_logfile $fake_rtfile $fake_datafile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_test
> +_require_scratch_nocheck
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +
> +rm -f $seqres.full
> +
> +# Create some fake sparse files for testing external devices and whatnot
> +fake_datafile=$TEST_DIR/scratch.data
> +rm -f $fake_datafile
> +truncate -s 500m $fake_datafile
> +
> +fake_logfile=$TEST_DIR/scratch.log
> +rm -f $fake_logfile
> +truncate -s 500m $fake_logfile
> +
> +fake_rtfile=$TEST_DIR/scratch.rt
> +rm -f $fake_rtfile
> +truncate -s 500m $fake_rtfile
> +

I think it's usually good practice to incorporate $seq into filenames
created on the test device.

> +# Save the original variables
> +orig_ddev=$SCRATCH_DEV
> +orig_external=$USE_EXTERNAL
> +orig_logdev=$SCRATCH_LOGDEV
> +orig_rtdev=$SCRATCH_RTDEV
> +
> +scenario() {
> +	echo "$@" | tee -a $seqres.full
> +
> +	SCRATCH_DEV=$orig_ddev
> +	USE_EXTERNAL=$orig_external
> +	SCRATCH_LOGDEV=$orig_logdev
> +	SCRATCH_RTDEV=$orig_rtdev
> +}
> +
> +check_label() {
> +	_scratch_mkfs -L oldlabel >> $seqres.full
> +	_scratch_xfs_db -c label
> +	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> +	_scratch_xfs_db -c label
> +	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +}
> +
> +scenario "S1: Check that label setting with file image"
> +SCRATCH_DEV=$fake_datafile
> +check_label -f
> +
> +scenario "S2: Check that setting with logdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +check_label
> +
> +scenario "S3: Check that setting with rtdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_RTDEV=$fake_rtfile
> +check_label
> +
> +scenario "S4: Check that setting with rtdev + logdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +SCRATCH_RTDEV=$fake_rtfile
> +check_label
> +
> +scenario "S5: Check that setting with nortdev + nologdev works"
> +USE_EXTERNAL=
> +SCRATCH_LOGDEV=
> +SCRATCH_RTDEV=
> +check_label
> +
> +scenario "S6: Check that setting with bdev incorrectly flagged as file works"
> +check_label -f
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/773.out b/tests/xfs/773.out
> new file mode 100644
> index 00000000..954bfb85
> --- /dev/null
> +++ b/tests/xfs/773.out
> @@ -0,0 +1,19 @@
> +QA output created by 773
> +S1: Check that label setting with file image
> +label = "oldlabel"
> +label = "newlabel"
> +S2: Check that setting with logdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S3: Check that setting with rtdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S4: Check that setting with rtdev + logdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S5: Check that setting with nortdev + nologdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S6: Check that setting with bdev incorrectly flagged as file works
> +label = "oldlabel"
> +label = "newlabel"
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 461ae2b2..a2309465 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -522,5 +522,7 @@
>  537 auto quick
>  538 auto stress
>  539 auto quick mount
> +764 auto quick repair
>  768 auto quick repair
>  770 auto repair
> +773 auto quick repair
> 

Both of these tests are primarily targeted at xfs_admin, right? If so,
I'm not sure the repair group makes much sense. With the nits fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

