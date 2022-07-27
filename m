Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0127EC3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jul 2022 23:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiG0XPf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 19:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiG0XPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 19:15:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45361A8;
        Wed, 27 Jul 2022 16:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81A7F6171E;
        Wed, 27 Jul 2022 23:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7B9C433D6;
        Wed, 27 Jul 2022 23:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658963730;
        bh=r9CKyhfjC+hIFTyNisY64mpXT0v21zmuQe9/0ge24mQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nhTRxxsK/Pd5aoGAkX55ZyQ7ENaiE2hiixkV/ZnalQ6ApFjkgTYwZhdOHE+2jpYAj
         gzeoEvEER4yh7bphZSXAAZX6NFJyF5fpMuihrHQto6x0QMiA0fcgUFHe9DqccJvnk4
         3742LhRqeyF565F2+SWyX7ubGTbzJ0kBdtfZygmU+n2emWmKhrH46uWDKWMbYKd2TG
         DHZB4WsGdVrR2uGYY2xEMJom0xQP0JMUguCe6j2cPB7xY5GbJ0OJvmOXKEtaZRwBk8
         U4sEsD9nHVkGJMrCEKrhCbO/aFERxbnymjH/0+ut57vQiFnLzdDbj6+GvqY/KZqzfk
         1Uo9qF6r/mTFg==
Date:   Wed, 27 Jul 2022 16:15:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH] xfs/432: fix this test when external devices are in use
Message-ID: <YuHHEhE1Hw6nL6Y+@magnolia>
References: <YuBFw4dheeSRHVQd@magnolia>
 <20220727220600.GU3600936@dread.disaster.area>
 <YuHAnCoB4FvMvIzb@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuHAnCoB4FvMvIzb@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 27, 2022 at 03:47:56PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 28, 2022 at 08:06:00AM +1000, Dave Chinner wrote:
> > On Tue, Jul 26, 2022 at 12:51:31PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > This program exercises metadump and mdrestore being run against the
> > > scratch device.  Therefore, the test must pass external log / rt device
> > > arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
> > > incorrect usage, and report repair failures, since this test has been
> > > silently failing for a while now.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/432 |   11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/xfs/432 b/tests/xfs/432
> > > index 86012f0b..5c6744ce 100755
> > > --- a/tests/xfs/432
> > > +++ b/tests/xfs/432
> > > @@ -89,7 +89,16 @@ _scratch_xfs_metadump $metadump_file -w
> > >  xfs_mdrestore $metadump_file $metadump_img
> > >  
> > >  echo "Check restored metadump image"
> > > -$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> > > +repair_args=('-n')
> > > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > > +	repair_args+=('-l' "$SCRATCH_LOGDEV")
> > > +
> > > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> > > +	repair_args+=('-r' "$SCRATCH_RTDEV")
> > > +
> > > +$XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1
> > > +res=$?
> > > +test $res -ne 0 && echo "xfs_repair on restored fs returned $res?"
> > 
> > I don't like open coding external device support into individual
> > tests.
> > 
> > i.e. Shouldn't this use a wrapper around check_xfs_filesystem()
> > similar to _check_xfs_test_fs()? Call it check_xfs_scratch_fs() that
> > uses SCRATCH_DEV by default, but if $1 is passed in use that as the
> > scratch device instead?
> 
> Yeah, that would also work.  IIRC there's one other fstest that does
> something similar to this.

Actually, there already is a _scratch_xfs_repair, so I think I'll just
re(ab)use it:

SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
	echo "xfs_repair on restored fs returned $?"

--D

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
