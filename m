Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46353 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbeJZOIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 10:08:22 -0400
Received: by mail-lj1-f196.google.com with SMTP id x3-v6so10344649lji.13
        for <linux-xfs@vger.kernel.org>; Thu, 25 Oct 2018 22:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20181011194424.20306-1-stefanrin@gmail.com> <20181011194424.20306-3-stefanrin@gmail.com>
 <20181023154922.GC28243@magnolia>
In-Reply-To: <20181023154922.GC28243@magnolia>
From: Stefan Ring <stefanrin@gmail.com>
Date: Fri, 26 Oct 2018 07:32:35 +0200
Message-ID: <CAAxjCEw5GTy+aK2e13ZeofJARA9OaLMYO-Etmo=DRA-MfVSQAw@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs_metadump: Zap more stale data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 23, 2018 at 5:49 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Thu, Oct 11, 2018 at 09:44:24PM +0200, Stefan Ring wrote:
> > I have empirically found and tried to fix some places where stale data was not
> > properly zeroed out.
> >
> > In the order of the code changes:
> >
> > - The "freeindex" blocks in inode directories, from last entry to end of block.
> > - XFS_DIR{2,3}_LEAFN_MAGIC, from last entry to end of block.
> > - In btree format inodes before as well as after the btree pointers.
> > - In dev inodes, everything after the header.
> > ---
> >  db/metadump.c | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 98 insertions(+), 8 deletions(-)
> >
> > diff --git a/db/metadump.c b/db/metadump.c
> > index ff96860d..c8213d41 100644
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -2118,6 +2173,21 @@ process_btinode(
> >       }
> >
> >       pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
> > +
> > +     if (zero_stale_data) {
> > +             char    *top;
> > +             int     used;
> > +
> > +             /* Space before btree pointers */
> > +             top = (char*)XFS_BMDR_PTR_ADDR(dib, 1, nrecs);
> > +             memset(top, 0, (char*)pp - top);
> > +
> > +             /* Space after btree pointers */
> > +             top = (char*)&pp[nrecs];
> > +             used = top - (char*)dip;
> > +             memset(top, 0, mp->m_sb.sb_inodesize - used);
>
> Er... this zaps everything past the end of the bmbt pointers, which
> means that this can zero the attr fork root.

True, this is broken. I'll play around a little more with this one.
