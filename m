Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17968 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932883AbdAJEYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 23:24:05 -0500
Date: Mon, 9 Jan 2017 20:23:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: minleft fixes V2
Message-ID: <20170110042355.GH14038@birch.djwong.org>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <20170105012159.GS1859@eguan.usersys.redhat.com>
 <20170105020105.GC17846@birch.djwong.org>
 <20170108103647.GD26451@lst.de>
 <20170108160959.GD62847@bfoster.bfoster>
 <20170108181002.GA3732@birch.djwong.org>
 <20170109152205.GA22368@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170109152205.GA22368@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 10:22:06AM -0500, Brian Foster wrote:
> On Sun, Jan 08, 2017 at 10:10:02AM -0800, Darrick J. Wong wrote:
> > On Sun, Jan 08, 2017 at 11:10:00AM -0500, Brian Foster wrote:
> > > On Sun, Jan 08, 2017 at 11:36:47AM +0100, Christoph Hellwig wrote:
> > > > On Wed, Jan 04, 2017 at 06:01:05PM -0800, Darrick J. Wong wrote:
> > > > > Ok, sounds good.  I just sent out my first attempt at a pull request to Linus,
> > > > > so I'll queue this series for another pull req. after that.
> > > > 
> > > > I'll resend with a few minor updates based on the comments from Brian
> > > > in a few days, so this should be ready for -rc4.
> > > 
> > > So I just noticed that this series was merged into for-next (which iiuc
> > > is easily fixable, yes?).
> > 
> > Yep.  for-next can be rebased.
> > 
> > > Christoph already mentioned he was sending a new variant... but
> > > juuuuuust a note that not all of these patches had a reviewed-by yet
> > > either. ;) 
> > 
> > <nod> I'm aware; I'll be more patient next time. :)
> > 
> 
> Thanks. At risk of stating the obvious, I'd much prefer we continue to
> follow the "at least one r-b requirement per patch" development model,
> even if that means something slips a release (not that this series is at
> such a risk). I'm certainly used to that by now... :P

Yeah, again, sorry about that.

> > TBH I was also curious to have the kbuild robot / linux-next pick up a
> > changeset that wasn't terribly likely to break anything else, just to
> > see how they run...
> > 
> 
> Hmm, is this something that can be enabled locally (e.g., on posts to
> the list) without having to merge stuff prematurely?

I (think) I've requested that the kbuild robot do build testing for any branch
that appears in xfs-linux.git (as well as my djwong xfs-linux repo).

--D

> 
> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
