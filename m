Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43560 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbeJZBQk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Oct 2018 21:16:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id y22-v6so2235057lji.10
        for <linux-xfs@vger.kernel.org>; Thu, 25 Oct 2018 09:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20181011194424.20306-1-stefanrin@gmail.com> <20181011194424.20306-3-stefanrin@gmail.com>
 <20181023154922.GC28243@magnolia>
In-Reply-To: <20181023154922.GC28243@magnolia>
From: Stefan Ring <stefanrin@gmail.com>
Date: Thu, 25 Oct 2018 18:42:58 +0200
Message-ID: <CAAxjCEwVtScDqNLa=06TA-iXnoe97kfMR=DHFqo_F-Qo1ip_6g@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs_metadump: Zap more stale data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
> > @@ -1421,12 +1421,49 @@ process_sf_attr(
> >               memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
> >  }
> >
> > +static void
> > +process_dir_free_block(
>
> I think patch 1 references this function in patch 2?

If this is the case, oops. I thought about this while preparing the
diffs but forgot about it again...

I should find some time this weekend for another round of polishing
these patches.
