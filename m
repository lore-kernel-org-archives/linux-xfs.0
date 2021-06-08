Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C9CC47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BDF06134F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhFHPXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231371AbhFHPXj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 11:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D8A61108;
        Tue,  8 Jun 2021 15:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623165706;
        bh=o8vZNpok/YZnRZogDG1I9Nyp7RaoVqS7I4xNQf4Bdzk=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=HMvX7CRfgkNBnohHP1KXA+GEeg+FNButlB2ssde79d8p5Dz56Wc7oj2t+Zzt468JX
         Qlzf+qykOHSWZogOQ69hCBT0uTmwkkD9XlueRV9Q3HwZSUH3jg7qRC1AfNSML56bb6
         xgaS5el3SKNzhhqTYwf+e3ZgZW/8yaCjzOjAXOG7xRjtcPGMscGPBKPV+kIqCuoaWO
         d2mbKPyzPLjO1RNQLLr449CRfEBRo03X/C2OAqr2Tk78DSKnti8E+EtcdyoYOKt8bu
         cTgCaoiIHcO6Hdii3UnQNgokq9bA7SOt3r3dk05nHtUc7ErJSRSayvQuBJaROSPjUS
         Cb3uy9HzVMKDg==
Date:   Tue, 8 Jun 2021 08:21:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <20210608152146.GR2945738@locust>
References: <162300204472.1202529.17352653046483745148.stgit@locust>
 <162300205695.1202529.8468586379242468573.stgit@locust>
 <20210608145948.b25ejxdfbm33uz42@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608145948.b25ejxdfbm33uz42@omega.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 04:59:48PM +0200, Carlos Maiolino wrote:
> Hi,
> 
> On Sun, Jun 06, 2021 at 10:54:17AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we decide to mark an inode sick, clear the DONTCACHE flag so that
> > the incore inode will be kept around until memory pressure forces it out
> > of memory.  This increases the chances that the sick status will be
> > caught by someone compiling a health report later on.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> The patch looks ok, so you can add:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> 
> Now, I have a probably dumb question about this.
> 
> by removing the I_DONTCACHE flag, as you said, we are increasing the chances
> that the sick status will be caught, so, in either case, it seems not reliable.
> So, my dumb question is, is there reason having these inodes around will benefit
> us somehow? I haven't read the whole code, but I assume, it can be used as a
> fast path while scrubbing the FS?

Two answers to your question: In the short term, preserving the incore
inode means that a subsequent reporting run (xfs_spaceman -c 'health')
is more likely to pick up the sickness report.

In the longer term, I intend to re-enable reclamation of sick inodes
by aggregating the per-inode sick bit in the per-AG health status so
that reporting won't be interrupted by memory demand:

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

(I haven't rebased that part in quite a while though.)

--D

> 
> Cheers.
> 
> > ---
> >  fs/xfs/xfs_health.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index 8e0cb05a7142..806be8a93ea3 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -231,6 +231,15 @@ xfs_inode_mark_sick(
> >  	ip->i_sick |= mask;
> >  	ip->i_checked |= mask;
> >  	spin_unlock(&ip->i_flags_lock);
> > +
> > +	/*
> > +	 * Keep this inode around so we don't lose the sickness report.  Scrub
> > +	 * grabs inodes with DONTCACHE assuming that most inode are ok, which
> > +	 * is not the case here.
> > +	 */
> > +	spin_lock(&VFS_I(ip)->i_lock);
> > +	VFS_I(ip)->i_state &= ~I_DONTCACHE;
> > +	spin_unlock(&VFS_I(ip)->i_lock);
> >  }
> >  
> >  /* Mark parts of an inode healed. */
> > 
> 
> -- 
> Carlos
> 
