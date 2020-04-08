Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20145C2BA80
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 21:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA12A20771
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 21:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="pI/Ke2eb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgDHV2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 17:28:46 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41964 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbgDHV2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 17:28:45 -0400
Received: by mail-ed1-f68.google.com with SMTP id v1so10606477edq.8
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2020 14:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gsc90LPV5vuebvWSwowSniEuuhSDnHS3fNotzCrMHhI=;
        b=pI/Ke2eb3jkjDRXlYPpj3VkVyEJR335iPpo7DsBKOj3g+DjMNeZJvrbuvyfq267OUD
         4I7dyDJsclQ5Slr540XjTRPHixi7zmEpnJbFNdrNPHGDhdR50DfloDptknHgyMIdpzbg
         +WLguh/vuRJiMIUGJsbXd21ZCz0w3EwbKD2oPW2TCb/WITmelq+YNrw74a1YeDapL9IM
         0UVEJDV/xqFxic1LVguPMWHIax948Z3G5lH3pCNHB7nyS8N+6MiW7SNMEuDx41bQqr/o
         XwWla1TJ1Cpdx1w3dRFYLcVNTKUZee16zXqvVoociuElI8kaSzpd8d2REh/aJHXedYW1
         1U7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gsc90LPV5vuebvWSwowSniEuuhSDnHS3fNotzCrMHhI=;
        b=puJff1Cvss6GtpBRzjDrlv3wN18B5HixfD1O4tRxIR5TR0iN23K73HXCVDQePC2goA
         mCGEhIuNwIm0FYHGZkbfoWMjbE9Sjwqy/9c5K8mceLRK0/Qi+/xMD+bNyZ19X1WLDf7j
         AtKQEoDq2XDvpx+Szy2HxIny9MlQ6K/1wvkliklJQp1k+dYfuonIPsAQ7DQkP6iV61ND
         BY6+jS9zMl/2BKM3vbOuQ1iX3n30INm9T5zlEca0EfBZqKteWa/xV2j0a0Yx0KN6KzNi
         0LTrqAe9LZJq+10Nhdx3ps/Vc2Q0Gkw6qLZ5wEpDMi53rkI96pct5hfuz+oX//XoVPD0
         ZJFw==
X-Gm-Message-State: AGi0Puaqt2EZEru8BvE1yyxDmyMooASutvmbT9vwozg2ntd2D6vc9qId
        JlfUVbQOi9aX6ck1VidH+HbNh/+001AUJDmRx6dbj1qR55o=
X-Google-Smtp-Source: APiQypJk5ijyBzx01h6/nF0/FztOREeQcwbT2SBq1CK12n6G3N8IiyFCzIyOVWUiYtoBKEH4Kr8GDj8vGyt7ncuxacA=
X-Received: by 2002:a17:907:1185:: with SMTP id uz5mr4432200ejb.335.1586381321924;
 Wed, 08 Apr 2020 14:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200407182958.568475-1-ira.weiny@intel.com> <20200407182958.568475-7-ira.weiny@intel.com>
 <20200408020827.GI24067@dread.disaster.area> <20200408170923.GC569068@iweiny-DESK2.sc.intel.com>
 <20200408210236.GK24067@dread.disaster.area>
