Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62B1C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 00:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7827661424
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 00:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhD2ApG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 20:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhD2ApG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 20:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D40161418;
        Thu, 29 Apr 2021 00:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619657060;
        bh=gooLNxRRlQAf/5MgwdRXRZrxmmq4qY6dUXn/Q+pqIuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dK2LoT0uIa2DJl6t6xYTXOzN38sI5iPEEY82RHXNegNI1tReyMmdQhIkIxhFSoT3+
         XiwnaMaPmZtV1uAccADZFHwlhPhaG5R8V7z5WbRXvf7yOHOY3O8sd1aUfVOI/zZynl
         QZsEJoUTOtyizfCgHSp5xibbJlXs8mK/EHD4j9R7jvjE8m80+rlQFR/1btj9xG4R+u
         aNTN5eKAMEVuGDG7++R+Ap3UM2zfnwXZr2CUlyfJlScBHblmr5mlVqMNvBntIbXIVk
         f27nfZiwu7ZO8vixgIcV9bQbPXXGSxgqQKvif8dBgh2ZJ1N4fESGmaGRc25TSMbbBG
         QIEQjqllJYhDQ==
Date:   Wed, 28 Apr 2021 17:44:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/5] xfs/49[12]: skip pre-lazysbcount filesystems
Message-ID: <20210429004420.GK3122235@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958296475.3452351.7075798777673076839.stgit@magnolia>
 <YImfyecT3zngAioz@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YImfyecT3zngAioz@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 01:47:53PM -0400, Brian Foster wrote:
> On Tue, Apr 27, 2021 at 09:09:24PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Prior to lazysbcount, the xfs mount code blindly trusted the value of
> > the fdblocks counter in the primary super, which means that the kernel
> > doesn't detect the fuzzed fdblocks value at all.  V4 is deprecated and
> > pre-lazysbcount V4 hasn't been the default for ~14 years, so we'll just
> > skip these two tests on those old filesystems.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/491 |    5 +++++
> >  tests/xfs/492 |    5 +++++
> >  2 files changed, 10 insertions(+)
> > 
> > 
> > diff --git a/tests/xfs/491 b/tests/xfs/491
> > index 6420202b..9fd0ab56 100755
> > --- a/tests/xfs/491
> > +++ b/tests/xfs/491
> > @@ -36,6 +36,11 @@ _require_scratch
> >  
> >  echo "Format and mount"
> >  _scratch_mkfs > $seqres.full 2>&1
> > +
> > +# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
> > +_check_scratch_xfs_features LAZYSBCOUNT &>/dev/null || \
> > +	_notrun "filesystem requires lazysbcount"
> > +
> 
> Perhaps we should turn this one into a '_require_scratch_xfs_feature
> <FEATURE>' helper or some such? Probably not that important for
> lazysbcount filtering, but it seems like that might be useful for newer
> features going forward.

Good idea, there are a few more tests in my stack that will need this.

--D

> Brian
> 
> >  _scratch_mount >> $seqres.full 2>&1
> >  echo "test file" > $SCRATCH_MNT/testfile
> >  
> > diff --git a/tests/xfs/492 b/tests/xfs/492
> > index 522def47..c4b087b5 100755
> > --- a/tests/xfs/492
> > +++ b/tests/xfs/492
> > @@ -36,6 +36,11 @@ _require_scratch
> >  
> >  echo "Format and mount"
> >  _scratch_mkfs > $seqres.full 2>&1
> > +
> > +# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
> > +_check_scratch_xfs_features LAZYSBCOUNT &>/dev/null || \
> > +	_notrun "filesystem requires lazysbcount"
> > +
> >  _scratch_mount >> $seqres.full 2>&1
> >  echo "test file" > $SCRATCH_MNT/testfile
> >  
> > 
> 
