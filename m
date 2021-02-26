Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378C7C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 22:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED6A364EDC
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 22:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZWm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 17:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhBZWm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 17:42:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC67C061756
        for <linux-xfs@vger.kernel.org>; Fri, 26 Feb 2021 14:41:47 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c6so12906211ede.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Feb 2021 14:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fHpk7bX3cDWOBW490ZT0/lz5t0wLMJKj3dSlv6bBAAo=;
        b=1yPeE5A9fp2f1ejfpTgfXOETxBjJbBT1SW14Chud06HLDzIPNmCmEsBOwUKfXdN3gG
         vJaneShjlCuuLtVWoYUcKIDMup8b2L1ipSyCLygvfOdhGe92XWeSyMfTu3qfKefqBXHV
         KMLUvZTGTvbA42+8ifrpPE2dZBXOL0gAQy9jhaV9OnK/sGFHAD8aBWOBYrjNVcWNAESs
         UBhGp1C8ai2SH/diDzk7qVVRiEWSsBjvBKIdzhrmhhVfDd4zoXVI/HXEe2k23sGGfAE2
         duzT9FLKldvV8YstP9kViwPaBBH+jJGT/gEcK/nbRdXMijcNQt9b9YiuJ7Wl/23jK6Cv
         BYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fHpk7bX3cDWOBW490ZT0/lz5t0wLMJKj3dSlv6bBAAo=;
        b=o3qAOhbnCY4vCrLaig3zYjRw5foVh434gKKzw92Gcry68pnEN50HU5ltGNxpu9jHhj
         q1CyH1NZ19506Bdqe/h0GsdWaJ9Fp+rcCt4ucmZYUI4casuqBLZqHM0LF8dipe4Qtokf
         u1hwoezH/NS3RciOwdd5nYfhPUCHtlpjFsLEbPi95G/F0FrxsCvBvSirJ2jx1nc4Yp+G
         g5ck8Mof0u6BlFrvArnUnNblA0mWAKAwgp/6lwD3vAi3ppA22I7kjpsofixnVkzG+lDN
         OaJ5IjiGGtHfzvSdqXlB8/FV9JvjG3vFywSyKdWwdE56IoJBKk33VnvLcdiMQT9oFYC2
         6ozA==
X-Gm-Message-State: AOAM533C0UBBo0beFOuAZa0RJVMOya3RTfH9I4Qc54wtXQOa76pUKPm5
        zUYPthFowIs5Wt/2hwVFZexiTFXa+0KbMheT8wXK6A==
X-Google-Smtp-Source: ABdhPJzRqB7Th9975KKwZVp3f4l2p1uq8ensA0GvES+o8Z3FVF9VoQw9apOJIKwlD0LzIcC2XhrsXeFRdf3KO98ibv0=
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr5689417edc.97.1614379305912;
 Fri, 26 Feb 2021 14:41:45 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
 <OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20210226190454.GD7272@magnolia> <CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
 <20210226205126.GX4662@dread.disaster.area> <CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
 <20210226212748.GY4662@dread.disaster.area>
In-Reply-To: <20210226212748.GY4662@dread.disaster.area>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 26 Feb 2021 14:41:34 -0800
Message-ID: <CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
Subject: Re: Question about the "EXPERIMENTAL" tag for dax in XFS
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "hch@lst.de" <hch@lst.de>, "rgoldwyn@suse.de" <rgoldwyn@suse.de>,
        "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
        "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 26, 2021 at 1:28 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Feb 26, 2021 at 12:59:53PM -0800, Dan Williams wrote:
