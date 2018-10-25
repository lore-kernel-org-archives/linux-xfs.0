Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbeJYX2N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Oct 2018 19:28:13 -0400
Date: Thu, 25 Oct 2018 10:55:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Message-ID: <20181025145501.GB2819@bfoster>
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster>
 <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
 <CAGiyNfBMjQPD0bxqHNMeUVZzr_uVdqRqMZpDOkVUEnenEobxNQ@mail.gmail.com>
 <20181024121112.GB46681@bfoster>
 <CAGiyNfC7H6nRXFyNZ-wQDBGecePtcciFh7_v2gi+jtrST9Q-mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGiyNfC7H6nRXFyNZ-wQDBGecePtcciFh7_v2gi+jtrST9Q-mw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mao Cheng <chengmao2010@gmail.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Oct 25, 2018 at 12:01:06PM +0800, Mao Cheng wrote:
> Brian Foster <bfoster@redhat.com> 于2018年10月24日周三 下午8:11写道：
> >
> > On Wed, Oct 24, 2018 at 05:02:11PM +0800, Mao Cheng wrote:
> > > Hi,
> > > Dave Chinner <david@fromorbit.com> 于2018年10月24日周三 下午12:34写道：
> > > >
> > > > On Wed, Oct 24, 2018 at 11:01:13AM +0800, Mao Cheng wrote:
> > > > > Hi Brian,
> > > > > Thanks for your response.
> > > > > Brian Foster <bfoster@redhat.com> 于2018年10月23日周二 下午10:53写道：
> > > > > >
> > > > > > On Tue, Oct 23, 2018 at 03:56:51PM +0800, Mao Cheng wrote:
> > > > > > > Sorry for trouble again. I just wrote wrong function name in previous
> > > > > > > sending, so resend it.
> > > > > > > If you have received previous email please ignore it, thanks
> > > > > > >
> > > > > > > we have a XFS mkfs with "-k" and mount with the default options(
> > > > > > > rw,relatime,attr2,inode64,noquota), the size is about 2.2TB，and
> > > > > > > exported via samba.
> > > > > > >
> > > > > > > [root@test1 home]# xfs_info /dev/sdk
> > > > > > > meta-data=/dev/sdk               isize=512    agcount=4, agsize=131072000 blks
> > > > > > >          =                       sectsz=4096  attr=2, projid32bit=1
> > > > > > >          =                       crc=1        finobt=0 spinodes=0
> > > > > > > data     =                       bsize=4096   blocks=524288000, imaxpct=5
> > > > > > >          =                       sunit=0      swidth=0 blks
> > > > > > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > > > > > log      =internal               bsize=4096   blocks=256000, version=2
> > > > > > >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > > > > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > > > > >
> > > > > > > free space about allocation groups:
> > > > > > >    from      to extents  blocks    pct
> > > > > > >       1       1       9       9   0.00
> > > > > > >       2       3   14291   29124   0.19
> > > > > > >       4       7    5689   22981   0.15
> > > > > > >       8      15     119    1422   0.01
> > > > > > >      16      31  754657 15093035  99.65
> > > >
> > > > 750,000 fragmented free extents means something like 1600 btree
> > > > leaf blocks to hold them all.....
> > > >
> > > > > > xfs_alloc_ag_vextent_near() is one of the several block allocation
> > > > > > algorithms in XFS. That function itself includes a couple different
> > > > > > algorithms for the "near" allocation based on the state of the AG. One
> > > > > > looks like an intra-block search of the by-size free space btree (if not
> > > > > > many suitably sized extents are available) and the second looks like an
> > > > > > outward sweep of the by-block free space btree to find a suitably sized
> > > > > > extent.
> > > >
> > > > Yup, just like the free inode allocation search, which is capped
> > > > at about 10 btree blocks left and right to prevent searching the
> > > > entire tree for the one free inode that remains in it.
> > > >
> > > > The problem here is that the first algorithm fails immediately
> > > > because there isn't a contiguous free space large enough for the
> > > > allocation being requested, and so it finds the largest block whose
> > > > /location/ is less than target block as the start point for the
> > > > nearest largest freespace.
> > > >
> > > > IOW, we do an expanding radius size search based on physical
> > > > locality rather than finding a free space based on size. Once we
> > > > find a good extent to either the left or right, we then stop that
> > > > search and try to find a better extent to the other direction
> > > > (xfs_alloc_find_best_extent()). That search is not bound, so can
> > > > search the entire of the tree in that remaining directory without
> > > > finding a better match.
> > > >
> > > > We can't cut the initial left/right search shorter - we've got to
> > > > find a large enough free extent to succeed, but we can chop
> > > > xfs_alloc_find_best_extent() short, similar to searchdistance in
> > > > xfs_dialloc_ag_inobt(). The patch below does that.
> > > >
> > > > Really, though, I think what we need to a better size based search
> > > > before falling back to a locality based search. This is more
> > > > complex, so not a few minutes work and requires a lot more thought
> > > > and testing.
> > > >
> > > > > We share an xfs filesystem to windows via SMB protocol.
> > > > > There are about 5 windows copy small files to the samba share at the same time.
> > > > > The main problem is the throughput degraded from 30MB/s to around
> > > > > 10KB/s periodically and recovered about 5s later.
> > > > > The kworker consumes 100% of one CPU when the throughput degraded and
> > > > > kworker task is wrteback.
> > > > > /proc/vmstat shows nr_dirty is very close to nr_dirty_threshold
> > > > > and nr_writeback is too small(is that means there too many dirty pages
> > > > > in page cache and can't be written out to disk?)
> > > >
> > > > incoming writes are throttled at the rate writeback makes progress,
> > > > hence the system will sit at the threshold. This is normal.
> > > > Writeback is just slow because of the freespace fragmentation in the
> > > > filesystem.
> > > Does running xfs_fsr periodically alleviate this problem?
> > > And is it advisable to run xfs_fsr regularly to reduce the
> > > fragmentation in xfs filesystems?
> > >
> >
> > I think xfs_fsr is more likely to contribute to this problem than
> > alleviate it. xfs_fsr defragments files whereas the problem here is
> > fragmentation of free space.
> >
> > Could you determine whether Dave's patch helps with performance at all?
> I will test the patch later.
> >
> > Also, would you be able to share a metadump of this filesystem?
> The metadump has been uploaded to google driver, and link as follows:
> https://drive.google.com/open?id=1RLekC-BnbAujXDl-xZ-vteMudrl2xC9D
> 

Thanks. xfs_alloc_ag_vextent_near() shows up as a hot path if I restore
this and throw an fs_mark small file workload at it. Some observations..

A trace of xfs_alloc_near* events over a 5 minute period shows a
breakdown like the following:

    513 xfs_alloc_near_first:
   8102 xfs_alloc_near_greater:
    180 xfs_alloc_near_lesser:

If I re-mkfs the restored image and run the same workload, I end up
with (to no real surprise):

  61561 xfs_alloc_near_first:

So clearly we are falling back to that second algorithm most of the
time. Most of these lesser/greater allocs have minlen == maxlen == 38
blocks and occur mostly split between AG 0 and AG 2. Looking at the
(initial) per-ag free space summary:

# for i in $(seq 0 3); do xfs_db -c "freesp -a $i" /mnt/img ; done
   from      to extents  blocks    pct
      1       1       9       9   0.00
      2       3   14243   28983   0.06
      4       7   10595   42615   0.09
      8      15     123    1468   0.00
     16      31  862232 17244531  37.66
     32      63  126968 7364144  16.08
     64     127       1      88   0.00
  16384   32767       1   30640   0.07
 131072  262143       1  131092   0.29
 524288 1048575       3 1835043   4.01
1048576 2097151       2 2883584   6.30
2097152 4194303       3 10456093  22.84
4194304 8388607       1 5767201  12.60
   from      to extents  blocks    pct
      1       1       8       8   0.00
      2       3    6557   13115   0.08
      4       7    7710   30844   0.18
      8      15      26     320   0.00
     16      31  393039 7859395  47.08
     32      63     250    9568   0.06
8388608 16777215       1 8780040  52.60
   from      to extents  blocks    pct
      1       1    2418    2418   0.01
      2       3    6126   16025   0.06
      4       7    1052    4263   0.02
      8      15      84     998   0.00
     16      31  873095 17461168  62.84
     32      63   35224 2042992   7.35
4194304 8388607       1 8259469  29.72
   from      to extents  blocks    pct
      1       1     258     258   0.00
      2       3    7951   16550   0.06
      4       7   10484   42007   0.14
      8      15      68     827   0.00
     16      31  864835 17296959  57.85
     32      63      58    2700   0.01
1048576 2097151       1 1310993   4.38
4194304 8388607       2 11228101  37.55

We can see that both AGs 0 and 2 have many likely >= 38 block extents,
but each also has a significant number of < 32 block extents. The first
bit can contribute to skipping the cntbt algorithm, the second bit
leaves a proverbial minefield of too small extents that the second
algorithm may have to sift through.

AGs 1 and 3 look like they have decent (< 32) fragmentation, but both at
least start with a much smaller number of 32+ block extents and thus
increased odds of finding an extent in the cntbt. That said, I'm not
seeing any (38 block, near) allocation requests in these AGs at all for
some reason. Perhaps my trace window was too small to catch any..

Brian

> Thanks,
> 
> Mao
> >
> > Brian
> >
> > > Regards,
> > >
> > > Mao.
> > > >
> > > > Cheers,
> > > >
> > > > Dave.
> > > > --
> > > > Dave Chinner
> > > > david@fromorbit.com
> > > >
> > > >
> > > > xfs: cap search distance in xfs_alloc_ag_vextent_near()
> > > >
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > Don't waste too much CPU time finding the perfect free extent when
> > > > we don't have a large enough contiguous free space and there are
> > > > many, many small free spaces that we'd do a linear search through.
> > > > Modelled on searchdistance in xfs_dialloc_ag_inobt() which solved
> > > > the same problem with the cost of finding the last free inodes in
> > > > the inode allocation btree.
> > > >
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_alloc.c | 13 ++++++++++---
> > > >  1 file changed, 10 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > index e1c0c0d2f1b0..c0c0a018e3bb 100644
> > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > @@ -886,8 +886,14 @@ xfs_alloc_ag_vextent_exact(
> > > >  }
> > > >
> > > >  /*
> > > > - * Search the btree in a given direction via the search cursor and compare
> > > > - * the records found against the good extent we've already found.
> > > > + * Search the btree in a given direction via the search cursor and compare the
> > > > + * records found against the good extent we've already found.
> > > > + *
> > > > + * We cap this search to a number of records to prevent searching hundreds of
> > > > + * thousands of records in a potentially futile search for a larger freespace
> > > > + * when free space is really badly fragmented. Spending more CPU time than the
> > > > + * IO cost of a sub-optimal allocation is a bad tradeoff - cap it at searching
> > > > + * a full btree block (~500 records on a 4k block size fs).
> > > >   */
> > > >  STATIC int
> > > >  xfs_alloc_find_best_extent(
> > > > @@ -906,6 +912,7 @@ xfs_alloc_find_best_extent(
> > > >         int                     error;
> > > >         int                     i;
> > > >         unsigned                busy_gen;
> > > > +       int                     searchdistance = args->mp->m_alloc_mxr[0];
> > > >
> > > >         /* The good extent is perfect, no need to  search. */
> > > >         if (!gdiff)
> > > > @@ -963,7 +970,7 @@ xfs_alloc_find_best_extent(
> > > >                         error = xfs_btree_decrement(*scur, 0, &i);
> > > >                 if (error)
> > > >                         goto error0;
> > > > -       } while (i);
> > > > +       } while (i && searchdistance-- > 0);
> > > >
> > > >  out_use_good:
> > > >         xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
