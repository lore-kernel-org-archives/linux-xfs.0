Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35306 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbeJFDrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 23:47:06 -0400
Received: by mail-lf1-f65.google.com with SMTP id r191-v6so10266075lff.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Oct 2018 13:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20181004205749.2042-1-stefanrin@gmail.com> <20181004205749.2042-2-stefanrin@gmail.com>
 <20181004222309.GL19324@magnolia>
In-Reply-To: <20181004222309.GL19324@magnolia>
From: Stefan Ring <stefanrin@gmail.com>
Date: Fri, 5 Oct 2018 22:46:28 +0200
Message-ID: <CAAxjCExSQ7Ex8U5k9_Com_89YDFGB-DE2FNGoEvO_MwFEMB_MQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs_metadump: Zap more stale data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 5, 2018 at 12:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Thu, Oct 04, 2018 at 10:57:49PM +0200, Stefan Ring wrote:
> > I have empirically found and tried to fix some places where stale data was not properly zeroed out.
> >
> > In the order of the code changes:
> >
> > The "freeindex" blocks in inode directories, from last entry to end of block.
> >
> > XFS_DIR2_LEAF1_MAGIC, from last entry to end of block.
> >
> > In btree format inodes before as well as after the btree pointers.
> >
> > In dev inodes, everything after the header.
>
> Mostly looks ok, but with some style issues:
>
> > ---
> >  db/metadump.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 69 insertions(+), 5 deletions(-)
> >
> > diff --git a/db/metadump.c b/db/metadump.c
> > index cc2ae9af..e7159cd1 100644
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -1421,12 +1421,42 @@ process_sf_attr(
> >               memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
> >  }
> >
> > +static void
> > +process_dir_free_block(
> > +     char                            *block)
> > +{
> > +     struct xfs_dir2_free            *free;
> > +     struct xfs_dir3_icfree_hdr      freehdr;
> > +
> > +     if (!zero_stale_data)
> > +             return;
> > +
> > +     free = (struct xfs_dir2_free *)block;
> > +     M_DIROPS(mp)->free_hdr_from_disk(&freehdr, free);
> > +
> > +     /* Zero out space from end of bests[] to end of block */
> > +     if (freehdr.magic == XFS_DIR2_FREE_MAGIC) {
>
> How about XFS_DIR3_FREE_MAGIC ?

Is there any documentation on DIR3? I left it out on purpose and hoped
someone would fill in the blanks for me ;).
