Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tyo161.gate.nec.co.jp ([114.179.232.161]:37155 "EHLO
        tyo161.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbeFVImF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 04:42:05 -0400
From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: RE: [PATCH] xfs_quota: fix -d option to limit directory depth
 correctly
Date: Fri, 22 Jun 2018 08:40:58 +0000
Message-ID: <C26C67884C4B7A48980D5746355948640348428E@BPXM20GP.gisp.nec.co.jp>
References: <C26C67884C4B7A48980D5746355948640347D54C@BPXM20GP.gisp.nec.co.jp>
 <20180615114449.cuzz5nkqrxn6j4bk@odin.usersys.redhat.com>
 <20180615155145.GD8128@magnolia>
In-Reply-To: <20180615155145.GD8128@magnolia>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>

Thanks for your helpful suggestions about the description.
I have no objection, so I'll send v2 patch to fix the patch description/subject.

Regards,
Kazuya Mio

> 2018/06/16 0:51:45, Darrick J. Wong wrote:
> 
> On Fri, Jun 15, 2018 at 01:44:49PM +0200, Carlos Maiolino wrote:
> > Although the patch looks correct, the patch description/subject is confusing
> > IMHO.
> >
> > On Mon, Jun 11, 2018 at 05:39:59AM +0000, Kazuya Mio wrote:
> >
> > > xfs_quota -x -c "project -d DEPTH" stops in the middle of its operation
> > > if a directory whose level is more than DEPTH was found.
> > >
> >
> > > To set/check/clear a project quota, xfs_quota performs pre-order tree traversal
> > > by using nftw(3). However, if the directory whose level is more than
> > > the recursion level specified by -d option is found, the function called
> > > by nftw() returns -1 and nftw() stops the tree walk.
> > >
> >
> > I've got what you meant here, but in fact, this description just sounds to me
> > as the operation should work, i.e. stop when DEPTH is hit.
> >
> > What you think about something like:
> >
> > ====
> > Continue the file tree walk, even though DEPTH is hit in one or more
> > sub-directory tree(s), so all sub-directory trees are processed up to DEPTH
> >
> > To set/check/clear a project quota, xfs_quota performs pre-order tree traversal
> > by using nftw(3). However, by now, {check,setup,clear}_project, returns -1 when
> > DEPTH is hit, stopping the directory tree walk.
> >
> > Change the return value of these functions to 0, when DEPTH is hit, so, the
> > remaining sub-directory trees are also processed up to DEPTH.
> 
> I suggest contrasting the current behavior vs. the documented behavior a
> little more explicitly:
> 
> "To set/check/clear a project quota, xfs_quota performs a pre-order tree
> traversal by using nftw(3).  The documentation states that the -d option
> can be used to skip subtrees below a certain level in the directory
> hierarchy.  Unfortunately, {check,setup,clear}_project returns -1 when
> DEPTH is hit, which stops the directory tree walk immediately.  We only
> wanted to skip the subtree, so return 0 instead."
> 
> Though if we're going to use FTW_ACTIONRETVAL/FTW_SKIP_SUBTREE then
> there ought to be checks for the existence of those flags at build time.
> 
> --D
> 
> > ====
> >
> > But well, English is not my native language too, so, might be more useful if some
> > native English speaker commented on it.
> >
> > For the patch itself:
> >
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> >
> >
> > > The following steps show that only one directory is set a project quota,
> > > even though another directory whose level is the same as the recursion level
> > > isn't set a project quota.
> > >
> >
> > > # mkfs.xfs -f /dev/sdb1
> > > # mount -o pquota /dev/sdb1 /mnt
> > > # mkdir -p /mnt/pquota/dirA/dirAA /mnt/pquota/dirB/dirBB
> > > # xfs_quota -x -c "project -d 1 -s -p /mnt/pquota 100"
> > > # xfs_io -c stat /mnt/pquota/dirA | grep projid
> > > fsxattr.projid = 100
> > > # xfs_io -c stat /mnt/pquota/dirB | grep projid
> > > fsxattr.projid = 0
> > >
> > > To fix above problem, if the directory whose level is more than the recursion
> > > level is found, the function called by nftw() returns 0 instead of -1.
> > >
> > > Note that the time of tree traversal is the same as no limitation of
> > > recursion level. To reduce the time, we have to use FTW_SKIP_SUBTREE
> > > that is glibc-specified flag. Is it better to use this flag?
> > >
> > > Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> > > ---
> > >  quota/project.c |    6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > diff --git a/quota/project.c b/quota/project.c
> > > index e4e7a01..20bc01b 100644
> > > --- a/quota/project.c
> > > +++ b/quota/project.c
> > > @@ -101,7 +101,7 @@ check_project(
> > >  	int			fd;
> > >
> > >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> > > -		return -1;
> > > +		return 0;
> > >
> > >  	if (flag == FTW_NS ){
> > >  		exitcode = 1;
> > > @@ -146,7 +146,7 @@ clear_project(
> > >  	int			fd;
> > >
> > >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> > > -		return -1;
> > > +		return 0;
> > >
> > >  	if (flag == FTW_NS ){
> > >  		exitcode = 1;
> > > @@ -193,7 +193,7 @@ setup_project(
> > >  	int			fd;
> > >
> > >  	if (recurse_depth >= 0 && data->level > recurse_depth)
> > > -		return -1;
> > > +		return 0;
> > >
> > >  	if (flag == FTW_NS ){
> > >  		exitcode = 1;
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

