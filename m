Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4BD657F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 13:31:54 -0500 (CDT)
Date: Fri, 27 Sep 2013 13:31:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [XFS MAINTAINERS] fs/xfs/xfs_dir2_node.c: xfs:
	xfs_dir2_leafn_add: Variables Uninitialized
Message-ID: <20130927183150.GG10553@sgi.com>
References: <CAGG-pURO7QrMcU1btzh_RvQkLB=4QFqrLntW3n6BeMfU4iFdUQ@mail.gmail.com>
	<CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Geyslan,

On Fri, Sep 27, 2013 at 02:59:12PM -0300, Geyslan Greg=F3rio Bem wrote:
> Hi Maintainers,
> =

> I suppose the variables "highstale" and "lowstale" are being used despite
> not having been initialized.
> =

> File: fs/xfs/xfs_dir2_node.c
> Function: xfs_dir2_leafn_add
> =

> L491:
> > /*
> > * Insert the new entry, log everything.
> > */
> > lep =3D xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowsta=
le,
> > highstale, &lfloglow, &lfloghigh);
> =

> The only place they are started up is within this condition:
> =

> L480:
> > if (compact)
> > xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
> > &highstale, &lfloglow, &lfloghigh);
> =

> So, if it is not compact, both have garbage.

Thanks for the report.  That sounds pretty bad.  Lets see...

421 static int                                      /* error */
422 xfs_dir2_leafn_add(
423         struct xfs_buf          *bp,            /* leaf buffer */
424         xfs_da_args_t           *args,          /* operation arguments =
*/
425         int                     index)          /* insertion pt for new=
 entry */
426 {
...
476         /*
477          * Compact out all but one stale leaf entry.  Leaves behind
478          * the entry closest to index.
479          */
480         if (compact)
481                 xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowst=
ale,
482                                          &highstale, &lfloglow, &lflogh=
igh);
483         else if (leafhdr.stale) {
484                 /*
485                  * Set impossible logging indices for this case.
486                  */
487                 lfloglow =3D leafhdr.count;
488                 lfloghigh =3D -1;
489         }
490
491         /*
492          * Insert the new entry, log everything.
493          */
494         lep =3D xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact=
, lowstale,
495                                        highstale, &lfloglow, &lfloghigh=
);

If compact is set at 481 we pass the addresses of highstale and lowstale to
xfs_dir3_leaf_compact_x1, which passes them to xfs_dir3_leaf_find_stale, wh=
ich
makes assignments to both variables unconditionally.  Later at 494 we pass
compact, lowstale, and highstale to xfs_dir3_leaf_find_entry.

So we're ok if compact is set...

555 struct xfs_dir2_leaf_entry *
556 xfs_dir3_leaf_find_entry(
557         struct xfs_dir3_icleaf_hdr *leafhdr,
558         struct xfs_dir2_leaf_entry *ents,
559         int                     index,          /* leaf table position =
*/
560         int                     compact,        /* need to compact leav=
es */
561         int                     lowstale,       /* index of prev stale =
leaf */
562         int                     highstale,      /* index of next stale =
leaf */
563         int                     *lfloglow,      /* low leaf logging ind=
ex */
564         int                     *lfloghigh)     /* high leaf logging in=
dex */
565 {
...
587         /*
588          * There are stale entries.
589          *
590          * We will use one of them for the new entry.  It's probably no=
t at
591          * the right location, so we'll have to shift some up or down f=
irst.
592          *
593          * If we didn't compact before, we need to find the nearest sta=
le
594          * entries before and after our insertion point.
595          */
596         if (compact =3D=3D 0)
597                 xfs_dir3_leaf_find_stale(leafhdr, ents, index,
598                                          &lowstale, &highstale);

In xfs_dir3_leaf_find_entry, it looks like if compact is not set, we will p=
ass
the addresses of lowstale and highstale to xfs_dir3_leaf_find_stale which
appears to make assignments to them unconditionally.  It looks like
xfs_dir3_leaf_find_entry doesn't read from lowstale and highstale until aft=
er
598.  I think this should take care of the !compact case too.  Do you agree?

Thanks much,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
