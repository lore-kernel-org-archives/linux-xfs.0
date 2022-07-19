Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1568ACCA481
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 14:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbiGSOpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 10:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240112AbiGSOoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 10:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7126204
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 07:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D8256181A
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 14:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DF4C341C6;
        Tue, 19 Jul 2022 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658241865;
        bh=Ed3+wr1F79/0bdvph3SCkJ8WCBqo0dv6igZinck0SXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=elb8u8krr3kjYr5FcUcLX4c6m0bHSaCRdHbncQ/ocnoiPWLp8QUq2ua6cI623gtbR
         umojUIcE+QCkJbvhZ20F/ZxuJTforhPtH282O8ztkAR5slhxlPMlMVFNI+LVrR9BSd
         EWUSahMEqk64ZxmvsLlnx4IVUHzpAW8xTC9a/zc+ZHGOqP9AP5GIbvxBzo7FaoFlTJ
         xKryzaR6CwNB8b4RDzOAraOyJiFhMl7X4p2bLUdzcAuD7imrCMvM2ymqysQ+fsKkn/
         /QaZqQMtcyxPxCEwyMndHK1fxJAf8WhqGumgLn9rK9XIsENm0mdOeT233yxF5pS4uz
         xyAu/bvj+fg/Q==
Date:   Tue, 19 Jul 2022 07:44:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE 0/9] xfs stable candidate patches for
 5.15.y (part 3)
Message-ID: <YtbDSQjWaVvweLRC@magnolia>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
 <YtXXhQuOioUeSltH@magnolia>
 <CAOQ4uxh13NPtWP98E-R7Sxfy=dkgCHxk7tysEykJ2rg3yhJ__A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh13NPtWP98E-R7Sxfy=dkgCHxk7tysEykJ2rg3yhJ__A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 10:44:29AM +0200, Amir Goldstein wrote:
> On Tue, Jul 19, 2022 at 12:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Jul 18, 2022 at 01:29:50PM -0700, Leah Rumancik wrote:
> > > Hi again,
> > >
> > > This set contains fixes from 5.16 to 5.17. The normal testing was run
> > > for this set with no regressions found.
> > >
> > > I included some fixes for online scrub. I am not sure if this
> > > is in use for 5.15 though so please let me know if these should be
> > > dropped.
> > >
> > > Some refactoring patches were included in this set as dependencies:
> > >
> > > bf2307b19513 xfs: fold perag loop iteration logic into helper function
> > >     dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
> > > f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
> > >     dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d
> > >
> > > Thanks,
> > > Leah
> > >
> > >
> > > Brian Foster (4):
> > >   xfs: fold perag loop iteration logic into helper function
> > >   xfs: rename the next_agno perag iteration variable
> > >   xfs: terminate perag iteration reliably on agcount
> > >   xfs: fix perag reference leak on iteration race with growfs
> > >
> > > Dan Carpenter (1):
> > >   xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
> > >
> > > Darrick J. Wong (4):
> > >   xfs: fix maxlevels comparisons in the btree staging code
> >
> > Up to this point,
> > Acked-by: Darrick J. Wong <djwong@kernel.org>
> >
> > >   xfs: fix incorrect decoding in xchk_btree_cur_fsbno
> > >   xfs: fix quotaoff mutex usage now that we don't support disabling it
> > >   xfs: fix a bug in the online fsck directory leaf1 bestcount check
> >
> > No objections to these last three, since they're legitimate fixes for
> > bugs in 5.15, but I would advise y'all not to worry too much about fixes
> > for EXPERIMENTAL features.

Also, to clarify -- if you /do/ want to pick up the scrub fixes, then
yes, the Acked-by above does apply to the entire set.  I don't know if
you have people running (experimental) scrub, but I don't know that you
**don't**. :)

> FWIW, from the set above, I only picked Dan Carpenter's fix for 5.10.
> I'll include it in one of the following updates.

<nod>

--D

> Thanks,
> Amir.
