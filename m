Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:52577 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726069AbfCDXRS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 18:17:18 -0500
Date: Tue, 5 Mar 2019 10:17:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
Message-ID: <20190304231713.GY23020@dastard>
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
 <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
 <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
 <20190304205006.GX23020@dastard>
 <CAKgNAki3teB9-9D-D2yObqLfAB4VUdr-Pg0qz735RfHmP+YzBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAki3teB9-9D-D2yObqLfAB4VUdr-Pg0qz735RfHmP+YzBg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, Andreas Dilger <adilger@dilger.ca>, Wang Shilong <wshilong@ddn.com>, linux-man <linux-man@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, Mar 04, 2019 at 10:16:29PM +0100, Michael Kerrisk (man-pages) wrote:
> Hi Dave,
> On Mon, 4 Mar 2019 at 21:50, Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Mar 04, 2019 at 02:52:59PM +0100, Michael Kerrisk (man-pages) wrote:
> > > Hello Wang Shilong,
> > >
> > > On Fri, 1 Mar 2019 at 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
> > > >
> > > > From: Wang Shilong <wshilong@ddn.com>
> > >
> > > I take it that these patches relate to some API changes that are not
> > > yet merged into the kernel, right?
> > >
> > > Also, I think we need some accompanying info to describe project IDs.
> > > Can you point me at any documents/resources?
> >
> > Probably "best" documented in the man pages that ship with xfsprogs.
> 
> But, these IDs are a kernel construct, right?

On disk filesystem format construct, actually. The kernel doesn't
use them for anything other than filesystem quota accounting - it's
completely oblivious to the meaning of the IDs (unlike uids and gids
used for user and group quota accounting).

> Is their scope limited
> just to XFS, or do other filesystems have the concept also?

Originally only XFS. Irix implemented project quotas rather than
group quotas, IIRC, in the late 80s/early 90s(*) so XFS supported
project quotas for day zero. I think is was 2004/2005 that they were
fully supported on Linux (using an exclusive group or project
quota requirement) and with v5 filesystems we added a third quota
inode so we can have user, group and project quotas all active on a
filesystem at once.

2-3 years ago project quotas were added to ext4 and so anything that
uses the generic kernel quota infrastructure can implement it, too.

Cheers,

Dave.

(*) In some ways, we are still dragging Linux into the '80s, kicking
and screaming all the way :P

-- 
Dave Chinner
david@fromorbit.com
