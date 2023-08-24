Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681FAC3DA6F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 03:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbjHXDTw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 23:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239588AbjHXDTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 23:19:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552D610F1;
        Wed, 23 Aug 2023 20:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0F42633B9;
        Thu, 24 Aug 2023 03:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CE4C433C7;
        Thu, 24 Aug 2023 03:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692847180;
        bh=u+xTE5/FLebkI7NM7ew173/Zm/eClvyweTxvI5xO6sU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ou4U8u7nEoHjmwxW+xMf2x0ZbTDCGHIGBEgOskHfHEx0gJbtKICUrBVS6klSZXIo1
         xTyCIfNYVkRDzNn6P5hiooCoeQ2grsOfV8Gu/7bgasJ7hEKWVSfrBKFwA6W1VuvSdK
         xjZyN+CLTHVLuN1USHsTgEbcnNw9mpohQAeVXxJxmMqICLZq7XZooiQ3Vgdi7R7yb9
         Oy9Yo/W2nH20fkUU6Zzqo2vrXFWB/kS4hZIeLVraLLci81yAQI47fG/YBTYWINH0SE
         XPjBLmKGf1dzBs5/117kE9d0hBcG73X4iUGx0Mpqurs7rZFGS5KILwqd5QzA6sBPnC
         f75IUVq6TEkCQ==
Date:   Wed, 23 Aug 2023 20:19:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] fstests: test fix for an agbno overflow in
 __xfs_getfsmap_datadev
Message-ID: <20230824031939.GI11263@frogsfrogsfrogs>
References: <20230823010046.GD11286@frogsfrogsfrogs>
 <20230823010239.GE11263@frogsfrogsfrogs>
 <ZObCG2iRTPr9wKuI@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZObCG2iRTPr9wKuI@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 12:36:11PM +1000, Dave Chinner wrote:
> On Tue, Aug 22, 2023 at 06:02:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Dave Chinner reported that xfs/273 fails if the AG size happens to be an
> > exact power of two.  I traced this to an agbno integer overflow when the
> > current GETFSMAP call is a continuation of a previous GETFSMAP call, and
> > the last record returned was non-shareable space at the end of an AG.
> > 
> > This is the regression test for that bug.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/935     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/935.out |    2 ++
> >  2 files changed, 57 insertions(+)
> >  create mode 100755 tests/xfs/935
> >  create mode 100644 tests/xfs/935.out
> > 
> > diff --git a/tests/xfs/935 b/tests/xfs/935
> > new file mode 100755
> > index 0000000000..a06f2fc8dc
> > --- /dev/null
> > +++ b/tests/xfs/935
> > @@ -0,0 +1,55 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 935
> > +#
> > +# Regression test for an agbno overflow bug in XFS GETFSMAP involving an
> > +# fsmap_advance call.  Userspace can indicate that a GETFSMAP call is actually
> > +# a continuation of a previous call by setting the "low" key to the last record
> > +# returned by the previous call.
> > +#
> > +# If the last record returned by GETFSMAP is a non-shareable extent at the end
> > +# of an AG and the AG size is exactly a power of two, the startblock in the low
> > +# key of the rmapbt query can be set to a value larger than EOAG.  When this
> > +# happens, GETFSMAP will return EINVAL instead of returning records for the
> > +# next AG.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick fsmap
> > +
> > +. ./common/filter
> > +
> > +_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> > +	"xfs: fix an agbno overflow in __xfs_getfsmap_datadev"
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_xfs_io_command fsmap
> > +_require_xfs_scratch_rmapbt
> > +
> > +_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> > +source $tmp.mkfs
> > +
> > +# Find the next power of two agsize smaller than whatever the default is.
> > +for ((p = 31; p > 0; p--)); do
> > +	desired_agsize=$((2 ** p))
> > +	test "$desired_agsize" -lt "$agsize" && break
> > +done
> > +
> > +echo "desired asize=$desired_agsize" >> $seqres.full
>                  agsize

Fixed.

> Otherwise looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Does the kernel patch fix the bug on your end too?

--D

> -- 
> Dave Chinner
> david@fromorbit.com
