Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:37980 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbeJEBvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 21:51:00 -0400
Received: by mail-io1-f68.google.com with SMTP id e2-v6so7085590ioh.5
        for <linux-xfs@vger.kernel.org>; Thu, 04 Oct 2018 11:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <20181004175839.18736-1-idryomov@gmail.com> <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
In-Reply-To: <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 4 Oct 2018 20:56:14 +0200
Message-ID: <CAOi1vP9VCYoiW7igCGnJYQY9s=iNadsx5dcrL=RqDgeiZAnyzw@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>

On Thu, Oct 4, 2018 at 8:33 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 10/4/18 12:58 PM, Ilya Dryomov wrote:
> > rbd devices report the following geometry:
> >
> >   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
> >   512
> >   512
> >   4194304
> >   4194304
> >
> > (4M is unnecessarily high and will probably be made configurable and
> > changed to 64K in the future.  By default, the new bluestore backend
> > does double-write for I/Os smaller than 64K.)
> >
> > If pbsz != iomin, mkfs.xfs goes into multidisk mode and, under the
> > assumption that larger multidisk filesystems will have more devices,
> > chooses a higher agcount.  Though rbd devices are indeed backed by
> > multiple OSD devices, it appears that high agcount actually degrades
> > the performance with multiple rbd devices on the same host.
> >
> > Commit 9a106b5fbb88 ("mkfs.xfs: Don't stagger AG for a single disk")
> > has set a precedent for treating sunit == swidth specially.  Take it
> > one step further.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  mkfs/xfs_mkfs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 2e53c1e83b6a..c3efa30005a2 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2650,8 +2650,8 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
> >                               (cfg->dblocks % cfg->agcount != 0);
> >       } else {
> >               calc_default_ag_geometry(cfg->blocklog, cfg->dblocks,
> > -                                      cfg->dsunit, &cfg->agsize,
> > -                                      &cfg->agcount);
> > +                                      cfg->dsunit != cfg->dswidth,
> > +                                      &cfg->agsize, &cfg->agcount);
> >       }
> >  }
>
> I think this makes reasonable sense - it's tough to argue that storage is
> advertising parallelism (multidisk) if swidth == sunit, IMHO.  I'd be curious
> to know what others think though, and I may go back and review the definitions
> of what these values actually mean and how we choose to interpret them :)
>
> TBH though if the functionality is OK (and I think it is) I'd rather pass
> dsunit and dswidth both to the function, and let /it/ make the determination
> about multidisk as opposed to leaving  that up to the callers.  Seems like
> I had some other reason to do that as well, though I'm not remembering it
> right now ...

Yeah, there is another slightly inconsistent caller in repair/sb.c
(although "dsunit" and "dswidth | dsunit" are probably always the same
in practice, given the checks in xfs_mkfs.c).  This is more of an RFC,
I'll make the change in v2.

Thanks,

                Ilya
