Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:62120 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbeLCUOT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 15:14:19 -0500
Date: Tue, 4 Dec 2018 07:14:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_io: allow open file permissions to be changed
Message-ID: <20181203201414.GE6311@dastard>
References: <20181202205343.7104-1-david@fromorbit.com>
 <20181202205343.7104-3-david@fromorbit.com>
 <CACj3i73vnbe7P_HcdjGyBjThSZ-hMUCvTuVCzfMHMO_W7m2rxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73vnbe7P_HcdjGyBjThSZ-hMUCvTuVCzfMHMO_W7m2rxA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Dec 03, 2018 at 11:17:05AM +0100, Jan Tulak wrote:
> On Sun, Dec 2, 2018 at 9:54 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > I need to be able to open a file read-write, then change the
> > permissions on the file to read-only to check that copy_file_range
> > returns EPERM correctly in that case. This can't be done as root,
> > because root ignores file permissions, but as a normal user we can't
> > open a 0444 file for writing and so can't actually test writing to
> > a read-only file without some method of "open read-write, change
> > permissions to read-only, try to write to file through open
> > read-write file".
> >
> > So, allow adding or removing write permissions on an open file.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Should there be a man page update as well? Other commands from open.c
> have a corresponding man section, but:
> $ grep -c chmod man/man8/xfs_io.8
> 0

I forgot that, thanks. So many other things to deal with.

> And I wonder if the two permissions (0444 and 0664) are enough, or we
> might want to add other modes as well. But maybe that can be added
> when the need comes... Otherwise it looks good.

If we need more than "make read-only" or "make read-write" then we
can do something more. But for pretty much all the cases where fine
grained permissions are needed, the chmod command itself should
suffice....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
