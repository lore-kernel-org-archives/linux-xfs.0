Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752361AbeBHQeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Feb 2018 11:34:06 -0500
Date: Thu, 8 Feb 2018 08:30:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs/348: dir->symlink corruption must not be allowed
Message-ID: <20180208163036.GI5433@magnolia>
References: <151803835881.19313.17455678207236452557.stgit@magnolia>
 <151803838538.19313.18126711641830374635.stgit@magnolia>
 <20180208111117.GB18267@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208111117.GB18267@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Feb 08, 2018 at 07:11:17PM +0800, Eryu Guan wrote:
> On Wed, Feb 07, 2018 at 01:19:45PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > A directory corrupted into a symlink will be caught by the upcoming
> 
> Still "upcoming" or already landed upstream?

Landed upstream finally. :)

--D

> > local format ifork verifiers.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I was about to ping on this patch yesterday :)
> 
> Thanks,
> Eryu
> 
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
> >  stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
> >  stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
> >  stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
