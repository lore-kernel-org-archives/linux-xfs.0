Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D33C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 16:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 942116101C
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 16:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhDSQOj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 12:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238724AbhDSQOh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Apr 2021 12:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA756101C;
        Mon, 19 Apr 2021 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618848847;
        bh=EHomr7953LjZEP/gz7c5+af3sNmoac8ZE/qTA2t2MT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yvq7sfTRTRWbeKB1NC3nZAL4BPlb1muXZG/R96zFnwaDbntIRQka1rkN76ZB4yq87
         Uuly/mkewzJ8Kg3+WsB6l9MN1mdtGTr7usrNy11sfumqPVbjWJbk5y0Au1q+xO6lmA
         SfudbjT8DgrOzj27Jk3KEqpmbGav5PcanU8zHH0Vj+sAacYkqQRPXb7AXPxkCijV86
         6IzCDrQq3ho+azPoCoqV4N3kUqtETLCi+ke7iDL4MW3m2yx1K7g3GfBMci3Mn0VOpE
         Spw0DNgY8tGVfZ5giGfjVyDoKqv66pULQdwebauUo184Cq/EQjY5ZjsZWMAOCLd2Bv
         cRsrB99lpA2yQ==
Date:   Mon, 19 Apr 2021 09:14:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Eryu Guan <guan@eryu.me>,
        guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/9] common/dmthin: make this work with external log
 devices
Message-ID: <20210419161402.GD3122264@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836230182.2754991.16864806174255630147.stgit@magnolia>
 <YHwlTMySYgKuaw6Y@desktop>
 <YHxFuFvbAiiIrbIo@mit.edu>
 <20210419020442.GA1990290@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419020442.GA1990290@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 12:04:42PM +1000, Dave Chinner wrote:
> On Sun, Apr 18, 2021 at 10:44:08AM -0400, Theodore Ts'o wrote:
> > On Sun, Apr 18, 2021 at 08:25:48PM +0800, Eryu Guan wrote:
> > > > diff --git a/tests/generic/223 b/tests/generic/223
> > > > index 1f85efe5..a5ace82f 100755
> > > > --- a/tests/generic/223
> > > > +++ b/tests/generic/223
> > > > @@ -43,6 +43,9 @@ for SUNIT_K in 8 16 32 64 128; do
> > > >  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
> > > >  	_scratch_mount
> > > >  
> > > > +	# Make sure everything is on the data device
> > > > +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > > 
> > > What does this do for non-xfs filesystems? Do we need a FSTYP check and
> > > do chattr only on XFS?

Yes, I think so.  Will fix.

> > This clears the FS_NOTAIL_FL flag, which prevents tail merging, on the
> 
> No, this is not the 'chattr' CLI program. This is the xfs_io
> 'chattr' command, and they have different attribute namespaces. See
> xfs_io for the definitions, but in this case:
> 
> 	 t    inherit realtime flag (XFS_XFLAG_RTINHERIT)
> 
> And so clearing that flag ensures that all newly created files
> are on the data device, as per the comment...
> 
> > I also have no idea why this helps for xfs --- I would think it's a
> > no-op,
> 
> Because it's not what you think it is. :)

(Indeed.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
