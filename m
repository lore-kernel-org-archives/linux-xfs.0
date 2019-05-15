Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40827 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfEOQrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 12:47:25 -0400
Received: by mail-lj1-f194.google.com with SMTP id d15so399615ljc.7
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 09:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190514185026.73788-1-jorgeguerra@gmail.com> <20190514233119.GS29573@dread.disaster.area>
 <CAEFkGAxFuh5qLrfSTreVLHGaaP9VtxTbfeePEwq2iqm0OLamxA@mail.gmail.com> <731994db-9f24-a3a8-02a9-eb92535b93f5@sandeen.net>
In-Reply-To: <731994db-9f24-a3a8-02a9-eb92535b93f5@sandeen.net>
From: Jorge Guerra <jorge.guerra@gmail.com>
Date: Wed, 15 May 2019 09:47:11 -0700
Message-ID: <CAEFkGAwdx6DC1YS_NaChYqz0Zp1+GxtrgpcQ262eLgYfX5U35w@mail.gmail.com>
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

On Wed, May 15, 2019 at 9:24 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> >> For example, xfs_db is not the right tool for probing online, active
> >> filesystems. It is not coherent with the active kernel filesystem,
> >> and is quite capable of walking off into la-la land as a result of
> >> mis-parsing the inconsistent filesystem that is on disk underneath
> >> active mounted filesystems. This does not make for a robust, usable
> >> tool, let alone one that can make use of things like rmap for
> >> querying usage and ownership information really quickly.
> >
> > I see your point, that the FS is constantly changing and that we might
> > see an inconsistent view.  But if we are generating bucketed
> > histograms we are anyways approximating the stats.
>
> I think that Dave's "inconsistency" concern is literal - if the on-disk
> metadata is not consistent, you may wander into what looks like corruption
> if you try to traverse every inode while mounted.
>
> It's pretty much never valid for userspace to try to traverse or read
> the filesystem while mounted.

Sure, I understand this point.  Then can we:

1) Abort scan if the we detect "corrupt" metadata, the user would then
either restart the scan or decide not to.
2) Have a mechanism which detects if the FS changed will scan was in
progress and tell the user the results might be stale?

>
> >> To solve this problem, we now have the xfs_spaceman tool and the
> >> GETFSMAP ioctl for running usage queries on mounted filesystems.
> >> That avoids all the coherency and crash problems, and for rmap
> >> enabled filesystems it does not require scanning the entire
> >> filesystem to work out this information (i.e. it can all be derived
> >> from the contents of the rmap tree).
> >>
> >> So I'd much prefer that new online filesystem queries go into
> >> xfs-spaceman and use GETFSMAP so they can be accelerated on rmap
> >> configured filesystems rather than hoping xfs_db will parse the
> >> entire mounted filesystem correctly while it is being actively
> >> changed...
> >
> > Good to know, I wasn't aware of this tool.  However I seems like I
> > don't have that ioctl in my systems yet :(
>
> It was added in 2017, in kernel-4.12 I believe.
> What kernel did you test?

Yeap, that's it we tested in 4.11.


-- 
Jorge E Guerra D