> > On Fri, Feb 26, 2021 at 12:51 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, Feb 26, 2021 at 11:24:53AM -0800, Dan Williams wrote:
> > > > On Fri, Feb 26, 2021 at 11:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > >
> > > > > On Fri, Feb 26, 2021 at 09:45:45AM +0000, ruansy.fnst@fujitsu.com wrote:
> > > > > > Hi, guys
> > > > > >
> > > > > > Beside this patchset, I'd like to confirm something about the
> > > > > > "EXPERIMENTAL" tag for dax in XFS.
> > > > > >
> > > > > > In XFS, the "EXPERIMENTAL" tag, which is reported in waring message
> > > > > > when we mount a pmem device with dax option, has been existed for a
> > > > > > while.  It's a bit annoying when using fsdax feature.  So, my initial
> > > > > > intention was to remove this tag.  And I started to find out and solve
> > > > > > the problems which prevent it from being removed.
> > > > > >
> > > > > > As is talked before, there are 3 main problems.  The first one is "dax
> > > > > > semantics", which has been resolved.  The rest two are "RMAP for
> > > > > > fsdax" and "support dax reflink for filesystem", which I have been
> > > > > > working on.
> > > > >
> > > > > <nod>
> > > > >
> > > > > > So, what I want to confirm is: does it means that we can remove the
> > > > > > "EXPERIMENTAL" tag when the rest two problem are solved?
> > > > >
> > > > > Yes.  I'd keep the experimental tag for a cycle or two to make sure that
> > > > > nothing new pops up, but otherwise the two patchsets you've sent close
> > > > > those two big remaining gaps.  Thank you for working on this!
> > > > >
> > > > > > Or maybe there are other important problems need to be fixed before
> > > > > > removing it?  If there are, could you please show me that?
> > > > >
> > > > > That remains to be seen through QA/validation, but I think that's it.
> > > > >
> > > > > Granted, I still have to read through the two patchsets...
> > > >
> > > > I've been meaning to circle back here as well.
> > > >
> > > > My immediate concern is the issue Jason recently highlighted [1] with
> > > > respect to invalidating all dax mappings when / if the device is
> > > > ripped out from underneath the fs. I don't think that will collide
> > > > with Ruan's implementation, but it does need new communication from
> > > > driver to fs about removal events.
> > > >
> > > > [1]: http://lore.kernel.org/r/CAPcyv4i+PZhYZiePf2PaH0dT5jDfkmkDX-3usQy1fAhf6LPyfw@mail.gmail.com
> > >
> > > Oh, yay.
> > >
> > > The XFS shutdown code is centred around preventing new IO from being
> > > issued - we don't actually do anything about DAX mappings because,
> > > well, I don't think anyone on the filesystem side thought they had
> > > to do anything special if pmem went away from under it.
> > >
> > > My understanding -was- that the pmem removal invalidates
> > > all the ptes currently mapped into CPU page tables that point at
> > > the dax device across the system. THe vmas that manage these
> > > mappings are not really something the filesystem really manages,
> > > but a function of the mm subsystem. What the filesystem cares about
> > > is that it gets page faults triggered when a change of state occurs
> > > so that it can remap the page to it's backing store correctly.
> > >
> > > IOWs, all the mm subsystem needs to when pmem goes away is clear the
> > > CPU ptes, because then when then when userspace tries to access the
> > > mapped DAX pages we get a new page fault. In processing the fault, the
> > > filesystem will try to get direct access to the pmem from the block
> > > device. This will get an ENODEV error from the block device because
> > > because the backing store (pmem) has been unplugged and is no longer
> > > there...
> > >
> > > AFAICT, as long as pmem removal invalidates all the active ptes that
> > > point at the pmem being removed, the filesystem doesn't need to
> > > care about device removal at all, DAX or no DAX...
> >
> > How would the pmem removal do that without walking all the active
> > inodes in the fs at the time of shutdown and call
> > unmap_mapping_range(inode->i_mapping, 0, 0, 1)?
>
> Which then immediately ends up back at the vmas that manage the ptes
> to unmap them.
>
> Isn't finding the vma(s) that map a specific memory range exactly
> what the rmap code in the mm subsystem is supposed to address?

rmap can lookup only vmas from a virt address relative to a given
mm_struct. The driver has neither the list of mm_struct objects nor
virt addresses to do a lookup. All it knows is that someone might have
mapped pages through the fsdax interface.

To me this looks like a notifier that fires from memunmap_pages()
after dev_pagemap_kill() to notify any block_device associated with
that dev_pagemap() to say that any dax mappings arranged through this
block_device are now invalid. The reason to do this after
dev_pagemap_kill() is so that any new mapping attempts that are racing
the removal will be blocked.

The receiver of that notification needs to go from a block_device to a
superblock that has mapped inodes and walk ->sb_inodes triggering the
unmap/invalidation.
