Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D2AEB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 14:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjGKOyo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 10:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjGKOyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 10:54:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6AD1BB
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 07:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8866761525
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 14:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1EEC433C7;
        Tue, 11 Jul 2023 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689087281;
        bh=rNzbCmLj94oItKe5XhnhnFv/rldl27kYYhnisNJ2crs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TAr8jZsmuqNJMuzbCHpQ/nI3LXt3YMSX1tUPeuS1PHNiEeXL0ZU+2XBhdh5gS32Mw
         dNjjHxfpvJHcL0au0ZLJf2ziGWfLQJOR4RzD4POQ9nqpZKmUTuwoRfi6HXhyZqq6/a
         CGQiVtM4LIrkKaYgCgAZErg298uxx1/7lUBfE1rEKzdPAvmlKKb5PCViP7tNBp0/dN
         d3DPuXnEDEJtDjt63tKMHIh9YOX7nT6RjF0FBNO7TctOv/JNj7uNeVwUOrF2RX5Hdo
         0UXhKK2fEjEiZN4Hb/4qejBfA2hIiLpiEtcrWkXBAX5XlwWAnXuT7dkNlAyn4FyHi0
         ochBQ5dPWYHww==
Date:   Tue, 11 Jul 2023 07:54:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: remove bogus fstest
Message-ID: <20230711145441.GB108251@frogsfrogsfrogs>
References: <DNb0uIBsmTk-4VL37ZmBH-nqyWm2cSqdM-Zd_bAXcZPV1pCBQsbvInqpO9Y-wscHogOqvlrjO_98ujQlmB6EEg==@protonmail.internalid>
 <20230709223750.GC11456@frogsfrogsfrogs>
 <20230711132454.y4jmjlwyuhxmeylc@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711132454.y4jmjlwyuhxmeylc@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 03:24:54PM +0200, Carlos Maiolino wrote:
> On Sun, Jul 09, 2023 at 03:37:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Remove this test, not sure why it was committed...
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/999     |   66 -----------------------------------------------------
> >  tests/xfs/999.out |   15 ------------
> >  2 files changed, 81 deletions(-)
> >  delete mode 100755 tests/xfs/999
> >  delete mode 100644 tests/xfs/999.out
> 
> Thanks for spotting it. I'm quite sure this was a result of my initial attempts
> of using b4 to retrieve the xfsprogs patch from the list, and it ended up
> retrieving the whole thread which included xfstests patches.
> 
> Won't happen again, thanks for the heads up.

Well I'm glad that /one/ of us now actually knows how to use b4, because
I certainly don't.  Maybe that's why Konstantin or whoever was talking
about how every patch should include a link to a gitbranch or whatever.

--D

> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> 
> -- 
> Carlos
> 
> > 
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > deleted file mode 100755
> > index 9e799f66e72..00000000000
> > --- a/tests/xfs/999
> > +++ /dev/null
> > @@ -1,66 +0,0 @@
> > -#! /bin/bash
> > -# SPDX-License-Identifier: GPL-2.0
> > -# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> > -#
> > -# FS QA Test 521
> > -#
> > -# Test xfs_repair's progress reporting
> > -#
> > -. ./common/preamble
> > -_begin_fstest auto repair
> > -
> > -# Override the default cleanup function.
> > -_cleanup()
> > -{
> > -	cd /
> > -	rm -f $tmp.*
> > -	_cleanup_delay > /dev/null 2>&1
> > -}
> > -
> > -# Import common functions.
> > -. ./common/filter
> > -. ./common/dmdelay
> > -. ./common/populate
> > -
> > -# real QA test starts here
> > -
> > -# Modify as appropriate.
> > -_supported_fs xfs
> > -_require_scratch
> > -_require_dm_target delay
> > -
> > -# Filter output specific to the formatters in xfs_repair/progress.c
> > -# Ideally we'd like to see hits on anything that matches
> > -# awk '/{FMT/' xfsprogs-dev/repair/progress.c
> > -filter_repair()
> > -{
> > -	sed -nre '
> > -	s/[0-9]+/#/g;
> > -	s/^\s+/ /g;
> > -	s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
> > -	/#:#:#:/p
> > -	'
> > -}
> > -
> > -echo "Format and populate"
> > -_scratch_populate_cached nofill > $seqres.full 2>&1
> > -
> > -echo "Introduce a dmdelay"
> > -_init_delay
> > -DELAY_MS=38
> > -
> > -# Introduce a read I/O delay
> > -# The default in common/dmdelay is a bit too agressive
> > -BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> > -DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
> > -_load_delay_table $DELAY_READ
> > -
> > -echo "Run repair"
> > -SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> > -        tee -a $seqres.full > $tmp.repair
> > -
> > -cat $tmp.repair | filter_repair | sort -u
> > -
> > -# success, all done
> > -status=0
> > -exit
> > diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> > deleted file mode 100644
> > index e27534d8de6..00000000000
> > --- a/tests/xfs/999.out
> > +++ /dev/null
> > @@ -1,15 +0,0 @@
> > -QA output created by 999
> > -Format and populate
> > -Introduce a dmdelay
> > -Run repair
> > - - #:#:#: Phase #: #% done - estimated remaining time {progres}
> > - - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minute
> > - - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> > - - #:#:#: process known inodes and inode discovery - # of # inodes done
> > - - #:#:#: process newly discovered inodes - # of # allocation groups done
> > - - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> > - - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> > - - #:#:#: scanning filesystem freespace - # of # allocation groups done
> > - - #:#:#: setting up duplicate extent list - # of # allocation groups done
> > - - #:#:#: verify and correct link counts - # of # allocation groups done
> > - - #:#:#: zeroing log - # of # blocks done
