Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20B0C19F21
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jul 2022 22:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiG0WsC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 18:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiG0WsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 18:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115852A431;
        Wed, 27 Jul 2022 15:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84C7AB8221E;
        Wed, 27 Jul 2022 22:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6D8C433D6;
        Wed, 27 Jul 2022 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658962077;
        bh=p0k3LrYd9h1zL+FgkSq3+MdBennwbZ1FBHPaanINR2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XheRAPYc1deuTTSMQa0tCqPQvb00JWvOPn+hnAhFk77+d5xU4H9IkPFlJL0v9siYg
         pM6Gn4Oo2UtRQ476+S897dJdMYvQR/2VsNrQbHvFYQ2yQluwU4kgS2IA1EfTvIKjiK
         9sjELjCrOKo3yebHxOnHeiH82hjsfPzpbZ0lgBQnBZRDEvdiXnEEumJFswDO24H1Jt
         rCDfD/dwvIfI+YaLOaRY6h2ymqWI7+q+ZDTxo6af/XML1CG05HAGeWKZ+MbrbXCjPf
         tuXTgrHiKKQ7X8xY5t16ydiOWw9h3mV/49/uQ+8j+ns+0t73pi2g6wHmVLuFb54TxA
         uQce5mF5dDLZQ==
Date:   Wed, 27 Jul 2022 15:47:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH] xfs/432: fix this test when external devices are in use
Message-ID: <YuHAnCoB4FvMvIzb@magnolia>
References: <YuBFw4dheeSRHVQd@magnolia>
 <20220727220600.GU3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727220600.GU3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 08:06:00AM +1000, Dave Chinner wrote:
> On Tue, Jul 26, 2022 at 12:51:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This program exercises metadump and mdrestore being run against the
> > scratch device.  Therefore, the test must pass external log / rt device
> > arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
> > incorrect usage, and report repair failures, since this test has been
> > silently failing for a while now.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/432 |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/432 b/tests/xfs/432
> > index 86012f0b..5c6744ce 100755
> > --- a/tests/xfs/432
> > +++ b/tests/xfs/432
> > @@ -89,7 +89,16 @@ _scratch_xfs_metadump $metadump_file -w
> >  xfs_mdrestore $metadump_file $metadump_img
> >  
> >  echo "Check restored metadump image"
> > -$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> > +repair_args=('-n')
> > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > +	repair_args+=('-l' "$SCRATCH_LOGDEV")
> > +
> > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> > +	repair_args+=('-r' "$SCRATCH_RTDEV")
> > +
> > +$XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1
> > +res=$?
> > +test $res -ne 0 && echo "xfs_repair on restored fs returned $res?"
> 
> I don't like open coding external device support into individual
> tests.
> 
> i.e. Shouldn't this use a wrapper around check_xfs_filesystem()
> similar to _check_xfs_test_fs()? Call it check_xfs_scratch_fs() that
> uses SCRATCH_DEV by default, but if $1 is passed in use that as the
> scratch device instead?

Yeah, that would also work.  IIRC there's one other fstest that does
something similar to this.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
