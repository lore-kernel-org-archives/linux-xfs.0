Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f181.google.com ([209.85.166.181]:35350 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbeJXR3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Oct 2018 13:29:39 -0400
Received: by mail-it1-f181.google.com with SMTP id p64-v6so5641743itp.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 Oct 2018 02:02:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster> <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
In-Reply-To: <20181024043416.GA19305@dastard>
From: Mao Cheng <chengmao2010@gmail.com>
Date: Wed, 24 Oct 2018 17:02:11 +0800
Message-ID: <CAGiyNfBMjQPD0bxqHNMeUVZzr_uVdqRqMZpDOkVUEnenEobxNQ@mail.gmail.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org

Hi,
Dave Chinner <david@fromorbit.com> =E4=BA=8E2018=E5=B9=B410=E6=9C=8824=E6=
=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8812:34=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Oct 24, 2018 at 11:01:13AM +0800, Mao Cheng wrote:
> > Hi Brian,
> > Thanks for your response.
> > Brian Foster <bfoster@redhat.com> =E4=BA=8E2018=E5=B9=B410=E6=9C=8823=
=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8810:53=E5=86=99=E9=81=93=EF=BC=
=9A
> > >
> > > On Tue, Oct 23, 2018 at 03:56:51PM +0800, Mao Cheng wrote:
> > > > Sorry for trouble again. I just wrote wrong function name in previo=
us
> > > > sending, so resend it.
> > > > If you have received previous email please ignore it, thanks
> > > >
> > > > we have a XFS mkfs with "-k" and mount with the default options(
> > > > rw,relatime,attr2,inode64,noquota), the size is about 2.2TB=EF=BC=
=8Cand
> > > > exported via samba.
> > > >
> > > > [root@test1 home]# xfs_info /dev/sdk
> > > > meta-data=3D/dev/sdk               isize=3D512    agcount=3D4, agsi=
ze=3D131072000 blks
> > > >          =3D                       sectsz=3D4096  attr=3D2, projid3=
2bit=3D1
> > > >          =3D                       crc=3D1        finobt=3D0 spinod=
es=3D0
> > > > data     =3D                       bsize=3D4096   blocks=3D52428800=
0, imaxpct=3D5
> > > >          =3D                       sunit=3D0      swidth=3D0 blks
> > > > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftyp=
e=3D1
> > > > log      =3Dinternal               bsize=3D4096   blocks=3D256000, =
version=3D2
> > > >          =3D                       sectsz=3D4096  sunit=3D1 blks, l=
azy-count=3D1
> > > > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtext=
ents=3D0
> > > >
> > > > free space about allocation groups:
> > > >    from      to extents  blocks    pct
> > > >       1       1       9       9   0.00
> > > >       2       3   14291   29124   0.19
> > > >       4       7    5689   22981   0.15
> > > >       8      15     119    1422   0.01
> > > >      16      31  754657 15093035  99.65
>
> 750,000 fragmented free extents means something like 1600 btree
> leaf blocks to hold them all.....
>
> > > xfs_alloc_ag_vextent_near() is one of the several block allocation
> > > algorithms in XFS. That function itself includes a couple different
> > > algorithms for the "near" allocation based on the state of the AG. On=
e
> > > looks like an intra-block search of the by-size free space btree (if =
not
> > > many suitably sized extents are available) and the second looks like =
an
> > > outward sweep of the by-block free space btree to find a suitably siz=
ed
> > > extent.
>
> Yup, just like the free inode allocation search, which is capped
> at about 10 btree blocks left and right to prevent searching the
> entire tree for the one free inode that remains in it.
>
> The problem here is that the first algorithm fails immediately
> because there isn't a contiguous free space large enough for the
> allocation being requested, and so it finds the largest block whose
> /location/ is less than target block as the start point for the
> nearest largest freespace.
>
> IOW, we do an expanding radius size search based on physical
> locality rather than finding a free space based on size. Once we
> find a good extent to either the left or right, we then stop that
> search and try to find a better extent to the other direction
> (xfs_alloc_find_best_extent()). That search is not bound, so can
> search the entire of the tree in that remaining directory without
> finding a better match.
>
> We can't cut the initial left/right search shorter - we've got to
> find a large enough free extent to succeed, but we can chop
> xfs_alloc_find_best_extent() short, similar to searchdistance in
> xfs_dialloc_ag_inobt(). The patch below does that.
>
> Really, though, I think what we need to a better size based search
> before falling back to a locality based search. This is more
> complex, so not a few minutes work and requires a lot more thought
> and testing.
>
> > We share an xfs filesystem to windows via SMB protocol.
> > There are about 5 windows copy small files to the samba share at the sa=
me time.
> > The main problem is the throughput degraded from 30MB/s to around
> > 10KB/s periodically and recovered about 5s later.
> > The kworker consumes 100% of one CPU when the throughput degraded and
> > kworker task is wrteback.
> > /proc/vmstat shows nr_dirty is very close to nr_dirty_threshold
> > and nr_writeback is too small(is that means there too many dirty pages
> > in page cache and can't be written out to disk?)
>
> incoming writes are throttled at the rate writeback makes progress,
> hence the system will sit at the threshold. This is normal.
> Writeback is just slow because of the freespace fragmentation in the
> filesystem.
Does running xfs_fsr periodically alleviate this problem?
And is it advisable to run xfs_fsr regularly to reduce the
fragmentation in xfs filesystems?

Regards,

Mao.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
>
> xfs: cap search distance in xfs_alloc_ag_vextent_near()
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Don't waste too much CPU time finding the perfect free extent when
> we don't have a large enough contiguous free space and there are
> many, many small free spaces that we'd do a linear search through.
> Modelled on searchdistance in xfs_dialloc_ag_inobt() which solved
> the same problem with the cost of finding the last free inodes in
> the inode allocation btree.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index e1c0c0d2f1b0..c0c0a018e3bb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -886,8 +886,14 @@ xfs_alloc_ag_vextent_exact(
>  }
>
>  /*
> - * Search the btree in a given direction via the search cursor and compa=
re
> - * the records found against the good extent we've already found.
> + * Search the btree in a given direction via the search cursor and compa=
re the
> + * records found against the good extent we've already found.
> + *
> + * We cap this search to a number of records to prevent searching hundre=
ds of
> + * thousands of records in a potentially futile search for a larger free=
space
> + * when free space is really badly fragmented. Spending more CPU time th=
an the
> + * IO cost of a sub-optimal allocation is a bad tradeoff - cap it at sea=
rching
> + * a full btree block (~500 records on a 4k block size fs).
>   */
>  STATIC int
>  xfs_alloc_find_best_extent(
> @@ -906,6 +912,7 @@ xfs_alloc_find_best_extent(
>         int                     error;
>         int                     i;
>         unsigned                busy_gen;
> +       int                     searchdistance =3D args->mp->m_alloc_mxr[=
0];
>
>         /* The good extent is perfect, no need to  search. */
>         if (!gdiff)
> @@ -963,7 +970,7 @@ xfs_alloc_find_best_extent(
>                         error =3D xfs_btree_decrement(*scur, 0, &i);
>                 if (error)
>                         goto error0;
> -       } while (i);
> +       } while (i && searchdistance-- > 0);
>
>  out_use_good:
>         xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
