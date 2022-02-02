Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170F0C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Feb 2022 20:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiBBUSr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Feb 2022 15:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiBBUSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Feb 2022 15:18:47 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0313C061714
        for <linux-xfs@vger.kernel.org>; Wed,  2 Feb 2022 12:18:46 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 23so2134460ybf.7
        for <linux-xfs@vger.kernel.org>; Wed, 02 Feb 2022 12:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8LIJsvWZ9oKvoIjo+LaEXdyIoqRnxKUMx3HfgshSuY=;
        b=dkC3+u2zOocErniPfR9ZmRhxNgLZxRQegYO8fJNdUbuYeB/7XQu2cJV9MEANpH5gmM
         oS3VFE7+WgGCjRKZhKSZmTUkMYiAzIqkH5RdWkZ1VF9Fu/lujtWh09AvyqWWlX+BaTGn
         3ybVJoDhzjjzUPJAkyPldpZ8XHtR8iSzHLKb25PXjpMKAerehaTN8vQxb39vVAiMajNQ
         3nx1PT9pcUIXOYjlkOdFMLA2dy59CXget7v7aXU1+aIdF4/y2POpyXJ39/nmECkSpVbM
         0c8wcMNPq5piszRXxwjEcsXvXlzCv+NR/PVmV4xnJeJH75GvnW430gN/CvOXYLNsyM5Y
         Q0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8LIJsvWZ9oKvoIjo+LaEXdyIoqRnxKUMx3HfgshSuY=;
        b=yNVpMLbnhQz62KHl5gHN1sO8NHg/7kc3ARdpnrL+h3S47O7FFFTjD8o9luQxMuL39g
         j9p5n4UyTMR7gUEAWZEKbEsHcvCavsoRv7/3WFIvy9LzyFp94zqMxYR6pulPlRsSuTEB
         dY7ME4BvBlLkFDguciy2Vxc+6xDSo0tW/l5yB2gg+sF2OoG/T4I3UYMveoX+A7tbof4C
         RM44RA2FTGUCYeaQAgTIc3cnepaAmPS5PbCGnVkMAuOXKJQFqLZkOLlgg7dIcXb/N5EA
         c0UKlnA1lV+Tv5KwS1dHcFiR40oAKfeXB/9Rya7wzr90ZVv/gBuB2W1QjxmBj/HVDAy9
         Tr/Q==
X-Gm-Message-State: AOAM532YXmHmSHSOl7GSlYCBMAWLp3lGVLQehl4hh2HTXIs6Uvb6VGIb
        MDHNTckyumkvVUa6bkPXy0UWm+8yPM7QFgA6Ely3tQ==
X-Google-Smtp-Source: ABdhPJzjeiocad3qwGEKAxo3zeLwVALESUq6gYsmsHF8FAuwacu774RQdmAID3E0iL/6D2YyKeFmzIh36N++LORMyL8=
X-Received: by 2002:a25:c307:: with SMTP id t7mr42811782ybf.701.1643833125719;
 Wed, 02 Feb 2022 12:18:45 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area> <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
 <20220202024430.GZ59729@dread.disaster.area> <20220202074242.GA59729@dread.disaster.area>
 <CAA43vkXxyHmQdu-GqVukmeOqEh8g-xJDCDD6sx7t4f-MVn+BBA@mail.gmail.com> <CAA43vkX6au8gmO97otOT4LQOzspomodGSO__qPMmFozzMsrRQg@mail.gmail.com>
In-Reply-To: <CAA43vkX6au8gmO97otOT4LQOzspomodGSO__qPMmFozzMsrRQg@mail.gmail.com>
From:   Sean Caron <scaron@umich.edu>
Date:   Wed, 2 Feb 2022 15:18:34 -0500
Message-ID: <CAA43vkUFW3Y_0L7dFc+iAySdf4j3cX4M9Xoz+3eU4raoavmnew@mail.gmail.com>
Subject: Re: [PATCH] metadump: handle corruption errors without aborting
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

It counted up to inode 13555712 and then crashed with the error:

malloc_consolidate(): invalid chunk size

Immediately before that, it printed:

xfs_metadump: invalid block number 4358190/50414336 (1169892770398976)
in bmap extent 0 in symlink ino 98799839421

Best,

Sean

