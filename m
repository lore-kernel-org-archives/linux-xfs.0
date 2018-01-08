Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754933AbeAHSJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 13:09:24 -0500
Date: Mon, 8 Jan 2018 10:06:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 0/7] xfs: inode transaction reservation fixups
Message-ID: <20180108180634.GQ5602@magnolia>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20180108140843.GA41128@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108140843.GA41128@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 08, 2018 at 09:08:44AM -0500, Brian Foster wrote:
> On Thu, Nov 30, 2017 at 01:58:29PM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v2 of the inode tx reservation fixups. This drops the agfl fixup
> > patch for the time being and adds some additional reservation fixups and
> > refactoring based on Dave's feedback. This survives xfstests in a few
> > different configurations and also happens to survive my inode unlink
> > reservation overrun tests.
> > 
> > Thoughts, reviews, flames appreciated.
> > 
> > Brian
> > 
> > v2:
> > - Update AGI unlinked list and truncate reservations
> > - Update commit log for ifree refactor patch.
> > - Additional refactoring patches.
> > - Dropped agfl fixup patch.
> > v1: https://marc.info/?l=linux-xfs&m=151181428031884&w=2
> > 
> 
> Ping...
> 
> It looks like this is all reviewed, but perhaps just not merged yet (or
> I'm just not looking in the right place)..?

It's all reviewed and ready to go, but I haven't had a chance to push
things out for testing due to last week's ... uh, fire drill. :/

Anyway, that's all over so I'll go work on that today.

--D

> Brian
> 
> > Brian Foster (7):
> >   xfs: print transaction log reservation on overrun
> >   xfs: include inobt buffers in ifree tx log reservation
> >   xfs: fix up agi unlinked list reservations
> >   xfs: truncate transaction does not modify the inobt
> >   xfs: include an allocfree res for inobt modifications
> >   xfs: refactor inode chunk alloc/free tx reservation
> >   xfs: eliminate duplicate icreate tx reservation functions
> > 
> >  fs/xfs/libxfs/xfs_trans_resv.c | 202 ++++++++++++++++++++---------------------
> >  fs/xfs/xfs_log.c               |   4 +-
> >  2 files changed, 99 insertions(+), 107 deletions(-)
> > 
> > -- 
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
