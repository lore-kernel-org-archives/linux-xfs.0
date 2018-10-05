Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbeJFD6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 23:58:04 -0400
Date: Fri, 5 Oct 2018 13:57:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/1] xfs_metadump: Zap more stale data
Message-ID: <20181005205733.GC19324@magnolia>
References: <20181004205749.2042-1-stefanrin@gmail.com>
 <20181004205749.2042-2-stefanrin@gmail.com>
 <20181004222309.GL19324@magnolia>
 <CAAxjCExSQ7Ex8U5k9_Com_89YDFGB-DE2FNGoEvO_MwFEMB_MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAxjCExSQ7Ex8U5k9_Com_89YDFGB-DE2FNGoEvO_MwFEMB_MQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 10:46:28PM +0200, Stefan Ring wrote:
> On Fri, Oct 5, 2018 at 12:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Thu, Oct 04, 2018 at 10:57:49PM +0200, Stefan Ring wrote:
> > > I have empirically found and tried to fix some places where stale data was not properly zeroed out.
> > >
> > > In the order of the code changes:
> > >
> > > The "freeindex" blocks in inode directories, from last entry to end of block.
> > >
> > > XFS_DIR2_LEAF1_MAGIC, from last entry to end of block.
> > >
> > > In btree format inodes before as well as after the btree pointers.
> > >
> > > In dev inodes, everything after the header.
> >
> > Mostly looks ok, but with some style issues:
> >
> > > ---
> > >  db/metadump.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 69 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/db/metadump.c b/db/metadump.c
> > > index cc2ae9af..e7159cd1 100644
> > > --- a/db/metadump.c
> > > +++ b/db/metadump.c
> > > @@ -1421,12 +1421,42 @@ process_sf_attr(
> > >               memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
> > >  }
> > >
> > > +static void
> > > +process_dir_free_block(
> > > +     char                            *block)
> > > +{
> > > +     struct xfs_dir2_free            *free;
> > > +     struct xfs_dir3_icfree_hdr      freehdr;
> > > +
> > > +     if (!zero_stale_data)
> > > +             return;
> > > +
> > > +     free = (struct xfs_dir2_free *)block;
> > > +     M_DIROPS(mp)->free_hdr_from_disk(&freehdr, free);
> > > +
> > > +     /* Zero out space from end of bests[] to end of block */
> > > +     if (freehdr.magic == XFS_DIR2_FREE_MAGIC) {
> >
> > How about XFS_DIR3_FREE_MAGIC ?
> 
> Is there any documentation on DIR3? I left it out on purpose and hoped
> someone would fill in the blanks for me ;).

Fairly similar to DIR2, but with bigger headers, I think.

https://djwong.org/docs/kdoc/filesystems/xfs-data-structures/dynamic.html#leaf-directories

--D
