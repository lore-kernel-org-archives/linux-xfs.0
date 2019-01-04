Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:32937 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfADW1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jan 2019 17:27:35 -0500
Received: by mail-lf1-f66.google.com with SMTP id i26so26462565lfc.0
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jan 2019 14:27:34 -0800 (PST)
MIME-Version: 1.0
References: <20181105213145.7560-1-stefanrin@gmail.com> <20181105213145.7560-3-stefanrin@gmail.com>
 <20190103175504.GD20475@magnolia>
In-Reply-To: <20190103175504.GD20475@magnolia>
From: Stefan Ring <stefanrin@gmail.com>
Date: Fri, 4 Jan 2019 23:27:20 +0100
Message-ID: <CAAxjCEytZ4U8K6CPJFBguTSocH_bmxxoEvZ-HkZuFc=QwrZbBQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 3, 2019 at 6:55 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Mon, Nov 05, 2018 at 10:31:42PM +0100, Stefan Ring wrote:
> > Using basically the same code as in process_single_fsb_objects.
> >
> > Signed-off-by: Stefan Ring <stefanrin@gmail.com>
> > ---
> >  db/metadump.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/db/metadump.c b/db/metadump.c
> > index 97d2a490..be7cf360 100644
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -1921,15 +1922,19 @@ process_multi_fsb_objects(
> >
> >                       }
> >
> > -                     if ((!obfuscate && !zero_stale_data) ||
>
> Hmmm, if we're not obfuscating or zeroing data, can we still jump to
> write_buf()?
>
> --D

The call to write_buf() is always necessary, as without this, nothing
would end up in the metadump. But while trying to argue the soundness
of this patch, I have found deficiencies ;). It will always call
process_dir_data_block, even without any zeroing/obfuscation flags
set. I must have considered this harmless, since it does not actually
"do" anything, but I'm not so sure anymore because it may complain
about data inconsistencies, and this might make an otherwise dumpable
image non-dumpable. It is also, at least in theory, able to reset the
need_crc back to zero, contrary to all the other usages of this flag
in this file. I don't think this is an actual problem, as the flag
only seems to be set when zeroing or obfuscating in the first place,
but it might become one if circumstances far removed from this
location change. It is just too much of a mental burden.

I will redo this once again so that it will be more similar in
structure to the code in process_single_fsb_objects _and_ the original
code, I hope.

>
> > -                          o >= mp->m_dir_geo->leafblk) {
> > -                             ret = write_buf(iocur_top);
> > -                             goto out_pop;
> > +                     dp = iocur_top->data;
> > +                     if (o >= mp->m_dir_geo->freeblk) {
> > +                             /* TODO, zap any stale data */
> > +                             goto write;
> > +                     } else if (o >= mp->m_dir_geo->leafblk) {
> > +                             process_dir_leaf_block(dp);
> > +                     } else {
> > +                             process_dir_data_block(dp, o,
> > +                                      last == mp->m_dir_geo->fsbcount);
> >                       }
> >
> > -                     process_dir_data_block(iocur_top->data, o,
> > -                                            last == mp->m_dir_geo->fsbcount);
> > -                     iocur_top->need_crc = 1;
> > +                     iocur_top->need_crc = obfuscate || zero_stale_data;
> > +write:
> >                       ret = write_buf(iocur_top);
> >  out_pop:
> >                       pop_cur();
> > --
> > 2.14.5
> >
