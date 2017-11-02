Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43939 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933146AbdKBQh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 12:37:59 -0400
Date: Thu, 2 Nov 2017 09:37:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/14] xfs/348: dir->symlink corruption must not be
 allowed
Message-ID: <20171102163754.GS4911@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957284389.18388.370732842906149356.stgit@magnolia>
 <20171102124214.GY17339@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102124214.GY17339@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Nov 02, 2017 at 08:42:14PM +0800, Eryu Guan wrote:
> On Wed, Nov 01, 2017 at 02:47:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > A directory corrupted into a symlink will be caught by the upcoming
> > local format ifork verifiers.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/348.out |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/xfs/348.out b/tests/xfs/348.out
> > index f4a7a71..17d9be2 100644
> > --- a/tests/xfs/348.out
> > +++ b/tests/xfs/348.out
> > @@ -239,7 +239,7 @@ would have junked entry "DATA" in directory PARENT_INO
> >  would have junked entry "DIR" in directory PARENT_INO
> >  would have junked entry "EMPTY" in directory PARENT_INO
> >  would have junked entry "FIFO" in directory PARENT_INO
> > -stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
> > +stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
> 
> But this breaks tests on old kernels. Or with the new ifork verifiers,
> old kernels can be considered as buggy?

Yes, they're buggy since we shouldn't be interpreting directory entries
as a link target given that the zero bytes in the "link target" will
screw things up.

--D

> Thanks,
> Eryu
> 
> >  stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
> >  stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
> >  stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
