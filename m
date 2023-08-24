Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C105C3DA6F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 03:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjHXDmq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 23:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239658AbjHXDm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 23:42:28 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B8710F3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 20:42:26 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-57128297bd7so553668eaf.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 20:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692848545; x=1693453345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vrRf4riJ4t0fLvCBn8UMQQlz3KktSckyxk3BqGu0//Y=;
        b=ul9TcXFUU67Xu01rjUzArK1u5YGDCNn9qghPulF1XeWiskjifpL8UE/19WsBuuFRgy
         f5/E+tcDfAagn5YmM34LyB6UI71za9iEOO7PVt7wmgIj2EGIDbJNjbkLT258h/axbGRk
         55zVFWn9+7ikuREdURiVlU0E6vieZGuqopeUB2i83FiCUX2rcAHsfLSJSdGKY1r8F+7o
         AKclqS3IqRj9FBcsYGxw8YZvSOsjyiBxPzbVL/X9dHOBLYRaik8v8DEy729znUcUaY9X
         Bvu1CcAfG82EI5dhnVOt9RICG+kGJK2mhQUzXyq0iR9SFvCR+SKMLb5JNeljuVrzdYgb
         BFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692848545; x=1693453345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vrRf4riJ4t0fLvCBn8UMQQlz3KktSckyxk3BqGu0//Y=;
        b=Ork4JQMaaPy28jVczM20MWi+RNjs8unF/xl5acaOBO2K0fSLgO254OWE8TiU61Waow
         M6dKfGuj/upAJDN3BM90A1Sq7REfWqzoTbWx3b9rzbhcDFwrfbIOr1ntmex4+4NcHVCl
         nR5f7AgUGrQnoUReC5H5CUszo7PoWEXrsuZ0SIsPtOrEymOBU3bcFZC93Fs7Toeavx+P
         D/LG89wLjWV6YRH/pws3X902n9zQoevhdkcRvIO4yU5g6hK12Iy36wfJdZvlZ6o711SB
         L21tYSiu5Dlao5kLr5n5OUDMt4fTUR4hcNY9/TFnm2PUiFEoz3L7A10DC4Qk+nrArtc7
         cZCg==
X-Gm-Message-State: AOJu0Yx4wSWougrJ/f1TfDB/wa6BweWy720V8Sv+95tzKa1HocfuOwn3
        wwPYIlUXqu+qKm/wMJs0SKoU6mIpCyEdiCpgcSA=
X-Google-Smtp-Source: AGHT+IF4D0jzcH2c8HNVH6S/nNQ39//03iGwedjhOwwV6GXuyDPevWK75NoRwKXxpP/7qhpyFPS2mA==
X-Received: by 2002:a05:6870:e394:b0:1b0:3637:2bbe with SMTP id x20-20020a056870e39400b001b036372bbemr18215277oad.54.1692848545593;
        Wed, 23 Aug 2023 20:42:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a034800b00262d662c9adsm532717pjf.53.2023.08.23.20.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 20:42:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZ1Ej-005j9S-2h;
        Thu, 24 Aug 2023 13:42:21 +1000
Date:   Thu, 24 Aug 2023 13:42:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] fstests: test fix for an agbno overflow in
 __xfs_getfsmap_datadev
Message-ID: <ZObRnfDTls3VBnNA@dread.disaster.area>
References: <20230823010046.GD11286@frogsfrogsfrogs>
 <20230823010239.GE11263@frogsfrogsfrogs>
 <ZObCG2iRTPr9wKuI@dread.disaster.area>
 <20230824031939.GI11263@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824031939.GI11263@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 23, 2023 at 08:19:39PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 24, 2023 at 12:36:11PM +1000, Dave Chinner wrote:
> > On Tue, Aug 22, 2023 at 06:02:39PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Dave Chinner reported that xfs/273 fails if the AG size happens to be an
> > > exact power of two.  I traced this to an agbno integer overflow when the
> > > current GETFSMAP call is a continuation of a previous GETFSMAP call, and
> > > the last record returned was non-shareable space at the end of an AG.
> > > 
> > > This is the regression test for that bug.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/935     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/935.out |    2 ++
> > >  2 files changed, 57 insertions(+)
> > >  create mode 100755 tests/xfs/935
> > >  create mode 100644 tests/xfs/935.out
> > > 
> > > diff --git a/tests/xfs/935 b/tests/xfs/935
> > > new file mode 100755
> > > index 0000000000..a06f2fc8dc
> > > --- /dev/null
> > > +++ b/tests/xfs/935
> > > @@ -0,0 +1,55 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 935
> > > +#
> > > +# Regression test for an agbno overflow bug in XFS GETFSMAP involving an
> > > +# fsmap_advance call.  Userspace can indicate that a GETFSMAP call is actually
> > > +# a continuation of a previous call by setting the "low" key to the last record
> > > +# returned by the previous call.
> > > +#
> > > +# If the last record returned by GETFSMAP is a non-shareable extent at the end
> > > +# of an AG and the AG size is exactly a power of two, the startblock in the low
> > > +# key of the rmapbt query can be set to a value larger than EOAG.  When this
> > > +# happens, GETFSMAP will return EINVAL instead of returning records for the
> > > +# next AG.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick fsmap
> > > +
> > > +. ./common/filter
> > > +
> > > +_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> > > +	"xfs: fix an agbno overflow in __xfs_getfsmap_datadev"
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +_require_xfs_io_command fsmap
> > > +_require_xfs_scratch_rmapbt
> > > +
> > > +_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> > > +source $tmp.mkfs
> > > +
> > > +# Find the next power of two agsize smaller than whatever the default is.
> > > +for ((p = 31; p > 0; p--)); do
> > > +	desired_agsize=$((2 ** p))
> > > +	test "$desired_agsize" -lt "$agsize" && break
> > > +done
> > > +
> > > +echo "desired asize=$desired_agsize" >> $seqres.full
> >                  agsize
> 
> Fixed.
> 
> > Otherwise looks fine.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Does the kernel patch fix the bug on your end too?

Haven't had a chance to test it yet. I'll let you know when I do.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
