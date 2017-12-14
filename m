Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdLNUUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 15:20:51 -0500
Date: Thu, 14 Dec 2017 12:20:43 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] fsstress: implement the clonerange/deduperange ioctls
Message-ID: <20171214202043.GK6896@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314503583.18893.15475795025536691678.stgit@magnolia>
 <CAOQ4uxh-msvkXA0Uyh9DfYicM6QGAohuaOZdwVpkKrfNPpvDTA@mail.gmail.com>
 <20171214073246.GF2749@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171214073246.GF2749@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Dec 14, 2017 at 03:32:46PM +0800, Eryu Guan wrote:
> On Thu, Dec 14, 2017 at 08:39:38AM +0200, Amir Goldstein wrote:
> > On Wed, Dec 13, 2017 at 8:03 AM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Mix it up a bit by reflinking and deduping data blocks when possible.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  ltp/fsstress.c |  440 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 440 insertions(+)
> > >
> > >
> > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > index 96f48b1..e2dfa5e 100644
> > > --- a/ltp/fsstress.c
> > > +++ b/ltp/fsstress.c
> > > @@ -68,7 +68,9 @@ typedef enum {
> > >         OP_BULKSTAT,
> > >         OP_BULKSTAT1,
> > >         OP_CHOWN,
> > > +       OP_CLONERANGE,
> > >         OP_CREAT,
> > > +       OP_DEDUPERANGE,
> > >         OP_DREAD,
> > >         OP_DWRITE,
> > >         OP_FALLOCATE,
> > > @@ -174,7 +176,9 @@ void        awrite_f(int, long);
> > >  void   bulkstat_f(int, long);
> > >  void   bulkstat1_f(int, long);
> > >  void   chown_f(int, long);
> > > +void   clonerange_f(int, long);
> > >  void   creat_f(int, long);
> > > +void   deduperange_f(int, long);
> > >  void   dread_f(int, long);
> > >  void   dwrite_f(int, long);
> > >  void   fallocate_f(int, long);
> > > @@ -221,7 +225,9 @@ opdesc_t    ops[] = {
> > >         { OP_BULKSTAT, "bulkstat", bulkstat_f, 1, 0 },
> > >         { OP_BULKSTAT1, "bulkstat1", bulkstat1_f, 1, 0 },
> > >         { OP_CHOWN, "chown", chown_f, 3, 1 },
> > > +       { OP_CLONERANGE, "clonerange", clonerange_f, 4, 1 },
> > >         { OP_CREAT, "creat", creat_f, 4, 1 },
> > > +       { OP_DEDUPERANGE, "deduperange", deduperange_f, 4, 1},
> > >         { OP_DREAD, "dread", dread_f, 4, 0 },
> > >         { OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
> > >         { OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
> > > @@ -1312,6 +1318,16 @@ make_freq_table(void)
> > >         }
> > >  }
> > >
> > > +void
> > > +free_freq_table(void)
> > > +{
> > > +       if (!freq_table)
> > > +               return;
> > > +       free(freq_table);
> > > +       freq_table = NULL;
> > > +       freq_table_size = 0;
> > > +}
> > > +
> > >  int
> > >  mkdir_path(pathname_t *name, mode_t mode)
> > >  {
> > > @@ -2189,6 +2205,430 @@ chown_f(int opno, long r)
> > >         free_pathname(&f);
> > >  }
> > >
> > > +static void
> > > +disable_op(opty_t opt)
> > > +{
> > > +       opdesc_t        *p;
> > > +
> > > +       for (p = ops; p < ops_end; p++) {
> > > +               if (opt == p->op) {
> > > +                       p->freq = 0;
> > > +                       free_freq_table();
> > > +                       make_freq_table();
> > > +                       return;
> > > +               }
> > > +       }
> > > +}
> > > +
> > 
> > If we want to go down the path of runtime disable ops, the question is:
> > Why disable_op clonerange/deduperange and not disable_op
> > insert/collapse/zero/punch? there are probably other ops as well.
> > This is also inconsistent by the fact that build time disable of
> > neither FALLOC nor LONERANGE/DEDUPERANGE will not
> > change the random op sequence, while runtime disable will.
> 
> That's a good point. I don't think we want to disable unsupported
> operations dynamically, fsstress just accepts/ignores whatever result
> the operation gives and just prints the errno to log in verbose mode.

Ok, I'll remove all the auto-disabling stuff & resubmit.

--D

> Thanks,
> Eryu
> 
> > 
> > This is related to the conversation of the golden output of xfs/068.
> > Will take my arguments there now...
> > 
> > Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
