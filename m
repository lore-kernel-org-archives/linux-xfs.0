Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52814 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbeJJFAG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 01:00:06 -0400
Date: Wed, 10 Oct 2018 08:41:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Which fragmentation factor is allowable for xfs (not impact on
 performance)?
Message-ID: <20181009214105.GF6311@dastard>
References: <CABXGCsOxH-gfLL4Mo+RxNk4OoWgAdJzW2Sv2w2He7VkgKxqUug@mail.gmail.com>
 <57e256e5-bcf7-c6ce-601a-64263606d707@sandeen.net>
 <CABXGCsNKQn96nPCABmBduF2_EyQXmhSgxgR1ue8MuGQ3acRuAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXGCsNKQn96nPCABmBduF2_EyQXmhSgxgR1ue8MuGQ3acRuAA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Tue, Oct 09, 2018 at 10:33:48PM +0500, Mikhail Gavrilov wrote:
> On Sun, 7 Oct 2018 at 02:20, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> > On 10/6/18 12:34 PM, Mikhail Gavrilov wrote:
> > > Which fragmentation factor is allowable for xfs (not impact on performance)?
> > >
> > > # xfs_db -c frag -r /dev/sda
> > > actual 4908781, ideal 2801391, fragmentation factor 42.93%
> >
> > Ignore the fragmentation factor, because:
> >
> > > Note, this number is largely meaningless.
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F
> >
> > > Files on this filesystem average 1.75 extents per file
> > The majority of your files have only 1 extent.
> >
> > > # mount | grep sda
> > > /dev/sda on /home type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
> > >
> > > # df -h | grep sda
> > > /dev/sda         11T  5.3T  5.7T  49% /home
> > >
> > > I think it too much for partition which are half free.
> >
> > Why do you think that?
> >
> > > It would also be interesting to see the fragmentation in the context
> > > of files, but I have not found anywhere how to look at it.
> >
> > xfs_bmap will show you extent layout for individual files.
> >
> > -Eric
> 
> 
> Thanks I wrote simple bash script for inspect my HDD for top 100
> fragmented files.
> Here is my top 100:
> 
> 20511  -  /home/mikhail/.local/share/Steam/steamapps/common/Deus Ex
> Mankind Divided/share/data/runtime/game.layer.0.all.archive

These are almost all steam packages. I'm betting they have a
torrent-style download algorithm which effectively makes writing the
file random IO. This is why torrent clients tend to use fallocate()
these days, so the end result is a contiguous file regardless of the
order of file data chunks arriving over the network....

> The biggest concern is the presence file
> "/home/mikhail/.cache/tracker/meta.db" in this list.
> Because this is a base of indexed files in GNOME.

That's not unusual, and given that it's a database that is generally
used for random lookups then file fragmentation is mostly
irrelevant.

> The purpose of my research was to show that despite the fact that with
> average 1.75 extents per file, is possible find files on the disk
> that, for some unknown reason, are divided on 20K parts.

Usually a result of applications doing something unusual and the
developers being unaware that they are doing something sub-optimal
that can be easily mitigated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