In-Reply-To: <20200408210236.GK24067@dread.disaster.area>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 8 Apr 2020 14:28:30 -0700
Message-ID: <CAPcyv4gLvMSA9BypvWbYtv3xsK8o4+db3kvxBozUGAjr_sDDFQ@mail.gmail.com>
Subject: Re: [PATCH V6 6/8] fs/xfs: Combine xfs_diflags_to_linux() and xfs_diflags_to_iflags()
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 8, 2020 at 2:02 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Apr 08, 2020 at 10:09:23AM -0700, Ira Weiny wrote:
> > On Wed, Apr 08, 2020 at 12:08:27PM +1000, Dave Chinner wrote:
> > > On Tue, Apr 07, 2020 at 11:29:56AM -0700, ira.weiny@intel.com wrote:
> > > > From: Ira Weiny <ira.weiny@intel.com>
> >
> > [snip]
> >
> > > >
> > > > -STATIC void
> > > > -xfs_diflags_to_linux(
> > > > - struct xfs_inode        *ip)
> > > > -{
> > > > - struct inode            *inode = VFS_I(ip);
> > > > - unsigned int            xflags = xfs_ip2xflags(ip);
> > > > -
> > > > - if (xflags & FS_XFLAG_IMMUTABLE)
> > > > -         inode->i_flags |= S_IMMUTABLE;
> > > > - else
> > > > -         inode->i_flags &= ~S_IMMUTABLE;
> > > > - if (xflags & FS_XFLAG_APPEND)
> > > > -         inode->i_flags |= S_APPEND;
> > > > - else
> > > > -         inode->i_flags &= ~S_APPEND;
> > > > - if (xflags & FS_XFLAG_SYNC)
> > > > -         inode->i_flags |= S_SYNC;
> > > > - else
> > > > -         inode->i_flags &= ~S_SYNC;
> > > > - if (xflags & FS_XFLAG_NOATIME)
> > > > -         inode->i_flags |= S_NOATIME;
> > > > - else
> > > > -         inode->i_flags &= ~S_NOATIME;
> > > > -#if 0    /* disabled until the flag switching races are sorted out */
> > > > - if (xflags & FS_XFLAG_DAX)
> > > > -         inode->i_flags |= S_DAX;
> > > > - else
> > > > -         inode->i_flags &= ~S_DAX;
> > > > -#endif
> > >
> > > So this variant will set the flag in the inode if the disk inode
> > > flag is set, otherwise it will clear it.  It does it with if/else
> > > branches.
> > >
> > >
> > > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > > index e07f7b641226..a4ac8568c8c7 100644
> > > > --- a/fs/xfs/xfs_iops.c
> > > > +++ b/fs/xfs/xfs_iops.c
> > > > @@ -1259,7 +1259,7 @@ xfs_inode_supports_dax(
> > > >   return xfs_inode_buftarg(ip)->bt_daxdev != NULL;
> > > >  }
> > > >
> > > > -STATIC bool
> > > > +static bool
> > > >  xfs_inode_enable_dax(
> > > >   struct xfs_inode *ip)
> > > >  {
> > >
> > > This belongs in the previous patch.
> >
> > Ah yea...  Sorry.
> >
> > Fixed in V7
> >
> > >
> > > > @@ -1272,26 +1272,38 @@ xfs_inode_enable_dax(
> > > >   return false;
> > > >  }
> > > >
> > > > -STATIC void
> > > > +void
> > > >  xfs_diflags_to_iflags(
> > > > - struct inode            *inode,
> > > > - struct xfs_inode        *ip)
> > > > + struct xfs_inode        *ip,
> > > > + bool init)
> > > >  {
> > > > - uint16_t                flags = ip->i_d.di_flags;
> > > > -
> > > > - inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC |
> > > > -                     S_NOATIME | S_DAX);
> > >
> > > And this code cleared all the flags in the inode first, then
> > > set them if the disk inode flag is set. This does not require
> > > branches, resulting in more readable code and better code
> > > generation.
> > >
> > > > + struct inode            *inode = VFS_I(ip);
> > > > + uint                    diflags = xfs_ip2xflags(ip);
> > > >
> > > > - if (flags & XFS_DIFLAG_IMMUTABLE)
> > > > + if (diflags & FS_XFLAG_IMMUTABLE)
> > > >           inode->i_flags |= S_IMMUTABLE;
> > > > - if (flags & XFS_DIFLAG_APPEND)
> > > > + else
> > > > +         inode->i_flags &= ~S_IMMUTABLE;
> > >
> > > > + if (diflags & FS_XFLAG_APPEND)
> > > >           inode->i_flags |= S_APPEND;
> > > > - if (flags & XFS_DIFLAG_SYNC)
> > > > + else
> > > > +         inode->i_flags &= ~S_APPEND;
> > > > + if (diflags & FS_XFLAG_SYNC)
> > > >           inode->i_flags |= S_SYNC;
> > > > - if (flags & XFS_DIFLAG_NOATIME)
> > > > + else
> > > > +         inode->i_flags &= ~S_SYNC;
> > > > + if (diflags & FS_XFLAG_NOATIME)
> > > >           inode->i_flags |= S_NOATIME;
> > > > - if (xfs_inode_enable_dax(ip))
> > > > -         inode->i_flags |= S_DAX;
> > > > + else
> > > > +         inode->i_flags &= ~S_NOATIME;
> > > > +
> > > > + /* Only toggle the dax flag when initializing */
> > > > + if (init) {
> > > > +         if (xfs_inode_enable_dax(ip))
> > > > +                 inode->i_flags |= S_DAX;
> > > > +         else
> > > > +                 inode->i_flags &= ~S_DAX;
> > > > + }
> > > >  }
> > >
> > > IOWs, this:
> > >
> > >         struct inode            *inode = VFS_I(ip);
> > >         unsigned int            xflags = xfs_ip2xflags(ip);
> > >         unsigned int            flags = 0;
> > >
> > >         if (xflags & FS_XFLAG_IMMUTABLE)
> > >                 flags |= S_IMMUTABLE;
> > >         if (xflags & FS_XFLAG_APPEND)
> > >                 flags |= S_APPEND;
> > >         if (xflags & FS_XFLAG_SYNC)
> > >                 flags |= S_SYNC;
> > >         if (xflags & FS_XFLAG_NOATIME)
> > >                 flags |= S_NOATIME;
> > >     if ((xflags & FS_XFLAG_DAX) && init)
> > >             flags |= S_DAX;
> > >
> > >         inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC | S_NOATIME);
> > >         inode->i_flags |= flags;
> > >
> > > ends up being much easier to read and results in better code
> > > generation. And we don't need to clear the S_DAX flag when "init" is
> > > set, because we are starting from an inode that has no flags set
> > > (because init!)...
> >
> > This sounds good but I think we need a slight modification to make the function equivalent in functionality.
> >
> > void
> > xfs_diflags_to_iflags(
> >         struct xfs_inode        *ip,
> >         bool init)
> > {
> >         struct inode            *inode = VFS_I(ip);
> >         unsigned int            xflags = xfs_ip2xflags(ip);
> >         unsigned int            flags = 0;
> >
> >         inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC | S_NOATIME |
> >                             S_DAX);
>
> We don't want to clear the dax flag here, ever, if it is already
> set. That is an externally visible change and opens us up (again) to
> races where IS_DAX() changes half way through a fault path. IOWs, avoiding
> clearing the DAX flag was something I did explicitly in the above
> code fragment.
>
> And it makes the logic clearer by pre-calculating the new flags,
> then clearing and setting the inode flags together, rather than
> having the spearated at the top and bottom of the function.
>
> THis leads to an obvious conclusion: if we never clear the in memory
> S_DAX flag, we can actually clear the on-disk flag safely, so that
> next time the inode cycles into memory it won't be using DAX. IOWs,
> admins can stop the applications, clear the DAX flag and drop
> caches. This should result in the inode being recycled and when the
> app is restarted it will run without DAX. No ned for deleting files,
> copying large data sets, etc just to turn off an inode flag.

Makes sense, but is that sufficient? I recall you saying there might
be a multitude of other reasons that the inode is not evicted, not the
least of which is races [1]. Does this need another flag, lets call it
"dax toggle" to track the "I requested the inode to clear the flag,
but on cache-flush + restart the inode never got evicted" case. S_DAX
almost plays this role, but it loses the ability to audit which files
are pending an inode eviction event. So the dax-toggle flag indicates
to the kernel to xor the toggle value with the inode flag on inode
instantiation and the dax inode flag is never directly manipulated by
the ioctl path.

[1]: http://lore.kernel.org/r/20191025003603.GE4614@dread.disaster.area
