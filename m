Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0DEC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A5832078B
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BnoHuiC5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgHTFLk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHTFLj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:11:39 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BC2C061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:11:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id v2so709831ilq.4
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XATOR1sfYrj8EZrpetOmbOdo492pK7/k4DrbdmFy7WQ=;
        b=BnoHuiC5CygOHtqqnTSyNTGrKJphTxRrPiLbv3X3HV/Ppoge9D+AC9ODQc4XAqNXsf
         0RhZevtlAEpHIkWWB90taaxOyJQ5Y2Nrxn+N4XCSOVkKjRqEwPbxfdbAQenthgrX4L/i
         W265UG3pqjfVgeyuMCnOhuIOCvzEdXfYQF6qcR7qkT3m68jnuZ/jT5XtkFjvpqxp4XfC
         9xSw+nJMV68xsiw2mtRInRm82xdRLDZHx1ireorwcskYTLdPSq0VufxlwzgB8cdZirsZ
         L1Yw7xCXxOUbKiN58z7F9NQTiculivLbgjLPzwIVvSgyygNvHRBawwF4DWc9rqN4S6fV
         ap+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XATOR1sfYrj8EZrpetOmbOdo492pK7/k4DrbdmFy7WQ=;
        b=c7xppqWPhlP9GWyFs8iIxu1SEXWDxHpldQxo+JUmUw68dLns/hfWNnqpUGKsL3lJry
         7qouilyJoa0BLynsdppGRndgJSo5uBsL8RpUw7eMPu+vDwQa1CwcnYYt5s1EJK5R+YEM
         A2RRveJOroV90m3i4lh1bd/iomMQc848UPanewvvWyFJL+i6IDM+2usgEy4AXGf0WQIz
         7O24c4kVZTTxpt2N5rkuka6vVj6IW3qhIj75Ld8tuQ7foGDeDYbxHd3M1CqVCt/X52oR
         IfbKwjQT0Bz34l9ObGJRUptaUbn1N8QAABc5cgqJN7XK04bxzlz1uCBAGWSpOiYIPcdW
         RGbg==
X-Gm-Message-State: AOAM530n83NoWzjPqRDHXjE9YafNJMuDUVTCV2wqfB2oznSQQjbxf/wU
        QDLMWQFQgXUj9X9qxUjD4S+RTVXF8icZe/Ba97qpi3MR/Bg=
X-Google-Smtp-Source: ABdhPJyF95KCDdHK0evCPGCGmcsZ0bPkqfrALq0jwY3zfQeaxkKqZf3an1VH0g+MZvyWghraa1oPG3s++35pllFbNtY=
X-Received: by 2002:a92:da0a:: with SMTP id z10mr1235321ilm.275.1597900297934;
 Wed, 19 Aug 2020 22:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia> <20200818233535.GD21744@dread.disaster.area>
 <20200819214322.GE6096@magnolia> <20200820000102.GF6096@magnolia>
In-Reply-To: <20200820000102.GF6096@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 20 Aug 2020 08:11:27 +0300
Message-ID: <CAOQ4uxiinUPDB6K=cZ=4h1hwzOefoLgCR8pF3B+cn3u0HTWj0A@mail.gmail.com>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038 problem
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 3:03 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
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

And unnecessarily make the code less readable and harder to review.
To what end? Dave writes:
"I just didn't really like the way the code in the encode/decode
helpers turned out..."

Cannot respond to that argument on a technical review.
I can only say that as a reviewer, the posted version was clear and easy
for me to verify and the posted alternative that turned out to have a bug,
I would never have never caught that bug in review and I would not have
felt confident about verifying the code in review either.

Thanks,
Amir.
