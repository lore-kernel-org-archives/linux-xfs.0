Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5825C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6AA4613AC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhESXV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhESXV1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D469611AD;
        Wed, 19 May 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621466407;
        bh=X3Fr7P6lFBu+mm3Lt1fKimT0vXjEhJOo/eInly4kfh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dKcXul1lNyL4Vclk7gNBpBo6kuuZXvUUiAvbmacrn6PqyChHy/slphz9TkQ0PXde2
         DNzim8BoSo8jVKeviUugbkHqVjZZVKwslif+Cjv211p/OAwUVIjiG6EMBz6C4aTFcP
         4/AaRckSdcE+DlunCBnGBmsQE8SSKuEVroDQAZnqRPjK1oEc1Yg5bOo65z3UWJs54a
         a6m1BUmpvgCt4Flpu2NxoPdRpodQFQbWLygl8NUTQFid47p4K20G4rADRgcZncthrP
         XF2eP8NMjtX/mBBjHXytauiJ7LvIX+hs5WfiAEGGlCEC9b1HGE5jOieId/OoQoKNST
         1AVfxHl9xsfPg==
Date:   Wed, 19 May 2021 16:20:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs/178: fix mkfs success test
Message-ID: <20210519232006.GD9648@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
 <162078494495.3302755.13327851823592717788.stgit@magnolia>
 <YKFANr4Yki6+cBmk@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKFANr4Yki6+cBmk@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 16, 2021 at 11:54:30PM +0800, Eryu Guan wrote:
> On Tue, May 11, 2021 at 07:02:24PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix the obviously incorrect code here that wants to fail the test if
> > mkfs doesn't succeed.  The return value ("$?") is always the status of
> > the /last/ command in the pipe.  Change the checker to _notrun so that
> > we don't leave the scratch check files around.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/178 |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/178 b/tests/xfs/178
> > index a24ef50c..bf72e640 100755
> > --- a/tests/xfs/178
> > +++ b/tests/xfs/178
> > @@ -57,8 +57,8 @@ _supported_fs xfs
> >  #             fix filesystem, new mkfs.xfs will be fine.
> >  
> >  _require_scratch
> > -_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs \
> > -        || _fail "mkfs failed!"
> > +_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> > +test "${PIPESTATUS[0]}" -eq 0 || _notrun "mkfs failed!"
> 
> I still don't understand why changing this to _notrun, shouldn't creating a
> default filesystem should always pass?

It will, unless you've injected a malicious mkfs.xfs to make sure
constructions like these actually work.

> and fail the test if mkfs failed?

Yeah, you're right, it /should/ fail.  I'll leave it alone then.

--D

> 
> Thanks,
> Eryu
> 
> >  
> >  # By executing the followint tmp file, will get on the mkfs options stored in
> >  # variables
> > 
