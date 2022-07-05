Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D031DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 16:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiGEQy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 12:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiGEQy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 12:54:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8AA13CC2
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 09:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CACCEB817EE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 16:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81331C341CA;
        Tue,  5 Jul 2022 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657040064;
        bh=sgyi1khZcgipCdvc7BpBxCx5fMVnxwICwZkvO/BjhM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3ol30cx4cG2ZLFdDaoRFmwkF0L2OOOf3jaOBhq3/ASAAwwmA7RO5Z8zg8AVzA1//
         Tvimbv+Zk3wEmTpWq57Ms4gvcV1W5jgPAlOWBl3CaPW3dmbg7o02njn7ptk0UNb/fW
         T745lRA5nk51eRLZlhC0HRlIHupDfiUpudZ1lkFYoACtsKVUFAMw8eljllv2IADCur
         xJPjoITbeBbgByEn3irTOjihgr5sSqWGRFcKKuGT17zTNTDVrXysJnjXI/R0whiqx4
         TIJaPO1LtNlYtRQYzv16eox8TmgD19V7FkZstN84TeK8hK++Ue9sdRQ14tTuVkQ/9e
         nev5hR55XqWKQ==
Date:   Tue, 5 Jul 2022 09:54:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Srikanth C S <srikanth.c.s@oracle.com>, linux-xfs@vger.kernel.org,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com
Subject: Re: [PATCH] mkfs: custom agcount that renders AG size <
 XFS_AG_MIN_BYTES gives "Assertion failed. Aborted"
Message-ID: <YsRsv/KrtkDWoFVO@magnolia>
References: <20220705031958.407-1-srikanth.c.s@oracle.com>
 <20220705035536.GE227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705035536.GE227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 01:55:36PM +1000, Dave Chinner wrote:
> On Tue, Jul 05, 2022 at 08:49:58AM +0530, Srikanth C S wrote:
> > For a 2GB FS we have
> > $ mkfs.xfs -f -d agcount=129 test.img
> > mkfs.xfs: xfs_mkfs.c:3021: align_ag_geometry: Assertion `!cli_opt_set(&dopts, D_AGCOUNT)' failed.
> > Aborted
> 
> Ok, that's because the size of the last AG is too small when trying
> to align the AG size to stripe geometry. It fails an assert that
> says "we should not get here if the agcount was specified on the
> CLI".
> 
> > 
> > With this change we have
> > $ mkfs.xfs -f -d agcount=129 test.img
> > Invalid value 129 for -d agcount option. Value is too large.

What version of mkfs is this?

$ truncate -s 2g /tmp/a
$ mkfs.xfs -V
mkfs.xfs version 5.18.0
$ mkfs.xfs -f -d agcount=129 /tmp/a
agsize (4065 blocks) too small, need at least 4096 blocks

> OK, but....
> 
> > 
> > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 057b3b09..32dcbfff 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2897,6 +2897,13 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
> >  		cfg->agcount = cli->agcount;
> >  		cfg->agsize = cfg->dblocks / cfg->agcount +
> >  				(cfg->dblocks % cfg->agcount != 0);
> > +		if (cfg->agsize < XFS_AG_MIN_BYTES >> cfg->blocklog)
> > +		{
> > +			fprintf(stderr,
> > +_("Invalid value %lld for -d agcount option. Value is too large.\n"),
> > +				(long long)cli->agcount);
> > +			usage();	
> > +		}
> 
> .... that's not where we validate the calculated ag size. That
> happens via align_ag_geometry() -> validate_ag_geometry(). i.e. we
> can't reject an AG specification until after we've applied all the
> necessary modifiers to it first (such as stripe alignment
> requirements).
> 
> IOWs, we do actually check for valid AG sizes, it's just that this
> specific case hit an ASSERT() check before we got to validating the
> AG size. I'm pretty sure just removing the ASSERT - which assumes
> that "-d agcount=xxx" is not so large that it produces undersized
> AGs - will fix the problem and result in the correct error message
> being returned.

(Agreed.)

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
