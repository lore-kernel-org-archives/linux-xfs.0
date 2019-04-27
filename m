Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44115 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfD0DdL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Apr 2019 23:33:11 -0400
Received: by mail-lf1-f65.google.com with SMTP id h18so3757121lfj.11
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 20:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190426225920.34359-1-jorgeguerra@gmail.com> <4c0ed0bf-c980-9379-3816-c8e5dddd61b5@sandeen.net>
 <20190427012406.GO178290@magnolia>
In-Reply-To: <20190427012406.GO178290@magnolia>
From: Jorge Guerra <jorge.guerra@gmail.com>
Date: Fri, 26 Apr 2019 20:32:57 -0700
Message-ID: <CAEFkGAx0cNTb2zAed9-3+qkJ-B9ARXCt90HJd28Vpv=wcKAqKg@mail.gmail.com>
Subject: Re: [PATCH] xfs_db: Scan entire file system when using 'frag'
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

Lol!

Thanks Darrick!

On Fri, Apr 26, 2019 at 6:24 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Fri, Apr 26, 2019 at 07:13:49PM -0500, Eric Sandeen wrote:
> > On 4/26/19 5:59 PM, Jorge Guerra wrote:
> > > From: Jorge Guerra <jorgeguerra@fb.com>
> > >
> > > While running the 'frag' command of 'xfs_db' we noticed that the
> > > tool is not scanning all the files in the file system.  We noticed
> > > this when we modified the tool to print the inodes of all the files
> > > scanned.  For example:
> > >
> > >  $ find /mnt/xfsdisk -type f | wc -l
> > >  1782674
> > >  $ xfs_db -r -c frag /dev/sdXX  | grep MB | awk '{print $5}' | paste -s -d+ | bc
> > >  656818
> > >
> > > Upon inspecting the code we noticed that the scanfunc_ino function
> > > stops processing a given inode block once it encounters a free leaf.
> > > However, in practice we see that inodes are necessarily always layed
> > > out contiguously on the leaf node.  This resulted in the 'frag'
> > > command skipping some valid inodes.
> > >
> > > In this change we modify the scanfunc_ino function to skip freed
> > > inodes.  With the change in place we ran the same experiment again
> > > and noticed a more accurate file count:
> > >
> > >  $ find /mnt/d0 -type f | wc -l
> > >  1810442
> > >  $ xfs_db -r -c frag /dev/sdXX  | grep MB | awk '{print $5}' | paste -s -d+ | bc
> > >  1810442
> > >
> > > Signed-off-by: Jorge Guerra <jorgeguerra@fb.com>
> >
> > This looks right, but I'll warn you that xfs_db's frag command is largely
> > useless in the first place.  ;)
>
> I was looking through the manpages for the part where it says frag is
> useless but couldn't find it.  Oh well. :(
>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> --D
>
> >
> > Also, I think:
> >
> > Fixes: 2a5eb70c ("xfs_db: teach the frag command about sparse inode chunks")
> >
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> >
> > Thanks!
> >
> > > ---
> > >  db/frag.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/db/frag.c b/db/frag.c
> > > index 5f33cb73..91395234 100644
> > > --- a/db/frag.c
> > > +++ b/db/frag.c
> > > @@ -507,7 +507,7 @@ scanfunc_ino(
> > >
> > >                             for (j = 0; j < inodes_per_buf; j++) {
> > >                                     if (XFS_INOBT_IS_FREE_DISK(&rp[i], ioff + j))
> > > -                                           goto next_buf;
> > > +                                           continue;
> > >                                     dip = (xfs_dinode_t *)((char *)iocur_top->data +
> > >                                             ((off + j) << mp->m_sb.sb_inodelog));
> > >                                     process_inode(agf, agino + ioff + j, dip);
> > >



-- 
Jorge E Guerra D
