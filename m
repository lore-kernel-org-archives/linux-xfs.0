Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48017 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdKVSbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 13:31:24 -0500
Date: Wed, 22 Nov 2017 10:31:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20171122183119.GI2135@magnolia>
References: <20170830145400.3681-1-hch@lst.de>
 <20171115011022.GC5119@magnolia>
 <CAOQ4uxg2iF5ucZTeN6orJVA2VYFnHAkvyb1-FS0BEZ=rGN+-Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg2iF5ucZTeN6orJVA2VYFnHAkvyb1-FS0BEZ=rGN+-Lw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 15, 2017 at 08:14:33AM +0200, Amir Goldstein wrote:
> On Wed, Nov 15, 2017 at 3:10 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Wed, Aug 30, 2017 at 04:54:00PM +0200, Christoph Hellwig wrote:
> >> But reject reflink + DAX file systems for now until the code to
> >> support reflinks on DAX is actually implemented.
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> ---
> >>  fs/xfs/xfs_super.c | 8 +++-----
> >>  1 file changed, 3 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >> index 38aaacdbb8b3..92521032468e 100644
> >> --- a/fs/xfs/xfs_super.c
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -1634,7 +1634,9 @@ xfs_fs_fill_super(
> >>               }
> >>               if (xfs_sb_version_hasreflink(&mp->m_sb))
> >>                       xfs_alert(mp,
> >> -             "DAX and reflink have not been tested together!");
> >> +             "DAX and reflink can not be used together!");
> >> +                     error = -EINVAL;
> >> +                     goto out_filestream_unmount;
> >>       }
> >>
> >>       if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> >> @@ -1648,10 +1650,6 @@ xfs_fs_fill_super(
> >>       "EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
> >>       }
> >>
> >> -     if (xfs_sb_version_hasreflink(&mp->m_sb))
> >> -             xfs_alert(mp,
> >> -     "EXPERIMENTAL reflink feature enabled. Use at your own risk!");
> >
> > Ok, now that the incore extent map rework has landed upstream, can we
> > please get everyone's QA to stress the reflink/cow code vigorously
> > during this release cycle so that we can re-consider this patch for
> > 4.16?
> >
> > (And if you're particularly mean, force cowextsize = 1fsb to age the
> > filesystem prematurely?)
> >
> > Right now I think the only problem I know about is that log recovery bug
> > where the defer ops of replayed defer ops get logged in the wrong order,
> > but that's it.
> >
> 
> Last time you wrote about this bug you had a "hard question" about transaction
> reservation for the solution and said your're going to go have a think about it:
> https://marc.info/?l=linux-xfs&m=150766311924170&w=2
> Did you come to any conclusions?
> That sounds like one of those nasty CoW corner cases, so I'd be happy to know
> there is at least a well thought design for a solution - if not a fix.

Sorry I let myself get distracted/stressed with the merge window;
hopefully the patch I sent out will address that problem?

> Practically, I would love if that bug could be solved soon so that we can all
> start running generic/503 for more than a few iterations to stress
> test reflink/cow
> with power failure. Success on this front could be a big upside before
> turning off
> EXPERIMENTAL.

Indeed!  What is the status of those tests, anyway?  Are they in xfstests?

--D

> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
