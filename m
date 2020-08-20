Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,FROM_LOCAL_NOVOWEL,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4778C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 04:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DAE2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 04:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgHTErZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 00:47:25 -0400
Received: from smtp.netregistry.net ([202.124.241.204]:39834 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHTErY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 00:47:24 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2020 00:47:22 EDT
Received: from mail-ed1-f46.google.com ([209.85.208.46]:28634)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1k8cOw-0003Jf-5C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2020 14:42:13 +1000
Received: by mail-ed1-f46.google.com with SMTP id v22so615065edy.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 21:42:10 -0700 (PDT)
X-Gm-Message-State: AOAM530RW77w+TBSm4IcKT9qdYY6c4BOZJb0/APi48zhBCCrUfYchl/I
        5ewWJmoVd1gE8nlldjXfzovq7mlqLPMNxX0hFXk=
X-Google-Smtp-Source: ABdhPJwoEIRz5gQWmcRMfrpE3pfj+zFLnVFoVVPycnRuvMe9jjJdaXbXaF/csxiwDEhSX7ZaJUtv82WUR7AqGFzppFA=
X-Received: by 2002:a50:f687:: with SMTP id d7mr1216016edn.306.1597898528470;
 Wed, 19 Aug 2020 21:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia> <20200818233535.GD21744@dread.disaster.area>
 <20200819214322.GE6096@magnolia> <20200820000102.GF6096@magnolia>
In-Reply-To: <20200820000102.GF6096@magnolia>
From:   griffin tucker <xfssxsltislti2490@griffintucker.id.au>
Date:   Thu, 20 Aug 2020 14:42:29 +1000
X-Gmail-Original-Message-ID: <CAH3XsHH8i4GY7TcMvLPy6F1Gs-UMaR1Kcx5BJnt=XzR42t+EqA@mail.gmail.com>
Message-ID: <CAH3XsHH8i4GY7TcMvLPy6F1Gs-UMaR1Kcx5BJnt=XzR42t+EqA@mail.gmail.com>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038 problem
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Authenticated-User: xfssxsltislti2490@griffintucker.id.au
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

how difficult would it be to implement 128 bit timestamps? and how
much further in time beyond 2486 would this allow?

is the implementation of 128 bit timestamps just not feasible due to
64 bit alu width?

how long is it until hardware capability reaches beyond the 16exabyte limit?

On Thu, 20 Aug 2020 at 10:01, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Aug 19, 2020 at 02:43:22PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 19, 2020 at 09:35:35AM +1000, Dave Chinner wrote:
> > > On Mon, Aug 17, 2020 at 03:57:39PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > >
> > > > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > > > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > > > time epoch).  This enables us to handle dates up to 2486, which solves
> > > > the y2038 problem.
> > > >
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > .....
> > > > +/* Convert an ondisk timestamp into the 64-bit safe incore format. */
> > > >  void
> > > >  xfs_inode_from_disk_timestamp(
> > > > + struct xfs_dinode               *dip,
> > > >   struct timespec64               *tv,
> > > >   const union xfs_timestamp       *ts)
> > > >  {
> > > > + if (dip->di_version >= 3 &&
> > > > +     (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {
> > > > +         uint64_t                t = be64_to_cpu(ts->t_bigtime);
> > > > +         uint64_t                s;
> > > > +         uint32_t                n;
> > > > +
> > > > +         s = div_u64_rem(t, NSEC_PER_SEC, &n);
> > > > +         tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> > > > +         tv->tv_nsec = n;
> > > > +         return;
> > > > + }
> > > > +
> > > >   tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
> > > >   tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
> > > >  }
> > >
> > > Can't say I'm sold on this union. It seems cleaner to me to just
> > > make the timestamp an opaque 64 bit field on disk and convert it to
> > > the in-memory representation directly in the to/from disk
> > > operations. e.g.:
> > >
> > > void
> > > xfs_inode_from_disk_timestamp(
> > >     struct xfs_dinode               *dip,
> > >     struct timespec64               *tv,
> > >     __be64                          ts)
> > > {
> > >
> > >     uint64_t                t = be64_to_cpu(ts);
> > >     uint64_t                s;
> > >     uint32_t                n;
> > >
> > >     if (xfs_dinode_is_bigtime(dip)) {
> > >             s = div_u64_rem(t, NSEC_PER_SEC, &n) - XFS_INO_BIGTIME_EPOCH;
> > >     } else {
> > >             s = (int)(t >> 32);
> > >             n = (int)(t & 0xffffffff);
> > >     }
> > >     tv->tv_sec = s;
> > >     tv->tv_nsec = n;
> > > }
> >
> > I don't like this open-coded union approach at all because now I have to
> > keep the t_sec and t_nsec bits separate in my head instead of letting
> > the C compiler take care of that detail.  The sample code above doesn't
> > handle that correctly either:
> >
> > Start with an old kernel on a little endian system; each uppercase
> > letter represents a byte (A is the LSB of t_sec, D is the MSB of t_sec,
> > E is the LSB of t_nsec, and H is the MSB of t_nsec):
> >
> >       sec  nsec (incore)
> >       ABCD EFGH
> >
> > That gets written out as:
> >
> >       sec  nsec (ondisk)
> >       DCBA HGFE
> >
> > Now reboot with a new kernel that only knows 64bit timestamps on disk:
> >
> >       64bit (ondisk)
> >       DCBAHGFE
> >
> > Now it does the first be64_to_cpu conversion:
> >       64bit (incore)
> >       EFGHABCD
> >
> > And then masks and shifts:
> >       sec  nsec (incore)
> >       EFGH ABCD
> >
> > Oops, we just switched the values!
> >
> > The correct approach (I think) is to perform the shifting and masking on
> > the raw __be64 value before converting them to incore format via
> > be32_to_cpu, but now I have to work out all four cases by hand instead
> > of letting the compiler do the legwork for me.  I don't remember if it's
> > correct to go around shifting and masking __be64 values.
> >
> > I guess the good news is that at least we have generic/402 to catch
> > these kinds of persistence problems, but ugh.
> >
> > Anyway, what are you afraid of?  The C compiler smoking crack and not
> > actually overlapping the two union elements?  We could control for
> > that...
>
> (Following up on the mailing list with something I pasted into IRC)
>
> Ok, so I temporarily patched up my dev tree with this approximation of
> how that would work, properly done:
>
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index c59ddb56bb90..7c71e4440402 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -176,8 +176,8 @@ xfs_inode_from_disk_timestamp(
>                 return;
>         }
>
> -       tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
> -       tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
> +       tv->tv_sec = (time64_t)be32_to_cpu((__be32)(ts->t_bigtime >> 32));
> +       tv->tv_nsec = be32_to_cpu(ts->t_bigtime & 0xFFFFFFFFU);
>  }
>
>  int
> @@ -294,8 +294,8 @@ xfs_inode_to_disk_timestamp(
>                 return;
>         }
>
> -       ts->t_sec = cpu_to_be32(tv->tv_sec);
> -       ts->t_nsec = cpu_to_be32(tv->tv_nsec);
> +       ts->t_bigtime = (__be64)cpu_to_be32(tv->tv_sec) << 32 |
> +                       cpu_to_be32(tv->tv_nsec);
>  }
>
>  void
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index d44e8932979b..5d36d6dea326 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -308,8 +308,8 @@ xfs_log_dinode_to_disk_ts(
>                 return;
>         }
>
> -       ts->t_sec = cpu_to_be32(its->t_sec);
> -       ts->t_nsec = cpu_to_be32(its->t_nsec);
> +       ts->t_bigtime = (__be64)cpu_to_be32(its->t_sec) << 32 |
> +                       cpu_to_be32(its->t_nsec);
>  }
>
> And immediately got a ton of smatch warnings:
>
> xfs_inode_buf.c:179:32: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:179:32: warning: cast to restricted __be32
> xfs_inode_buf.c:179:32: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:179:32: warning: cast to restricted __be32
> xfs_inode_buf.c:179:32: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:179:32: warning: cast to restricted __be32
> xfs_inode_buf.c:179:32: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:179:32: warning: cast to restricted __be32
> xfs_inode_buf.c:179:32: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:179:32: warning: cast to restricted __be32
> xfs_inode_buf.c:179:32: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:179:32: warning: cast to restricted __be32
> xfs_inode_buf.c:180:23: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:180:23: warning: cast to restricted __be32
> xfs_inode_buf.c:180:23: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:180:23: warning: cast to restricted __be32
> xfs_inode_buf.c:180:23: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:180:23: warning: cast to restricted __be32
> xfs_inode_buf.c:180:23: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:180:23: warning: cast to restricted __be32
> xfs_inode_buf.c:180:23: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:180:23: warning: cast to restricted __be32
> xfs_inode_buf.c:180:23: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:180:23: warning: cast to restricted __be32
> xfs_inode_buf.c:297:26: warning: cast to restricted __be64
> xfs_inode_buf.c:297:26: warning: cast from restricted __be32
> xfs_inode_buf.c:297:26: warning: restricted __be64 degrades to integer
> xfs_inode_buf.c:298:25: warning: restricted __be32 degrades to integer
> xfs_inode_buf.c:297:23: warning: incorrect type in assignment (different base types)
> xfs_inode_buf.c:297:23:    expected restricted __be64 [usertype] t_bigtime
> xfs_inode_buf.c:297:23:    got unsigned long long
>
> (and even more in xfs_inode_item.c)
>
> So... while we could get rid of the union and hand-decode the timestamp
> from a __be64 on legacy filesystems, I see the static checker complaints
> as a second piece of evidence that this would be unnecessarily risky.
>
> --D
>
> > > > @@ -220,9 +234,9 @@ xfs_inode_from_disk(
> > > >    * a time before epoch is converted to a time long after epoch
> > > >    * on 64 bit systems.
> > > >    */
> > > > - xfs_inode_from_disk_timestamp(&inode->i_atime, &from->di_atime);
> > > > - xfs_inode_from_disk_timestamp(&inode->i_mtime, &from->di_mtime);
> > > > - xfs_inode_from_disk_timestamp(&inode->i_ctime, &from->di_ctime);
> > > > + xfs_inode_from_disk_timestamp(from, &inode->i_atime, &from->di_atime);
> > > > + xfs_inode_from_disk_timestamp(from, &inode->i_mtime, &from->di_mtime);
> > > > + xfs_inode_from_disk_timestamp(from, &inode->i_ctime, &from->di_ctime);
> > > >
> > > >   to->di_size = be64_to_cpu(from->di_size);
> > > >   to->di_nblocks = be64_to_cpu(from->di_nblocks);
> > > > @@ -235,9 +249,17 @@ xfs_inode_from_disk(
> > > >   if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> > > >           inode_set_iversion_queried(inode,
> > > >                                      be64_to_cpu(from->di_changecount));
> > > > -         xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
> > > > +         xfs_inode_from_disk_timestamp(from, &to->di_crtime,
> > > > +                         &from->di_crtime);
> > > >           to->di_flags2 = be64_to_cpu(from->di_flags2);
> > > >           to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> > > > +         /*
> > > > +          * Set the bigtime flag incore so that we automatically convert
> > > > +          * this inode's ondisk timestamps to bigtime format the next
> > > > +          * time we write the inode core to disk.
> > > > +          */
> > > > +         if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
> > > > +                 to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
> > > >   }
> > >
> > > We do not want on-disk flags to be changed outside transactions like
> > > this. Indeed, this has implications for O_DSYNC operation, in that
> > > we do not trigger inode sync operations if the inode is only
> > > timestamp dirty. If we've changed this flag, then the inode is more
> > > than "timestamp dirty" and O_DSYNC will need to flush the entire
> > > inode.... :/
> >
> > I forgot about XFS_ILOG_TIMESTAMP.
> >
> > > IOWs, I think we should only change this flag in a timestamp
> > > transaction where the timestamps are actually being logged and hence
> > > we can set inode dirty state appropriately so that everything will
> > > get logged, changed and written back correctly....
> >
> > Yeah, that's fair.  I'll change xfs_trans_log_inode to set the bigtime
> > flag if we're logging either the timestamps or the core.
> >
> > --D
> >
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com