On Wed, Feb 2, 2022 at 2:43 PM Sean Caron <scaron@umich.edu> wrote:
>
> OK, I got it applied with:
>
> git apply --ignore-space-change --ignore-whitespace
>
> I've got it running and so far it looks good. It's gotten past the
> inode number where exited before and now just prints as an
> informational message:
>
> inode xx has unexpected extents
>
> I'll let this run and follow up on this thread if I have any more
> issues with xfs_metadump in particular.
>
> Thanks again,
>
> Sean
>
> On Wed, Feb 2, 2022 at 1:49 PM Sean Caron <scaron@umich.edu> wrote:
> >
> > Hi Dave,
> >
> > Thank you! I tried copying and pasting this into a file and applying it with:
> >
> > patch < thispatchfile
> >
> > against both the 5.14.2 release and xfsprogs-dev Git pull and I'm
> > getting errors from patch.
> >
> > I also tried using "git patch" and it told me the patch does not apply.
> >
> > I tried applying the patch by hand to the 5.14.2 metadump.c but I get
> > a compilation error in process_dev_inode but I'm not sure if that's
> > because I made a mistake or because the patch is expecting other
> > content to be there, that isn't.
> >
> > I'm sorry for the ignorance but how would I make use of this?
> >
> > Thanks,
> >
> > Sean
> >
> > On Wed, Feb 2, 2022 at 2:42 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > >
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > Sean Caron reported that a metadump terminated after givin gthis
> > > warning:
> > >
> > > xfs_metadump: inode 2216156864 has unexpected extents
> > >
> > > Metadump is supposed to ignore corruptions and continue dumping the
> > > filesystem as best it can. Whilst it warns about many situations
> > > where it can't fully dump structures, it should stop processing that
> > > structure and continue with the next one until the entire filesystem
> > > has been processed.
> > >
> > > Unfortunately, some warning conditions also return an "abort" error
> > > status, causing metadump to abort if that condition is hit. Most of
> > > these abort conditions should really be "continue on next object"
> > > conditions so that the we attempt to dump the rest of the
> > > filesystem.
> > >
> > > Fix the returns for warnings that incorrectly cause aborts
> > > such that the only abort conditions are read errors when
> > > "stop-on-read-error" semantics are specified. Also make the return
> > > values consistently mean abort/continue rather than returning -errno
> > > to mean "stop because read error" and then trying to infer what
> > > the error means in callers without the context it occurred in.
> > >
> > > Reported-by: Sean Caron <scaron@umich.edu>
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >
> > > Sean,
> > >
> > > Can you please apply this patch to your xfsprogs source tree and
> > > rebuild it? This should let metadump continue past the corrupt
> > > inodes it aborted on and run through to completion.
> > >
> > > -Dave.
> > >
> > >  db/metadump.c | 94 +++++++++++++++++++++++++++++------------------------------
> > >  1 file changed, 47 insertions(+), 47 deletions(-)
> > >
> > > diff --git a/db/metadump.c b/db/metadump.c
> > > index 96b098b0eaca..9b32b88a3c50 100644
> > > --- a/db/metadump.c
> > > +++ b/db/metadump.c
> > > @@ -1645,7 +1645,7 @@ process_symlink_block(
> > >  {
> > >         struct bbmap    map;
> > >         char            *link;
> > > -       int             ret = 0;
> > > +       int             rval = 1;
> > >
> > >         push_cur();
> > >         map.nmaps = 1;
> > > @@ -1658,8 +1658,7 @@ process_symlink_block(
> > >
> > >                 print_warning("cannot read %s block %u/%u (%llu)",
> > >                                 typtab[btype].name, agno, agbno, s);
> > > -               if (stop_on_read_error)
> > > -                       ret = -1;
> > > +               rval = !stop_on_read_error;
> > >                 goto out_pop;
> > >         }
> > >         link = iocur_top->data;
> > > @@ -1682,10 +1681,11 @@ process_symlink_block(
> > >         }
> > >
> > >         iocur_top->need_crc = 1;
> > > -       ret = write_buf(iocur_top);
> > > +       if (write_buf(iocur_top))
> > > +               rval = 0;
> > >  out_pop:
> > >         pop_cur();
> > > -       return ret;
> > > +       return rval;
> > >  }
> > >
> > >  #define MAX_REMOTE_VALS                4095
> > > @@ -1843,8 +1843,8 @@ process_single_fsb_objects(
> > >         typnm_t         btype,
> > >         xfs_fileoff_t   last)
> > >  {
> > > +       int             rval = 1;
> > >         char            *dp;
> > > -       int             ret = 0;
> > >         int             i;
> > >
> > >         for (i = 0; i < c; i++) {
> > > @@ -1858,8 +1858,7 @@ process_single_fsb_objects(
> > >
> > >                         print_warning("cannot read %s block %u/%u (%llu)",
> > >                                         typtab[btype].name, agno, agbno, s);
> > > -                       if (stop_on_read_error)
> > > -                               ret = -EIO;
> > > +                       rval = !stop_on_read_error;
> > >                         goto out_pop;
> > >
> > >                 }
> > > @@ -1925,16 +1924,17 @@ process_single_fsb_objects(
> > >                 }
> > >
> > >  write:
> > > -               ret = write_buf(iocur_top);
> > > +               if (write_buf(iocur_top))
> > > +                       rval = 0;
> > >  out_pop:
> > >                 pop_cur();
> > > -               if (ret)
> > > +               if (!rval)
> > >                         break;
> > >                 o++;
> > >                 s++;
> > >         }
> > >
> > > -       return ret;
> > > +       return rval;
> > >  }
> > >
> > >  /*
> > > @@ -1952,7 +1952,7 @@ process_multi_fsb_dir(
> > >         xfs_fileoff_t   last)
> > >  {
> > >         char            *dp;
> > > -       int             ret = 0;
> > > +       int             rval = 1;
> > >
> > >         while (c > 0) {
> > >                 unsigned int    bm_len;
> > > @@ -1978,8 +1978,7 @@ process_multi_fsb_dir(
> > >
> > >                                 print_warning("cannot read %s block %u/%u (%llu)",
> > >                                                 typtab[btype].name, agno, agbno, s);
> > > -                               if (stop_on_read_error)
> > > -                                       ret = -1;
> > > +                               rval = !stop_on_read_error;
> > >                                 goto out_pop;
> > >
> > >                         }
> > > @@ -1998,18 +1997,19 @@ process_multi_fsb_dir(
> > >                         }
> > >                         iocur_top->need_crc = 1;
> > >  write:
> > > -                       ret = write_buf(iocur_top);
> > > +                       if (write_buf(iocur_top))
> > > +                               rval = 0;
> > >  out_pop:
> > >                         pop_cur();
> > >                         mfsb_map.nmaps = 0;
> > > -                       if (ret)
> > > +                       if (!rval)
> > >                                 break;
> > >                 }
> > >                 c -= bm_len;
> > >                 s += bm_len;
> > >         }
> > >
> > > -       return ret;
> > > +       return rval;
> > >  }
> > >
> > >  static bool
> > > @@ -2039,15 +2039,15 @@ process_multi_fsb_objects(
> > >                 return process_symlink_block(o, s, c, btype, last);
> > >         default:
> > >                 print_warning("bad type for multi-fsb object %d", btype);
> > > -               return -EINVAL;
> > > +               return 1;
> > >         }
> > >  }
> > >
> > >  /* inode copy routines */
> > >  static int
> > >  process_bmbt_reclist(
> > > -       xfs_bmbt_rec_t          *rp,
> > > -       int                     numrecs,
> > > +       xfs_bmbt_rec_t          *rp,
> > > +       int                     numrecs,
> > >         typnm_t                 btype)
> > >  {
> > >         int                     i;
> > > @@ -2059,7 +2059,7 @@ process_bmbt_reclist(
> > >         xfs_agnumber_t          agno;
> > >         xfs_agblock_t           agbno;
> > >         bool                    is_multi_fsb = is_multi_fsb_object(mp, btype);
> > > -       int                     error;
> > > +       int                     rval = 1;
> > >
> > >         if (btype == TYP_DATA)
> > >                 return 1;
> > > @@ -2123,16 +2123,16 @@ process_bmbt_reclist(
> > >
> > >                 /* multi-extent blocks require special handling */
> > >                 if (is_multi_fsb)
> > > -                       error = process_multi_fsb_objects(o, s, c, btype,
> > > +                       rval = process_multi_fsb_objects(o, s, c, btype,
> > >                                         last);
> > >                 else
> > > -                       error = process_single_fsb_objects(o, s, c, btype,
> > > +                       rval = process_single_fsb_objects(o, s, c, btype,
> > >                                         last);
> > > -               if (error)
> > > -                       return 0;
> > > +               if (!rval)
> > > +                       break;
> > >         }
> > >
> > > -       return 1;
> > > +       return rval;
> > >  }
> > >
> > >  static int
> > > @@ -2331,7 +2331,7 @@ process_inode_data(
> > >         return 1;
> > >  }
> > >
> > > -static int
> > > +static void
> > >  process_dev_inode(
> > >         xfs_dinode_t            *dip)
> > >  {
> > > @@ -2339,15 +2339,13 @@ process_dev_inode(
> > >                 if (show_warnings)
> > >                         print_warning("inode %llu has unexpected extents",
> > >                                       (unsigned long long)cur_ino);
> > > -               return 0;
> > > -       } else {
> > > -               if (zero_stale_data) {
> > > -                       unsigned int    size = sizeof(xfs_dev_t);
> > > +               return;
> > > +       }
> > > +       if (zero_stale_data) {
> > > +               unsigned int    size = sizeof(xfs_dev_t);
> > >
> > > -                       memset(XFS_DFORK_DPTR(dip) + size, 0,
> > > -                                       XFS_DFORK_DSIZE(dip, mp) - size);
> > > -               }
> > > -               return 1;
> > > +               memset(XFS_DFORK_DPTR(dip) + size, 0,
> > > +                               XFS_DFORK_DSIZE(dip, mp) - size);
> > >         }
> > >  }
> > >
> > > @@ -2365,11 +2363,10 @@ process_inode(
> > >         xfs_dinode_t            *dip,
> > >         bool                    free_inode)
> > >  {
> > > -       int                     success;
> > > +       int                     rval = 1;
> > >         bool                    crc_was_ok = false; /* no recalc by default */
> > >         bool                    need_new_crc = false;
> > >
> > > -       success = 1;
> > >         cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
> > >
> > >         /* we only care about crc recalculation if we will modify the inode. */
> > > @@ -2390,32 +2387,34 @@ process_inode(
> > >         /* copy appropriate data fork metadata */
> > >         switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
> > >                 case S_IFDIR:
> > > -                       success = process_inode_data(dip, TYP_DIR2);
> > > +                       rval = process_inode_data(dip, TYP_DIR2);
> > >                         if (dip->di_format == XFS_DINODE_FMT_LOCAL)
> > >                                 need_new_crc = 1;
> > >                         break;
> > >                 case S_IFLNK:
> > > -                       success = process_inode_data(dip, TYP_SYMLINK);
> > > +                       rval = process_inode_data(dip, TYP_SYMLINK);
> > >                         if (dip->di_format == XFS_DINODE_FMT_LOCAL)
> > >                                 need_new_crc = 1;
> > >                         break;
> > >                 case S_IFREG:
> > > -                       success = process_inode_data(dip, TYP_DATA);
> > > +                       rval = process_inode_data(dip, TYP_DATA);
> > >                         break;
> > >                 case S_IFIFO:
> > >                 case S_IFCHR:
> > >                 case S_IFBLK:
> > >                 case S_IFSOCK:
> > > -                       success = process_dev_inode(dip);
> > > +                       process_dev_inode(dip);
> > >                         need_new_crc = 1;
> > >                         break;
> > >                 default:
> > >                         break;
> > >         }
> > >         nametable_clear();
> > > +       if (!rval)
> > > +               goto done;
> > >
> > >         /* copy extended attributes if they exist and forkoff is valid */
> > > -       if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
> > > +       if (XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
> > >                 attr_data.remote_val_count = 0;
> > >                 switch (dip->di_aformat) {
> > >                         case XFS_DINODE_FMT_LOCAL:
> > > @@ -2425,11 +2424,11 @@ process_inode(
> > >                                 break;
> > >
> > >                         case XFS_DINODE_FMT_EXTENTS:
> > > -                               success = process_exinode(dip, TYP_ATTR);
> > > +                               rval = process_exinode(dip, TYP_ATTR);
> > >                                 break;
> > >
> > >                         case XFS_DINODE_FMT_BTREE:
> > > -                               success = process_btinode(dip, TYP_ATTR);
> > > +                               rval = process_btinode(dip, TYP_ATTR);
> > >                                 break;
> > >                 }
> > >                 nametable_clear();
> > > @@ -2442,7 +2441,8 @@ done:
> > >
> > >         if (crc_was_ok && need_new_crc)
> > >                 libxfs_dinode_calc_crc(mp, dip);
> > > -       return success;
> > > +
> > > +       return rval;
> > >  }
> > >
> > >  static uint32_t        inodes_copied;
> > > @@ -2541,7 +2541,7 @@ copy_inode_chunk(
> > >
> > >                         /* process_inode handles free inodes, too */
> > >                         if (!process_inode(agno, agino + ioff + i, dip,
> > > -                           XFS_INOBT_IS_FREE_DISK(rp, ioff + i)))
> > > +                                       XFS_INOBT_IS_FREE_DISK(rp, ioff + i)))
> > >                                 goto pop_out;
> > >
> > >                         inodes_copied++;
> > > @@ -2800,7 +2800,7 @@ copy_ino(
> > >         xfs_agblock_t           agbno;
> > >         xfs_agino_t             agino;
> > >         int                     offset;
> > > -       int                     rval = 0;
> > > +       int                     rval = 1;
> > >
> > >         if (ino == 0 || ino == NULLFSINO)
> > >                 return 1;
