Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfG2AIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jul 2019 20:08:30 -0400
Date: Sun, 28 Jul 2019 17:06:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: lift the xfs writepage code into iomap v3
Message-ID: <20190729000603.GL1561054@magnolia>
References: <20190722095024.19075-1-hch@lst.de>
 <20190726233753.GD2166993@magnolia>
 <CAHc6FU7L52soLiRafnOiTsaMYp4X_NmjjimpMMzdaoSH_afT+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU7L52soLiRafnOiTsaMYp4X_NmjjimpMMzdaoSH_afT+A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, Jul 27, 2019 at 03:33:14PM +0200, Andreas Gruenbacher wrote:
> On Sat, 27 Jul 2019 at 01:38, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Mon, Jul 23, 2019 at 11:50:12AM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > >
> > > this series cleans up the xfs writepage code and then lifts it to
> > > fs/iomap.c so that it could be use by other file system.  I've been
> > > wanting to this for a while so that I could eventually convert gfs2
> > > over to it, but I never got to it.  Now Damien has a new zonefs
> > > file system for semi-raw access to zoned block devices that would
> > > like to use the iomap code instead of reinventing it, so I finally
> > > had to do the work.
> >
> > Hmm... I don't like how there are xfs changes mixed in with the iomap
> > changes, because were I to take this series as-is then I'd have to
> > commit both to adding iomap writeback code /and/ converting xfs at the
> > same time.
> >
> > I think I'd be more comfortable creating a branch to merge the changes
> > to list.h and fs/iomap/, and then gfs2/zonefs/xfs can sprout their own
> > branches from there to do whatever conversions are necessary.
> >
> > To me what that means is splitting patch 7 into 7a which does the iomap
> > changes and 7b which does the xfs changes.  To get there, I'd create a
> > iomap-writeback branch containing:
> >
> > 1 7a 8 9 10 11 12
> >
> > and then a new xfs-iomap-writeback branch containing:
> >
> > 2 4 7b
> >
> > This eliminates the need for patches 3, 5, and 6, though the cost is
> > that it's less clear from the history that we did some reorganizing of
> > the xfs writeback code and then moved it over to iomap.  OTOH, I also
> > see this as a way to lower risk because if some patch in the
> > xfs-iomap-writeback branch shakes loose a bug that doesn't affect gfs2
> > or zonedfs we don't have to hold them up.
> >
> > I'll try to restructure this series along those lines and report back
> > how it went.
> 
> Keeping the infrastructure changes in separate commits would certainly
> make the patches easier to work with for me. Keeping the commits
> interleaved should be fine though: patch "iomap: zero newly allocated
> mapped blocks" depends on "xfs: set IOMAP_F_NEW more carefully", so a
> pure infrastructure branch without "xfs: set IOMAP_F_NEW more
> carefully" probably wouldn't be correct.

<nod> In the end I went with:

iomap: 1 7a 8 9 10 11 12

and then atop that:

xfs: 2 4 3 5 6 7b

Because xfs can merge the refactoring in patches 2 & 4 without needing
to take patches 3-7b.  Will retest overnight with -rc2 (now that scsi
works again <cough>).

--D

> Thanks,
> Andreas
